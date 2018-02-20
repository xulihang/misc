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
    Dim sql1 As SQL
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.

	Private EditText1 As EditText
	Private Spinner1 As Spinner
	Private CustomView1 As CustomListView
	Private Label2 As Label
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("search")
	CustomView1.DefaultTextColor=Colors.DarkGray
	CustomView1.DefaultTextBackgroundColor=Colors.ARGB(255,215,218,192)
    CustomView1.AsView.Color=Colors.ARGB(255,215,218,192)
	Spinner1.AddAll(Array As String("假名","日文","中文"))
    loadHis
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub lookup(searchtype As String)
	CustomView1.Clear
	sql1.Initialize(File.DirInternal, "dict.db", False)
	Dim Cursor1 As Cursor
	Cursor1 = sql1.ExecQuery("SELECT * FROM dict WHERE "&searchtype&" like '%"&EditText1.Text&"%'")
    For I = 0 To Cursor1.RowCount - 1
	    Cursor1.Position = I
		'Log(Cursor1.GetString("nihongo"))
		addItem(Cursor1.GetString("nihongo"),Cursor1.GetString("kana"),Cursor1.GetString("kanji"),Cursor1.GetString("pronunication"),Cursor1.GetString("wordtype"),Cursor1.GetString("lesson"))
	Next
	ToastMessageShow("共搜索到"&Cursor1.RowCount&"个结果",False)
	Cursor1.Close
End Sub

Sub Spinner1_ItemClick (Position As Int, Value As Object)
	If EditText1.Text="" Then
		ToastMessageShow("不能为空",False)
	Else
		Dim list1 As List
		If File.Exists(File.DirInternal,"search_his.txt") Then
			list1=File.ReadList(File.DirInternal,"search_his.txt")
		Else
			list1.Initialize
		End If
		If list1.IndexOf(EditText1.Text)=-1 Then
		    list1.InsertAt(0,EditText1.Text)
		Else
			list1.RemoveAt(list1.IndexOf(EditText1.Text))
			list1.InsertAt(0,EditText1.Text)
		End If
		File.WriteList(File.DirInternal,"search_his.txt",list1)
		Select Position
			Case 0
				lookup("kana")
			Case 1
				lookup("nihongo")
			Case 2
				lookup("kanji")
		End Select
	End If
	'Log(EditText1.Text)
End Sub

Sub EditText1_EnterPressed

End Sub

Sub addItem(nihongo As String, kana As String,kanji As String,pronunication As String, wordtype As String, lesson As String)
	Private panel1 As Panel
	panel1.Initialize("panel1")
	panel1.LoadLayout("item")
	Dim nihongokana=panel1.GetView(0) As Label
	nihongokana.Text=nihongo&" （"&kana&"） ["&wordtype&"]"&" "& kanji
	Dim pronunicationText=panel1.GetView(1) As Label
	pronunication=pronunication.Replace("0","◎")
	pronunication=pronunication.Replace("1","①")
	pronunication=pronunication.Replace("2","②")
	pronunication=pronunication.Replace("3","③")
	pronunication=pronunication.Replace("4","④")
	pronunication=pronunication.Replace("5","⑤")
	pronunication=pronunication.Replace("6","⑥")
	pronunicationText.Text=pronunication
	CustomView1.Add(panel1,40dip,lesson)
End Sub

Sub CustomView1_ItemClick (Index As Int, Value As Object)
    Dim str As String
	str=Value
	If str.Contains("search") Then
	    EditText1.Text=str.Replace("search","")
		CustomView1.Clear
	Else
	    ToastMessageShow("这是第"&Value&"课的单词",False)
	End If
End Sub

Sub Label2_Click
	Dim index As Int
	index = CustomView1.GetItemFromView(Sender)
	Dim pnl As Panel
	pnl = CustomView1.GetPanel(index)
	Dim lbl As Label
	lbl=pnl.GetView(0)
	Dim lbl2 As Label
	lbl2=pnl.GetView(1)
	Dim str As String
	str=lbl.Text&lbl2.Text
    Dim result As Int
	result=Msgbox2("加入收藏吗？","","好","","不用了",Null)
	If result = DialogResponse.POSITIVE Then
		If File.Exists(File.DirInternal,"fav.txt") Then
			Dim list1 As List
			list1=File.ReadList(File.DirInternal,"fav.txt")
			Dim exist As Int
			exist=0
			For i=0 To list1.Size-1
				Dim str2 As String
				str2=list1.Get(i)
				'Log(str2)
				'Log(str)
				If str2.Trim=str.Trim Then '判断有没有已经收藏
					ToastMessageShow("您已经收藏过了",False)
					exist=1
					Exit
				End If
			Next
			If exist=0 Then
				list1.Add(str)
		        File.WriteList(File.DirInternal,"fav.txt",list1)
			End If
		Else
			Dim list1 As List
			list1.Initialize
		    list1.Add(str)
		    File.WriteList(File.DirInternal,"fav.txt",list1)
	    End If
	End If
End Sub

Sub EditText1_TextChanged (Old As String, New As String)
    loadHis
End Sub

Sub loadHis
	CustomView1.Clear
	If File.Exists(File.DirInternal,"search_his.txt") Then
		Dim list1 As List
		list1=File.ReadList(File.DirInternal,"search_his.txt")
		Dim str As String
		If EditText1.Text="" Then 
			Dim j As Int
			If list1.Size-1<2 Then
				j=list1.Size-1
			Else
				j=2
			End If
			For i=0 To j
				str=list1.Get(i)
				CustomView1.AddTextItem(str,str&"search")
			Next		    
		Else 
			For i=0 To list1.Size-1
                str=list1.Get(i)
			    If str.StartsWith(EditText1.Text)=True Then
			        CustomView1.AddTextItem(str,str&"search")
			    End If
		    Next
		End If
	End If
End Sub