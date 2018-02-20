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
    Private customView1 As CustomListView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	'Do not forget to load the layout file created with the visual designer. For example:
	Activity.LoadLayout("toneIntro")	
	customView1.DefaultTextColor=Colors.Black
	customView1.DefaultTextBackgroundColor=Colors.ARGB(255,215,218,192)
	customView1.DefaultTextSize=16
	customView1.AsView.Color=Colors.ARGB(255,215,218,192)
	customView1.AddTextItem(File.ReadString(File.DirAssets,"shengdiao.txt"),"")
End Sub

Sub Activity_Resume

End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub


