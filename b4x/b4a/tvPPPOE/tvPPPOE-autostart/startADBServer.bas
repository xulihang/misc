Type=Service
Version=7.01
ModulesStructureVersion=1
B4A=true
@EndOfDesignText@
#Region  Service Attributes 
	#StartAtBoot: False
	
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Private Timer1 As Timer
	Private timeStart As Long
End Sub

Sub Service_Create
	Timer1.Initialize("Timer1",1000)
	Timer1.Enabled=False
End Sub

Sub Service_Start (StartingIntent As Intent)
	start
End Sub

Sub Service_Destroy

End Sub




Sub run(command As String,args() As String) As String
	Dim ph As Phone
	Dim result As Int
	Dim stdout,stderr As StringBuilder
	stdout.Initialize
	stderr.Initialize
	result=ph.Shell(command,args,stdout,stderr)
	Log(result)
	Log(stdout.ToString)
	Log(stderr.ToString)
	Return stdout
End Sub

Sub runWithoutArgs(command As String) As String
	Dim ph As Phone
	Dim result As Int
	Dim stdout,stderr As StringBuilder
	stdout.Initialize
	stderr.Initialize
	result=ph.Shell(command,Null,stdout,stderr)
	Log(result)
	Log(stdout.ToString)
	Log(stderr.ToString)
	Return stdout
End Sub

Sub Timer1_tick
	Dim processStatus As String
	processStatus=runWithoutArgs("ps")
	If processStatus.IndexOf("adb")=processStatus.LastIndexOf("adb") Then
		If DateTime.Now-timeStart>15000 Then
			Timer1.Enabled=False
			ProgressDialogHide
			ToastMessageShow("启动超时adb未启动，将再次尝试",False)
			start
		End If
	Else
		ProgressDialogHide
		Timer1.Enabled=False
		ToastMessageShow("adb已启动",False)
	End If
End Sub