B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Service
Version=7.01
@EndOfDesignText@
#Region  Service Attributes 
	#StartAtBoot: True
	
#End Region

Sub Process_Globals
	'These global variables will be declared once when the application starts.
	'These variables can be accessed from all modules.
	Private username="@itv" As String
	Private passwd="" As String
    Private timer1 As Timer
End Sub

Sub Service_Create
	timer1.Initialize("timer1",10000)
	
End Sub

Sub Service_Start (StartingIntent As Intent)
	File.WriteString(File.DirRootExternal,"test.txt","started"&DateTime.GetMinute(DateTime.Now))
	timer1.Enabled=True
	'connect
End Sub

Sub Service_Destroy

End Sub

Sub setAccount
	run("adb",Array As String("shell","setprop","pppoe.user",username))
	run("adb",Array As String("shell","setprop","pppoe.passwd",passwd))
End Sub

Sub connect
	If checkIsConnected=True Then
		'ToastMessageShow("请先断开连接",False)
		Return
	End If
	setAccount
	Do While run("busybox",Array As String("ifconfig")).Contains("ppp")=True
		'Msgbox("尚未断开连接，点确认后再次检测","")
		Sleep(1000)
	Loop
	Do While run("getprop",Array As String("pppoe.user")).Contains(username)<>True
		'Msgbox("尚未设置成功，点确认后再次检测","")
		Sleep(1000)
	Loop
	run("adb",Array As String("shell","busybox","nohup","/etc/ppp/ppp.connect"))
	Do While run("busybox",Array As String("ifconfig")).Contains("ppp0")<>True
		'Msgbox("尚未连接，点确认后再次检测","")
		Sleep(1000)
	Loop
	run("adb",Array As String("shell","ip","route","del","default"))
	run("adb",Array As String("shell","ip","route","add","default","dev","ppp0"))
	Log("done")
	run("adb",Array As String("shell","am","start","com.fiberhome.iptv"))
	'ToastMessageShow("已连接",False)
End Sub

Sub checkIsConnected As Boolean
	If run("busybox",Array As String("ifconfig")).Contains("ppp")=True Then
		Return True
	Else
		Return False
	End If
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

Sub timer1_Tick
	'Dim job As HttpJob 'checkStatus
	'job.Initialize("job",Me)
	'job.Download("http://www.baidu.com")
	'Wait For (job) JobDone (job As HttpJob)
	'If job.Success Then '说明连了外网了
	'	Return
	'Else
	'	Log(job.ErrorMessage)
	'	If checkIsConnected Then '还要区别是连了iptv连不上还是根本没连连不上
	'		Return
	'	Else
	'		connect
	'	End If
	'End If
	'job.Release
	If checkIsConnectedUsingPing Then
		Return
	Else
		Dim iproute As String
		iproute=runWithoutArgs("ip route")
		If iproute.Contains("default via 192.168.1.1 dev wlan0") Then
			If iproute.Contains("ppp0") Then
				run("adb",Array As String("shell","ip","route","del","default"))
				run("adb",Array As String("shell","ip","route","add","default","dev","ppp0"))
			Else
				connect
			End If
		Else
			If File.Exists(File.DirInternal,"checkppp.sh")=False Then
				File.Copy(File.DirAssets,"checkppp.sh",File.DirInternal,"checkppp.sh")
			End If
			Dim pppdStatus As String
			pppdStatus=runWithoutArgs("sh "&File.Combine(File.DirInternal,"checkppp.sh"))
			If pppdStatus.IndexOf("pppd")<>pppdStatus.LastIndexOf("pppd") Then '出现多个pppd
				run("adb",Array As String("shell","busybox","killall","pppd"))
			End If
			If iproute.Contains("default")=False And iproute.Contains("ppp0")=True Then
				run("adb",Array As String("shell","ip","route","add","default","dev","ppp0"))
			Else
				run("adb",Array As String("shell","busybox","route","add","default","dev","wlan0","gw","192.168.1.1"))
				connect
			End If
		End If
	End If
End Sub

Sub checkIsConnectedUsingPing As Boolean
	'Requires Phone Library
	Dim p As Phone
	Dim Response, Error As StringBuilder
	Response.Initialize
	Error.Initialize
	'Ping Google DNS - if you can't reach this you are in serious trouble!
	p.Shell("ping -c 1 220.189.127.106",Null,Response,Error)
	Log("======= Response ========")
	Log(Response)
	Log("======= Error ===========")
	Log(Error)
	Log("======================")

	If Response.ToString.Contains("100%")=False And Error.ToString="" Then
		Return True
	Else
		Return False
	End If

End Sub