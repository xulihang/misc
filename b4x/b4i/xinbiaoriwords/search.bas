Type=StaticCode
Version=2.75
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'Code module

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'Public variables can be accessed from all modules.
    Private page2 As Page
	
	Private CustomListView1 As CustomListView
	Private Spinner1 As Spinner
	Private TextField1 As TextField
	Private SQL1 As SQL
	Private TTS1 As TTS
	Private Toast As clsToastMsg
End Sub

Public Sub Show
	If page2.IsInitialized=False Then
		page2.Initialize("Page2")
		page2.RootPanel.Color = Colors.ARGB(255,215,218,192)
		page2.RootPanel.LoadLayout("search")
		page2.Title = "搜索"
		Spinner1.Add("日语")
	    Spinner1.Add("假名")
	    Spinner1.Add("中文意思")
		Spinner1.SelectedIndex=0
		Toast.Initialize(page2,14,False)
		'Dim no As NativeObject = Main.NavControl
        'no.GetField("navigationBar").RunMethod("setBarTintColor:", Array(no.ColorToUIColor(Colors.ARGB(200,32,202,176))))
		TextField1.Color=Colors.ARGB(200,32,202,176)
		Spinner1.Color=Colors.ARGB(200,32,202,176)
	End If	
	Main.NavControl.ShowPage(page2)

End Sub



Sub Spinner1_ItemClick (index As Int, value As Object)
	TextField1.ResignFocus
	If TextField1.Text="" Then
		Toast.ShowToastMessage("关键字不能为空", 3000)
	Else
		Select index
			Case 0
				loadDict("nihongo")
			Case 1
				loadDict("kana")
			Case 2
				loadDict("kanji")
		End Select
	End If
End Sub

Sub loadDict(searchtype As String)
	 CustomListView1.Clear
	If SQL1.IsInitialized=False Then
	    SQL1.Initialize(File.DirLibrary,"dict.db",False)
	End If
    Dim rs As ResultSet = SQL1.ExecQuery("SELECT * FROM dict WHERE "&searchtype&" like '%"&TextField1.Text&"%'")
	Dim rowCount As Int
	rowCount=0
    Do While rs.NextRow
		rowCount=rowCount+1
        addItem(rs.GetString("nihongo"),rs.GetString("kana"),rs.GetString("kanji"),rs.GetString("pronunication"),rs.GetString("wordtype"),rs.GetString("lesson"))
    Loop 	
	Toast.ShowToastMessage("搜索到"&rowCount&"个结果",3000)
End Sub

Sub CustomListView1_ItemClick (Index As Int, Value As Object)
	If TTS1.IsInitialized=False Then
		TTS1.Initialize("TTS1")
		'For Each i In TTS1.GetSupportedLanguages
		'	Log(i)
		'Next
	End If
    TTS1.SpeechRate=0.1
	TTS1.SetLanguage("ja-JP")
	TTS1.Speak(Value,True)	
End Sub

Sub addItem(nihongo As String, kana As String,kanji As String,pronunication As String, wordtype As String,lesson As String)	
	Private panel1 As Panel
	panel1.Initialize("panel1")
	panel1.LoadLayout("item")
	Dim nihongokana=panel1.GetView(0) As Label
	nihongokana.Text=nihongo&" （"&kana&"） ["&wordtype&"]"&" "& kanji
	nihongokana.Multiline=True
	Dim pronunicationText=panel1.GetView(1) As Label
	Dim change1 As change
	change1.Initialize
	pronunicationText.Text=change1.changeToneSymbol(pronunication)
	pronunicationText.Tag=nihongo
	CustomListView1.Add(panel1,40dip,nihongo)
End Sub

Sub Label2_Click
	Dim lbl As Label = Sender
	'doHelper.lesson=lbl.Tag
	doHelper.nihongo=lbl.Tag
	doHelper.Show
End Sub