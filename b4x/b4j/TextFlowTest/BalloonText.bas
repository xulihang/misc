B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.8
@EndOfDesignText@
'Static code module
'根据气泡掩膜图计算每一行的可用宽度（以及该行的水平中心），
'再按最新形状换行逻辑断行。文字不进气泡掩膜外的区域，不改变字号。
Sub Process_Globals
End Sub

'读取掩膜图（红色区域为气泡），只统计 MinX <= x < MaxX 的区域，返回：
'  width, height
'  yMin, yMax            掩膜区域的垂直范围
'  rowMin, rowMax        List，每一行红像素的最左/最右 x（没有红像素为 -1）
'  centerX               该区域所有行中心点的平均值
Public Sub LoadMaskSpans(Dir As String,FileName As String,MinX As Int,MaxX As Int) As Map
	Dim result As Map
	result.Initialize
	Dim ins As InputStream = File.OpenInput(Dir,FileName)
	Dim img As JavaObject
	img.InitializeNewInstance("javafx.scene.image.Image",Array(ins))
	ins.Close
	Dim w As Int = img.RunMethod("getWidth",Null)
	Dim h As Int = img.RunMethod("getHeight",Null)
	Dim pr As JavaObject = img.RunMethod("getPixelReader",Null)
	Dim pixels(w*h) As Int
	Dim readOK As Boolean = False
	Try
		Dim pf As JavaObject
		pf.InitializeStatic("javafx.scene.image.PixelFormat")
		Dim fmt As JavaObject = pf.RunMethod("getIntArgbInstance",Null)
		pr.RunMethod("getPixels",Array(0,0,w,h,fmt,pixels,0,w))
		readOK = True
	Catch
		Log("getPixels failed: " & LastException)
	End Try
	If readOK = False Then
		For y = 0 To h - 1
			For x = 0 To w - 1
				pixels(y*w+x) = pr.RunMethod("getArgb",Array(x,y))
			Next
		Next
	End If

	Dim rowMin,rowMax As List
	rowMin.Initialize
	rowMax.Initialize
	Dim yMin As Int = h
	Dim yMax As Int = -1
	Dim centerSum As Double = 0
	Dim centerRows As Int = 0
	Dim xLimit As Int = Min(MaxX,w)
	Dim xStart As Int = Max(0,MinX)
	For y = 0 To h - 1
		Dim minx As Int = -1
		Dim rightX As Int = -1
		For x = xStart To xLimit - 1
			Dim p As Int = pixels(y*w+x)
			Dim r As Int = Bit.And(Bit.ShiftRight(p,16),255)
			Dim g As Int = Bit.And(Bit.ShiftRight(p,8),255)
			Dim b As Int = Bit.And(p,255)
			If r > 128 And g < 100 And b < 100 Then
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
		End If
	Next
	'文字块使用一个固定的中心（所有行共用一个 x），避免逐行跟随掩膜中心而看起来"歪"
	Dim centerX As Double = 0
	If centerRows > 0 Then centerX = centerSum / centerRows
	result.Put("width",w)
	result.Put("height",h)
	result.Put("yMin",yMin)
	result.Put("yMax",yMax)
	result.Put("rowMin",rowMin)
	result.Put("rowMax",rowMax)
	result.Put("regionMinX",xStart)
	result.Put("regionMaxX",xLimit - 1)
	result.Put("centerX",centerX)
	Return result
End Sub

'按掩膜的逐行宽度断行。和 ImageTrans 里的形状换行一致：
'- 不在单词内部断行
'- 所有行共用一个固定中心（居中的仍然保持居中，不会逐行偏移）
'- 每行可用宽度 = 该行带内、以固定中心为轴左右两侧较小一半的两倍（保证不出气泡）
'- 行数允许向上取整，文本块可以略微超出掩膜高度（不压行距、不改字号）
'返回：
'  success, lines, widths(文字实际宽度), centers(每行中心x),
'  slots(每行可用宽度), top(相对 yMin 的偏移), yMin, lineStep, naturalLineHeight,
'  overflow(True 表示字号太大、按掩膜排不下，文本块改用 maxWidth 自动换行)
'  blockLines / blockWidth / blockHeight / blockLeft / blockTop  溢出时整块 TextFlow 的几何
Public Sub WrapInMask(Text As String,F As Font,Mask As Map,LineSpacing As Double,Padding As Double,VerticalFill As Double,Alignment As String) As Map
	Dim result As Map
	result.Initialize
	Dim emptyList As List
	emptyList.Initialize
	result.Put("success",False)
	result.Put("lines",emptyList)
	result.Put("widths",emptyList)
	result.Put("centers",emptyList)
	result.Put("slots",emptyList)
	result.Put("top",0.0)
	result.Put("yMin",0)
	result.Put("lineStep",0.0)
	result.Put("naturalLineHeight",0.0)
	result.Put("overflow",False)
	result.Put("blockLines",emptyList)
	result.Put("blockWidth",0.0)
	result.Put("blockHeight",0.0)
	result.Put("blockLeft",0.0)
	result.Put("blockTop",0.0)
	Dim s As String = Text.Trim
	If s = "" Then
		result.Put("success",True)
		Return result
	End If
	s = s.Replace(Chr(160)," ")
	Dim words As List = Regex.Split("\s+",s)
	Dim n As Int = words.Size
	If n = 0 Then
		result.Put("success",True)
		Return result
	End If

	Dim rowMin As List = Mask.Get("rowMin")
	Dim rowMax As List = Mask.Get("rowMax")
	Dim yMin As Int = Mask.Get("yMin")
	Dim yMax As Int = Mask.Get("yMax")
	Dim H As Int = yMax - yMin + 1
	Dim CenterX As Double = Mask.Get("centerX")

	Dim wordWidths(n) As Double
	Dim maxWordWidth As Double = 0
	For i = 0 To n - 1
		Dim word As String = words.Get(i)
		wordWidths(i) = MeasureTextWidth(word,F)
		If wordWidths(i) > maxWordWidth Then maxWordWidth = wordWidths(i)
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
	Dim targetLines As Int = Round(VerticalFill * H / lineStep)
	If targetLines < 1 Then targetLines = 1
	If targetLines > maxLines Then targetLines = maxLines

	Dim bestDiff As Int = 1000000
	Dim bestFill As Double = -1
	Dim bestLines As List
	Dim bestCenters As List
	Dim bestSlots As List
	Dim bestTop As Double
	Dim bestFillOK As Boolean = False

	For lineCount = 1 To maxLines
		Dim blockHeight As Double = naturalLineHeight + (lineCount - 1) * lineStep
		'掩膜模式下文本块从顶部开始排（垂直居中会让最后一行落进气泡底部的窄尾巴）
		Dim top As Double = 0
		Dim avail(lineCount) As Double
		Dim centers(lineCount) As Double
		Dim slots As List
		slots.Initialize
		Dim centerList As List
		centerList.Initialize
		Dim ok As Boolean = True
		For i = 0 To lineCount - 1
			'只按文字实际占用的高度取掩膜宽度（行距是空白，不能算进去，否则最后一行会
			'被气泡底部的窄尾巴卡死）
			Dim lineTopY As Double = yMin + top + i * lineStep
			Dim y0 As Int = Floor(lineTopY)
			Dim y1 As Int = Ceil(lineTopY + naturalLineHeight) - 1
			If y0 < yMin Then y0 = yMin
			If y1 > yMax Then y1 = yMax
			'先求该行带内最宽的掩膜行；太窄的行（顶部小凸起、底部尖尾巴）不参与宽度计算，
			'否则会把整行可用区间压得极小
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
				Dim mn As Int = rowMin.Get(yy)
				If mn >= 0 Then
					Dim mx As Int = rowMax.Get(yy)
					Dim span As Int = mx - mn + 1
					If span >= 0.5 * maxSpan Then
						If span < minSpan Then minSpan = span
						If mn > leftLimit Then leftLimit = mn
						If mx < rightLimit Then rightLimit = mx
						rowCount = rowCount + 1
					End If
				End If
			Next
			If rowCount = 0 Then
				ok = False
				Exit
			End If
			Dim align As String = Alignment.ToUpperCase
			Dim slot As Double
			Dim lineCenter As Double
			If align = "LEFT" Or align = "RIGHT" Then
				'左/右对齐：取该行带内所有行区间的交集，保证文字不出气泡；
				'各行的起始/结束位置会跟随掩膜边缘，因此允许出现错位
				slot = (rightLimit - leftLimit + 1) - 2 * Padding
				If align = "LEFT" Then
					lineCenter = leftLimit + Padding + slot / 2
				Else
					lineCenter = rightLimit - Padding - slot / 2
				End If
			Else
				'居中：所有行共用一个固定中心，不会逐行左右偏移
				slot = minSpan - 2 * Padding
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
		Dim diff As Int = Abs(lineCount - targetLines)
		If diff < bestDiff Or (diff = bestDiff And fill > bestFill) Then
			bestDiff = diff
			bestFill = fill
			bestLines = solved
			bestCenters = centerList
			bestSlots = slots
			bestTop = top
			bestFillOK = True
		End If
	Next

	'字号太大，按掩膜怎么排都放不下（比如某个单词比该行的可用宽度还宽，
	'或者 maxLines 已经只剩 1 行）：不再返回空结果，改为允许溢出，
	'整段文字放进一个宽度固定的 TextFlow，由 maxWidth 自动换行。
	If bestFillOK = False Then
		Return BuildOverflowResult(Text,Mask,F,Alignment,result)
	End If
	Dim widths As List
	widths.Initialize
	For Each lineText As String In bestLines
		widths.Add(MeasureTextWidth(lineText,F))
	Next
	result.Put("success",True)
	result.Put("lines",bestLines)
	result.Put("widths",widths)
	result.Put("centers",bestCenters)
	result.Put("slots",bestSlots)
	result.Put("top",bestTop)
	result.Put("yMin",yMin)
	result.Put("lineStep",lineStep)
	result.Put("naturalLineHeight",naturalLineHeight)
	result.Put("targetLines",targetLines)
	Return result
End Sub

'按掩膜排不下时的兜底：允许溢出，由 TextFlow 按 maxWidth 自动换行。
'- maxWidth 取该区域可用宽度的中位数，比最宽处窄一些，避免大字号时整行远远伸出气泡左右边缘
'- 整块水平居中到掩膜中心，从掩膜顶部 yMin 开始向下排，超出部分向下溢出
'- Alignment 同时影响块的位置：LEFT 左边缘贴掩膜左边缘，RIGHT 右边缘贴掩膜右边缘
Private Sub BuildOverflowResult(Text As String,Mask As Map,F As Font,Alignment As String,result As Map) As Map
	Dim rowMin As List = Mask.Get("rowMin")
	Dim rowMax As List = Mask.Get("rowMax")
	Dim yMin As Int = Mask.Get("yMin")
	Dim yMax As Int = Mask.Get("yMax")
	Dim CenterX As Double = Mask.Get("centerX")
	Dim regionMinX As Int = Mask.GetDefault("regionMinX",0)
	Dim regionMaxX As Int = Mask.GetDefault("regionMaxX",Mask.Get("width") - 1)
	Dim spans As List
	spans.Initialize
	For yy = yMin To yMax
		Dim mn As Int = rowMin.Get(yy)
		If mn >= 0 Then spans.Add(rowMax.Get(yy) - mn + 1)
	Next
	If spans.Size = 0 Then Return result
	spans.Sort(False)
	'可用宽度取中位数：比最宽处窄一些，避免大字号时整行远远伸出气泡左右边缘；
	'同时不超过掩膜区域本身的宽度
	Dim blockWidth As Double = Min(spans.Get(spans.Size / 2) + 0.0,regionMaxX - regionMinX + 1.0)
	Dim naturalLineHeight As Double = MeasureLineHeight(F)
	If naturalLineHeight <= 0 Then naturalLineHeight = F.Size * 1.2
	Dim lineStep As Double = naturalLineHeight + F.Size * 0.25
	'TextFlow 的自动换行不一定和 MeasureTextWidth 完全一致，多量几行，宁可高度算大
	Dim lineCount As Int = 0
	For Each lineText As String In WrapWordsToWidth(Text,blockWidth,F)
		lineCount = lineCount + 1
	Next
	Dim blockHeight As Double = naturalLineHeight + Max(0,lineCount - 1) * lineStep
	Dim oneLine As List
	oneLine.Initialize
	oneLine.Add(Text)
	'lines/widths/centers/slots 保持单行形式，即使调用方还没按 overflow 分支渲染，
	'也至少能画出第一行，而不是整块空白
	Dim widths As List
	widths.Initialize
	widths.Add(Min(MeasureTextWidth(Text,F),blockWidth))
	Dim centers As List
	centers.Initialize
	centers.Add(CenterX)
	Dim slots As List
	slots.Initialize
	slots.Add(blockWidth)
	result.Put("success",True)
	result.Put("overflow",True)
	result.Put("lines",oneLine)
	result.Put("widths",widths)
	result.Put("centers",centers)
	result.Put("slots",slots)
	result.Put("top",0.0)
	result.Put("yMin",yMin)
	result.Put("lineStep",lineStep)
	result.Put("naturalLineHeight",naturalLineHeight)
	result.Put("blockWidth",blockWidth)
	result.Put("blockHeight",blockHeight)
	Dim align As String = Alignment.ToUpperCase
	Dim blockLeft As Double = CenterX - blockWidth / 2
	If align = "LEFT" Then
		blockLeft = regionMinX
	Else If align = "RIGHT" Then
		blockLeft = regionMaxX - blockWidth + 1
	End If
	result.Put("blockLeft",blockLeft)
	result.Put("blockTop",yMin + 0.0)
	Return result
End Sub

'把文字按宽度断词（单词不拆），返回每行文本；和掩膜版的断行逻辑一致
Private Sub WrapWordsToWidth(Text As String,width As Double,F As Font) As List
	Dim lines As List
	lines.Initialize
	Dim words As List = Regex.Split("\s+",Text.Replace(Chr(160)," ").Trim)
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

'创建一个按 maxWidth 自动换行的 TextFlow（用于字号过大、允许溢出时）
Public Sub CreateOverflowFlow(Text As String,F As Font,Width As Double,Alignment As String) As Pane
	Dim tf As JavaObject
	tf.InitializeNewInstance("javafx.scene.text.TextFlow", Null)
	Dim ta As JavaObject
	ta.InitializeStatic("javafx.scene.text.TextAlignment")
	tf.RunMethod("setTextAlignment",Array(ta.GetField(Alignment.ToUpperCase)))
	Dim t As JavaObject
	t.InitializeNewInstance("javafx.scene.text.Text",Array(Text))
	t.RunMethod("setFont",Array(F))
	Dim p As Pane = tf
	Dim tn As Node = t
	p.AddNode(tn,0,0,-1,-1)
	'关键：字号比气泡还大时，TextFlow 不能再按掩膜逐行排，而是靠 maxWidth 自动换行
	tf.RunMethod("setPrefWidth",Array(Width))
	tf.RunMethod("setMaxWidth",Array(Width))
	Return p
End Sub

'DP：按 avail() 给定的每行可用宽度断行，单词不能拆。无解返回 Null。
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

'创建一个只放一行的 TextFlow（宽度为气泡在该行的可用宽度，按指定方式对齐）
Public Sub CreateLineFlow(Line As String,F As Font,Width As Double,Alignment As String) As Pane
	Dim tf As JavaObject
	tf.InitializeNewInstance("javafx.scene.text.TextFlow", Null)
	Dim ta As JavaObject
	ta.InitializeStatic("javafx.scene.text.TextAlignment")
	tf.RunMethod("setTextAlignment",Array(ta.GetField(Alignment.ToUpperCase)))
	Dim t As JavaObject
	t.InitializeNewInstance("javafx.scene.text.Text",Array(Line))
	t.RunMethod("setFont",Array(F))
	Dim p As Pane = tf
	Dim tn As Node = t
	p.AddNode(tn,0,0,-1,-1)
	tf.RunMethod("setPrefWidth",Array(Width))
	p.SetSize(Width,MeasureLineHeight(F))
	Return p
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
