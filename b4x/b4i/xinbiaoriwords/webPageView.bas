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
	Private WebView1 As WebView
	Public uri As String
End Sub

Public Sub Show
	If page2.IsInitialized=False Then
		page2.Initialize("Page2")
		page2.RootPanel.Color = Colors.ARGB(255,215,218,192)
		page2.RootPanel.LoadLayout("webview")
		page2.Title = "选择操作"
	End If	
    Main.NavControl.ToolBarVisible=True
	Main.NavControl.ShowPage(page2)
    Log(uri)
	WebView1.LoadUrl(uri)
	'WebView1.LoadUrl("http://www.baidu.com")
End Sub


Sub  Page2_BarButtonClick (Tag As String)
	Log(Tag)
	If Tag="back" Then
		If WebView1.CanGoBack Then
	        WebView1.GoBack	
		End If
	Else if Tag="forward" Then
		If WebView1.CanGoForward Then
			WebView1.GoForward
		End If
	Else
		Main.NavControl.ToolBarVisible=False
		Main.NavControl.RemoveCurrentPage
	End If
End Sub