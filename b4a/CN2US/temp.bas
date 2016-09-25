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

End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.

	Private EditText1 As EditText
	Private EditText2 As EditText
	Private i As Int
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("temp")
    Activity.Title="temperature"
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub



Sub EditText2_TextChanged (Old As String, New As String)
	If i=2 And New<>"" And New<>"-" Then
	    EditText1.Text=32+EditText2.Text*1.8 
	End If
End Sub
Sub EditText2_FocusChanged (HasFocus As Boolean)
	If HasFocus=True Then
		i=2
	End If	
End Sub
Sub EditText1_TextChanged (Old As String, New As String)
	If i=1 And New<>"" And New<>"-" Then
	    EditText2.Text=EditText1.Text/1.8-32
	End If
End Sub
Sub EditText1_FocusChanged (HasFocus As Boolean)
	If HasFocus=True Then
		i=1
	End If	
End Sub