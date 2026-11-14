B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.9
@EndOfDesignText@
'气泡掩膜排版：把一段文字排进气球形状里。
'坐标约定和 VerticalTextEngine.setBalloonMask(mask,offsetX,offsetY) 一致：
'  - 掩膜是整张图，白色（alpha>0 或灰度>30）是气球内部
'  - areaLeft/areaTop/areaWidth/areaHeight 是文字框在掩膜图里的位置
'
'返回 Map：
'  success        是否排出了结果（False 时调用方应退回矩形换行）
'  overflow       True 表示放不下，调用方应把整段文字用 wrapWidth 作为 maxWidth 显示
'  text           插入换行符后的文本
'  lineLefts / lineTops   每行文字在框内的左上角（框的局部坐标）
'  wrapWidth      每行的容器宽度
'  blockHeight    文本块底部相对框顶的位置（可大于框高，允许溢出）
Sub Process_Globals
End Sub

Public Sub LoadMaskSpans(mask As cvMat) As Map
	Dim result As Map
	result.Initialize
	Try
		result = LoadMaskSpansInternal(mask)
	Catch
		Log("BalloonMaskWrapper: LoadMaskSpans failed: " & LastException)
	End Try
	If result.IsInitialized = False Then result.Initialize
	Return result
End Sub

Private Sub LoadMaskSpansInternal(mask As cvMat) As Map
	Dim result As Map
	result.Initialize
	If mask.IsInitialized = False Or mask.empty Then Return result
	Dim w As Int = mask.Cols
	Dim h As Int = mask.Rows

	'转灰度：4 通道（BGRA）取 alpha，气泡掩膜的气泡信息在 alpha 里；
	'3 通道/单通道按普通灰度处理
	Dim gray As cvMat
	gray.Initialize(Null)
	Dim usedAlpha As Boolean = False
	If mask.Channels = 1 Then
		gray = mask
	Else If mask.Channels = 4 Then
		Dim core As JavaObject
		core.InitializeStatic("org.opencv.core.Core")
		core.RunMethod("extractChannel",Array(mask.JO,gray.JO,3))
		usedAlpha = True
	Else
		cv2.cvtColor(mask,gray,"COLOR_BGR2GRAY")
	End If

	'二值化成 0/255，再用 BitmapCreator 读像素：
	'逐像素不用 Mat.get（B4J 里对 JavaObject 做动态派发容易踩类型/空指针问题）
	Dim bc As BitmapCreator
	bc.Initialize(w,h)
	Dim binary As cvMat
	binary.Initialize(Null)
	Try
		Dim imgproc As JavaObject
		imgproc.InitializeStatic("org.opencv.imgproc.Imgproc")
		imgproc.RunMethod("threshold",Array(gray.JO,binary.JO,30.0,255.0,imgproc.GetField("THRESH_BINARY")))
		bc.DrawBitmap(Utils.BytesToImage(binary.mat2bytesPNG),bc.TargetRect,False)
	Catch
		Log("BalloonMaskWrapper: threshold/decode failed: " & LastException)
		binary.release
		If gray.JO <> mask.JO Then gray.release
		Return result
	End Try
	'每颗气球（连通域）的外接矩形：WrapInMask 用它挑出框所在的那颗气球
	Dim boxes As List = FindBalloonBoxes(binary,bc)
	binary.release
	If gray.JO <> mask.JO Then gray.release

	Dim rowMin,rowMax As List
	rowMin.Initialize
	rowMax.Initialize
	Dim yMin As Int = h
	Dim yMax As Int = -1
	Dim centerSum As Double = 0
	Dim centerRows As Int = 0
	Dim spans As List
	spans.Initialize
	Dim c As ARGBColor
	c.Initialize
	For y = 0 To h - 1
		Dim minx As Int = -1
		Dim rightX As Int = -1
		For x = 0 To w - 1
			bc.GetARGB(x,y,c)
			If c.r > 128 Then
				If minx < 0 Then minx = x
				rightX = x
			End If
		Next
		rowMin.Add(minx)
		rowMax.Add(rightX)
		If minx >= 0 Then
			If y < yMin Then yMin = y
			If y > yMax Then yMax = y
			centerSum = centerSum + (minx + rightX) / 2.0
			centerRows = centerRows + 1
			spans.Add(rightX - minx + 1)
		End If
	Next
	Dim centerX As Double = 0
	If centerRows > 0 Then centerX = centerSum / centerRows
	Dim medianSpan As Double = 0
	If spans.Size > 0 Then
		spans.Sort(False)
		medianSpan = spans.Get(spans.Size / 2)
	End If
	result.Put("width",w)
	result.Put("height",h)
	result.Put("yMin",yMin)
	result.Put("yMax",yMax)
	result.Put("rowMin",rowMin)
	result.Put("rowMax",rowMax)
	result.Put("centerX",centerX)
	result.Put("medianSpan",medianSpan)
	result.Put("usedAlpha",usedAlpha)
	result.Put("whiteRatio",100.0 * centerRows / Max(1,h))
	'WrapInMask 需要按框的横向范围重新扫描每行区间，这里保留二值位图
	result.Put("bitmap",bc)
	result.Put("boxes",boxes)
	Log("BalloonMaskWrapper: mask " & w & "x" & h & " channels=" & mask.Channels & " usedAlpha=" & usedAlpha & " yMin=" & yMin & " yMax=" & yMax & " medianSpan=" & medianSpan & " rowsWithWhite=" & (100.0 * centerRows / Max(1,h)) & "%")
	Return result
End Sub

'按掩膜排版。
'策略：
'  1. 最长单词必须放得进所有行的可用宽度；
'  2. 行数从 1 到 maxLines 逐个试，每行的可用宽度取该行的掩膜区间；居中时各行共用最窄宽度；
'  3. DP 断行，代价是各行剩余宽度的平方和；
'  4. 用每行的掩膜区间定位（LEFT 贴左、RIGHT 贴右、CENTER 围绕中轴）；
'  5. 全部行数都无解时返回 overflow=True，由调用方整段 + maxWidth 显示。
'按掩膜排版，沿用旧版 BalloonText 的算法（那一版在 B4J\TextFlowTest 里效果已确认）：
'  1. 先在框的横向范围内取掩膜区间（相当于旧版的 xStart..xLimit），纵向取气球范围与框之交；
'  2. 行数 1..maxLines 逐个试，每行可用宽度 = 该行带内掩膜区间（居中取最窄 span，
'     LEFT/RIGHT 取各行区间交集）；
'  3. 缺口部分用 DP 断行，按"行数接近 H/lineStep、填充率高"排序选最优；
'  4. 每行按中心 + 可用宽度摆放。
'全部行数都放不下时返回 overflow=True，由调用方整段按 maxWidth 显示。
Public Sub WrapInMask(Text As String,F As Font,Mask As Map,LineSpacing As Double,Alignment As Int,areaLeft As Int,areaTop As Int,areaWidth As Int,areaHeight As Int,VerticalFill As Double) As Map
	Dim result As Map
	result.Initialize
	result.Put("success",False)
	result.Put("overflow",False)
	result.Put("text",Text)
	result.Put("lineSpacing",LineSpacing)
	result.Put("topOffset",0.0)
	result.Put("leftOffset",0.0)
	result.Put("blockWidth",0.0)
	result.Put("wrapWidth",0.0)
	result.Put("blockHeight",0.0)
	PutEmptyLines(result)
	If Mask.IsInitialized = False Or Mask.ContainsKey("yMin") = False Then Return result
	If areaWidth <= 0 Or areaHeight <= 0 Then Return result

	'2. 选气球：每个气球（连通域）的外接矩形和框算重叠比例，取最大的那颗，
	'   框外的部分（气球比框大）照样保留，别的气球全部抹掉
	Dim box As Map = PickBalloon(Mask,areaLeft,areaTop,areaWidth,areaHeight)
	If box.IsInitialized = False Then
		Log("balloonMask: no balloon overlaps the box, fallback")
		Return result
	End If
	'扫描范围：气球的左右边界（气球比框大时，框外的气球部分也能用）
	Dim xStart As Int = Max(box.Get("X"),0)
	Dim xLimit As Int = Min(box.Get("X") + box.Get("width"),Mask.Get("width"))
	Log("balloonMask: balloon x=" & box.Get("X") & ".." & (box.Get("X") + box.Get("width") - 1) & " y=" & box.Get("Y") & ".." & (box.Get("Y") + box.Get("height") - 1))
	Dim rowMin As List
	Dim rowMax As List
	rowMin.Initialize
	rowMax.Initialize
	Dim bc As BitmapCreator = Mask.Get("bitmap")
	If bc.IsInitialized Then
		Dim c As ARGBColor
		c.Initialize
		Dim bx0 As Int = box.Get("X")
		Dim by0 As Int = box.Get("Y")
		Dim bx1 As Int = bx0 + box.Get("width") - 1
		Dim by1 As Int = by0 + box.Get("height") - 1
		Dim boxes As List = Mask.Get("boxes")
		Dim others As List
		others.Initialize
		For i = 0 To boxes.Size - 1
			If IsSameBox(boxes.Get(i),box) = False Then others.Add(boxes.Get(i))
		Next
		For y = 0 To bc.mHeight - 1
			Dim minx As Int = -1
			Dim rightX As Int = -1
			If y >= by0 And y <= by1 Then
				For x = xStart To xLimit - 1
					'外接矩形里，别的气球占的像素不算
					Dim drop As Boolean = False
					For i = 0 To others.Size - 1
						Dim bm As Map = others.Get(i)
						If x >= bm.Get("X") And x <= bm.Get("X") + bm.Get("width") - 1 And y >= bm.Get("Y") And y <= bm.Get("Y") + bm.Get("height") - 1 Then
							drop = True
							Exit
						End If
					Next
					If drop = False Then
						bc.GetARGB(x,y,c)
						If c.r > 128 Then
							If minx < 0 Then minx = x
							rightX = x
						End If
					End If
				Next
			End If
			rowMin.Add(minx)
			rowMax.Add(rightX)
		Next
	Else
		Return result
	End If

	'行区间已只来自选中的这颗气球，不再按段裁剪

	Dim yMin As Int = -1
	Dim yMax As Int = -1
	Dim boxTop As Int = Max(areaTop,0)
	Dim boxBottom As Int = Min(areaTop + areaHeight - 1,rowMin.Size - 1)
	For y = boxTop To boxBottom
		If rowMin.Get(y) >= 0 Then
			If yMin < 0 Then yMin = y
			yMax = y
		End If
	Next
	If yMin < 0 Then
		Log("balloonMask: box area has no mask, fallback")
		Return result
	End If
	Dim H As Int = yMax - yMin + 1
	Dim CenterX As Double = (xStart + xLimit - 1) / 2.0

	'气球比框宽时，框外的气球部分只用来扩展行宽，文字本身不能越出框：
	'把每行的左右边界夹到 [areaLeft, areaLeft+areaWidth-1]
	Dim frameL As Int = areaLeft
	Dim frameR As Int = areaLeft + areaWidth - 1
	For y = 0 To rowMin.Size - 1
		Dim mnF As Int = rowMin.Get(y)
		Dim mxF As Int = rowMax.Get(y)
		If mnF >= 0 Then
			If mxF < frameL Or mnF > frameR Then
				mnF = -1
				mxF = -1
			Else
				mnF = Max(mnF,frameL)
				mxF = Min(mxF,frameR)
			End If
		End If
		rowMin.Set(y,mnF)
		rowMax.Set(y,mxF)
	Next

	Dim words As List
	words.Initialize
	Dim s As String = Text.Trim
	If s <> "" Then
		s = s.Replace(Chr(160)," ")
		words = Regex.Split("\s+",s)
	End If
	Dim naturalLineHeight As Double = MeasureLineHeight(F)
	If naturalLineHeight <= 0 Then naturalLineHeight = F.Size * 1.2
	Dim lineStep As Double = naturalLineHeight + LineSpacing
	If words.Size = 0 Then
		result.Put("success",True)
		result.Put("blockWidth",xLimit - xStart)
		result.Put("wrapWidth",xLimit - xStart)
		result.Put("blockHeight",naturalLineHeight)
		result.Put("topOffset",yMin - areaTop)
		Return result
	End If

	'贪心排版：
	'  逐词往当前行追加，先用文字估算这行的宽度；
	'  再看这行所在的高度带在掩膜里的右边界（左边界 + 可用宽度），
	'  超出就换行；一整行放不下（单个词就超宽）时允许这一行溢出。
	Dim lineTexts As List
	Dim lineLefts As List
	Dim lineTops As List
	Dim lineSlots As List
	lineTexts.Initialize
	lineLefts.Initialize
	lineTops.Initialize
	lineSlots.Initialize
	'中文等无空格语言按字断行，英文按词
	Dim units As List
	Dim joinerList As List
	joinerList.Initialize
	BreakUnits(words,units,joinerList)
	Dim joiner As String = joinerList.Get(0)
	Dim curText As String = ""
	Dim curTop As Double = yMin
	For i = 0 To units.Size - 1
		Dim w As String = units.Get(i)
		Dim candidate As String
		If curText = "" Then
			candidate = w
		Else
			candidate = curText & joiner & w
		End If
		'后面紧跟的标点/闭合括号不能单独留在下一行行首：算宽度时先带上，
		'但换行与否只看文字本身，标点始终挂在上一行末尾（允许略超出边界）
		Dim tail As String = ""
		Dim merged As Boolean = False
		If joiner = "" And i + 1 < units.Size Then
			Dim k As Int = i + 1
			Do While k < units.Size And IsNoLineStart(units.Get(k))
				tail = tail & units.Get(k)
				k = k + 1
			Loop
			merged = (tail <> "")
		End If
		Dim cw As Double = MeasureTextWidth(candidate,F)		'每个断行单元（词或汉字）：取这一行高度带在掩膜里的左/右边界，
		'左边界 = 带内各行的交集（文字起点不能越过它），右边界 = 带内最宽行。
		'累加宽度超过右边界就换行；行首不到左边界就在每行开头补空格。
		Dim band As Map = LineBand(rowMin,rowMax,curTop,naturalLineHeight)
		If band.Get("ok") And curText <> "" Then
			Dim availR As Double = band.Get("usableRight")
			Dim availL As Double = band.Get("usableLeft")
			Dim cw As Double = MeasureTextWidth(candidate,F)
			Dim fits As Boolean = (availL + cw - 1 <= availR)
			If fits = False Then
				AddLineAligned(lineTexts,lineLefts,lineTops,lineSlots,curText,curTop,rowMin,rowMax,naturalLineHeight,F,Alignment,CenterX,areaTop,xStart,xLimit)
				curText = w
				curTop = curTop + lineStep
				If merged Then i = k - 1
				Continue
			End If
		End If
		curText = candidate
		If merged Then i = k - 1
	Next
	If curText <> "" Then
		Dim band2 As Map = LineBand(rowMin,rowMax,curTop,naturalLineHeight)
		Dim l2 As Double = -1
		Dim w2 As Double = -1
		If band2.Get("ok") Then
			l2 = band2.Get("left")
			w2 = band2.Get("right") - l2 + 1
		End If
		AddLineAligned(lineTexts,lineLefts,lineTops,lineSlots,curText,curTop,rowMin,rowMax,naturalLineHeight,F,Alignment,CenterX,areaTop,xStart,xLimit)
	End If


	'lineLefts 目前是整图坐标，统一换成框内局部坐标（渲染端只加 area.X）
	For i = 0 To lineLefts.Size - 1
		lineLefts.Set(i,lineLefts.Get(i) - areaLeft)
	Next

	Dim sb As StringBuilder
	sb.Initialize
	Dim minLeft As Double = 1000000
	Dim maxRight As Double = -1000000
	For i = 0 To lineTexts.Size - 1
		If i > 0 Then sb.Append(Chr(10))
		sb.Append(lineTexts.Get(i))
		minLeft = Min(minLeft,lineLefts.Get(i))
		maxRight = Max(maxRight,lineLefts.Get(i) + MeasureTextWidth(lineTexts.Get(i),F))
	Next
	result.Put("success",True)
	result.Put("text",sb.ToString)
	result.Put("lineLefts",lineLefts)
	result.Put("lineTops",lineTops)
	result.Put("lineSlots",lineSlots)
	result.Put("topOffset",lineTops.Get(0))
	result.Put("leftOffset",minLeft)
	result.Put("blockLeft",minLeft)
	result.Put("blockWidth",maxRight - minLeft)
	result.Put("wrapWidth",xLimit - xStart)
	result.Put("blockHeight",lineTops.Get(lineTops.Size - 1) + naturalLineHeight - areaTop)
	Log("balloonMask: " & lineTexts.Size & " lines (greedy)")
	Return result
End Sub

'选气球：每个气球（连通域）的外接矩形和框算重叠比例，取重叠最多的那颗
Private Sub PickBalloon(Mask As Map,areaLeft As Int,areaTop As Int,areaWidth As Int,areaHeight As Int) As Map
	Dim best As Map
	Dim boxes As List = Mask.Get("boxes")
	If boxes.IsInitialized = False Then Return best
	Dim bestRatio As Double = 0
	For i = 0 To boxes.Size - 1
		Dim b As Map = boxes.Get(i)
		Dim ox0 As Int = Max(b.Get("X"),areaLeft)
		Dim ox1 As Int = Min(b.Get("X") + b.Get("width"),areaLeft + areaWidth)
		Dim oy0 As Int = Max(b.Get("Y"),areaTop)
		Dim oy1 As Int = Min(b.Get("Y") + b.Get("height"),areaTop + areaHeight)
		If ox1 <= ox0 Or oy1 <= oy0 Then Continue
		Dim ov As Double = (ox1 - ox0) * (oy1 - oy0)
		'重叠面积 / 框面积：框通常整颗落在气球里，用框面积做分母更准
		Dim ratio As Double = ov / Max(1,areaWidth * areaHeight)
		If ratio > bestRatio Then
			bestRatio = ratio
			best = b
		End If
	Next
	If best.IsInitialized Then Log("balloonMask: pick balloon overlap=" & bestRatio)
	Return best
End Sub

'按"每个气球（连通域）的外接矩形"切分掩膜：
'  boxes：每个元素 Map(X,Y,width,height,area)，已丢掉很小的碎块
Private Sub FindBalloonBoxes(binary As cvMat,bc As BitmapCreator) As List
	Dim r As List
	r.Initialize
	Dim W As Int = bc.mWidth
	Dim H As Int = bc.mHeight
	Try
		Dim labels As cvMat
		labels.Initialize(Null)
		Dim stats As cvMat
		stats.Initialize(Null)
		Dim centroids As cvMat
		centroids.Initialize(Null)
		Dim imgproc As JavaObject
		imgproc.InitializeStatic("org.opencv.imgproc.Imgproc")
		'8 位二值图作输入时返回连通域个数；默认 4 邻域连通
		Dim n As Int = imgproc.RunMethod("connectedComponentsWithStats",Array(binary.JO,labels.JO,stats.JO,centroids.JO))
		Dim minArea As Int = Max(30,W * H / 5000)
		For i = 1 To n - 1
			Dim idx(2) As Int
			idx(0) = i
			idx(1) = 0
			Dim x As Int = stats.get(idx)(0)
			idx(1) = 1
			Dim y As Int = stats.get(idx)(0)
			idx(1) = 2
			Dim w As Int = stats.get(idx)(0)
			idx(1) = 3
			Dim h As Int = stats.get(idx)(0)
			idx(1) = 4
			Dim area As Int = stats.get(idx)(0)
			If area < minArea Then Continue
			Dim b As Map
			b.Initialize
			b.Put("X",x)
			b.Put("Y",y)
			b.Put("width",w)
			b.Put("height",h)
			b.Put("area",area)
			r.Add(b)
		Next
		labels.release
		stats.release
		centroids.release
	Catch
		Log("BalloonMaskWrapper: connectedComponents failed: " & LastException)
	End Try
	Log("BalloonMaskWrapper: balloons=" & r.Size)
	Return r
End Sub

'两个外接矩形是否同一个气球
Private Sub IsSameBox(a As Map,b As Map) As Boolean
	Return a.Get("X") = b.Get("X") And a.Get("Y") = b.Get("Y") And a.Get("width") = b.Get("width") And a.Get("height") = b.Get("height")
End Sub

'在 row row 上找包含 x 的那段连续掩膜（一段 = 同一行里连续的一段）
'返回 Map(ok,left,right)：包含 x 的那一段掩膜
Private Sub FindSegment(rowMin As List,rowMax As List,row As Int,x As Int) As Map
	Dim r As Map
	r.Initialize
	r.Put("ok",False)
	Dim mn As Int = rowMin.Get(row)
	Dim mx As Int = rowMax.Get(row)
	If mn < 0 Then Return r
	If x < mn Or x > mx Then Return r
	Dim left As Int = x
	Do While left > mn And IsMaskCol(rowMin,rowMax,row,left - 1)
		left = left - 1
	Loop
	Dim right As Int = x
	Do While right < mx And IsMaskCol(rowMin,rowMax,row,right + 1)
		right = right + 1
	Loop
	r.Put("ok",True)
	r.Put("left",left)
	r.Put("right",right)
	Return r
End Sub

Private Sub IsMaskCol(rowMin As List,rowMax As List,row As Int,x As Int) As Boolean
	Dim mn As Int = rowMin.Get(row)
	Dim mx As Int = rowMax.Get(row)
	Return mn >= 0 And x >= mn And x <= mx
End Sub

'把词拆成断行单元：有空格的语言按词，中文/日文按单字
Private Sub BreakUnits(words As List,units As List,joiner As List)
	units.Initialize
	joiner.Clear
	joiner.Add(" ")
	Dim spaceCount As Int = 0
	Dim cjkChars As Int = 0
	Dim otherChars As Int = 0
	For Each w As String In words
		For i = 0 To w.Length - 1
			Dim ch As String = w.SubString2(i,i + 1)
			If ch = " " Then
				spaceCount = spaceCount + 1
			Else If IsCJK(ch) Then
				cjkChars = cjkChars + 1
			Else
				otherChars = otherChars + 1
			End If
		Next
	Next
	If spaceCount > 0 Or cjkChars <= otherChars Then
		For Each w As String In words
			units.Add(w)
		Next
		Return
	End If
	joiner.Clear
	joiner.Add("")
	For Each w As String In words
		For i = 0 To w.Length - 1
			units.Add(w.SubString2(i,i + 1))
		Next
	Next
End Sub

'这些标点不能出现在行首（中文排版惯例）：换行时挂到上一行末尾
Private Sub IsNoLineStart(s As String) As Boolean
	Dim bad As String = "！？，。、；：）」』】》〉…—·!?,.;:)]}"
	Return s <> "" And bad.IndexOf(s.SubString2(0,1)) >= 0
End Sub

Private Sub IsCJK(s As String) As Boolean
	If s = "" Then Return False
	Dim code As Int = Asc(s.SubString2(0,1))
	Return (code >= 19968 And code <= 40959) Or (code >= 12288 And code <= 12543)
End Sub

Private Sub LineBand(rowMin As List,rowMax As List,topY As Double,height As Double) As Map
	Dim r As Map
	r.Initialize
	r.Put("ok",False)
	Dim y0 As Int = Floor(topY)
	Dim y1 As Int = Ceil(topY + height) - 1
	If y0 < 0 Then y0 = 0
	If y1 > rowMin.Size - 1 Then y1 = rowMin.Size - 1
	'取带内"最宽那一行"的左右边界：气泡边缘的轻微凹凸不会把整行压窄，
	'同时这个范围仍然完全落在掩膜里（不会超出气泡）
	Dim bestSpan As Int = 0
	Dim l As Int = -1
	Dim rr As Int = -1
	'带内所有行都包含的范围（交集）：文字一定要落在里面，左右都不出气泡。
	'只让"够宽"的行参与（像气球边缘的小凸起、同高度别的碎块不参与），
	'否则交集会被压成一个极窄的缝。
	Dim inL As Int = -1
	Dim inR As Int = 1000000
	Dim refSpan As Int = 0
	For y = y0 To y1
		Dim mnR As Int = rowMin.Get(y)
		If mnR >= 0 Then
			Dim spanR As Int = rowMax.Get(y) - mnR + 1
			If spanR > refSpan Then refSpan = spanR
		End If
	Next
	For y = y0 To y1
		Dim mn As Int = rowMin.Get(y)
		If mn >= 0 Then
			Dim span As Int = rowMax.Get(y) - mn + 1
			If span > bestSpan Then
				bestSpan = span
				l = mn
				rr = rowMax.Get(y)
			End If
			'只有足够宽的行参与交集（>= 40% 最宽行），边缘凸起/碎块不参与
			If span >= 0.4 * refSpan Then
				If mn > inL Then inL = mn
				If rowMax.Get(y) < inR Then inR = rowMax.Get(y)
			End If
		End If
	Next
	If l < 0 Then Return r
	If inR >= inL Then
		r.Put("usableLeft",inL + 0.0)
	Else
		r.Put("usableLeft",l + 0.0)
	End If
	r.Put("usableRight",rr + 0.0)
	r.Put("ok",True)
	r.Put("left",l + 0.0)
	r.Put("right",rr + 0.0)
	If inR >= inL Then
		r.Put("inLeft",inL + 0.0)
		r.Put("inRight",inR + 0.0)
	Else
		'带内各行的公共区间为空（气球左右边缘错开）：退化为最宽行的范围
		r.Put("inLeft",l + 0.0)
		r.Put("inRight",rr + 0.0)
	End If
	Return r
End Sub

'把一行加入结果：按对齐方式在可用区间里定位
'按掩膜给这一行定位（写入 lineLefts / lineTops / lineSlots，框内局部坐标）。
'  容器 = 该行带内所有行的公共区间 inL..inR：左右都不出气泡
'  LEFT  ：文字从 inL 开始；放不下时用空格前缀把文字往里推（LEFT 是唯一可能需要补空格的）
'  RIGHT ：行框贴 inR，文字在行框内右对齐
'  CENTER：行框贴 inL，宽度=公共区间，文字在行框内居中
'按掩膜给这一行定位（写入 lineLefts / lineTops / lineSlots，框内局部坐标）。
'左右都不出气泡：文字必须落在该行带内所有"足够宽的行"的交集 [inL, inR] 里。
'  LEFT  ：文字从 inL 开始；放不下时用前缀空格把整行往右推（仍然 ≤ inR）
'  RIGHT ：用前缀空格把文字推到 inR 附近
'  CENTER：行框 = 交集，文字在行框内居中
'按掩膜给这一行定位（写入 lineLefts / lineTops / lineSlots，框内局部坐标）。
'左右都受约束：尽量让文字落在该行带里所有"足够宽的行"的交集 [inL, inR] 内。
'  LEFT  ：文字从 inL 开始；只有右端会超过 inR 时才补前缀空格
'  RIGHT ：补前缀空格，让文字右端贴近 inR
'  CENTER：行框 = 交集，文字在行框内居中
'按掩膜给这一行定位（写入 lineLefts / lineTops / lineSlots，框内局部坐标）。
'  LEFT  ：起点 = 这一行自己的掩膜左边界（该高度带内的左边界），右端不得超过该行右边界；
'          放不下时用前缀空格把整行往右推，直到刚好放下为止
'  RIGHT ：补前缀空格让文字右端贴近这一行的右边界
'  CENTER：所有行共用同一中轴（带内公共区间），在交集内居中
Private Sub AddLineAligned(lineTexts As List,lineLefts As List,lineTops As List,lineSlots As List,lineText As String,topY As Double,rowMin As List,rowMax As List,lineH As Double,F As Font,alignment As Int,CenterX As Double,areaTop As Int,xStart As Int,xLimit As Int)
	Dim band As Map = LineBand(rowMin,rowMax,topY,lineH)
	Dim text As String = lineText
	Dim tw As Double = MeasureTextWidth(lineText,F)
	Dim slot As Double
	Dim left As Double
	If band.Get("ok") = False Then
		slot = xLimit - xStart
		left = xStart
	Else
		'该行自己的左右边界（最宽的那一行）
		Dim ownL As Double = band.Get("left")
		Dim ownR As Double = band.Get("right")
		'所有行的公共区间（居中时用）
		Dim inL As Double = band.Get("inLeft")
		Dim inR As Double = band.Get("inRight")
		Dim spaceW As Double = MeasureTextWidth(" ",F)
		Dim usableL As Double = band.Get("usableLeft")
		If alignment = 1 Then
			'居中：行框 = 公共区间
			slot = Max(inR - inL + 1,tw)
			left = inL
		Else If alignment = 2 Then
			'右对齐：右端贴这一行带内的右边界
			left = ownL
			slot = ownR - ownL + 1
		Else
			'左对齐：从这一行带内的左边界开始
			left = ownL
			If usableL > left Then left = usableL
			slot = ownR - ownL + 1
		End If
		'行首不足这一行的左边界时，前面补空格把文字推到左边界之后
		If usableL > left And spaceW > 0 Then
			Dim padL As Int = Ceil((usableL - left) / spaceW)
			If padL > 0 Then
				text = Spaces(padL) & text
				tw = MeasureTextWidth(text,F)
				left = left + padL * spaceW
			End If
		End If
		'右对齐时在行首补空格，让文字右端贴住右边界（左对齐不再补右侧空格）
		If alignment = 2 And spaceW > 0 Then
			Dim padR As Int = 0
			Do While tw + spaceW * (padR + 1) <= slot
				padR = padR + 1
			Loop
			If slot - (tw + spaceW * padR) >= spaceW * 0.5 Then padR = padR + 1
			If padR > 0 Then
				text = Spaces(padR) & text
				tw = MeasureTextWidth(text,F)
			End If
		End If
		slot = Max(slot,tw)
	End If
	lineTexts.Add(text)
	lineLefts.Add(left)
	lineTops.Add(topY - areaTop)
	lineSlots.Add(Max(slot,tw))
End Sub

Private Sub Spaces(n As Int) As String
	Dim sb As StringBuilder
	sb.Initialize
	For i = 1 To n
		sb.Append(" ")
	Next
	Return sb.ToString
End Sub

'没有行可排时也给出空列表，调用方访问 .Size 不会报未初始化
Private Sub PutEmptyLines(result As Map)
	Dim lefts As List
	Dim tops As List
	lefts.Initialize
	tops.Initialize
	result.Put("lineLefts",lefts)
	result.Put("lineTops",tops)
End Sub

'取 [topY, topY+height) 这一行带内的掩膜信息：
'  ok / leftLimit / rightLimit  带内各行的公共区间（无掩膜的行不参与）
'  minSpan / maxSpan / coveredRows
Private Sub ReadMaskBand(rowMin As List,rowMax As List,topY As Double,height As Double,yMin As Int,yMax As Int) As Map
	Dim r As Map
	r.Initialize
	r.Put("ok",False)
	Dim y0 As Int = Floor(topY)
	Dim y1 As Int = Ceil(topY + height) - 1
	If y0 < yMin Then y0 = yMin
	If y1 > yMax Then y1 = yMax
	Dim maxSpan As Int = 0
	Dim covered As Int = 0
	For yy = y0 To y1
		Dim mn0 As Int = rowMin.Get(yy)
		If mn0 >= 0 Then
			Dim span0 As Int = rowMax.Get(yy) - mn0 + 1
			If span0 > maxSpan Then maxSpan = span0
			covered = covered + 1
		End If
	Next
	If maxSpan <= 0 Then Return r
	Dim minSpan As Int = 1000000
	Dim leftLimit As Int = -1
	Dim rightLimit As Int = 1000000
	'先求带内最宽行的左右范围作参照；只保留"覆盖了这行大部分宽度"的行参与公共区间，
	'这样气球边缘的小凸起不会把可用宽度压成 1-2 像素，同时所有参与的行都在白色区域内
	Dim refMn As Int = -1
	Dim refMx As Int = -1
	For yy = y0 To y1
		Dim mnR As Int = rowMin.Get(yy)
		If mnR >= 0 Then
			Dim mxR As Int = rowMax.Get(yy)
			If refMn = -1 Or (mxR - mnR) > (refMx - refMn) Then
				refMn = mnR
				refMx = mxR
			End If
		End If
	Next
	If refMn < 0 Then Return r
	Dim refLen As Int = refMx - refMn + 1
	For yy = y0 To y1
		Dim mn As Int = rowMin.Get(yy)
		If mn >= 0 Then
			Dim mx As Int = rowMax.Get(yy)
			Dim span As Int = mx - mn + 1
			'与最宽行重叠超过一半的行才参与
			Dim ov As Int = Min(mx,refMx) - Max(mn,refMn) + 1
			If ov >= 0.5 * refLen Then
				If span < minSpan Then minSpan = span
				If mn > leftLimit Then leftLimit = mn
				If mx < rightLimit Then rightLimit = mx
			End If
		End If
	Next
	If leftLimit < 0 Then Return r
	r.Put("ok",True)
	r.Put("maxSpan",maxSpan)
	r.Put("minSpan",minSpan)
	r.Put("leftLimit",leftLimit)
	r.Put("rightLimit",rightLimit)
	r.Put("coveredRows",covered)
	Return r
End Sub

'按断好的行求每行位置。返回：
'  ok / lineLefts / lineTops（整图坐标）/ blockLeft / blockRight / blockWidth / bottomY
Private Sub RefineLines(lines As List,F As Font,rowMin As List,rowMax As List,yMin As Int,lineHeight As Double,lineStep As Double,Alignment As Int,areaLeft As Int,areaWidth As Int,avail() As Double) As Map
	Dim r As Map
	r.Initialize
	r.Put("ok",False)
	If lines.Size = 0 Then Return r
	Dim align As String = AlignmentKey(Alignment)
	Dim lineLefts As List
	Dim lineTops As List
	lineLefts.Initialize
	lineTops.Initialize
	Dim minLeft As Double = 1000000
	Dim maxRight As Double = -1000000
	For i = 0 To lines.Size - 1
		Dim lineW As Double = MeasureTextWidth(lines.Get(i),F)
		Dim band As Map = ReadMaskBand(rowMin,rowMax,yMin + i * lineStep,lineHeight,yMin,rowMin.Size - 1)
		Dim lLimit As Int = areaLeft
		Dim rLimit As Int = areaLeft + areaWidth - 1
		If band.Get("ok") Then
			lLimit = Max(band.Get("leftLimit"),areaLeft)
			rLimit = Min(band.Get("rightLimit"),areaLeft + areaWidth - 1)
		End If
		If rLimit < lLimit Then
			'该行带里没有落在框内的掩膜：以掩膜中轴/框为准，允许溢出
			lLimit = areaLeft
			rLimit = areaLeft + areaWidth - 1
		End If
		'断行时这一行的可用宽度不超过 avail(i)；这里只把区间收窄到段宽，不要求文字整体能放进去
		'（字号固定，长单词允许在本行左右各溢出一点，由归位逻辑让它围绕掩膜中轴）
		If i < avail.Length Then
			Dim segW As Double = Min(avail(i),rLimit - lLimit + 1)
			Dim segCenter As Double = (lLimit + rLimit + 1) / 2.0
			lLimit = Floor(segCenter - segW / 2.0)
			rLimit = lLimit + segW - 1
		End If
		Dim l As Double
		If align = "LEFT" Then
			l = lLimit
		Else If align = "RIGHT" Then
			l = rLimit + 1 - lineW
		Else
			l = (lLimit + rLimit + 1) / 2.0 - lineW / 2
		End If
		'文字比该行区间宽时尽量往里收，不让它伸出框
		If l + lineW > areaLeft + areaWidth Then l = areaLeft + areaWidth - lineW
		If l < areaLeft Then l = areaLeft
		lineLefts.Add(l)
		lineTops.Add(yMin + i * lineStep)
		minLeft = Min(minLeft,l)
		maxRight = Max(maxRight,l + lineW)
	Next
	r.Put("ok",True)
	r.Put("lineLefts",lineLefts)
	r.Put("lineTops",lineTops)
	r.Put("blockLeft",minLeft)
	r.Put("blockRight",maxRight)
	r.Put("blockWidth",maxRight - minLeft)
	r.Put("bottomY",yMin + (lines.Size - 1) * lineStep + lineHeight)
	Return r
End Sub

Private Sub MaxLineWidth(lines As List,F As Font) As Double
	Dim w As Double = 0
	For Each lineText As String In lines
		w = Max(w,MeasureTextWidth(lineText,F))
	Next
	Return w
End Sub

'DP 断行：把 n 个词放进 lineCount 行，每行宽度不超过 avail(i)，单词不拆。
'无解返回 Null。
Private Sub SolveMaskBreak(words As List,prefix() As Double,spaceWidth As Double,avail() As Double,n As Int) As List
	Dim inf As Double = 1e100
	Dim lineCount As Int = avail.Length
	Dim dp(n + 1) As Double
	Dim nextDp(n + 1) As Double
	For j = 0 To n
		dp(j) = inf
	Next
	dp(0) = 0
	Dim choices As List
	choices.Initialize
	For i = 0 To lineCount - 1
		Dim choice As List
		choice.Initialize
		For j = 0 To n
			choice.Add(-1)
			nextDp(j) = inf
		Next
		For j = 1 To n
			Dim bestCost As Double = inf
			Dim bestK As Int = -1
			For k = 0 To j - 1
				If dp(k) < inf Then
					Dim lineW As Double = prefix(j) - prefix(k) + (j - k - 1) * spaceWidth
					If lineW <= avail(i) + 0.01 Then
						Dim slack As Double = avail(i) - lineW
						Dim cost As Double = dp(k) + slack * slack / Max(1.0,avail(i))
						If cost < bestCost Then
							bestCost = cost
							bestK = k
						End If
					End If
				End If
			Next
			If bestK >= 0 Then
				nextDp(j) = bestCost
				choice.Set(j,bestK)
			End If
		Next
		For j = 0 To n
			dp(j) = nextDp(j)
		Next
		choices.Add(choice)
	Next
	If dp(n) >= inf Then Return Null
	Dim lines As List
	lines.Initialize
	Dim pos As Int = n
	For i = lineCount - 1 To 0 Step -1
		Dim ch As List = choices.Get(i)
		Dim k As Int = ch.Get(pos)
		Dim sb As StringBuilder
		sb.Initialize
		For t = k To pos - 1
			If t > k Then sb.Append(" ")
			sb.Append(words.Get(t))
		Next
		lines.InsertAt(0,sb.ToString)
		pos = k
	Next
	Return lines
End Sub

Private Sub WrapWordsToWidth(Text As String,width As Double,F As Font) As List
	Dim lines As List
	lines.Initialize
	Dim s As String = Text.Replace(Chr(160)," ").Trim
	If s = "" Then Return lines
	Dim words As List = Regex.Split("\s+",s)
	Dim sb As StringBuilder
	sb.Initialize
	For Each w As String In words
		Dim candidate As String
		If sb.Length = 0 Then
			candidate = w
		Else
			candidate = sb.ToString & " " & w
		End If
		If sb.Length > 0 And MeasureTextWidth(candidate,F) > width Then
			lines.Add(sb.ToString)
			sb.Initialize
			sb.Append(w)
		Else
			sb.Initialize
			sb.Append(candidate)
		End If
	Next
	If sb.Length > 0 Then lines.Add(sb.ToString)
	Return lines
End Sub

Private Sub AlignmentKey(Alignment As Int) As String
	If Alignment = 0 Then Return "LEFT"
	If Alignment = 2 Then Return "RIGHT"
	Return "CENTER"
End Sub

Private Sub MeasureTextWidth(s As String,F As Font) As Double
	Dim t As JavaObject
	t.InitializeNewInstance("javafx.scene.text.Text", Array(s))
	t.RunMethod("setFont", Array(F))
	Dim b As JavaObject = t.RunMethod("getLayoutBounds", Null)
	Return b.RunMethod("getWidth", Null)
End Sub

Private Sub MeasureLineHeight(F As Font) As Double
	Dim t As JavaObject
	t.InitializeNewInstance("javafx.scene.text.Text", Array("Hg"))
	t.RunMethod("setFont", Array(F))
	Dim b As JavaObject = t.RunMethod("getLayoutBounds", Null)
	Return b.RunMethod("getHeight", Null)
End Sub
