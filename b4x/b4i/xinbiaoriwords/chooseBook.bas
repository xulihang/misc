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
End Sub

Public Sub Show
	If page2.IsInitialized=False Then
		page2.Initialize("Page2")
		page2.Title = "Page 2"
		page2.RootPanel.Color = Colors.White
		page2.RootPanel.LoadLayout("main")
	End If	
	Main.NavControl.ShowPage(page2)
End Sub

