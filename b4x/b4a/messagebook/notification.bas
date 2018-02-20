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

	Private CustomView1 As CustomListView
	Dim realname,username As String
	Dim currentpage=1 As Int
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("usernotif")
	check
	CustomView1.AsView.Color=Colors.Transparent
	Activity.Color=Colors.Black
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub loadnotif
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	job1.Download2("http://jnu.azurewebsites.net/getnotif", _
	     Array As String("username",username,"page",1))
	ProgressDialogShow2("获取通知中",False)	
End Sub

Sub check	
	Dim Reader As TextReader
	If File.Exists(File.DirInternal,"user") Then
        Reader.Initialize(File.OpenInput(File.DirInternal, "user"))
		username = Reader.ReadLine
        realname = Reader.ReadLine
		realname = Reader.ReadLine
        Reader.Close
		loadnotif
	Else
		ToastMessageShow("请先登录",False)
		Activity.Finish
    End If
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
				'print the result to the logs
				ProgressDialogHide
				Log(job.GetString)
				If job.GetString="[]" Or job.GetString="没有通知" Then
				    ToastMessageShow("没有通知",False)
				Else
				    parseJSON(job.GetString)
				End If
			Case "loadmore"  
				ProgressDialogHide
				If job.GetString="[]" Or job.GetString="没有通知" Then
				    ToastMessageShow("没有更多通知了",False)
					CustomView1.RemoveAt(CustomView1.GetSize-1)
				Else
					CustomView1.RemoveAt(CustomView1.GetSize-1)
				    parseJSON(job.GetString)
				End If				
		End Select
	Else
	    ProgressDialogHide
		Log("Error: " & job.ErrorMessage)
		ToastMessageShow("Error: " & job.ErrorMessage, True)
	End If
	job.Release
End Sub

Sub CustomView1_ItemClick (Index As Int, Value As Object)
	If Value="more" Then
		currentpage=currentpage+1
		Dim loadmore As HttpJob
		loadmore.Initialize("loadmore",Me)
		loadmore.Download2("http://jnu.azurewebsites.net/getnotif", _
		     Array As String("username",username,"page",currentpage))
		ProgressDialogShow2("获取通知中",False)			
	End If	
End Sub

Sub parseJSON(jsonresult As String)
	Dim JSON As JSONParser
    'JSON.Initialize(File.ReadString(File.DirAssets, "out.json")) 'Read the text from a file.
	JSON.Initialize(jsonresult)
    Dim list1 As List
    list1 = JSON.NextArray
    For I =0 To list1.Size-1
        Dim map1 As Map
        map1 = list1.get(I)
	    Dim time As String
		time=map1.Get("posttime")
		time=DateTime.GetMonth(time)&"-"&DateTime.GetDayOfMonth(time)&" "&DateTime.GetHour(time)&":"&DateTime.GetMinute(time)&":"&DateTime.GetSecond(time)
        CustomView1.AddTextItem(map1.Get("realname")&"在"&time&"回复了你在"&map1.Get("roomcode")&"的留言，内容为："&map1.Get("text"),map1.Get("roomcode"))
		If i =list1.Size-1 Then
			CustomView1.AddTextItem("加载更多","more")
		End If
    Next	
End Sub