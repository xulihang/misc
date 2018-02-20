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
    Dim customview1 As CustomListView 
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("favourite")
    Activity.Title="收藏"
	customview1.DefaultTextColor=Colors.Black
	customview1.DefaultTextBackgroundColor=Colors.ARGB(255,215,218,192)
	customview1.DefaultTextSize=16
	customview1.AsView.Color=Colors.ARGB(255,215,218,192)
	If File.Exists(File.DirInternal,"fav.txt")  Then		
		For Each i In File.ReadList(File.DirInternal,"fav.txt")
			customview1.AddTextItem(i,i)
		Next	    
	Else
		ToastMessageShow("目前无收藏",False)
	End If

End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Sub CustomView1_ItemClick (Index As Int, Value As Object)
    Dim result As Int 
	result=Msgbox2("删除此条收藏吗？","","是"	,"","不",Null)
    If result=DialogResponse.POSITIVE Then
		Dim List1 As List
		List1=File.ReadList(File.DirInternal,"fav.txt")
		List1.RemoveAt(List1.IndexOf(Value))
		File.WriteList(File.DirInternal,"fav.txt",List1)	
		customview1.RemoveAt(Index)
    End If
	
End Sub
