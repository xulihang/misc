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

	'照旧版 LoadMaskSpans(MinX,MaxX) 的做法：只在框的横向范围 [xStart,xLimit) 里
	'由原始掩膜重新求每行区间。不能对整行 rowMin/rowMax 再做裁剪：
	'同一行右侧的另一段掩膜会把边界拉过去，旧版根本看不到那一段。
	Dim xStart As Int = Max(areaLeft,0)
	Dim xLimit As Int = Min(areaLeft + areaWidth,Mask.Get("width"))
	Dim rowMin As List
	Dim rowMax As List
	rowMin.Initialize
	rowMax.Initialize
	Dim bc As BitmapCreator = Mask.Get("bitmap")
	If bc.IsInitialized Then
		Dim c As ARGBColor
		c.Initialize
		For y = 0 To bc.mHeight - 1
			Dim minx As Int = -1
			Dim rightX As Int = -1
			For x = xStart To xLimit - 1
				bc.GetARGB(x,y,c)
				If c.r > 128 Then
					If minx < 0 Then minx = x
					rightX = x
				End If
			Next
			rowMin.Add(minx)
			rowMax.Add(rightX)
		Next
	Else
		'没有位图时退回整行结果（只能在整图掩膜时用）
		Dim rowMinRaw As List = Mask.Get("rowMin")
		Dim rowMaxRaw As List = Mask.Get("rowMax")
		For y = 0 To rowMinRaw.Size - 1
			Dim mn As Int = rowMinRaw.Get(y)
			Dim mx As Int = rowMaxRaw.Get(y)
			If mn >= 0 Then
				mn = Max(mn,xStart)
				mx = Min(mx,xLimit - 1)
				If mx < mn Then
					mn = -1
					mx = -1
				End If
			End If
			rowMin.Add(mn)
			rowMax.Add(mx)
		Next
	End If

	'和旧版 LoadMaskSpans 一样：yMin/yMax 取"框内掩膜"的上下界
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

	'文字块的水平中心：和旧版一样，取掩膜逐行中心点的平均值（所有行共用一个中心）
	Dim CenterX As Double = (xStart + xLimit - 1) / 2.0
	Dim sumC As Double = 0
	Dim cntC As Int = 0
	For y = 0 To rowMin.Size - 1
		Dim rmn As Int = rowMin.Get(y)
		If rmn >= 0 Then
			sumC = sumC + (rmn + rowMax.Get(y)) / 2.0
			cntC = cntC + 1
		End If
	Next
	If cntC > 0 Then CenterX = sumC / cntC

	Dim s As String = Text.Trim
	Dim words As List
	words.Initialize
	If s <> "" Then
		s = s.Replace(Chr(160)," ")
		words = Regex.Split("\s+",s)
	End If
	Dim n As Int = words.Size
	If n = 0 Then
		result.Put("success",True)
		result.Put("blockWidth",xLimit - xStart)
		result.Put("wrapWidth",xLimit - xStart)
		result.Put("blockHeight",MeasureLineHeight(F))
		result.Put("topOffset",yMin - areaTop)
		Return result
	End If

	Dim wordWidths(n) As Double
	For i = 0 To n - 1
		wordWidths(i) = MeasureTextWidth(words.Get(i),F)
	Next
	Dim spaceWidth As Double = MeasureTextWidth("A A",F) - 2 * MeasureTextWidth("A",F)
	If spaceWidth <= 0 Then spaceWidth = MeasureTextWidth(" ",F)
	Dim naturalLineHeight As Double = MeasureLineHeight(F)
	If naturalLineHeight <= 0 Then naturalLineHeight = F.Size * 1.2
	Dim lineStep As Double = naturalLineHeight + LineSpacing
	Dim prefix(n + 1) As Double
	For j = 1 To n
		prefix(j) = prefix(j - 1) + wordWidths(j - 1)
	Next
	Dim totalTextWidth As Double = prefix(n) + (n - 1) * spaceWidth
	Dim maxLines As Int = Ceil(H / lineStep)
	If maxLines < 1 Then maxLines = 1
	If maxLines > n Then maxLines = n
	Dim align As String = AlignmentKey(Alignment)

	'和旧版一致：目标行数 = VerticalFill * 高度 / 行距
	Dim targetLines As Int = Round(VerticalFill * H / lineStep)
	If targetLines < 1 Then targetLines = 1
	If targetLines > maxLines Then targetLines = maxLines
	Dim bestDiff As Int = 1000000
	Dim bestFill As Double = -1
	Dim bestLines As List
	Dim bestCenters As List
	Dim bestSlots As List
	Dim bestFillOK As Boolean = False

	For lineCount = 1 To maxLines
		Dim avail(lineCount) As Double
		Dim centers(lineCount) As Double
		Dim slots As List
		slots.Initialize
		Dim centerList As List
		centerList.Initialize
		Dim ok As Boolean = True
		For i = 0 To lineCount - 1
			'只按文字实际占用的高度取掩膜宽度（行距是空白，不算进去）
			Dim lineTopY As Double = yMin + i * lineStep
			Dim y0 As Int = Floor(lineTopY)
			Dim y1 As Int = Ceil(lineTopY + naturalLineHeight) - 1
			If y0 < yMin Then y0 = yMin
			If y1 > yMax Then y1 = yMax
			'完全照旧版 BalloonText 的两遍结构：
			'  第一遍求带内最宽的 span（maxSpan）
			'  第二遍只让 span >= 0.5*maxSpan 的行参与，求它们的交集（leftLimit/rightLimit）
			'    和其中最小的 span（minSpan）
			'行边界用该行自己的掩膜区间；本方法拿到的掩膜已经按框横向范围限定过，
			'所以同一高度别的气球不会混进来。
			Dim maxSpan As Int = 0
			For yy = y0 To y1
				Dim mn0 As Int = rowMin.Get(yy)
				If mn0 >= 0 Then
					Dim span0 As Int = rowMax.Get(yy) - mn0 + 1
					If span0 > maxSpan Then maxSpan = span0
				End If
			Next
			If maxSpan <= 0 Then
				ok = False
				Exit
			End If
			Dim minSpan As Int = 1000000
			Dim leftLimit As Int = -1
			Dim rightLimit As Int = 1000000
			Dim rowCount As Int = 0
			For yy = y0 To y1
				Dim mn2 As Int = rowMin.Get(yy)
				If mn2 >= 0 Then
					Dim mx2 As Int = rowMax.Get(yy)
					Dim span As Int = mx2 - mn2 + 1
					If span >= 0.5 * maxSpan Then
						If span < minSpan Then minSpan = span
						If mn2 > leftLimit Then leftLimit = mn2
						If mx2 < rightLimit Then rightLimit = mx2
						rowCount = rowCount + 1
					End If
				End If
			Next
			If rowCount = 0 Then
				ok = False
				Exit
			End If
			Dim slot As Double
			Dim lineCenter As Double
			If align = "LEFT" Or align = "RIGHT" Then
				'左右对齐：可用宽度 = 各行区间的交集宽度，起点贴交集左/右边界
				slot = rightLimit - leftLimit + 1
				If align = "LEFT" Then
					lineCenter = leftLimit + slot / 2
				Else
					lineCenter = rightLimit - slot / 2
				End If
			Else
				'居中：可用宽度 = 最窄 span，所有行共用一个固定中心
				slot = minSpan
				lineCenter = CenterX
			End If
			If slot < 4 Then
				ok = False
				Exit
			End If
			avail(i) = slot
			centers(i) = lineCenter
			slots.Add(slot)
			centerList.Add(lineCenter)
		Next
		If ok = False Then Continue
		Dim solved As List = SolveMaskBreak(words,prefix,spaceWidth,avail,n)
		If solved.IsInitialized = False Then Continue
		Dim availSum As Double = 0
		For i = 0 To lineCount - 1
			availSum = availSum + avail(i)
		Next
		Dim fill As Double = totalTextWidth / Max(1.0,availSum)
		'评分：优先选填充率高的方案（行数多、每行只剩一个词时填充率会很低），
		'行数与 H/lineStep 的接近程度只作为次级参考
		Dim diff As Int = Abs(lineCount - targetLines)
		'和旧版一致：先比行数是否接近 targetLines（diff），再比填充率
		If diff < bestDiff Or (diff = bestDiff And fill > bestFill) Then
			bestDiff = diff
			bestFill = fill
			bestLines = solved
			bestCenters = centerList
			bestSlots = slots
			bestFillOK = True
		End If
	Next

	If bestFillOK = False Then
		Dim ow As Double = xLimit - xStart
		Dim rows As List = WrapWordsToWidth(Text,ow,F)
		Dim oh As Double = naturalLineHeight + Max(0,rows.Size - 1) * lineStep
		result.Put("success",True)
		result.Put("overflow",True)
		result.Put("blockWidth",ow)
		result.Put("wrapWidth",ow)
		result.Put("blockHeight",oh)
		result.Put("topOffset",yMin - areaTop)
		result.Put("leftOffset",0.0)
		result.Put("blockLeft",0.0)
		Log("balloonMask: overflow fallback, width=" & ow)
		Return result
	End If

	Dim lineLefts As List
	Dim lineTops As List
	lineLefts.Initialize
	lineTops.Initialize
	Dim minLeft As Double = 1000000
	Dim maxRight As Double = -1000000
	For i = 0 To bestLines.Size - 1
		Dim lineText As String = bestLines.Get(i)
		Dim lineW As Double = MeasureTextWidth(lineText,F)
		Dim slot As Double = bestSlots.Get(i)
		Dim center As Double = bestCenters.Get(i)
		'每行是一个宽 slot 的 TextFlow，左边界 = 中心 - slot/2。
		'旧版就是这样：TextFlow 用该行自己的 textAlignment 在 slot 内对齐，
		'所以 LEFT 行贴着 slot 左边，RIGHT 行贴着右边，CENTER 在中间
		Dim l As Double = center - slot / 2
		Dim lineRight As Double = l + slot
		lineLefts.Add(l - areaLeft)
		lineTops.Add(yMin + i * lineStep - areaTop)
		minLeft = Min(minLeft,l)
		maxRight = Max(maxRight,lineRight)
	Next
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To bestLines.Size - 1
		If i > 0 Then sb.Append(Chr(10))
		sb.Append(bestLines.Get(i))
	Next
	result.Put("success",True)
	result.Put("text",sb.ToString)
	'每行的容器宽度（slot）和中心（框内坐标）：调用方按旧版方式逐行放置
	Dim lineSlots As List
	Dim lineCenters As List
	lineSlots.Initialize
	lineCenters.Initialize
	For i = 0 To bestSlots.Size - 1
		lineSlots.Add(bestSlots.Get(i))
		lineCenters.Add(bestCenters.Get(i) - areaLeft)
	Next
	result.Put("lineSlots",lineSlots)
	result.Put("lineCenters",lineCenters)
	result.Put("lineLefts",lineLefts)
	result.Put("lineTops",lineTops)
	result.Put("topOffset",lineTops.Get(0))
	result.Put("leftOffset",minLeft - areaLeft)
	result.Put("blockLeft",minLeft - areaLeft)
	result.Put("blockWidth",maxRight - minLeft)
	result.Put("wrapWidth",xLimit - xStart)
	result.Put("blockHeight",yMin + (bestLines.Size - 1) * lineStep + naturalLineHeight - areaTop)
	Log("balloonMask: " & bestLines.Size & " lines, blockWidth=" & result.Get("blockWidth"))
	Return result
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
