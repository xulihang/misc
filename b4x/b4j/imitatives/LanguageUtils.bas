B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=7.8
@EndOfDesignText@
'Static code module
Sub Process_Globals

End Sub

Sub TokenizedList(text As String,sourceLang As String) As List
	text=text.ToLowerCase
	Dim words As List
	words.Initialize
	If Utils.LanguageHasSpace(sourceLang) Then
		text=removePunctuation(text," ")
		words.AddAll(Regex.Split(" ",text))
	Else
		text=removePunctuation(text,"")
		words.AddAll(Regex.Split("",text))
	End If
    'Utils.removeDuplicated(words)
	Dim newList As List
	newList.Initialize
	For Each word As String In words
		If word.Trim="" Then
			Continue
		End If
		newList.Add(word)
	Next
	Return newList
End Sub

Sub removePunctuation(source As String,replacement As String) As String
	source=Regex.Replace($"[。！？，“”'",\.\!\?\*\^\-\(\)\[\]]"$,source,replacement)
	Return source
End Sub

Sub removeMultiBytesWords(words As List)
	Dim newList As List
	newList.Initialize
	For Each word As String In words
		word=word.Trim
		If word.Length>1 Then
			If getBytesLength(word.CharAt(0))>1 Then
				Continue
			End If
		End If
		newList.Add(word)
	Next
	words.Clear
	words.AddAll(newList)
End Sub

Sub removeChineseWords(words As List)
	Dim newList As List
	newList.Initialize
	For Each word As String In words
		If Utils.isChinese(word) Then
			Continue
		End If
		newList.Add(word)
	Next
	words.Clear
	words.AddAll(newList)
End Sub

Sub removeCharacters(source As List)
	Dim newList As List
	newList.Initialize
	For Each text As String In source
		If text.Length=1 Then
			If Regex.IsMatch("[a-z]",text.ToLowerCase)=True Then
				Continue
			End If
		End If
		newList.Add(text)
	Next
	source.Clear
	source.AddAll(newList)
End Sub

Sub getBytesLength(singleString As String) As Int
	Dim bytes() As Byte
	bytes=singleString.GetBytes("UTF-8")
	Return bytes.Length
End Sub
