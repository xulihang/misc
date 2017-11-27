#Region ;**** 参数创建于 ACNWrapper_GUI ****
#PRE_icon=..\..\..\autoit3\AU3TOOL.exe|-1
#PRE_UseX64=n
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=c:\users\xulihang\downloads\compressed\fd\forms\form1.kxf
$Form1_1 = GUICreate("获取术语-雪人CAT外挂", 587, 435, 195, 146)
$ListView1 = GUICtrlCreateListView("原文|译文", 32, 16, 481, 321)
$Button1 = GUICtrlCreateButton("获取并导出", 40, 368, 105, 41)

GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

MsgBox(64,"提示","使用该工具获取术语，请先开启雪人CAT，进入项目词典界面，并双击第一个术语，使其处于编辑状态。")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Button1
			getTerms()

	EndSwitch
WEnd

Func getTerms()
	Dim $className="[CLASS:SnowmanTranslationFreeEditionMainFrame]"
	If winExists($className,"") Then	
		WinActivate($className,"")
		;Dim $sourceText()
		;Dim $targetText()
		Local $text = WinGetClassList($className, "")

		Local $ubound = StringInStr($text, @LF,0, 15) ; 搜索第三个匹配的字符串
		Local $lbound = StringInStr($text, @LF,0, 16) ; 搜索第三个匹配的字符串
		Local $atlName= StringMid($text,$ubound+1,$lbound-$ubound-1)
		MsgBox(0,"",$text)
		msgbox(0,"",$atlName)
        Local $line=""
		Local $i=0
		Local $file = FileOpen("terms.csv", BitOR($FO_OVERWRITE,$FO_ANSI))

		; 检查打开的文件是否可写
		If $file = -1 Then
			MsgBox(4096, "错误", "不能打开文件.")
			Exit
		EndIf		
        While $i=0
			If $line=controlGettext($className,"","[CLASS:" & $atlName & ";INSTANCE:1]") Then
				$i=1
				FileClose($file)
				MsgBox(64,"","terms.csv文件已保存在程序目录下")
			Else
				send("{F2}")
			    $line=controlGettext($className,"","[CLASS:" & $atlName & ";INSTANCE:1]")
				send("{TAB}")
			    send("{TAB}")
				sleep(100)
				
				send("{F2}")
				ConsoleWrite($line)
			    $targetText=controlGettext($className,"","[CLASS:" & $atlName & ";INSTANCE:1]")

				send("{TAB}")
			    send("{TAB}")				

				$item1 = GUICtrlCreateListViewItem($line&"|"&$targetText, $ListView1)
                FileWriteLine($file, $line&"	"&$targetText)
		    EndIf
        WEnd		
	Else
		MsgBox(16,"错误","雪人CAT没有运行")
	EndIf
EndFunc