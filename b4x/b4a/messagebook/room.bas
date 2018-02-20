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
    Dim sql1 As SQL
	Dim jwlink As String
	Dim roomcode As String
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.

	Private ListView1 As ListView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("main")
    loadlist
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub



Sub ListView1_ItemClick (Position As Int, Value As Object)
	Dim map1 As Map
	map1=Value	
	Dim r As List 
    r.Initialize 
    r.AddAll(Array As String("查看课表","留言"))
    Dim m As Int
    Dim x As id 
    m = x.InputList1(r,"选择操作")
	roomcode=map1.Get("roomcode")
	Log(roomcode)
	Log(roomcode.Trim)
	Select m
        Case 0
			Log(map1.Get("link"))
			jwlink=map1.Get("link")
			StartActivity(kebiao)
		Case 1
			roomcode=roomcode.Trim
			StartActivity(message)
    End Select	

End Sub

Sub loadlist
	sql1.Initialize(File.DirInternal, "list.db", False)
	Dim Cursor1 As Cursor
	Cursor1 = sql1.ExecQuery("SELECT * FROM content WHERE level like '%"&building.level&"%'")
    For I = 0 To Cursor1.RowCount - 1
	    Cursor1.Position = I
		'Log(Cursor1.GetString("nihongo"))
		Dim map1 As Map
		map1.Initialize
		map1.Put("roomcode",Cursor1.GetString("roomcode"))
		map1.Put("link",Cursor1.GetString("jwlink"))
        ListView1.AddSingleLine2(Cursor1.GetString("room"),map1)		
	Next
	Cursor1.Close
End Sub