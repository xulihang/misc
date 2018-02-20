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
    Dim bdl As BaiduLocation
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.

	Private Button3 As Button
	Private EditText1 As EditText
	Private CustomView1 As CustomListView
	Dim links As Map
	Dim ime1 As IME
	Dim su As StringUtils
	Dim currentpage=1 As Int
	Dim latitude As Double
	Dim longitude As Double
	Dim clickedItemIndex As Int
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("comment")
    links.Initialize
	ime1.Initialize("IME")
    ime1.AddHeightChangedEvent
	'IME_HeightChanged(100%y, 0) 
	ime1.AddHandleActionEvent(EditText1)
	getmessage
	bdl.Init("Baidu")
	bdl.setLocationOption(False,"bd0911","baidu",False,True,5000,True)
	bdl.StartListener
	CustomView1.AsView.Color=Colors.Transparent
	Activity.Color=Colors.Black
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub getmessage
	Dim job1 As HttpJob
	job1.Initialize("job1",Me)
	job1.Download2("http://jnu.azurewebsites.net/getcomment", _
	     Array As String("roomcode",room.roomcode,"querytype","1","page",1))
	ProgressDialogShow2("获取评论中",False)
End Sub

Sub JobDone (job As HttpJob)
	Log("JobName = " & job.JobName & ", Success = " & job.Success)
	If job.Success = True Then
		Select job.JobName
			Case "job1"
				'print the result to the logs
				ProgressDialogHide
				Log(job.GetString)
				If job.GetString="[]" Or job.GetString="没有留言" Then
				    ToastMessageShow("没有留言",False)
				Else
				    parseJSON(job.GetString)
				End If
			Case "job4"'评论用
			    ProgressDialogHide
				ToastMessageShow(job.getstring,False)
				CustomView1.Clear
				getmessage
			Case "loadmore"  
				ProgressDialogHide
				If job.GetString="[]" Or job.GetString="没有留言" Then
				    ToastMessageShow("没有更多留言了",False)
					CustomView1.RemoveAt(CustomView1.GetSize-1)
				Else
					CustomView1.RemoveAt(CustomView1.GetSize-1)
				    parseJSON(job.GetString)
				End If
			Case "deljob"
				ProgressDialogHide
				If job.GetString="操作成功" Then
				    ToastMessageShow("操作成功",False)
					CustomView1.RemoveAt(clickedItemIndex)
				Else
				    ToastMessageShow("操作失败",False)
				End If				
		End Select
	Else
	    ProgressDialogHide
		Log("Error: " & job.ErrorMessage)
		ToastMessageShow("Error: " & job.ErrorMessage, True)
	End If
	job.Release
End Sub

Sub Button3_Click
	
    Dim realname,username As String
	Dim Reader As TextReader
	If File.Exists(File.DirInternal,"user") Then
        Reader.Initialize(File.OpenInput(File.DirInternal, "user"))
		username = Reader.ReadLine
        realname = Reader.ReadLine
		realname = Reader.ReadLine
        Reader.Close
		Dim job4 As HttpJob
		job4.Initialize("job4",Me)
		job4.PostString("http://jnu.azurewebsites.net/addcomment","username="&username&"&text="&EditText1.Text&"&roomcode="&room.roomcode&"&longitude="&longitude&"&latitude="&latitude)
		ProgressDialogShow2("发表中",False)
	Else
	    ToastMessageShow("请先登录",False)
	    'Activity.Finish
    End If
End Sub

Sub IME_HeightChanged(NewHeight As Int, OldHeight As Int)
    EditText1.Top = NewHeight - EditText1.Height
	Button3.Top = NewHeight - Button3.Height
    CustomView1.AsView.Height = EditText1.Top - CustomView1.AsView.Top
End Sub

Sub parseJSON(jsonresult As String)
	links.Clear
	Dim JSON As JSONParser
    'JSON.Initialize(File.ReadString(File.DirAssets, "out.json")) 'Read the text from a file.
	JSON.Initialize(jsonresult)
    Dim list1 As List
    list1 = JSON.NextArray
    For I =0 To list1.Size-1
        Dim map1 As Map
        map1 = list1.get(I)
	    addItem(map1.get("username"),map1.get("posttime"),map1.get("text"),map1.get("uid"),map1.get("realname"),map1.get("longitude"),map1.get("latitude"))
		If I=list1.Size-1 Then
			CallSubDelayed2(ImageDownloader, "DownloadAvatar", links)
	        CustomView1.AddTextItem("更多","more")
	    End If
    Next	
End Sub

Sub addItem(username As String, time As String,text As String,uid As String, realname As String, userlongitude As Double, userlatitude As Double)
	Private panel1 As Panel
	panel1.Initialize("panel1")
	panel1.LoadLayout("item")
    panel1.Tag=time
	Dim avatar=panel1.GetView(0) As ImageView
	avatar.Bitmap=LoadBitmap(File.DirAssets,"avatar.png")
	links.Put(avatar, uid)
	Dim Label1=panel1.GetView(1) As Label
	Label1.Text=realname
	Label1.Tag=username
	Dim label2=panel1.GetView(2) As Label
	label2.Text=DateTime.GetMonth(time)&"-"&DateTime.GetDayOfMonth(time)&" "&DateTime.GetHour(time)&":"&DateTime.GetMinute(time)&":"&DateTime.GetSecond(time)
	Dim timeBehind As String
	timeBehind=showTimeBehind(time)
	If timeBehind.Contains("秒") Then
		label2.Text=timeBehind
	Else If timeBehind.Contains("分") Then
		label2.Text=timeBehind
	End If
	Dim label3=panel1.GetView(3) As Label
	label3.Text=text
	Dim minHeight,ProperHeight As Int
	minHeight = su.MeasureMultilineTextHeight(label3, label3.Text)
	ProperHeight = Max(20dip, minHeight)
	label3.Height=ProperHeight
	Dim bar=panel1.GetView(4) As ImageView
	bar.Top=label3.Height+50dip
	Dim map1 As Map
	map1.Initialize
	map1.Put("longitude",userlongitude)
	map1.Put("latitude",userlatitude)
	map1.Put("username",username)
	map1.Put("posttime",time)
    CustomView1.Add(panel1,52dip+ProperHeight,map1)
End Sub

Sub CustomView1_ItemClick (Index As Int, Value As Object)
	clickedItemIndex=Index
    Dim username As String
	Dim Reader As TextReader
	If File.Exists(File.DirInternal,"user") Then
        Reader.Initialize(File.OpenInput(File.DirInternal, "user"))
		username = Reader.ReadLine
        Reader.Close
    End If	
	If Value="more" Then
		currentpage=currentpage+1
		Dim loadmore As HttpJob
	    loadmore.Initialize("loadmore",Me)
	    loadmore.Download2("http://jnu.azurewebsites.net/getcomment", _
	         Array As String("roomcode",room.roomcode,"querytype","1","page",currentpage))
	    ProgressDialogShow2("获取评论中",False)
	Else
		Dim pnl As Panel
		pnl=CustomView1.GetPanel(Index)
		Dim lbl As Label
		lbl=pnl.GetView(1)
		Dim map1 As Map
		map1=Value
		Dim userlongitude,userlatitude As Double
		Dim r As List 
	    r.Initialize 
	    r.AddAll(Array As String("回复ta","查看与ta的距离"))
		If map1.Get("username")=username Then
			r.Add("删除该留言")
		End If
	    Dim m As Int
	    Dim x As id 
	    m = x.InputList1(r,"选择操作")
		Select m
	        Case 0
                EditText1.Text="回复@"&lbl.Text&"："
				EditText1.RequestFocus
			Case 1
				userlongitude=map1.Get("longitude")
		        userlatitude=map1.Get("latitude")
		        calDistance(userlongitude,userlatitude)
			Case 2
				Dim deljob As HttpJob
				deljob.Initialize("deljob",Me)
				deljob.PostString("http://jnu.azurewebsites.net/delcomment","username="&username&"&posttime="&map1.Get("posttime")&"&roomcode="&room.roomcode)
				ProgressDialogShow2("删除中",False)
	    End Select			

	End If	
End Sub

Sub Baidu_listen(bd As BaiduDB)  '定位监听
	Log(bd.Gettime&CRLF&bd.Longitude&":"&bd.Latitude&" "&bd.Province&" "&bd.City)
	latitude=bd.Latitude
	longitude=bd.Longitude
End Sub
Sub Baidu_poilisten(bd As BaiduDB)  '离线监听

End Sub

Sub calDistance(userlongitude As Double, userlatitude As Double)
	Dim mylongtitude,mylatitude As Double 
	mylongtitude=longitude
	mylatitude=latitude
	Dim distance As Double
	Log(cPI)
	distance=6371004*ACos(1-(Power((Sin((90-mylatitude)*cPI/180)*Cos(mylongtitude*cPI/180)-Sin((90-userlatitude)*cPI/180)*Cos(userlongitude*cPI/180)),2)+Power((Sin((90-mylatitude)*cPI/180)*Sin(mylongtitude*cPI/180)-Sin((90-userlatitude)*cPI/180)*Sin(userlongitude*cPI/180)),2)+Power((Cos((90-mylatitude)*cPI/180)-Cos((90-userlatitude)*cPI/180)),2))/2)
	Log(distance)
    Dim a As Int
	a=distance
	Log(longitude&latitude)
	Dim direction As String
	
	If userlatitude>latitude Then
	    If userlongitude>longitude	Then
			direction="东北"
		Else
			direction="西北"
		End If
	Else
		If userlongitude>longitude Then
		    direction="东南"	
		Else
			direction="西南"
		End If
	End If
	Msgbox("对方在你"&direction&"方向"&a&"米","")
End Sub

Sub showTimeBehind(time As String) As String
	Log(time)
	Dim targetTime As Long
	targetTime=time
	'单位为毫秒哦
	If DateTime.Now>targetTime And DateTime.Now-targetTime<60000 Then
		Dim seconds As Int
		seconds=(DateTime.Now-targetTime)/1000
		Return seconds&"秒前"
	Else if  DateTime.Now-targetTime>60000 And DateTime.Now-targetTime<3600000 Then
		Dim minutes As Int
		minutes=(DateTime.Now-targetTime)/1000/60
		Return minutes&"分前"
	Else
		Return "null"
	End If
End Sub