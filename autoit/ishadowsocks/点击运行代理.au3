#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=2.ico
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_LegalCopyright=徐力航
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "WinHttp2.au3"
;MsgBox(64,"即将设置","")

Global $sGet = HttpGet("http://xulihang.azurewebsites.net/shadowsocks")
dim $content="{"&'"'&"configs"&'"'&" : [  {"&'"'&"server"&'"'&" : "&'"'&"US1.ISS.TF"&'"'&","&'"'&"server_port"&'"'&" : 8989,"&'"'&"password"&'"'&" : "&'"'&$sGet&'"'&","&'"'&"method"&'"'&" : "&'"'&"aes-256-cfb"&'"'&","&'"'&"remarks"&'"'&" : "&'"'&""&'"'&"}],"&'"'&"index"&'"'&" : 0,"&'"'&"global"&'"'&" : false,"&'"'&"enabled"&'"'&" : true,"&'"'&"shareOverLan"&'"'&" : false,"&'"'&"isDefault"&'"'&" : false,"&'"'&"localPort"&'"'&" : 1080}"

ConsoleWrite($content)

if FileExists("./gui-config.json")=1 Then
	FileDelete("./gui-config.json")
Endif
FileWrite("./gui-config.json", $content)

$flag=MsgBox(4,"","运行代理吗？",10)
ConsoleWrite("Flag:"&$flag)
if $flag=6 or $flag=-1 Then
	run("Shadowsocks.exe","./")
Else
	MsgBox(64,"","已取消")
EndIf
