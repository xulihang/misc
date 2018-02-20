Type=StaticCode
Version=2.75
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@
'Code module

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'Public variables can be accessed from all modules.
    Private page3 As Page
	Private CustomListView1 As CustomListView
	Private SQL1 As SQL
	Private TTS1 As TTS
End Sub

Public Sub Show
	If page3.IsInitialized=False Then
		page3.Initialize("Page3")		
		page3.RootPanel.Color = Colors.ARGB(255,215,218,192)
		page3.RootPanel.LoadLayout("main")
		page3.Title = "单词"
		page3.RootPanel.TintColor=Colors.Black
	End If	
	Main.NavControl.ShowPage(page3)
	Log(chooseLesson.chosenlesson)
	If File.Exists(File.DirLibrary,"dict.db")=False Then
		File.Copy(File.DirAssets,"dict.db",File.DirLibrary,"dict.db")
	End If
	loadDict
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

Sub loadDict()
	 CustomListView1.Clear
	Log(chooseLesson.chosenlesson)
	If SQL1.IsInitialized=False Then
	    SQL1.Initialize(File.DirLibrary,"dict.db",False)
	End If
    Dim rs As ResultSet = SQL1.ExecQuery("SELECT * FROM dict WHERE lesson like '%"&chooseLesson.chosenlesson&"%'")
    Do While rs.NextRow
        addItem(rs.GetString("nihongo"),rs.GetString("kana"),rs.GetString("kanji"),rs.GetString("pronunication"),rs.GetString("wordtype"),rs.GetString("nihongo"))
    Loop 
End Sub

Sub addItem(nihongo As String, kana As String,kanji As String,pronunication As String, wordtype As String,star As Boolean)
	
	Private panel1 As Panel
	panel1.Initialize("panel1")
	panel1.LoadLayout("item")
	Dim nihongokana=panel1.GetView(0) As Label
	nihongokana.Text=nihongo&" （"&kana&"） ["&wordtype&"]"&" "& kanji
	nihongokana.Multiline=True
	Dim pronunicationText=panel1.GetView(1) As Label
	Dim change1 As change
	change1.Initialize
	pronunicationText.Tag=nihongo
	pronunicationText.Text=change1.changeToneSymbol(pronunication)
	CustomListView1.Add(panel1,40dip,nihongo)
End Sub

Sub Label2_Click
	Dim lbl As Label = Sender
	'doHelper.lesson=lbl.Tag
	doHelper.nihongo=lbl.Tag
	doHelper.Show
End Sub
