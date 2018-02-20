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
	Public chosenlesson As String
End Sub

Public Sub Show
	If page2.IsInitialized=False Then
		page2.Initialize("Page2")
		page2.RootPanel.Color = Colors.ARGB(255,215,218,192)
		page2.RootPanel.LoadLayout("main")
		page2.Title = "选择课程"
	End If	
	Main.NavControl.ShowPage(page2)
	loadList
End Sub

Sub loadList
	CustomListView1.Clear
	CustomListView1.DefaultTextBackgroundColor=Colors.ARGB(255,215,218,192)
	If Main.book=0 Then
		For i=1 To 24 
			CustomListView1.AddTextItem("第"&i&"课",i)
		Next
	Else
		For i=25 To 47 
			CustomListView1.AddTextItem("第"&i&"课",i)
		Next
	End If
End Sub


Sub CustomListView1_ItemClick (Index As Int, Value As Object)
	Dim lesson As Int
	lesson=Value
	Log(lesson)
	If lesson<10 Then
		chosenlesson="0"&lesson
	Else
		chosenlesson=lesson
	End If
	Log(chosenlesson)
	content.Show
End Sub