#Region ;**** 参数创建于 ACNWrapper_GUI ****
#AutoIt3Wrapper_icon=D:\ca\players\110.ico
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

Dim $used[56]
Dim $i=0
Dim $a=1
Dim $b=false
$ini = FileOpen("config.ini",0) 


If $ini = -1 Then
	MsgBox(16, "错误", '请检查配置文件' & @ScriptDir & '\"config.ini"是否存在!') ;@ScriptDir为脚本所在目录
	Exit
EndIf

$min= IniRead("config.ini", "最值", "min", "")
$max= IniRead("config.ini", "最值", "max", "")

$form				= Guicreate("抽签", 800, 600, -1, -1)

$Button1		= GuiCtrlCreateButton("抽", 330, 420, 140, 80)

$Label1			= GuiCtrlCreateLabel("00",330, 110, 360, 230)
GUICtrlSetFont ($Label1, 96 )

$Label2			= GuiCtrlCreateLabel("2012-2，高二一班", 620, 530,120, 20)

GuiSetState(@SW_SHOW)

While $a=1
	$result=Random($min,$max,1)
	While $b=false
	for $i =1 to 55
	$used[$i]=IniRead("config.ini","已抽",$i,"")
	If $used[$i] = $result Then
		$b=False
		$result=Random($min,$max,1)
		$i=0
	Else
		$b=True
    EndIf
	Next
   WEnd
 
   If $b=true Then			 
	$Label1	= GuiCtrlCreateLabel($result, 330, 110, 360, 230)
	GUICtrlSetFont ($Label1, 96 )
	$b=false
   EndIf
	sleep(100)
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
		    _start()
	EndSwitch
Wend

While $a=2
	$Msg = GUIGetMsg()
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
		    _start()
	EndSwitch
WEnd

Func _start()
	$b=False
While $b=false
	for $i =1 to 55
	$used[$i]=IniRead("config.ini","已抽",$i,"")
	If $used[$i] = $result Then
		$b=False
		$result=Random($min,$max,1)
		$i=0
	Else
		$b=True
    EndIf
	Next
WEnd
 
If $b=true Then			 
	IniWrite("config.ini","已抽",$result,$result)
	$Label1	= GuiCtrlCreateLabel($result, 330, 110, 360, 230)
	GUICtrlSetFont ($Label1, 96 )
	GUICtrlSetData($Button1,"再抽")
	$a=2

	;GUISetState(@SW_LOCK)    
EndIf
EndFunc



