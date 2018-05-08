#Region ;**** 参数创建于 ACNWrapper_GUI ****
#AutoIt3Wrapper_icon=D:\ca\players\s.ico
#EndRegion ;**** 参数创建于 ACNWrapper_GUI ****
FileCopy("./config.ini","./config.bak",1)
for $i = 1 to 55
IniWrite("config.ini","已抽",$i,"")
Next
MsgBox(64,"clear","已重置。")