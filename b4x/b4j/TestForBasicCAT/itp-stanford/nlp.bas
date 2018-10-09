B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=6.51
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
	Private gramString As String
	Private space As String=""
End Sub

Sub treeFromString(text As String) As List
	Dim stack As List
	stack.Initialize
	Dim group As List
	group.Initialize
	Dim leaf As List
	leaf.Initialize
	group.Add("label")
	group.Add(leaf)
	stack.Add(group)
	'[[label,[node]]]
	Dim matcher As Matcher
	matcher=Regex.Matcher("\(\s*([^\s\(\)]+)?|\)|([^\s\(\)]+)",text)
	Do While matcher.Find
		Log(matcher.Match)
		
		If matcher.Match.CharAt(0)="(" Then
			Dim lbl As String
			lbl=matcher.Match.SubString2(1,matcher.Match.Length).Trim
			Dim leaf As List
			leaf.Initialize
			Dim group As List
			group.Initialize
			group.Add(lbl)
			group.Add(leaf)
			stack.Add(group)
			
		else if matcher.Match=")" Then
			Dim group As List
			group=stack.Get(stack.Size-1)
			stack.RemoveAt(stack.Size-1)
			Dim newGroup As List
			newGroup=stack.Get(stack.Size-1)
			Dim leaf As List
			leaf=newGroup.get(1)
			leaf.Add(group)
			newGroup.Set(1,leaf)
			stack.Set(stack.Size-1,newGroup)
		Else
			Dim group As List
			group=stack.Get(stack.Size-1)
			group.Set(1,matcher.Match)
			stack.Set(stack.Size-1,group)
		End If
		Log(stack)
	Loop
	Log(stack)
	Dim group As List
	group=stack.Get(0)
	Dim tree As List
	tree=group.Get(1)
	Log(tree)
	Return tree
End Sub


Sub getSimpleTreeList(newList As List) As List
	'get the list starting with S
	Dim t As List
	t.Initialize
	t.AddAll(newList)
	If t.Size=1 Then
		t=t.Get(0)
		Return getSimpleTreeList(t)
	Else if t.Get(0)<>"S" Then
		t=t.Get(1)
		Return getSimpleTreeList(t)
	Else if t.Get(0)="S" Then
		Return t
	End If
End Sub

Sub getGramsFromString(text As String) As List
	Dim gramsList As List
	gramsList.Initialize
	
	If text.Contains(" ") Then
		space=" "
	Else
		space=""
	End If
	
	Dim t As List
	t=getSimpleTreeList(treeFromString(text))
    
	Dim grams As List
	grams=t.Get(1)
	For Each gram As List In grams
		gramString=""
		If isString(gram.Get(1))=False Then
			getString(gram.Get(1),"")
		Else
			Log(gram.Get(1))
		End If
		gramsList.Add(gramString.Trim)
	Next
	Return gramsList
End Sub


Sub getString(t As List, content As String)
	Log(t)
	If isString(t.Get(0)) Then 'label
		If t.Size>1 And isList(t.Get(1)) Then '[NP, [[PRP, you]]]
			Log(1)
			getString(t.Get(1),content)
		Else if t.Size>1 And isString(t.Get(1)) Then '[PRP, I]
			Log(2)
			Log(t.Get(1))
			content=content&t.Get(1)
			gramString=gramString&space&t.Get(1)
		End If
	Else
		Log(3)
		'[[VBP, love], [NP, [[PRP, you]]]]
		Dim nextList As List
		nextList=t
		If isString(nextList.Get(0)) Then
			Log(nextList.Get(1))
			content=content&nextList.Get(1)
			gramString=gramString&space&nextList.Get(1)
		Else
			For Each group As List In nextList
				getString(group,content)
			Next
		End If
	End If
	
End Sub


Sub isString(o As Object) As Boolean
	If GetType(o)="java.lang.String" Then
		Return True
	Else
		Return False
	End If
End Sub

Sub isList(o As Object) As Boolean
	If GetType(o)="java.util.ArrayList" Then
		Return True
	Else
		Return False
	End If
End Sub

Sub getGramsFromStringViaRe(text As String) As List
    Dim gramsList As List
	gramsList.Initialize
	text=Regex.Replace("\r\n",text,"")
	text=Regex.Replace(" {1,}",text," ")
	'For Each item As String In Array As String("NP","IP","VP","PP","SBAR")	
	'	Dim matcher As Matcher
		'\(NP .*?\){2,}
		'\(.*?
		'\)
	'	matcher=Regex.Matcher("\("&item&" .*?\){2,}",text)
	'	Do While matcher.Find
	'		gramsList.Add(Regex.Replace("\(.*? |\)",matcher.Match,""))
			'ListView1.Items.Add(matcher.Match)
	'		Log(matcher.Match)
	'	Loop
	'Next
	For Each item As String In Array As String("NP","IP","VP","PP","SBAR")
		
		Dim matcher As Matcher
		
		'\(NP .*?\){2,}
		'\(.*?
		'\)
		matcher=Regex.Matcher("\("&item&" .*\){2,}",text)
		
		Do While matcher.Find
			gramsList.Add(Regex.Replace("\(.*? |\)",matcher.Match,""))
			Log(matcher.Match)
		Loop
	Next
		
	Return gramsList
End Sub

Sub getGrams(text As String,all As List) As List
	text=Regex.Replace("\r\n",text,"")
	text=Regex.Replace(" {1,}",text," ")
	For Each item As String In Array As String("NP","VP","PP")
		Dim matcher As Matcher
	'\(NP .*?\){2,}
	'\(.*?
	'\)
		matcher=Regex.Matcher("\("&item&" .*?\){2,}",text)
		Do While matcher.Find
			all.Add(Regex.Replace("\(.*? |\)",matcher.Match,""))
			Log(matcher.Match)
		Loop
	Next

	all=get(text,all,"VP")

	Return all
End Sub

Sub get(text As String,all As List,item As String) As List
	Dim matcher As Matcher

	matcher=Regex.Matcher("\("&item&" .*\){2,}",text)
		
	Do While matcher.Find
		Log(matcher.Match)
		all.Add(Regex.Replace("\(.*? |\)",matcher.Match,""))
		
		Dim matcher2 As Matcher
		matcher2=Regex.Matcher("\("&item&" .*?\){2,}",matcher.Match)
		Do While matcher2.Find

			'all.Add(matcher2.Match)
			all.Add(Regex.Replace("\(.*? |\)",matcher2.Match,""))
			get(matcher.Match.Replace(matcher2.Match,""),all,item)
		Loop
		
	Loop
	Return duplicatedRemovedList(all)
End Sub


Sub duplicatedRemovedList(list1 As List) As List
	Dim newList As List
	newList.Initialize
	For Each item As String In list1
		Dim matcher As Matcher
		matcher=Regex.Matcher(",",item)
		If newList.IndexOf(item)=-1 And matcher.Find=False Then
			newList.Add(item)
		End If
	Next
	Return newList
End Sub