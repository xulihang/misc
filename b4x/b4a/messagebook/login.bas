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
	Private EditText1 As EditText
	Private EditText2 As EditText
	Private Label1 As Label
	Private Label2 As Label
	Private EditText3 As EditText
	Private ImageView1 As ImageView
	Private Label3 As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("login")

End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub Button1_Click
	userlogin
End Sub
Sub ImageView1_Click
	
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "Job1"
				'print the result to the logs
				ProgressDialogHide
				Log(job.GetString)
				If job.GetString="登录失败" Then
				    ToastMessageShow("用户名或密码错误",False)
					'EditText3.Visible=True
					'Dim job2 As HttpJob
					'job2.Initialize("Job2", Me)
                    'job2.Download("http://e.jiangnan.edu.cn/valcode.jpg")
				Else 
				    If EditText1.Text="" Then
					    Msgbox("用户名为空","")
						Activity.Finish
					Else
				        ToastMessageShow(job.GetString&"登录成功!",False)
					    Dim Writer As TextWriter
                        Writer.Initialize(File.OpenOutput(File.DirInternal, "user", False))
                        Writer.WriteLine(EditText1.Text)
                        Writer.WriteLine(EditText2.Text)
						Writer.WriteLine(job.GetString)
                        Writer.Close 
					    Activity.Finish
					End If
				End If
			Case "Job2"
				'ImageView1.Visible=True
				'ImageView1.Bitmap=job2.GetBitmap
		End Select
	Else
	    ProgressDialogHide
		Log("Error: " & job.ErrorMessage)
		ToastMessageShow("Error: " & job.ErrorMessage, True)
	End If
	job.Release
End Sub

Sub userlogin
	Dim job1 As HttpJob	
    Dim URL,param As String
	
	If EditText3.Visible=False Then
	    URL="http://jnu.azurewebsites.net/login"
	    param="username="&EditText1.Text&"&password="&EditText2.Text
	Else
	    URL="http://jnu.azurewebsites.net/login2"
        param="username="&EditText1.Text&"&password="&EditText2.Text&"&validcode="&EditText3.Text
	End If
    job1.Initialize("Job1",Me)
	Log(URL)
    job1.PostString(URL,param)
	ProgressDialogShow("登录中")
End Sub