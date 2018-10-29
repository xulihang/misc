package b4j.example;


import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.B4AClass;
import anywheresoftware.b4a.debug.*;

public class xml2map extends B4AClass.ImplB4AClass implements BA.SubDelegator{
    public static java.util.HashMap<String, java.lang.reflect.Method> htSubs;
    private void innerInitialize(BA _ba) throws Exception {
        if (ba == null) {
            ba = new  anywheresoftware.b4a.ShellBA("b4j.example", "b4j.example.xml2map", this);
            if (htSubs == null) {
                ba.loadHtSubs(this.getClass());
                htSubs = ba.htSubs;
            }
            ba.htSubs = htSubs;
             
        }
        if (BA.isShellModeRuntimeCheck(ba))
                this.getClass().getMethod("_class_globals", b4j.example.xml2map.class).invoke(this, new Object[] {null});
        else
            ba.raiseEvent2(null, true, "class_globals", false);
    }

 
    public void  innerInitializeHelper(anywheresoftware.b4a.BA _ba) throws Exception{
        innerInitialize(_ba);
    }
    public Object callSub(String sub, Object sender, Object[] args) throws Exception {
        return BA.SubDelegator.SubNotFound;
    }
public static class _xmlelement{
public boolean IsInitialized;
public String Name;
public anywheresoftware.b4a.objects.collections.List Children;
public String Text;
public anywheresoftware.b4a.objects.collections.Map Attributes;
public void Initialize() {
IsInitialized = true;
Name = "";
Children = new anywheresoftware.b4a.objects.collections.List();
Text = "";
Attributes = new anywheresoftware.b4a.objects.collections.Map();
}
@Override
		public String toString() {
			return BA.TypeToString(this, false);
		}}
public anywheresoftware.b4a.keywords.Common __c = null;
public anywheresoftware.b4a.objects.SaxParser _parser = null;
public anywheresoftware.b4a.objects.collections.List _elements = null;
public b4j.example.main _main = null;
public b4j.example.srx _srx = null;
public b4j.example.utils _utils = null;
public String  _class_globals(b4j.example.xml2map __ref) throws Exception{
__ref = this;
RDebugUtils.currentModule="xml2map";
RDebugUtils.currentLine=589824;
 //BA.debugLineNum = 589824;BA.debugLine="Sub Class_Globals";
RDebugUtils.currentLine=589825;
 //BA.debugLineNum = 589825;BA.debugLine="Private parser As SaxParser";
_parser = new anywheresoftware.b4a.objects.SaxParser();
RDebugUtils.currentLine=589826;
 //BA.debugLineNum = 589826;BA.debugLine="Type XmlElement (Name As String, Children As List";
;
RDebugUtils.currentLine=589827;
 //BA.debugLineNum = 589827;BA.debugLine="Private elements As List";
_elements = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=589829;
 //BA.debugLineNum = 589829;BA.debugLine="End Sub";
return "";
}
public b4j.example.xml2map._xmlelement  _createelement(b4j.example.xml2map __ref,String _name) throws Exception{
__ref = this;
RDebugUtils.currentModule="xml2map";
if (Debug.shouldDelegate(ba, "createelement"))
	 {return ((b4j.example.xml2map._xmlelement) Debug.delegate(ba, "createelement", new Object[] {_name}));}
b4j.example.xml2map._xmlelement _xe = null;
RDebugUtils.currentLine=917504;
 //BA.debugLineNum = 917504;BA.debugLine="Private Sub CreateElement (Name As String) As XmlE";
RDebugUtils.currentLine=917505;
 //BA.debugLineNum = 917505;BA.debugLine="Dim xe As XmlElement";
_xe = new b4j.example.xml2map._xmlelement();
RDebugUtils.currentLine=917506;
 //BA.debugLineNum = 917506;BA.debugLine="xe.Initialize";
_xe.Initialize();
RDebugUtils.currentLine=917507;
 //BA.debugLineNum = 917507;BA.debugLine="xe.Children.Initialize";
_xe.Children.Initialize();
RDebugUtils.currentLine=917508;
 //BA.debugLineNum = 917508;BA.debugLine="xe.Name = Name";
_xe.Name = _name;
RDebugUtils.currentLine=917509;
 //BA.debugLineNum = 917509;BA.debugLine="Return xe";
if (true) return _xe;
RDebugUtils.currentLine=917510;
 //BA.debugLineNum = 917510;BA.debugLine="End Sub";
return null;
}
public Object  _elementtoobject(b4j.example.xml2map __ref,b4j.example.xml2map._xmlelement _element) throws Exception{
__ref = this;
RDebugUtils.currentModule="xml2map";
if (Debug.shouldDelegate(ba, "elementtoobject"))
	 {return ((Object) Debug.delegate(ba, "elementtoobject", new Object[] {_element}));}
anywheresoftware.b4a.objects.collections.Map _m = null;
b4j.example.xml2map._xmlelement _child = null;
Object _childobject = null;
Object _currentitem = null;
anywheresoftware.b4a.objects.collections.List _list = null;
RDebugUtils.currentLine=851968;
 //BA.debugLineNum = 851968;BA.debugLine="Private Sub ElementToObject (Element As XmlElement";
RDebugUtils.currentLine=851969;
 //BA.debugLineNum = 851969;BA.debugLine="If Element.Children.Size = 0 And Element.Attribut";
if (_element.Children.getSize()==0 && _element.Attributes.IsInitialized()==__c.False) { 
if (true) return (Object)(_element.Text);};
RDebugUtils.currentLine=851970;
 //BA.debugLineNum = 851970;BA.debugLine="Dim m As Map";
_m = new anywheresoftware.b4a.objects.collections.Map();
RDebugUtils.currentLine=851971;
 //BA.debugLineNum = 851971;BA.debugLine="m.Initialize";
_m.Initialize();
RDebugUtils.currentLine=851972;
 //BA.debugLineNum = 851972;BA.debugLine="If Element.Attributes.IsInitialized Then m.Put(\"A";
if (_element.Attributes.IsInitialized()) { 
_m.Put((Object)("Attributes"),(Object)(_element.Attributes.getObject()));};
RDebugUtils.currentLine=851973;
 //BA.debugLineNum = 851973;BA.debugLine="If Element.Children.Size = 0 Then m.Put(\"Text\", E";
if (_element.Children.getSize()==0) { 
_m.Put((Object)("Text"),(Object)(_element.Text));};
RDebugUtils.currentLine=851974;
 //BA.debugLineNum = 851974;BA.debugLine="For Each child As XmlElement In Element.Children";
{
final anywheresoftware.b4a.BA.IterableList group6 = _element.Children;
final int groupLen6 = group6.getSize()
;int index6 = 0;
;
for (; index6 < groupLen6;index6++){
_child = (b4j.example.xml2map._xmlelement)(group6.Get(index6));
RDebugUtils.currentLine=851975;
 //BA.debugLineNum = 851975;BA.debugLine="Dim childObject As Object = ElementToObject(chil";
_childobject = __ref._elementtoobject(null,_child);
RDebugUtils.currentLine=851976;
 //BA.debugLineNum = 851976;BA.debugLine="If m.ContainsKey(child.Name) Then";
if (_m.ContainsKey((Object)(_child.Name))) { 
RDebugUtils.currentLine=851977;
 //BA.debugLineNum = 851977;BA.debugLine="Dim currentItem As Object = m.Get(child.Name)";
_currentitem = _m.Get((Object)(_child.Name));
RDebugUtils.currentLine=851978;
 //BA.debugLineNum = 851978;BA.debugLine="Dim list As List";
_list = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=851979;
 //BA.debugLineNum = 851979;BA.debugLine="If currentItem Is List Then";
if (_currentitem instanceof java.util.List) { 
RDebugUtils.currentLine=851980;
 //BA.debugLineNum = 851980;BA.debugLine="list = currentItem";
_list.setObject((java.util.List)(_currentitem));
 }else {
RDebugUtils.currentLine=851982;
 //BA.debugLineNum = 851982;BA.debugLine="list.Initialize";
_list.Initialize();
RDebugUtils.currentLine=851983;
 //BA.debugLineNum = 851983;BA.debugLine="list.Add(currentItem)";
_list.Add(_currentitem);
RDebugUtils.currentLine=851984;
 //BA.debugLineNum = 851984;BA.debugLine="m.Put(child.Name, list)";
_m.Put((Object)(_child.Name),(Object)(_list.getObject()));
 };
RDebugUtils.currentLine=851986;
 //BA.debugLineNum = 851986;BA.debugLine="list.Add(childObject)";
_list.Add(_childobject);
 }else {
RDebugUtils.currentLine=851988;
 //BA.debugLineNum = 851988;BA.debugLine="m.Put(child.Name, childObject)";
_m.Put((Object)(_child.Name),_childobject);
 };
 }
};
RDebugUtils.currentLine=851991;
 //BA.debugLineNum = 851991;BA.debugLine="Return m";
if (true) return (Object)(_m.getObject());
RDebugUtils.currentLine=851992;
 //BA.debugLineNum = 851992;BA.debugLine="End Sub";
return null;
}
public b4j.example.xml2map._xmlelement  _getlastelement(b4j.example.xml2map __ref) throws Exception{
__ref = this;
RDebugUtils.currentModule="xml2map";
if (Debug.shouldDelegate(ba, "getlastelement"))
	 {return ((b4j.example.xml2map._xmlelement) Debug.delegate(ba, "getlastelement", null));}
RDebugUtils.currentLine=1048576;
 //BA.debugLineNum = 1048576;BA.debugLine="Private Sub GetLastElement As XmlElement";
RDebugUtils.currentLine=1048577;
 //BA.debugLineNum = 1048577;BA.debugLine="Return elements.Get(elements.Size - 1)";
if (true) return (b4j.example.xml2map._xmlelement)(__ref._elements.Get((int) (__ref._elements.getSize()-1)));
RDebugUtils.currentLine=1048578;
 //BA.debugLineNum = 1048578;BA.debugLine="End Sub";
return null;
}
public String  _initialize(b4j.example.xml2map __ref,anywheresoftware.b4a.BA _ba) throws Exception{
__ref = this;
innerInitialize(_ba);
RDebugUtils.currentModule="xml2map";
if (Debug.shouldDelegate(ba, "initialize"))
	 {return ((String) Debug.delegate(ba, "initialize", new Object[] {_ba}));}
RDebugUtils.currentLine=655360;
 //BA.debugLineNum = 655360;BA.debugLine="Public Sub Initialize";
RDebugUtils.currentLine=655361;
 //BA.debugLineNum = 655361;BA.debugLine="parser.Initialize";
__ref._parser.Initialize(ba);
RDebugUtils.currentLine=655362;
 //BA.debugLineNum = 655362;BA.debugLine="End Sub";
return "";
}
public anywheresoftware.b4a.objects.collections.Map  _parse(b4j.example.xml2map __ref,String _xml) throws Exception{
__ref = this;
RDebugUtils.currentModule="xml2map";
if (Debug.shouldDelegate(ba, "parse"))
	 {return ((anywheresoftware.b4a.objects.collections.Map) Debug.delegate(ba, "parse", new Object[] {_xml}));}
anywheresoftware.b4a.objects.streams.File.InputStreamWrapper _in = null;
byte[] _b = null;
RDebugUtils.currentLine=720896;
 //BA.debugLineNum = 720896;BA.debugLine="Public Sub Parse(XML As String) As Map";
RDebugUtils.currentLine=720897;
 //BA.debugLineNum = 720897;BA.debugLine="Dim in As InputStream";
_in = new anywheresoftware.b4a.objects.streams.File.InputStreamWrapper();
RDebugUtils.currentLine=720898;
 //BA.debugLineNum = 720898;BA.debugLine="Dim b() As Byte = XML.GetBytes(\"UTF8\")";
_b = _xml.getBytes("UTF8");
RDebugUtils.currentLine=720899;
 //BA.debugLineNum = 720899;BA.debugLine="in.InitializeFromBytesArray(b, 0, b.Length)";
_in.InitializeFromBytesArray(_b,(int) (0),_b.length);
RDebugUtils.currentLine=720900;
 //BA.debugLineNum = 720900;BA.debugLine="Return Parse2(in)";
if (true) return __ref._parse2(null,_in);
RDebugUtils.currentLine=720901;
 //BA.debugLineNum = 720901;BA.debugLine="End Sub";
return null;
}
public anywheresoftware.b4a.objects.collections.Map  _parse2(b4j.example.xml2map __ref,anywheresoftware.b4a.objects.streams.File.InputStreamWrapper _input) throws Exception{
__ref = this;
RDebugUtils.currentModule="xml2map";
if (Debug.shouldDelegate(ba, "parse2"))
	 {return ((anywheresoftware.b4a.objects.collections.Map) Debug.delegate(ba, "parse2", new Object[] {_input}));}
anywheresoftware.b4a.objects.collections.Map _m = null;
RDebugUtils.currentLine=786432;
 //BA.debugLineNum = 786432;BA.debugLine="Public Sub Parse2(Input As InputStream) As Map";
RDebugUtils.currentLine=786433;
 //BA.debugLineNum = 786433;BA.debugLine="elements.Initialize";
__ref._elements.Initialize();
RDebugUtils.currentLine=786434;
 //BA.debugLineNum = 786434;BA.debugLine="elements.Add(CreateElement(\"stub\"))";
__ref._elements.Add((Object)(__ref._createelement(null,"stub")));
RDebugUtils.currentLine=786435;
 //BA.debugLineNum = 786435;BA.debugLine="parser.Parse(Input, \"parser\")";
__ref._parser.Parse((java.io.InputStream)(_input.getObject()),"parser");
RDebugUtils.currentLine=786436;
 //BA.debugLineNum = 786436;BA.debugLine="Dim m As Map = ElementToObject(elements.Get(0))";
_m = new anywheresoftware.b4a.objects.collections.Map();
_m.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(__ref._elementtoobject(null,(b4j.example.xml2map._xmlelement)(__ref._elements.Get((int) (0))))));
RDebugUtils.currentLine=786437;
 //BA.debugLineNum = 786437;BA.debugLine="Return m";
if (true) return _m;
RDebugUtils.currentLine=786438;
 //BA.debugLineNum = 786438;BA.debugLine="End Sub";
return null;
}
public String  _parser_endelement(b4j.example.xml2map __ref,String _uri,String _name,anywheresoftware.b4a.keywords.StringBuilderWrapper _text) throws Exception{
__ref = this;
RDebugUtils.currentModule="xml2map";
if (Debug.shouldDelegate(ba, "parser_endelement"))
	 {return ((String) Debug.delegate(ba, "parser_endelement", new Object[] {_uri,_name,_text}));}
b4j.example.xml2map._xmlelement _element = null;
RDebugUtils.currentLine=1114112;
 //BA.debugLineNum = 1114112;BA.debugLine="Private Sub Parser_EndElement (Uri As String, Name";
RDebugUtils.currentLine=1114113;
 //BA.debugLineNum = 1114113;BA.debugLine="Dim Element As XmlElement = GetLastElement";
_element = __ref._getlastelement(null);
RDebugUtils.currentLine=1114114;
 //BA.debugLineNum = 1114114;BA.debugLine="Element.Text = Text.ToString";
_element.Text = _text.ToString();
RDebugUtils.currentLine=1114115;
 //BA.debugLineNum = 1114115;BA.debugLine="elements.RemoveAt(elements.Size - 1)";
__ref._elements.RemoveAt((int) (__ref._elements.getSize()-1));
RDebugUtils.currentLine=1114116;
 //BA.debugLineNum = 1114116;BA.debugLine="End Sub";
return "";
}
public String  _parser_startelement(b4j.example.xml2map __ref,String _uri,String _name,anywheresoftware.b4a.objects.SaxParser.AttributesWrapper _attributes) throws Exception{
__ref = this;
RDebugUtils.currentModule="xml2map";
if (Debug.shouldDelegate(ba, "parser_startelement"))
	 {return ((String) Debug.delegate(ba, "parser_startelement", new Object[] {_uri,_name,_attributes}));}
b4j.example.xml2map._xmlelement _element = null;
anywheresoftware.b4a.objects.collections.Map _att = null;
int _i = 0;
RDebugUtils.currentLine=983040;
 //BA.debugLineNum = 983040;BA.debugLine="Private Sub Parser_StartElement (Uri As String, Na";
RDebugUtils.currentLine=983042;
 //BA.debugLineNum = 983042;BA.debugLine="Dim Element As XmlElement = CreateElement(Name)";
_element = __ref._createelement(null,_name);
RDebugUtils.currentLine=983043;
 //BA.debugLineNum = 983043;BA.debugLine="If Attributes.IsInitialized And Attributes.Size >";
if (_attributes.IsInitialized() && _attributes.getSize()>0) { 
RDebugUtils.currentLine=983044;
 //BA.debugLineNum = 983044;BA.debugLine="Dim att As Map";
_att = new anywheresoftware.b4a.objects.collections.Map();
RDebugUtils.currentLine=983048;
 //BA.debugLineNum = 983048;BA.debugLine="att.Initialize";
_att.Initialize();
RDebugUtils.currentLine=983049;
 //BA.debugLineNum = 983049;BA.debugLine="For i = 0 To Attributes.Size - 1";
{
final int step5 = 1;
final int limit5 = (int) (_attributes.getSize()-1);
_i = (int) (0) ;
for (;_i <= limit5 ;_i = _i + step5 ) {
RDebugUtils.currentLine=983050;
 //BA.debugLineNum = 983050;BA.debugLine="att.Put(Attributes.GetName(i), Attributes.GetVa";
_att.Put((Object)(_attributes.GetName(_i)),(Object)(_attributes.GetValue(_i)));
 }
};
RDebugUtils.currentLine=983053;
 //BA.debugLineNum = 983053;BA.debugLine="Element.Attributes = att";
_element.Attributes = _att;
 };
RDebugUtils.currentLine=983055;
 //BA.debugLineNum = 983055;BA.debugLine="GetLastElement.Children.Add(Element)";
__ref._getlastelement(null).Children.Add((Object)(_element));
RDebugUtils.currentLine=983056;
 //BA.debugLineNum = 983056;BA.debugLine="elements.Add(Element)";
__ref._elements.Add((Object)(_element));
RDebugUtils.currentLine=983057;
 //BA.debugLineNum = 983057;BA.debugLine="End Sub";
return "";
}
}