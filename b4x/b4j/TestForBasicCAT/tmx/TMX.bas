B4J=true
Group=Default Group
ModulesStructureVersion=1
Type=StaticCode
Version=6.51
@EndOfDesignText@
'Static code module
Sub Process_Globals
	Private fx As JFX
End Sub

Sub import(filepath As String) As List
	Dim segments As List
	segments.Initialize
	filepath=File.Combine(File.DirApp,"out.tmx")
	Dim tmxString As String
	tmxString=File.ReadString(filepath,"")
	Dim tmxMap As Map
	tmxMap=getXmlMap(tmxString)
	Log(tmxMap)
	Dim tmxroot As Map
	tmxroot=tmxMap.Get("tmx")
	Dim body As Map
	body=tmxroot.Get("body")
	Dim tuList As List
	tuList=GetElements(body,"tu")
	For Each tu As Map In tuList
		Dim bitext As List
		bitext.Initialize
		Dim tuvList As List
		tuvList=GetElements(tu,"tuv")
		For Each tuv As Map In tuvList

			bitext.Add(tuv.Get("seg"))
		Next
		segments.Add(bitext)
	Next
	Log(segments)
	Return segments
End Sub

Sub export(segments As List)
	Dim rootmap As Map
	rootmap.Initialize
	'rootmap.Put("tmx",CreateMap("Attributes":CreateMap("version":"1.4")))
	Dim tmxMap As Map
	tmxMap.Initialize
	tmxMap.Put("Attributes",CreateMap("version":"1.4"))
	Dim headerAttributes As Map
	headerAttributes.Initialize
	headerAttributes.Put("creationtool","BasicCAT")
	headerAttributes.Put("creationtoolversion","1.0.0")
	headerAttributes.put("adminlang","en")
	headerAttributes.put("srclang","en")
	headerAttributes.put("segtype","sentence")
	headerAttributes.put("o-tmf","BasicCAT")
	tmxMap.Put("header",headerAttributes)
	Dim body As Map
	body.Initialize
	Dim tuList As List
	tuList.Initialize

	For Each bitext As List In segments
		Dim tuvMap As Map
		tuvMap.Initialize
		Dim tuvList As List
		tuvList.Initialize
		Dim index As Int=0
        For Each seg As String In bitext
			index=index+1
			If index Mod 2=0 Then
				tuvList.Add(CreateMap("Attributes":CreateMap("xml:lang":"zh"),"seg":seg))
			Else
				tuvList.Add(CreateMap("Attributes":CreateMap("xml:lang":"en"),"seg":seg))
			End If
			
        Next
		tuvMap.Put("tuv",tuvList)
		tuList.Add(tuvMap)
	Next
	body.Put("tu",tuList)
	tmxMap.Put("body",body)
	rootmap.Put("tmx",tmxMap)
	File.WriteString(File.DirApp,"out1.tmx",getXmlFromMap(rootmap))
End Sub


Sub GetElements (m As Map, key As String) As List
	Dim res As List
	If m.ContainsKey(key) = False Then
		res.Initialize
		Return res
	Else
		Dim value As Object = m.Get(key)
		If value Is List Then Return value
		res.Initialize
		res.Add(value)
		Return res
	End If
End Sub

Sub getXmlMap(xmlstring As String) As Map
	Dim ParsedData As Map
	Dim xm As Xml2Map
	xm.Initialize
	ParsedData = xm.Parse(xmlstring)
	Return ParsedData
End Sub

Sub getXmlFromMap(map1 As Map) As String
	Dim mx As Map2Xml
	mx.Initialize
	Return mx.MapToXml(map1)
End Sub