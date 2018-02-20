Type=Activity
Version=5.2
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: False
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
    Dim sql1 As SQL
	Dim TTS1 As TTS
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
    Private CustomView1 As CustomListView
	Private text As String
	Private ImageView1 As ImageView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("content")
    CustomView1.AsView.Color=Colors.ARGB(255,215,218,192)
	'CustomView1.AddTextItem("dddd","ddd")
	Activity.AddMenuItem("添加收藏","favourite")
	Activity.Title="第"&chooselesson.chosenlesson&"课"
	loadDict(False)
	If TTS1.IsInitialized = False Then
        TTS1.Initialize("TTS1")
    End If
	configureTTS
End Sub

Sub Activity_Resume
    If TTS1.IsInitialized = False Then
        TTS1.Initialize("TTS1")
    End If
End Sub

Sub Activity_Pause (UserClosed As Boolean)
TTS1.Release
End Sub

Sub configureTTS
	TTS1.SpeechRate=0.75
	TTS1.Pitch=1.0
	If TTS1.SetLanguage("ja", "JP") = False Then
        ToastMessageShow("不确定是否装有日语TTS", True)
        Return
    End If
End Sub
Sub loadDict(star As Boolean)
	CustomView1.Clear
	Log(chooselesson.chosenlesson)
	sql1.Initialize(File.DirInternal, "dict.db", False)
	Dim Cursor1 As Cursor
	Cursor1 = sql1.ExecQuery("SELECT * FROM dict WHERE lesson like '%"&chooselesson.chosenlesson&"%'")
    For I = 0 To Cursor1.RowCount - 1
	    Cursor1.Position = I
		'Log(Cursor1.GetString("nihongo"))
		If star = True Then
			addItem(Cursor1.GetString("nihongo"),Cursor1.GetString("kana"),Cursor1.GetString("kanji"),Cursor1.GetString("pronunication"),Cursor1.GetString("wordtype"),star)
		Else
			addItem(Cursor1.GetString("nihongo"),Cursor1.GetString("kana"),Cursor1.GetString("kanji"),Cursor1.GetString("pronunication"),Cursor1.GetString("wordtype"),star)
		End If
		
	Next
	Cursor1.Close
End Sub

Sub addItem(nihongo As String, kana As String,kanji As String,pronunication As String, wordtype As String,star As Boolean)
	
	Private panel1 As Panel
	panel1.Initialize("panel1")
	If star =False Then
		panel1.LoadLayout("item")
		Dim nihongokana=panel1.GetView(0) As Label
		nihongokana.Text=nihongo&" （"&kana&"） ["&wordtype&"]"&" "& kanji
		Dim pronunicationText=panel1.GetView(1) As Label
		pronunicationText.Text=changeToneSymbol(pronunication)
	Else
		panel1.LoadLayout("itemWithStar")
	    Dim nihongokana=panel1.GetView(0) As Label
	    nihongokana.Text=nihongo&" （"&kana&"） ["&wordtype&"]"&" "& kanji & changeToneSymbol(pronunication)
		Dim favouriteImg=panel1.GetView(1) As ImageView
		If File.Exists(File.DirInternal,"fav.txt") Then
			Dim list1 As List
			list1=File.ReadList(File.DirInternal,"fav.txt")
			Dim exist As Int
			exist=0
			For i=0 To list1.Size-1
				Dim str As String
				str=list1.Get(i)
				If str.Trim=nihongokana.text.Trim Then
					favouriteImg.Bitmap=LoadBitmap(File.DirAssets,"star_checked.png")
					favouriteImg.Tag="starred"
					exist=1
					Exit
				End If
			Next
			If exist=0 Then
                favouriteImg.Tag="unstarred"				
			End If
		Else
			favouriteImg.Tag="unstarred"
	    End If
	End If
	CustomView1.Add(panel1,40dip,nihongo)
End Sub

Sub CustomView1_ItemClick (Index As Int, Value As Object)
    'ToastMessageShow("hhh",False)
	text=Value
	TTS1.Speak(text,True)
End Sub

Sub TTS1_Ready (Success As Boolean)
    If Success Then
        'enable all views
        For i = 0 To Activity.NumberOfViews - 1
            Activity.GetView(i).Enabled = True
        Next
        TTS1.Speak(text,True) 'play first sentence
    Else
        Msgbox("Error initializing TTS engine.", "")
    End If
End Sub

Sub favourite_click
	loadDict(True)
End Sub

Sub changeToneSymbol(symbol As String) As String
	symbol=symbol.Replace("0","◎")
	symbol=symbol.Replace("1","①")
	symbol=symbol.Replace("2","②")
	symbol=symbol.Replace("3","③")
	symbol=symbol.Replace("4","④")
	symbol=symbol.Replace("5","⑤")
	symbol=symbol.Replace("6","⑥")
	Return symbol
End Sub


Sub ImageView1_Click
	Dim index As Int
	index = CustomView1.GetItemFromView(Sender)
	Dim pnl As Panel
	pnl = CustomView1.GetPanel(index)
	Dim lbl As Label
	lbl=pnl.GetView(0)
	Dim img As ImageView
	img=pnl.GetView(1)
	Dim tagstring As String
	tagstring=img.Tag
	If tagstring="starred" Then
		Dim List1 As List
		List1=File.ReadList(File.DirInternal,"fav.txt")
		List1.RemoveAt(List1.IndexOf(lbl.Text))
		File.WriteList(File.DirInternal,"fav.txt",List1)	
		img.Bitmap=LoadBitmap(File.DirAssets,"star_unchecked.png")	
		img.Tag="unstarred"
	Else
		Dim List1 As List
		If File.Exists(File.DirInternal,"fav.txt") Then
			List1=File.ReadList(File.DirInternal,"fav.txt")
		Else
			List1.Initialize
		End If
		List1.Add(lbl.Text)
		'List1.Sort(True)
		File.WriteList(File.DirInternal,"fav.txt",List1)
		img.Bitmap=LoadBitmap(File.DirAssets,"star_checked.png")
		img.Tag="starred"
	End If
End Sub