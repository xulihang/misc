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

	Private Button1 As Button
	Private ImageView1 As ImageView
	Private Label1 As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("userinfo")
    check
End Sub

Sub Activity_Resume
    check
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub check
	Dim realname,username As String
	Dim Reader As TextReader
	If File.Exists(File.DirInternal,"user") Then
        Reader.Initialize(File.OpenInput(File.DirInternal, "user"))
		username = Reader.ReadLine
        realname = Reader.ReadLine
		realname = Reader.ReadLine
        Reader.Close
		Label1.Text=realname&"已登录"
		Button1.Text="注销"
    End If
End Sub

Sub Button1_Click
	If Button1.Text="登录" Then
	    StartActivity(login)
	Else
		File.Delete(File.DirInternal,"user")
		ToastMessageShow("已注销",False)
		Activity.Finish
	End If
End Sub