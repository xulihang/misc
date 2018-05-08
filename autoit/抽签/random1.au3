#Region ;**** 参数创建于 ACNWrapper_GUI ****
#AutoIt3Wrapper_icon=D:\ca\players\110.ico
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
Dim $used[56]
Dim $i=0
Dim $b=false
$ini = FileOpen("config.ini",0) 


If $ini = -1 Then
	MsgBox(16, "错误", '请检查配置文件' & @ScriptDir & '\"config.ini"是否存在!') ;@ScriptDir为脚本所在目录
	Exit
EndIf

$min= IniRead("config.ini", "最值", "min", "")
$max= IniRead("config.ini", "最值", "max", "")
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
	IniWrite("config.ini","已抽",$result,$result)
	MsgBox(64,"Result",$result)
EndIf