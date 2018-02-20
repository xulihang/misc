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
    Dim chosenlesson As String
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.
    
	Private ListView1 As ListView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("chooselesson")
	Activity.Title="选择课程"
	Activity.Color=Colors.ARGB(255,215,218,192)
	Dim lbl As Label
	lbl=ListView1.SingleLineLayout.Label
	lbl.TextColor=Colors.Black
    loadlist
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub loadlist
	If Main.book=1 Then
		For i=1 To 24 
			ListView1.AddSingleLine2("第"&i&"课",i)
		Next
	Else
		For i=25 To 47 
			ListView1.AddSingleLine2("第"&i&"课",i)
		Next
	End If
End Sub

Sub ListView1_ItemClick (Position As Int, Value As Object)
	Dim lesson As Int
	lesson=Value
	Log(lesson)
	If lesson<10 Then
		chosenlesson="0"&lesson
	Else
		chosenlesson=lesson
	End If
	Log(chosenlesson)
	StartActivity(content)
End Sub