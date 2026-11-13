B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.8
@EndOfDesignText@
Sub Class_Globals
	Private fx As JFX
	Private Label1 As Label
	Public Tag As Object
	Private mCallBack As Object 'ignore
	Private mEventName As String 'ignore
	Private tfPane As AnchorPane
	Private iv As ImageView
	Private mFontName As String
	Private mVerticalCJK As Boolean
	Private mPercent As Double=1.0
	Private mbold,mitalic As Boolean
	Private mWrappedText As String
	Private mVerticalAlignment As String="" 'top,bottom,center
	Private mHorizontalAlignment As String="" 'left,right,center
	Private mAlignment As String
	Private mLeft2RightForVertical As Boolean = False
	Private mRotation As Double
	Private mImageScale As Double = 1.0
	Private mLineSpace As Double = 1.25
	Private mTrakcing As Double = 0
	Private mPadding As Int = 0
	Private mImageWidth As Int
	Private mImageHeight As Int
	Private mStyle As String
	Private mFontStyleName As String
	Private mTargetLang As String
	Private mPaint As Paint = fx.Colors.Black
	Public TypesettingMode As Boolean = False
	Private mVerticalOffsetRules As Map
	Private mShadowRadius As Double
	Private mShadowColor As String
	Private mBalloonMask As cvMat
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize(Callback As Object, EventName As String,FontName As String,VerticalCJK As Boolean,targetLang As String)
	mCallBack=Callback
	mEventName=EventName
	mFontName=FontName
	mVerticalCJK=VerticalCJK
	mTargetLang=targetLang
	Label1.Initialize("Label1")
	tfPane.Initialize("tfPane")

	tfPane.AddNode(Label1,0,0,-1,-1)
	'tfPane.SetAnchors(Label1,0,0,0,0)
	Label1.Visible=True
	
	iv.Initialize("iv")
	iv.PickOnBounds=True
	iv.PreserveRatio=False
	tfPane.AddNode(iv,0,0,-1,-1)
End Sub

Public Sub setBalloonMask(m As cvMat)
	mBalloonMask = m
End Sub

Public Sub setVerticalOffsetRules(rules As Map)
	mVerticalOffsetRules = rules
End Sub

Public Sub getFontSize As Double
	Return Label1.Font.Size
End Sub

Public Sub getPercent As Double
	Return mPercent
End Sub

Public Sub getIsVertical As Boolean
	Return mVerticalCJK
End Sub

Public Sub SetTFPaneSize(width As Double,height As Double)
	tfPane.SetSize(width,height)
End Sub


public Sub SetLayout(left As Double,top As Double,width As Double,height As Double,percent As Double)
	mPercent=percent
	Dim widthCalculated,heightCalculated As Double
	widthCalculated = width/percent
	heightCalculated = height/percent
	Label1.SetLayoutAnimated(0,Label1.Left,Label1.Top,widthCalculated,heightCalculated)
	tfPane.SetLayoutAnimated(0,left,top,width,height)
End Sub

Sub SetSize(width As Double,height As Double,percent As Double)
	mPercent=percent
	Label1.SetSize(width/percent,height/percent)
	tfPane.SetSize(width,height)
End Sub

Public Sub SetWidth(width As Double)
	tfPane.SetSize(width,tfPane.Height)
	tfPane.PrefWidth = width
End Sub

public Sub rotate(degree As Double)
	'Log("degree")
	'Log(degree)
	mRotation=degree
	setShadow(mShadowColor,mShadowRadius)
	'Log(mStyle)
	Dim tagMap As Map=Tag
	Dim direction As Int=tagMap.GetDefault("direction",0)
	If direction <> 0 And mVerticalCJK = False Then
		Log("skip setting text")
	Else
		setText(Label1.Text)
	End If
    If mVerticalCJK = False Then
		Utils.RotateNode(iv,degree)
    End If
End Sub

public Sub getRotation As Double
	Return mRotation
End Sub

public Sub getVerticalAlignment As String
	Return mVerticalAlignment
End Sub

'center, top, bottom
public Sub setVerticalAlignment(Alignment As String)
    mVerticalAlignment=Alignment
	AdjustVerticalAlignment
End Sub

'center, left, right
public Sub setHorizontalAlignment(Alignment As String)
	mHorizontalAlignment=Alignment
	AdjustHorizontalAlignment
End Sub

public Sub getHorizontalAlignment As String
	Return mHorizontalAlignment
End Sub

Sub setShadow(rgba As String,shadowRadius As String)
	mShadowRadius = shadowRadius
	mShadowColor = rgba
	mStyle = getShadowStyle
End Sub

Private Sub getShadowStyle As String
	Dim upscaleRatio As Double = 1.0
	Dim radius As Double = mShadowRadius
	If mVerticalCJK Then
		If mRotation = 0 Then
			upscaleRatio = 1.414
		Else
			upscaleRatio = 1.414 * 1.414
		End If
		radius = radius * upscaleRatio
	End If
	Return "-fx-effect: dropshadow( three-pass-box , rgba("&mShadowColor&") , "&radius&" , 1 , 0 , 0 );"
End Sub

Public Sub setMouseCursor(cursor As Object)
	tfPane.MouseCursor=cursor
End Sub

Sub setStyle(style As String)
	If style = "" Then
		mShadowRadius = 0
		mShadowColor = ""
	End If
	mStyle=style
End Sub

Sub setFontStyleName(style As String)
	mFontStyleName=style
End Sub

Sub getTFAlignment As String
	Dim alignment As String
	If mAlignment.Contains("LEFT") Then
		alignment="LEFT"
	else if mAlignment.Contains("CENTER") Then
		alignment="CENTER"
	else if mAlignment.Contains("RIGHT") Then
		alignment="RIGHT"
	Else
		alignment="JUSTIFY"
	End If
	Return alignment
End Sub

public Sub getLineSpace As Double
	Return mLineSpace
End Sub

public Sub setLineSpace(value As Double)
	mLineSpace = value
End Sub

public Sub getTracking As Double
	Return mTrakcing
End Sub

public Sub setTracking(value As Double)
	mTrakcing = value
End Sub

public Sub getPadding As Int
	Return mPadding
End Sub

public Sub setPadding(value As Int)
	mPadding = value
End Sub

Public Sub setImageWidth(value As Int)
	mImageWidth = value
End Sub

Public Sub setImageHeight(value As Int)
	mImageHeight = value
End Sub

Public Sub getImageWidth As Int
	Return mImageWidth
End Sub

Public Sub getImageHeight As Int
	Return mImageHeight
End Sub

Sub getWidth As Double
	Return tfPane.Width
End Sub

Sub getHeight As Double
	Return tfPane.Height
End Sub

Sub getPrefWidth As Double
	Return tfPane.PrefWidth
End Sub

Sub getPrefHeight As Double
	Return tfPane.PrefHeight
End Sub

Sub getView As B4XView
	Return tfPane
End Sub

Sub getBasePane As Pane
	Return tfPane
End Sub

Sub getImageView As ImageView
	Return iv
End Sub

Sub getFont As Font
	Return Label1.Font
End Sub

Sub setFont(font As Font,familyName As String,bold As Boolean,italic As Boolean)
	Label1.Font=font
	mFontName=familyName
	mbold=bold
	mitalic=italic
End Sub

Sub setTextColor(a As Int,r As Int,g As Int,b As Int)
	mPaint=fx.Colors.ARGB(a,r,g,b)
End Sub

Sub setText(Text As String)
	Dim old As String=Label1.Text
	If Text = "" Then
		Text = " "
	End If
	Label1.Text=Text
	
	If mVerticalCJK Then
		If Text<>"" Then
			AddVerticalText
		Else
			AddTextFlow(tfPane.PrefWidth,tfPane.PrefHeight)
		End If
	Else
		If ShouldUseImageView Then
			AddHorizontalText
		Else
			AddTextFlow(tfPane.PrefWidth,tfPane.PrefHeight)
		End If
		EnableNonCJKVerticalIfNeeded
	End If
	CallSubDelayed3(mCallBack,mEventName&"_TextChanged",old,Text)
End Sub

private Sub ShouldUseImageView As Boolean
	If Label1.Text="" Then
		Return False
	Else
		Return True
	End If
End Sub

Sub getWrappedText As String
	If Label1.WrapText Then
		Return mWrappedText
	Else
		Return ""
	End If
End Sub

Private Sub MeasureVerticalTextWidth(text As String,wrap As Boolean,f As Font,wordspace As Double,linespace As Double,height As Double) As Double
	Dim numberOfLines As Int
	If wrap Then
		Dim lines As List = Regex.Split(CRLF,text)
		For Each line As String In lines
			Dim length As Int = line.Length
			Dim lineHeight As Double = (f.Size + wordspace) * length + f.Size * 3
			Dim wrappedLineNumber As Int
			wrappedLineNumber = Ceil(lineHeight / height)
			numberOfLines = numberOfLines + wrappedLineNumber
		Next
	Else
		If text.Contains(CRLF) Then
			numberOfLines = Regex.Split(CRLF,text).Length
		Else
			numberOfLines = 1
		End If
	End If
	Dim width As Double = f.Size * numberOfLines + f.Size*(linespace-1) * (numberOfLines - 1)
	Return width
End Sub

Private Sub MeasureSingleLineVerticalTextHeight(text As String,f As Font,wordspace As Double) As Double
	Dim maxTextLength As Int
	If text.Contains(CRLF) Then
		For Each line As String In Regex.Split(CRLF,text)
			maxTextLength = Max(line.Length,maxTextLength)
		Next
	Else
		maxTextLength = text.Length
	End If
	Dim length As Int = maxTextLength * 1.25
	Return (f.Size + wordspace) * length
End Sub

Private Sub CreateVerticalTextEngine As VerticalTextEngine
	Dim vte As VerticalTextEngine
	vte.Initialize(mTargetLang,Utils.getSetting("do_not_break_words",True),Utils.getSetting("minWordLengthForBreak",99))
	vte.RightAlignRules = Utils.getSetting("char_right_align","[\.,。，、っッ]")
	vte.CenterAlignRules = Utils.getSetting("char_center_align","[\!\?！？⁉‼…—~⋮0-9a-zA-Z]")
	vte.RotationRules = Utils.getSetting("char_rotate","[…—~]")
	vte.ZeroWordspaceRules = Utils.getSetting("char_zerowordspace","[—…]")
	vte.ReplacingJSON = Utils.getSetting("char_replace","")
	vte.FirstCharToMoveUpRules = Utils.getSetting("firstchar_to_moveup","")
	vte.FreeHeightRules = Utils.getSetting("char_freeheight","")
	If mVerticalOffsetRules.IsInitialized Then
		vte.OffsetRulesMap = mVerticalOffsetRules
	End If
	If mBalloonMask.IsInitialized Then
		Dim tagMap As Map=Tag
		Dim box As Map=tagMap.Get("box")
		Dim boxGeometry As Map
		If box.ContainsKey("targetGeometry") Then
			boxGeometry = box.Get("targetGeometry")
		Else
			boxGeometry = box.Get("geometry")
		End If
		Dim X,Y As Int
		X = boxGeometry.Get("X")
		Y = boxGeometry.Get("Y")
		vte.setBalloonMask(mBalloonMask,X,Y)
		
		'If mHorizontalAlignment = "center" Then
		'	Dim offsetX As Int = tfPane.Width / 2 - iv.PrefWidth / 2 
		'	vte.horizontalMaskOffsetX = offsetX / mPercent
		'End If
		
		'If mVerticalAlignment = "center" Then
		'	Dim offsetY As Int = tfPane.Height/2-iv.PrefHeight/2
		'	vte.verticalMaskOffsetY = offsetY / mPercent
		'End If
	End If
	Return vte
End Sub

Sub AddVerticalText
	If Label1.Text.Trim<>"" Then
		Dim vte As VerticalTextEngine = CreateVerticalTextEngine
		iv.SetImage(vte.Draw(tfPane,Label1.Text,Label1.Font,mFontName,mPaint,mbold,mitalic,mTrakcing,mLineSpace,mPadding,Label1.WrapText,mImageWidth,mImageHeight,mLeft2RightForVertical,mStyle,mRotation,mAlignment,mVerticalAlignment == "center"))
		mWrappedText=vte.Text
		mImageScale = 1.0 'the vertical engine returns the final-size image
		Dim width As Double = iv.GetImage.Width
		Dim height As Double = iv.GetImage.Height
		If mPercent <> 1.0 Then
			width = width*mPercent
			height = height*mPercent
		End If
		tfPane.RemoveAllNodes
		'tfPane.SetSize(width,height)
		tfPane.AddNode(iv,0,0,-1,-1)
		iv.SetSize(width,height)
		If mLeft2RightForVertical Then
			iv.Left=0
		Else
			iv.Left=tfPane.PrefWidth-iv.Width
		End If
		AdjustVerticalAlignment
		AdjustHorizontalAlignment
	End If
End Sub

Sub AddHorizontalText
	If Label1.Text<>"" Then
		Dim hte As HorizontalTextEngine
		hte.Initialize(mTargetLang,Utils.getSetting("do_not_break_words",True),Utils.getSetting("minWordLengthForBreak",99))
		Dim result As HorizontalTextEngineResult = hte.Draw(tfPane,Label1.Text,Label1.Font,mFontName,mPaint,mbold,mitalic,Label1.WrapText,mImageWidth,mImageHeight,getTFAlignment,Label1.Font.Size*(mLineSpace-1),mTrakcing,mPadding,mStyle,mFontStyleName,mRotation)
		If result.fontsize <> Label1.Font.Size Or result.width>mImageWidth Then
			Dim tagMap As Map=Tag
			Dim box As Map=tagMap.Get("box")
			box.Put("suitableSize",result.fontsize)
			Label1.Font = fx.CreateFont(Label1.Font.FamilyName,result.fontsize,mbold,mitalic)
		End If
		'The snapshot is upright (CreateTextFlow no longer rotates the node).
		'The rotation is applied to the ImageView in rotate() via Utils.RotateNode,
		'which pivots around the parent center. When rotated, the image is rendered
		'at a higher resolution (result.scale) so the rotation stays crisp, so divide
		'by it to keep the on-screen size unchanged.
		iv.SetImage(result.img)
		mImageScale = result.scale
		Dim width As Double = iv.GetImage.Width/mImageScale*mPercent
		Dim height As Double = iv.GetImage.Height/mImageScale*mPercent
		tfPane.RemoveAllNodes
		tfPane.AddNode(iv,0,0,-1,-1)
		iv.SetSize(width,height)
		AdjustVerticalAlignment
	End If
End Sub

Sub AddTextFlow(width As Int,height As Int)
	Dim hte As HorizontalTextEngine
	hte.Initialize(mTargetLang,Utils.getSetting("do_not_break_words",True),Utils.getSetting("minWordLengthForBreak",99))
	hte.AddTextFlow(tfPane,Label1.Text,Label1.Font,mFontName,mPaint,mbold,mitalic,Label1.WrapText,width/mPercent,height/mPercent,getTFAlignment,Label1.Font.Size*(mLineSpace - 1),mTrakcing,mStyle,mFontStyleName,mRotation)
	AdjustVerticalAlignment
End Sub

Sub getText As String
	Return Label1.Text
End Sub

Sub setTextSize(TextSize As Double)
	Label1.TextSize=TextSize
End Sub

Sub setWrapText(wrap As Boolean)
	Label1.WrapText=wrap
End Sub

Sub getWrapText As Boolean
	Return Label1.WrapText
End Sub

Sub setTextAlignment(alignment As String)
	mAlignment = alignment
	Dim jo As JavaObject = Label1
	jo.RunMethod("setTextAlignment", Array(alignment))
End Sub

Public Sub getTextAlignment As String
	Return mAlignment
End Sub

Public Sub setLeft2RightForVertical(value As Boolean)
	mLeft2RightForVertical = value
End Sub

Public Sub getLeft2RightForVertical As Boolean
	Return mLeft2RightForVertical
End Sub

Sub AutoAdjustFont(width As Int,height As Int,fromBox As Boolean,fontsize As Double,fontfamily As String)
	If Utils.getSetting("autoFontSize",True)=False Then
		Return
	End If
	
	Dim minFontSize As Int=Utils.getSetting("minFontSize",12)
	Dim maxFontSize As Int=Utils.getSetting("maxFontSize",100)
	Dim tagMap As Map=Tag
	Dim box As Map=tagMap.Get("box")
	If box.ContainsKey("suitableSize") Then
		fontsize=box.Get("suitableSize")
	End If
	fontsize = Max(minFontSize,fontsize)
	fontsize = Min(maxFontSize,fontsize)
	
	If mVerticalCJK Then
		Label1.Font = fx.CreateFont(fontfamily,fontsize,mbold,mitalic)
		If Label1.WrapText Then
			Dim initialSize As Int = Label1.Font.Size
			AddVerticalText
			AutoAdjustFontVertical(minFontSize,maxFontSize,box.ContainsKey("suitableSize"),"")
			If initialSize <> Label1.Font.Size Then
				AddVerticalText
			End If
			Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size,mbold,mitalic)
			Dim suitableSize As Double
			suitableSize=Label1.Font.Size
			box.Put("suitableSize",suitableSize)
		Else
			AutoAdjustFontVerticalSimple(minFontSize,maxFontSize,box.ContainsKey("suitableSize"),"")
			Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size,mbold,mitalic)
			Dim suitableSize As Double
			suitableSize=Label1.Font.Size
			box.Put("suitableSize",suitableSize)
			AddVerticalText
		End If
		Return
	End If
	Label1.Font = fx.CreateFont(fontfamily,fontsize,mbold,mitalic)
	AutoAdjustFontHorizontal(tagMap,width,height,fromBox)
	EnableNonCJKVerticalIfNeeded
End Sub

Sub EnableNonCJKVerticalIfNeeded
	Dim tagMap As Map=Tag
	Dim direction As Int=tagMap.GetDefault("direction",0)
	If direction=1 Then
		'Log("make it vertical")
		If Utils.isChinese(Label1.Text)=False Then
			rotate(90)
		End If
	End If
End Sub

private Sub AutoAdjustFontVerticalSimple(minFontSize As Int,maxFontSize As Int,hasSuitableSize As Boolean,previousStatus As String)
	If Label1.WrapText Then
		Dim currentWidth As Double = MeasureVerticalTextWidth(Label1.Text,Label1.WrapText,Label1.Font,mTrakcing,mLineSpace,mImageHeight)
		'Log("image width: "&mImageWidth)
		'Log("current width: "&currentWidth)
		If mImageWidth - currentWidth > Label1.Font.Size*0.2 Then
			'Log("make it bigger")
			If previousStatus = "shrink" Then
				'Log("current width: "&currentWidth)
				'Log("stop at size: "&Label1.Font.Size)
				Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size+1,mbold,mitalic)
				Return
			End If

			Dim plus As Double = 1

			If Label1.Font.Size + plus > maxFontSize Then
				Return
			End If
		
			currentWidth = MeasureVerticalTextWidth(Label1.Text,Label1.WrapText,Label1.Font,mTrakcing,mLineSpace,mImageHeight)
			'Log("current width: "&currentWidth)
			'Log("new size: "&Label1.Font.Size)
			If currentWidth - mImageWidth > 0 Then
				Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size-plus,mbold,mitalic)
				Return
			End If
			Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size+plus,mbold,mitalic)
			AutoAdjustFontVerticalSimple(minFontSize,maxFontSize,hasSuitableSize,"enlarge")
		else if currentWidth - mImageWidth > 0 Then
			'Log("make it smaller")
			If previousStatus = "enlarge" Then
				'Log("current width: "&currentWidth)
				'Log("stop at size: "&Label1.Font.Size)
				Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size-1,mbold,mitalic)
				Return
			End If

			Dim minus As Double = 1

			currentWidth = MeasureVerticalTextWidth(Label1.Text,Label1.WrapText,Label1.Font,mTrakcing,mLineSpace,mImageHeight)
			'Log("current width: "&currentWidth)
			'Log("new size: "&Label1.Font.Size)
			If Label1.Font.Size - minus < minFontSize Then
				Return
			End If
			Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size-minus,mbold,mitalic)
			AutoAdjustFontVerticalSimple(minFontSize,maxFontSize,hasSuitableSize,"shrink")
		End If
	Else
		Dim currentHeight As Double = MeasureSingleLineVerticalTextHeight(Label1.Text,Label1.Font,mTrakcing)
		'Log("image width: "&mImageWidth)
		'Log("current width: "&currentWidth)
		If mImageHeight - currentHeight > Label1.Font.Size*0.2 Then
			'Log("make it bigger")
			If previousStatus = "shrink" Then
				'Log("current width: "&currentWidth)
				'Log("stop at size: "&Label1.Font.Size)
				Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size+1,mbold,mitalic)
				Return
			End If

			Dim plus As Double = 1

			If Label1.Font.Size + plus > maxFontSize Then
				Return
			End If
		
			currentHeight = MeasureSingleLineVerticalTextHeight(Label1.Text,Label1.Font,mTrakcing)
			'Log("current width: "&currentWidth)
			'Log("new size: "&Label1.Font.Size)
			If currentHeight - mImageHeight > 0 Then
				Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size-plus,mbold,mitalic)
				Return
			End If
			Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size+plus,mbold,mitalic)
			AutoAdjustFontVerticalSimple(minFontSize,maxFontSize,hasSuitableSize,"enlarge")
		else if currentHeight - mImageHeight > 0 Then
			'Log("make it smaller")
			If previousStatus = "enlarge" Then
				'Log("current width: "&currentWidth)
				'Log("stop at size: "&Label1.Font.Size)
				Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size-1,mbold,mitalic)
				Return
			End If

			Dim minus As Double = 1

			currentHeight = MeasureSingleLineVerticalTextHeight(Label1.Text,Label1.Font,mTrakcing)
			'Log("current width: "&currentWidth)
			'Log("new size: "&Label1.Font.Size)
			If Label1.Font.Size - minus < minFontSize Then
				Return
			End If
			Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size-minus,mbold,mitalic)
			AutoAdjustFontVerticalSimple(minFontSize,maxFontSize,hasSuitableSize,"shrink")
		End If
	End If
End Sub

private Sub AutoAdjustFontVertical(minFontSize As Int,maxFontSize As Int,hasSuitableSize As Boolean,previousStatus As String)
	If iv.GetImage.IsInitialized = False Then
		Return
	End If
	Dim emptyPane As Pane
	emptyPane.Initialize("")
	Dim cvs1 As B4XCanvas
	cvs1.Initialize(emptyPane)
	Dim fixedRect As B4XRect=cvs1.MeasureText("鹅",Label1.Font)
	Dim currentWidth As Double = GetVerticalLayoutWidth
	Dim diff As Int = Abs(mImageWidth - currentWidth)
	If mImageWidth - currentWidth > fixedRect.Width*0.5 Then
		'Log("make it bigger")
		If previousStatus = "shrink" Then
			Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size+1,mbold,mitalic)
			Return
		End If

		Dim plus As Int = 1
		If hasSuitableSize = False Then
			If diff > fixedRect.Width Then
				plus = 5
				If Label1.Font.Size + plus > maxFontSize Then
					plus = 1
				End If
			End If
		End If
		
		If Label1.Font.Size + plus > maxFontSize Then
			Return
		End If
		Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size+plus,mbold,mitalic)
		AutoAdjustFontVertical(minFontSize,maxFontSize,hasSuitableSize,"enlarge")
	else if currentWidth - mImageWidth > 0 Then
		'Log("make it smaller")
		If previousStatus = "enlarge" Then
			Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size-1,mbold,mitalic)
			Return
		End If

		Dim minus As Int = 1
		
		If hasSuitableSize = False Then
			If diff > fixedRect.Width Then
				minus = 5
				If Label1.Font.Size - minus < minFontSize Then
					minus = 1
				End If
			End If
		End If

		If Label1.Font.Size - minus < minFontSize Then
			Return
		End If
		Label1.Font = fx.CreateFont(Label1.Font.FamilyName,Label1.Font.Size-minus,mbold,mitalic)
		AutoAdjustFontVertical(minFontSize,maxFontSize,hasSuitableSize,"shrink")
	End If
End Sub

private Sub GetVerticalLayoutWidth As Double
	Dim vte As VerticalTextEngine = CreateVerticalTextEngine
	Dim layoutResult As Map = vte.CalculateLayout(Label1.Text,Label1.Font,mFontName,mPaint,mbold,mitalic,mTrakcing,mLineSpace,mPadding,Label1.WrapText,mImageWidth,mImageHeight,mLeft2RightForVertical,0,mAlignment,mVerticalAlignment == "center")
	Dim width As Double = layoutResult.Get("width")
	If mShadowRadius <> 0 Then
	    width = width + mShadowRadius * 2
	End If
	Return width
End Sub

private Sub GetHorizontalLayoutHeight(text As String) As Double
	Dim hte As HorizontalTextEngine
	hte.Initialize(mTargetLang,False,999)
	Dim height As Double = hte.calculateHeight(tfPane,text,Label1.Font,mFontName,mPaint,mbold,mitalic,Label1.WrapText,mImageWidth,mImageHeight,getTFAlignment,Label1.Font.Size*(mLineSpace-1),mTrakcing,mPadding,mStyle,mFontStyleName,mRotation)
	Return height
End Sub

private Sub AutoAdjustFontHorizontal(tagMap As Map,width As Int,height As Int,fromBox As Boolean)
	Dim adjustWidth,adjustHeight As Int

	If fromBox Then
		Dim box As Map=tagMap.Get("box")
		Dim boxGeometry As Map
		If box.ContainsKey("targetGeometry") Then
			boxGeometry=box.Get("targetGeometry")
		Else
			boxGeometry=box.Get("geometry")
		End If
		adjustWidth=boxGeometry.Get("width")
		adjustHeight=boxGeometry.Get("height")
	Else
		adjustWidth=width/mPercent
		adjustHeight=height/mPercent
	End If
	'Log("adjustWidth + adjustHeight")
	'Log(adjustWidth)
	'Log(adjustHeight)
	AutoAdjustFontForLabel(adjustWidth,adjustHeight) 'calculate size using label first

	If ShouldUseImageView Then
		AddHorizontalText
	Else
		AddTextFlow(width,height)
	End If
End Sub

private Sub BBCodeRemovedText(text As String) As String
	If Utils.getSetting("richtext",False) Then
		Return Regex.Replace("\[.*?\]",text,"")
	End If
	Return text
End Sub

Sub AutoAdjustFontForLabel(width As Int,height As Int) As Int
	'Log("-------------")
	'Log("width: "&width)
	'Log("height: "&height)
	
	Dim tagMap As Map=Tag
	Dim box As Map=tagMap.Get("box")
	Dim bold As Boolean=tagMap.GetDefault("bold",mbold)
	Dim italic As Boolean=tagMap.GetDefault("italic",mitalic)
	'Dim text As String = BBCodeRemovedText(Label1.Text)
	'Log(text)
	Dim currentHeight As Double=GetHorizontalLayoutHeight(Label1.Text)
	'Log(currentHeight)
	Dim heightDiff As Double=height-currentHeight
	If heightDiff>=0 Then
		heightDiff=heightDiff+1
	Else
		heightDiff=heightDiff-1
	End If
	setSuitableFontSize(Label1.Text,heightDiff,width,height)
	Label1.Font=fx.CreateFont(mFontName,Label1.Font.Size-1,bold,italic)
	Dim suitableSize As Double
	suitableSize=Label1.Font.Size
	box.Put("suitableSize",suitableSize)
	'Log("suitiable size:"&suitableSize)
	Return suitableSize
End Sub

Sub LabelLineHeight As Double
	
	Dim lineheight As Double=Label1.Font.Size + Label1.Font.Size*(mLineSpace-1)
	'Log(lbl.Font.Size)
	'Log(lineheight)
	Return lineheight
End Sub

Sub setSuitableFontSize(text As String,previousDiff As Double,boxWidth As Double,boxHeight As Double)
	Dim HeightNeeded As Double=GetHorizontalLayoutHeight(text)
	Dim minFontSize As Int=Utils.getSetting("minFontSize",12)
	Dim maxFontSize As Int=Utils.getSetting("maxFontSize",100)
	Dim lineHeight As Double=LabelLineHeight
	Dim diff As Double=lineHeight/2 'old value:5 
	Dim heightDiff As Double=boxHeight-HeightNeeded
	'Log("diff:"&diff)
	'Log("lbl.Font.Size:"&lbl.Font.Size)
	'Log("minFontSize:"&minFontSize)
	'Log("maxFontSize:"&maxFontSize)
	'Log("heightDiff:"&heightDiff)
	'Log("previousDiff:"&previousDiff)
	If heightDiff>diff Or Label1.Font.Size<minFontSize Then
		If Label1.Font.Size+1>maxFontSize Then
			Return
		End If
		Label1.Font=fx.CreateFont(mFontName,Label1.Font.Size+1,mbold,mitalic)
	Else if heightDiff<5 Then
		If Label1.Font.Size-1<minFontSize Then
			Return
		End If
		Label1.Font=fx.CreateFont(mFontName,Label1.Font.Size-1,mbold,mitalic)
	Else
		Return
	End If
	If previousDiff>=0 Then
		If heightDiff>0 And heightDiff<previousDiff Then 'heightdiff应该缩小
			setSuitableFontSize(text,heightDiff,boxWidth,boxHeight)
		End If
	Else
		If heightDiff<0 And heightDiff>previousDiff Then 'heightdiff应该变大
			setSuitableFontSize(text,heightDiff,boxWidth,boxHeight)
		End If
	End If
End Sub

#region pane events

public Sub AdjustVerticalAlignment
	If mVerticalCJK Then
		Return
	End If
	Dim tagMap As Map=Tag
	Dim box As Map=tagMap.Get("box")
	Dim Height As Double=tfPane.PrefHeight
	For i=0 To tfPane.NumberOfNodes-1
		Dim node As Node=tfPane.GetNode(i)
		If node.PrefHeight>0 Then
			If mVerticalAlignment="center" Then
				Dim value As Int = Height/2-node.PrefHeight/2
				node.Top = value
			else if mVerticalAlignment="top" Then
				node.Top=0
			else if mVerticalAlignment="bottom" Then
				Dim value As Int = Height-node.PrefHeight
				node.Top = value
			End If
			If node Is ImageView Then
				box.Put("verticalBaseLineShift",node.Top)
			End If
		End If
	Next
End Sub

public Sub AdjustHorizontalAlignment
	Dim tagMap As Map=Tag
	Dim box As Map=tagMap.Get("box")
	Dim Width As Double=tfPane.PrefWidth
	For i=0 To tfPane.NumberOfNodes-1
		Dim node As Node=tfPane.GetNode(i)
		If node.PrefHeight>0 Then
			If mHorizontalAlignment="center" Then
				Dim value As Int = Width/2-node.PrefWidth/2
				node.Left = value
			else if mVerticalAlignment="left" Then
				node.left = 0
			else if mVerticalAlignment="right" Then
				Dim value As Int = Width-node.PrefWidth
				node.left = value
			End If
			If node Is ImageView Then
				box.Put("horizontalBaseLineShift",node.left)
			End If
		End If
	Next
End Sub

public Sub ResizeImage
	If iv.GetImage.IsInitialized Then
		Dim width As Double = iv.GetImage.Width/mImageScale
		Dim height As Double = iv.GetImage.Height/mImageScale
		If mPercent <> 1.0 Then
			width = width*mPercent
			height = height*mPercent
		End If
		iv.SetSize(width,height)
		If mVerticalCJK Then
			If mLeft2RightForVertical Then
				iv.Left=0
			Else
				iv.Left=tfPane.PrefWidth-iv.Width
			End If
		End If
	End If
End Sub

Private Sub tfPane_Resize (Width As Double, Height As Double)
	AdjustVerticalAlignment
	If mVerticalCJK Then
		AdjustHorizontalAlignment
	End If
	'If Label1.WrapText = False Then
	'	If mVerticalCJK Then
	'		AddVerticalText
	'	End If
	'End If
End Sub

Sub tfPane_MouseEntered (EventData As MouseEvent)
	CallSubDelayed2(mCallBack,mEventName&"_MouseEntered",EventData)
End Sub

Sub tfPane_MouseExited (EventData As MouseEvent)
	CallSubDelayed2(mCallBack,mEventName&"_MouseExited",EventData)
End Sub

Sub tfPane_MouseDragged (EventData As MouseEvent)
	If TypesettingMode Then
		EventData.Consume
	End If
	CallSubDelayed2(mCallBack,mEventName&"_MouseDragged",EventData)
End Sub

Public Sub ResetText(checkWrap As Boolean)
	If Label1.WrapText Or checkWrap = False Then
		setText(Label1.Text)
	End If
End Sub

Private Sub tfPane_MouseClicked (EventData As MouseEvent)
	CallSubDelayed2(mCallBack,mEventName&"_MouseClicked",EventData)
End Sub

Private Sub tfPane_MousePressed (EventData As MouseEvent)
	CallSubDelayed2(mCallBack,mEventName&"_MousePressed",EventData)
End Sub

Private Sub tfPane_MouseMoved (EventData As MouseEvent)
	CallSubDelayed2(mCallBack,mEventName&"_MouseMoved",EventData)
End Sub


Private Sub tfPane_MouseReleased (EventData As MouseEvent)
	CallSubDelayed2(mCallBack,mEventName&"_MouseReleased",EventData)
End Sub
#End Region

Sub iv_MouseMoved (EventData As MouseEvent)
	CallSubDelayed2(mCallBack,mEventName&"_MouseMoved",EventData)
End Sub
