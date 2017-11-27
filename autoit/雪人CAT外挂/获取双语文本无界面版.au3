#Region ;**** 参数创建于 ACNWrapper_GUI ****
#PRE_icon=..\..\..\..\autoit3\AU3TOOL.exe|-1
#PRE_UseX64=n
#PRE_Res_requestedExecutionLevel=None
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=c:\users\xulihang\downloads\compressed\fd\forms\form1.kxf
#EndRegion ### END Koda GUI section ###

MsgBox(64,"提示","使用该工具获取平行文本，请先开启雪人CAT，进入编辑界面，并单击第一行译文部分，使其保持激活状态。")

getBiText()

Func getBiText()
	Dim $className="[CLASS:SnowmanTranslationFreeEditionMainFrame]"
	If winExists($className,"") Then	
		WinActivate($className,"")
		;Dim $sourceText()
		;Dim $targetText()
		Local $text = WinGetClassList($className, "")
		Local $ubound,$lbound,$atlName
		Local $j=0
		Local $repeatTimes=0
		While $j<>-1
			$j=$j+1
            $ubound = StringInStr($text, @LF,0, $j+1) 
		    $lbound = StringInStr($text, @LF,0, $j+2) 
			If StringMid($text,$ubound+1,$lbound-$ubound-1)=$atlName Then
				$repeatTimes=$repeatTimes+1
			Else
				$repeatTimes=0
			EndIf
		    $atlName= StringMid($text,$ubound+1,$lbound-$ubound-1)
			ConsoleWrite($atlName)
			If $repeatTimes=2 Then ;输入区的控件出现三次，以此来定位
				$j=-1
			EndIf
		Wend
		;If $atlname="SysHeader32" Then
		;	$ubound = StringInStr($text, @LF,0, 31) ; 搜索第三个匹配的字符串
		;    $lbound = StringInStr($text, @LF,0, 32) ; 搜索第三个匹配的字符串
		;    $atlName= StringMid($text,$ubound+1,$lbound-$ubound-1)
		;EndIf
		Local $line=""
		Local $i=0
		Local $file = FileOpen("out.csv", BitOR($FO_OVERWRITE,$FO_UTF8))
        ;MsgBox(0,"",$text)
		; 检查打开的文件是否可写
		If $file = -1 Then
			MsgBox(4096, "错误", "不能打开文件.")
			Exit
		EndIf		
		ConsoleWrite("[CLASS:" & $atlName & ";INSTANCE:1]")
		Local $lines=0
		Local $statusbarText=StatusbarGetText($className,"",2)
		Local $current=StringMid($statusbarText,StringInStr($statusbarText,": ")+1,StringInStr($statusbarText,"/")-StringInStr($statusbarText,": ")-1): 
		Local $recordNum=StringMid($statusbarText,StringInStr($statusbarText,"/")+1) ;通过状态栏的记录数来判断要获取几条数据
		;ConsoleWrite(@CRLF&StringInStr($statusbarText,"/"))
		;ConsoleWrite(@CRLF&StringInStr($statusbarText,": "))		
		$current=Int($current)
		$recordNum=Int($recordNum)
		;MsgBox(64,"",$current&@CRLF&$recordNum)
        While $current<=$recordNum
            $current=$current+1
			$line=controlGettext($className,"","[CLASS:" & $atlName & ";INSTANCE:1]")
			$targetText=controlGettext($className,"","[CLASS:" & $atlName & ";INSTANCE:2]")
			If StringStripWS(StringStripCR($targetText),$STR_STRIPALL)="" Then
				$targetText="未翻译"
			EndIf

            FileWriteLine($file, $line&"	"&$targetText)
			;ConsoleWrite($targetText&@LF)
			sleep(100)
			send("{ENTER}")
			ConsoleWrite($i)
        WEnd
		FileClose($file)
		MsgBox(64,"","out.csv文件已保存在程序目录下")
		Exit
	Else
		MsgBox(16,"错误","雪人CAT没有运行")
	EndIf
EndFunc