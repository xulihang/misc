Type=Class
Version=2.75
ModulesStructureVersion=1
B4i=true
@EndOfDesignText@

Sub Class_Globals
	
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize

End Sub

Public Sub changeToneSymbol(symbol As String) As String
	symbol=symbol.Replace("0","◎")
	symbol=symbol.Replace("1","①")
	symbol=symbol.Replace("2","②")
	symbol=symbol.Replace("3","③")
	symbol=symbol.Replace("4","④")
	symbol=symbol.Replace("5","⑤")
	symbol=symbol.Replace("6","⑥")
	Return symbol
End Sub