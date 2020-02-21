B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=7.8
@EndOfDesignText@
Sub Class_Globals
	Private sql1 As SQL
	'Private ser As B4XSerializator
End Sub

'Initializes the store and sets the store file.
Public Sub Initialize (Dir As String, FileName As String)

	If sql1.IsInitialized Then sql1.Close
#if B4J
	sql1.InitializeSQLite(Dir, FileName, True)
#else
	sql1.Initialize(Dir, FileName, True)
#end if
	sql1.ExecNonQuery("PRAGMA journal_mode = wal")
End Sub

Public Sub Put(imitatives As List)
	sql1.ExecNonQuery("CREATE VIRTUAL TABLE IF NOT EXISTS idx USING fts4(word, content, data, notindexed=data)")
	sql1.BeginTransaction
	For Each entry As String In imitatives
		'sql1.ExecNonQuery2("INSERT OR REPLACE INTO main VALUES(?, ?)", Array (source,bytes))
		Dim word,content As String
		word=Regex.Split("\t",entry)(0).Trim
		content=Regex.Split("\t",entry)(1).Trim
		Dim values As List
		values.Initialize
		values.Add(word)
		values.Add(getStringForIndex(content))
		values.Add(content)
		sql1.ExecNonQuery2("INSERT INTO idx VALUES(?,?,?)", values)
	Next
	sql1.TransactionSuccessful
End Sub

'Closes the store.
Public Sub Close
	sql1.Close
End Sub

'Tests whether a key is available in the store.
Public Sub size As Int
	Dim rs As ResultSet = sql1.ExecQuery("SELECT count(rowid) FROM idx")
	Return rs.GetInt2(0)
End Sub
	
Sub getWordsForAll(text As String) As List
	Dim words As List
	words.Initialize
	words.AddAll(LanguageUtils.TokenizedList(text,"en"))
	words.AddAll(LanguageUtils.TokenizedList(text,"zh"))
	LanguageUtils.removeCharacters(words)
	LanguageUtils.removeMultiBytesWords(words)
	Return words
End Sub

Sub getQuery(words As List,operator As String) As String
	Utils.removeDuplicated(words)
	Dim sb As StringBuilder
	sb.Initialize
	For index =0 To words.Size-1
		Dim word As String=words.Get(index)
		If word.Trim<>"" Then
			sb.Append(word)
			If index<>words.Size-1 Then
				sb.Append(" "&operator&" ") ' AND OR NOT
			End If
		End If
	Next
	Return sb.ToString
End Sub

Sub getStringForIndex(text As String) As String
	text=clean(text)
	Dim sb As StringBuilder
	sb.Initialize
	Dim words As List
	words.Initialize
	words.AddAll(LanguageUtils.TokenizedList(text,"en"))
	LanguageUtils.removeChineseWords(words)
	words.AddAll(LanguageUtils.TokenizedList(text,"zh"))
	LanguageUtils.removeCharacters(words)
	For index =0 To words.Size-1
		sb.Append(words.Get(index)).Append(" ")
	Next
	Return sb.ToString.Trim
End Sub

Sub clean(text As String) As String
	text=text.Replace(CRLF," ")
	text=text.Replace("["," ")
	text=text.Replace("]"," ")
	text=text.Replace("("," ")
	text=text.Replace(")"," ")
	Return text
End Sub