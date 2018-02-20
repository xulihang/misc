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
	Public lesson As String
	Public nihongo As String
	Private Toast As clsToastMsg
End Sub

Public Sub Show
	If page2.IsInitialized=False Then
		page2.Initialize("Page2")
		page2.RootPanel.Color = Colors.ARGB(255,215,218,192)
		page2.RootPanel.LoadLayout("main")
		page2.Title = "选择操作"
		Toast.Initialize(page2,14,False)
		'Toast.ShowToastMessage("这是第"&lesson&"课的单词",3000)
	End If	
	Main.NavControl.ShowPage(page2)
	loadlist
End Sub

Sub loadlist
	CustomListView1.Clear
	CustomListView1.DefaultTextBackgroundColor=Colors.ARGB(255,215,218,192)
	CustomListView1.AddTextItem("在沪江词典上查询","hjdict")
	CustomListView1.AddTextItem("在雅虎词典上查询","yahoodict")
End Sub

Sub CustomListView1_ItemClick (Index As Int, Value As Object)
	Dim su As StringUtils
	nihongo=su.EncodeUrl(nihongo,"UTF-8")	
	Select Index
		Case 0
			webPageView.uri="http://dict.hjenglish.com/jp/jc/"&nihongo
		Case 1
			webPageView.uri="http://dic.search.yahoo.co.jp/search?p="&nihongo&"&ei=UTF-8&fr=top_ga1_sa"
	End Select	
    webPageView.Show
End Sub
