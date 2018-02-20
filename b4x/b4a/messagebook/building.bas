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
    Public level As Int
End Sub

Sub Globals
	'These global variables will be redeclared each time the activity is created.
	'These variables can only be accessed from this module.

	Private ListView1 As ListView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("main")
    loadList
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub loadList

	If Main.buildingNum=2 Then
		ListView1.AddSingleLine2("一楼",21)
	    ListView1.AddSingleLine2("二楼",22)	
		ListView1.AddSingleLine2("三楼",23)
		ListView1.AddSingleLine2("四楼",24)	
		ListView1.AddSingleLine2("五楼",25)
	    ListView1.AddSingleLine2("六楼",26)	
    Else
		ListView1.AddSingleLine2("一楼",11)
	    ListView1.AddSingleLine2("二楼",12)	
		ListView1.AddSingleLine2("三楼",13)
		ListView1.AddSingleLine2("四楼",14)	
		ListView1.AddSingleLine2("五楼",15)
	End If
End Sub

Sub ListView1_ItemClick (Position As Int, Value As Object)
	level=Value
	StartActivity(room)
End Sub