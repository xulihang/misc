B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=8.8
@EndOfDesignText@
'Static code module
'把英文单词自动分配到“上下窄、中间宽”的菱形（或椭圆）宽度中。
'TextFlow 本身只会按矩形宽度自动换行，所以这里先算好每一行的断词位置，
'再把结果用 Chr(10) 连起来交给 TextFlow（配合 CENTER 对齐）渲染。
'
'WrapText 返回的 Map:
'  success      As Boolean  是否放得下（单个单词比最宽处还宽时为 False）
'  lines        As List     每一行的文本
'  widths       As List     每一行实际测量的像素宽度
'  lineCount    As Int
'  lineHeight   As Double   每行占用的高度（含行距）
'  blockHeight  As Double   整个文本块的高度
Sub Process_Globals
End Sub

'根据形状宽度自动选择行数并断行。
'Shape: "diamond"（菱形，宽度线性变化）或 "ellipse"（椭圆）
'FillRatio: 每行允许使用形状宽度的比例，例如 0.92（左右留一点边距）
'VerticalFill: 文本块希望占用的形状高度比例（0.5~0.9），用于挑选行数
Public Sub WrapText(Text As String, F As Font, ShapeWidth As Double, ShapeHeight As Double, Shape As String, LineSpacing As Double, FillRatio As Double, VerticalFill As Double) As Map
	Dim result As Map
	result.Initialize
	Dim emptyLines As List
	emptyLines.Initialize
	Dim emptyWidths As List
	emptyWidths.Initialize
	result.Put("success", False)
	result.Put("lines", emptyLines)
	result.Put("widths", emptyWidths)
	result.Put("lineCount", 0)
	result.Put("lineHeight", 0.0)
	result.Put("blockHeight", 0.0)

	Dim trimmed As String = Text.Trim
	If trimmed = "" Then
		result.Put("success", True)
		Return result
	End If

	'1. 按空格分词（英文按单词换行，不在单词内部断开）
	Dim words As List = Regex.Split("\s+", trimmed)
	Dim n As Int = words.Size
	Dim wordWidths(n) As Double
	Dim maxWordWidth As Double = 0
	For i = 0 To n - 1
		wordWidths(i) = MeasureTextWidth(words.Get(i), F)
		If wordWidths(i) > maxWordWidth Then maxWordWidth = wordWidths(i)
	Next
	Dim spaceWidth As Double = MeasureSpaceWidth(F)

	'2. 行高与最多行数
	Dim naturalLineHeight As Double = MeasureLineHeight(F)
	Dim lineHeight As Double = naturalLineHeight + LineSpacing
	Dim halfHeight As Double = ShapeHeight / 2
	Dim maxLines As Int = Floor(ShapeHeight / lineHeight)
	If maxLines < 1 Then maxLines = 1
	If maxLines > n Then maxLines = n

	'3. 单词宽度前缀和，用于 O(1) 计算任意词区间宽度
	Dim prefix(n + 1) As Double
	For j = 1 To n
		prefix(j) = prefix(j - 1) + wordWidths(j - 1)
	Next
	Dim totalTextWidth As Double = prefix(n) + (n - 1) * spaceWidth

	'4. 优先挑选接近目标行数、且文本量能填满宽度的方案
	Dim targetLines As Int = Round(VerticalFill * ShapeHeight / lineHeight)
	If targetLines < 1 Then targetLines = 1
	If targetLines > maxLines Then targetLines = maxLines

	Dim bestDiff As Int = 1000000
	Dim bestLines As List
	Dim fallbackLines As List

	For lineCount = 1 To maxLines
		Dim available(lineCount) As Double
		Dim availableSum As Double = 0
		Dim widest As Double = 0
		For i = 0 To lineCount - 1
			'第 i 行的中心相对形状中心的垂直偏移
			Dim dy As Double = (i - (lineCount - 1) / 2.0) * lineHeight
			available(i) = WidthAt(dy, ShapeWidth, halfHeight, Shape) * FillRatio
			availableSum = availableSum + available(i)
			If available(i) > widest Then widest = available(i)
		Next
		If maxWordWidth > widest Then Continue
		'形状总容量都不够，肯定放不下
		If totalTextWidth > availableSum Then Continue

		Dim breakLines As List = SolveBreak(words, prefix, spaceWidth, available, n)
		If breakLines.IsInitialized = False Then Continue
		fallbackLines = breakLines
		'文本太少时不要硬凑很多行（否则每行只有一两个词，看起来很散）
		If totalTextWidth < 0.55 * availableSum Then Continue
		Dim diff As Int = Abs(lineCount - targetLines)
		If diff < bestDiff Then
			bestDiff = diff
			bestLines = breakLines
		End If
	Next

	If bestLines.IsInitialized = False Then
		If fallbackLines.IsInitialized = False Then
			Return result '放不下
		End If
		bestLines = fallbackLines
	End If

	'5. 计算每行实际宽度
	Dim widths As List
	widths.Initialize
	For Each lineText As String In bestLines
		widths.Add(MeasureTextWidth(lineText, F))
	Next
	result.Put("success", True)
	result.Put("lines", bestLines)
	result.Put("widths", widths)
	result.Put("lineCount", bestLines.Size)
	result.Put("lineHeight", lineHeight)
	result.Put("blockHeight", bestLines.Size * naturalLineHeight + (bestLines.Size - 1) * LineSpacing)
	Return result
End Sub

'根据形状与行的垂直偏移返回该行可用宽度
Private Sub WidthAt(dy As Double, ShapeWidth As Double, HalfHeight As Double, Shape As String) As Double
	If HalfHeight <= 0 Then Return ShapeWidth
	Dim t As Double = Abs(dy) / HalfHeight
	If t >= 1 Then Return 0
	Dim shapeName As String = Shape.ToLowerCase
	If shapeName = "ellipse" Or shapeName = "oval" Then
		Return ShapeWidth * Sqrt(1 - t * t)
	End If
	'菱形：宽度随 |dy| 线性变窄
	Return ShapeWidth * (1 - t)
End Sub

'动态规划断行：把 n 个单词放进 available() 指定的若干行里，
'每行的词必须不超宽，代价是各行剩余空间（相对可用宽度）的平方和最小。
'无解返回 Null，否则返回 List（每行文本，从上到下）。
Private Sub SolveBreak(words As List, prefix() As Double, spaceWidth As Double, available() As Double, n As Int) As List
	Dim inf As Double = 1e100
	Dim lineCount As Int = available.Length
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
					If lineW <= available(i) + 0.01 Then
						Dim slack As Double = available(i) - lineW
						Dim cost As Double = dp(k) + slack * slack / Max(1.0, available(i))
						If cost < bestCost Then
							bestCost = cost
							bestK = k
						End If
					End If
				End If
			Next
			If bestK >= 0 Then
				nextDp(j) = bestCost
				choice.Set(j, bestK)
			End If
		Next
		For j = 0 To n
			dp(j) = nextDp(j)
		Next
		choices.Add(choice)
	Next

	If dp(n) >= inf Then Return Null

	'从最后一行往前还原断点
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
		lines.InsertAt(0, sb.ToString)
		pos = k
	Next
	Return lines
End Sub

'创建一个带换行文本的 TextFlow：行内水平居中，宽度固定为形状宽度
Public Sub CreateTextFlow(Result As Map, F As Font, Width As Double, LineSpacing As Double, Alignment As String) As Pane
	Dim tf As JavaObject
	tf.InitializeNewInstance("javafx.scene.text.TextFlow", Null)
	Dim ta As JavaObject
	ta.InitializeStatic("javafx.scene.text.TextAlignment")
	tf.RunMethod("setTextAlignment", Array(ta.GetField(Alignment)))
	tf.RunMethod("setLineSpacing", Array(LineSpacing))

	Dim lines As List = Result.Get("lines")
	Dim sb As StringBuilder
	sb.Initialize
	For i = 0 To lines.Size - 1
		If i > 0 Then sb.Append(Chr(10))
		sb.Append(lines.Get(i))
	Next
	Dim t As JavaObject
	t.InitializeNewInstance("javafx.scene.text.Text", Array(sb.ToString))
	t.RunMethod("setFont", Array(F))
	'通过 B4J 的 Pane 包装添加 Text 节点（直接用 JavaObject 反射 getChildren().addAll
	'会访问 javafx.base 内部类而被模块系统拒绝）
	Dim p As Pane = tf
	Dim tn As Node = t
	p.AddNode(tn, 0, 0, -1, -1)
	'不设置 maxWidth：换行已由 Chr(10) 显式控制，prefWidth 只决定行的对齐宽度
	tf.RunMethod("setPrefWidth", Array(Width))
	Return p
End Sub

'创建一个只有描边的菱形节点，方便对比文字轮廓
Public Sub CreateShapeNode(Width As Double, Height As Double, Fill As Paint, Stroke As Paint, StrokeWidth As Double) As Node
	Dim poly As JavaObject
	poly.InitializeNewInstance("javafx.scene.shape.Polygon", Null)
	Dim pts As List
	pts.Initialize
	pts.Add(Width / 2)
	pts.Add(0.0)
	pts.Add(Width)
	pts.Add(Height / 2)
	pts.Add(Width / 2)
	pts.Add(Height)
	pts.Add(0.0)
	pts.Add(Height / 2)
	poly.RunMethodJO("getPoints", Null).RunMethod("addAll", Array(pts))
	poly.RunMethod("setFill", Array(Fill))
	poly.RunMethod("setStroke", Array(Stroke))
	poly.RunMethod("setStrokeWidth", Array(StrokeWidth))
	Return poly
End Sub

Private Sub MeasureTextWidth(s As String, F As Font) As Double
	Dim t As JavaObject
	t.InitializeNewInstance("javafx.scene.text.Text", Array(s))
	t.RunMethod("setFont", Array(F))
	Dim b As JavaObject = t.RunMethod("getLayoutBounds", Null)
	Return b.RunMethod("getWidth", Null)
End Sub

Private Sub MeasureSpaceWidth(F As Font) As Double
	Dim w1 As Double = MeasureTextWidth("A A", F)
	Dim w2 As Double = MeasureTextWidth("A", F)
	Dim space As Double = w1 - 2 * w2
	If space <= 0 Then space = MeasureTextWidth(" ", F)
	Return space
End Sub

Private Sub MeasureLineHeight(F As Font) As Double
	Dim t As JavaObject
	t.InitializeNewInstance("javafx.scene.text.Text", Array("Hg"))
	t.RunMethod("setFont", Array(F))
	Dim b As JavaObject = t.RunMethod("getLayoutBounds", Null)
	Return b.RunMethod("getHeight", Null)
End Sub
