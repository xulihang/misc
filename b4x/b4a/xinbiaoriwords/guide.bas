Type=Activity
Version=5.2
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
#Region  Activity Attributes 
	#FullScreen: False
	#IncludeTitle: True
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
    Dim querytype As Int
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.

	Private ListView1 As ListView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("guide")
	Dim lbl As Label
	lbl=ListView1.SingleLineLayout.Label
	lbl.TextColor=Colors.Black
    ListView1.AddSingleLine2("声调说明","")
	ListView1.AddSingleLine2("单词发音说明","")
	ListView1.AddSingleLine2("关于","")
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub



Sub ListView1_ItemClick (Position As Int, Value As Object)
	Select Position
		Case 0
			querytype=0
			StartActivity(Intro)
		Case 1
			querytype=1
			StartActivity(Intro)
		Case 2
			StartActivity(about)
	End Select
End Sub