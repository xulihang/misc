package b4j.example;

import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.pc.*;

public class xml2map_subs_0 {


public static RemoteObject  _class_globals(RemoteObject __ref) throws Exception{
 //BA.debugLineNum = 3;BA.debugLine="Sub Class_Globals";
 //BA.debugLineNum = 4;BA.debugLine="Private parser As SaxParser";
xml2map._parser = RemoteObject.createNew ("anywheresoftware.b4a.objects.SaxParser");__ref.setField("_parser",xml2map._parser);
 //BA.debugLineNum = 5;BA.debugLine="Type XmlElement (Name As String, Children As List";
;
 //BA.debugLineNum = 6;BA.debugLine="Private elements As List";
xml2map._elements = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");__ref.setField("_elements",xml2map._elements);
 //BA.debugLineNum = 8;BA.debugLine="End Sub";
return RemoteObject.createImmutable("");
}
public static RemoteObject  _createelement(RemoteObject __ref,RemoteObject _name) throws Exception{
try {
		Debug.PushSubsStack("CreateElement (xml2map) ","xml2map",2,__ref.getField(false, "ba"),__ref,55);
if (RapidSub.canDelegate("createelement")) { return __ref.runUserSub(false, "xml2map","createelement", __ref, _name);}
RemoteObject _xe = RemoteObject.declareNull("b4j.example.xml2map._xmlelement");
Debug.locals.put("Name", _name);
 BA.debugLineNum = 55;BA.debugLine="Private Sub CreateElement (Name As String) As XmlE";
Debug.ShouldStop(4194304);
 BA.debugLineNum = 56;BA.debugLine="Dim xe As XmlElement";
Debug.ShouldStop(8388608);
_xe = RemoteObject.createNew ("b4j.example.xml2map._xmlelement");Debug.locals.put("xe", _xe);
 BA.debugLineNum = 57;BA.debugLine="xe.Initialize";
Debug.ShouldStop(16777216);
_xe.runVoidMethod ("Initialize");
 BA.debugLineNum = 58;BA.debugLine="xe.Children.Initialize";
Debug.ShouldStop(33554432);
_xe.getField(false,"Children").runVoidMethod ("Initialize");
 BA.debugLineNum = 59;BA.debugLine="xe.Name = Name";
Debug.ShouldStop(67108864);
_xe.setField ("Name",_name);
 BA.debugLineNum = 60;BA.debugLine="Return xe";
Debug.ShouldStop(134217728);
if (true) return _xe;
 BA.debugLineNum = 61;BA.debugLine="End Sub";
Debug.ShouldStop(268435456);
return RemoteObject.createImmutable(null);
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _elementtoobject(RemoteObject __ref,RemoteObject _element) throws Exception{
try {
		Debug.PushSubsStack("ElementToObject (xml2map) ","xml2map",2,__ref.getField(false, "ba"),__ref,29);
if (RapidSub.canDelegate("elementtoobject")) { return __ref.runUserSub(false, "xml2map","elementtoobject", __ref, _element);}
RemoteObject _m = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _child = RemoteObject.declareNull("b4j.example.xml2map._xmlelement");
RemoteObject _childobject = RemoteObject.declareNull("Object");
RemoteObject _currentitem = RemoteObject.declareNull("Object");
RemoteObject _list = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
Debug.locals.put("Element", _element);
 BA.debugLineNum = 29;BA.debugLine="Private Sub ElementToObject (Element As XmlElement";
Debug.ShouldStop(268435456);
 BA.debugLineNum = 30;BA.debugLine="If Element.Children.Size = 0 And Element.Attribut";
Debug.ShouldStop(536870912);
if (RemoteObject.solveBoolean("=",_element.getField(false,"Children").runMethod(true,"getSize"),BA.numberCast(double.class, 0)) && RemoteObject.solveBoolean("=",_element.getField(false,"Attributes").runMethod(true,"IsInitialized"),xml2map.__c.getField(true,"False"))) { 
if (true) return (_element.getField(true,"Text"));};
 BA.debugLineNum = 31;BA.debugLine="Dim m As Map";
Debug.ShouldStop(1073741824);
_m = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");Debug.locals.put("m", _m);
 BA.debugLineNum = 32;BA.debugLine="m.Initialize";
Debug.ShouldStop(-2147483648);
_m.runVoidMethod ("Initialize");
 BA.debugLineNum = 33;BA.debugLine="If Element.Attributes.IsInitialized Then m.Put(\"A";
Debug.ShouldStop(1);
if (_element.getField(false,"Attributes").runMethod(true,"IsInitialized").<Boolean>get().booleanValue()) { 
_m.runVoidMethod ("Put",(Object)(RemoteObject.createImmutable(("Attributes"))),(Object)((_element.getField(false,"Attributes").getObject())));};
 BA.debugLineNum = 34;BA.debugLine="If Element.Children.Size = 0 Then m.Put(\"Text\", E";
Debug.ShouldStop(2);
if (RemoteObject.solveBoolean("=",_element.getField(false,"Children").runMethod(true,"getSize"),BA.numberCast(double.class, 0))) { 
_m.runVoidMethod ("Put",(Object)(RemoteObject.createImmutable(("Text"))),(Object)((_element.getField(true,"Text"))));};
 BA.debugLineNum = 35;BA.debugLine="For Each child As XmlElement In Element.Children";
Debug.ShouldStop(4);
{
final RemoteObject group6 = _element.getField(false,"Children");
final int groupLen6 = group6.runMethod(true,"getSize").<Integer>get()
;int index6 = 0;
;
for (; index6 < groupLen6;index6++){
_child = (group6.runMethod(false,"Get",index6));Debug.locals.put("child", _child);
Debug.locals.put("child", _child);
 BA.debugLineNum = 36;BA.debugLine="Dim childObject As Object = ElementToObject(chil";
Debug.ShouldStop(8);
_childobject = __ref.runClassMethod (b4j.example.xml2map.class, "_elementtoobject",(Object)(_child));Debug.locals.put("childObject", _childobject);Debug.locals.put("childObject", _childobject);
 BA.debugLineNum = 37;BA.debugLine="If m.ContainsKey(child.Name) Then";
Debug.ShouldStop(16);
if (_m.runMethod(true,"ContainsKey",(Object)((_child.getField(true,"Name")))).<Boolean>get().booleanValue()) { 
 BA.debugLineNum = 38;BA.debugLine="Dim currentItem As Object = m.Get(child.Name)";
Debug.ShouldStop(32);
_currentitem = _m.runMethod(false,"Get",(Object)((_child.getField(true,"Name"))));Debug.locals.put("currentItem", _currentitem);Debug.locals.put("currentItem", _currentitem);
 BA.debugLineNum = 39;BA.debugLine="Dim list As List";
Debug.ShouldStop(64);
_list = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("list", _list);
 BA.debugLineNum = 40;BA.debugLine="If currentItem Is List Then";
Debug.ShouldStop(128);
if (RemoteObject.solveBoolean("i",_currentitem, RemoteObject.createImmutable("java.util.List"))) { 
 BA.debugLineNum = 41;BA.debugLine="list = currentItem";
Debug.ShouldStop(256);
_list.setObject(_currentitem);
 }else {
 BA.debugLineNum = 43;BA.debugLine="list.Initialize";
Debug.ShouldStop(1024);
_list.runVoidMethod ("Initialize");
 BA.debugLineNum = 44;BA.debugLine="list.Add(currentItem)";
Debug.ShouldStop(2048);
_list.runVoidMethod ("Add",(Object)(_currentitem));
 BA.debugLineNum = 45;BA.debugLine="m.Put(child.Name, list)";
Debug.ShouldStop(4096);
_m.runVoidMethod ("Put",(Object)((_child.getField(true,"Name"))),(Object)((_list.getObject())));
 };
 BA.debugLineNum = 47;BA.debugLine="list.Add(childObject)";
Debug.ShouldStop(16384);
_list.runVoidMethod ("Add",(Object)(_childobject));
 }else {
 BA.debugLineNum = 49;BA.debugLine="m.Put(child.Name, childObject)";
Debug.ShouldStop(65536);
_m.runVoidMethod ("Put",(Object)((_child.getField(true,"Name"))),(Object)(_childobject));
 };
 }
}Debug.locals.put("child", _child);
;
 BA.debugLineNum = 52;BA.debugLine="Return m";
Debug.ShouldStop(524288);
if (true) return (_m.getObject());
 BA.debugLineNum = 53;BA.debugLine="End Sub";
Debug.ShouldStop(1048576);
return RemoteObject.createImmutable(null);
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _getlastelement(RemoteObject __ref) throws Exception{
try {
		Debug.PushSubsStack("GetLastElement (xml2map) ","xml2map",2,__ref.getField(false, "ba"),__ref,86);
if (RapidSub.canDelegate("getlastelement")) { return __ref.runUserSub(false, "xml2map","getlastelement", __ref);}
 BA.debugLineNum = 86;BA.debugLine="Private Sub GetLastElement As XmlElement";
Debug.ShouldStop(2097152);
 BA.debugLineNum = 87;BA.debugLine="Return elements.Get(elements.Size - 1)";
Debug.ShouldStop(4194304);
if (true) return (__ref.getField(false,"_elements").runMethod(false,"Get",(Object)(RemoteObject.solve(new RemoteObject[] {__ref.getField(false,"_elements").runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1))));
 BA.debugLineNum = 88;BA.debugLine="End Sub";
Debug.ShouldStop(8388608);
return RemoteObject.createImmutable(null);
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _initialize(RemoteObject __ref,RemoteObject _ba) throws Exception{
try {
		Debug.PushSubsStack("Initialize (xml2map) ","xml2map",2,__ref.getField(false, "ba"),__ref,10);
if (RapidSub.canDelegate("initialize")) { return __ref.runUserSub(false, "xml2map","initialize", __ref, _ba);}
__ref.runVoidMethodAndSync("innerInitializeHelper", _ba);
Debug.locals.put("ba", _ba);
 BA.debugLineNum = 10;BA.debugLine="Public Sub Initialize";
Debug.ShouldStop(512);
 BA.debugLineNum = 11;BA.debugLine="parser.Initialize";
Debug.ShouldStop(1024);
__ref.getField(false,"_parser").runVoidMethod ("Initialize",__ref.getField(false, "ba"));
 BA.debugLineNum = 12;BA.debugLine="End Sub";
Debug.ShouldStop(2048);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _parse(RemoteObject __ref,RemoteObject _xml) throws Exception{
try {
		Debug.PushSubsStack("Parse (xml2map) ","xml2map",2,__ref.getField(false, "ba"),__ref,14);
if (RapidSub.canDelegate("parse")) { return __ref.runUserSub(false, "xml2map","parse", __ref, _xml);}
RemoteObject _in = RemoteObject.declareNull("anywheresoftware.b4a.objects.streams.File.InputStreamWrapper");
RemoteObject _b = null;
Debug.locals.put("XML", _xml);
 BA.debugLineNum = 14;BA.debugLine="Public Sub Parse(XML As String) As Map";
Debug.ShouldStop(8192);
 BA.debugLineNum = 15;BA.debugLine="Dim in As InputStream";
Debug.ShouldStop(16384);
_in = RemoteObject.createNew ("anywheresoftware.b4a.objects.streams.File.InputStreamWrapper");Debug.locals.put("in", _in);
 BA.debugLineNum = 16;BA.debugLine="Dim b() As Byte = XML.GetBytes(\"UTF8\")";
Debug.ShouldStop(32768);
_b = _xml.runMethod(false,"getBytes",(Object)(RemoteObject.createImmutable("UTF8")));Debug.locals.put("b", _b);Debug.locals.put("b", _b);
 BA.debugLineNum = 17;BA.debugLine="in.InitializeFromBytesArray(b, 0, b.Length)";
Debug.ShouldStop(65536);
_in.runVoidMethod ("InitializeFromBytesArray",(Object)(_b),(Object)(BA.numberCast(int.class, 0)),(Object)(_b.getField(true,"length")));
 BA.debugLineNum = 18;BA.debugLine="Return Parse2(in)";
Debug.ShouldStop(131072);
if (true) return __ref.runClassMethod (b4j.example.xml2map.class, "_parse2",(Object)(_in));
 BA.debugLineNum = 19;BA.debugLine="End Sub";
Debug.ShouldStop(262144);
return RemoteObject.createImmutable(null);
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _parse2(RemoteObject __ref,RemoteObject _input) throws Exception{
try {
		Debug.PushSubsStack("Parse2 (xml2map) ","xml2map",2,__ref.getField(false, "ba"),__ref,21);
if (RapidSub.canDelegate("parse2")) { return __ref.runUserSub(false, "xml2map","parse2", __ref, _input);}
RemoteObject _m = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
Debug.locals.put("Input", _input);
 BA.debugLineNum = 21;BA.debugLine="Public Sub Parse2(Input As InputStream) As Map";
Debug.ShouldStop(1048576);
 BA.debugLineNum = 22;BA.debugLine="elements.Initialize";
Debug.ShouldStop(2097152);
__ref.getField(false,"_elements").runVoidMethod ("Initialize");
 BA.debugLineNum = 23;BA.debugLine="elements.Add(CreateElement(\"stub\"))";
Debug.ShouldStop(4194304);
__ref.getField(false,"_elements").runVoidMethod ("Add",(Object)((__ref.runClassMethod (b4j.example.xml2map.class, "_createelement",(Object)(RemoteObject.createImmutable("stub"))))));
 BA.debugLineNum = 24;BA.debugLine="parser.Parse(Input, \"parser\")";
Debug.ShouldStop(8388608);
__ref.getField(false,"_parser").runVoidMethodAndSync ("Parse",(Object)((_input.getObject())),(Object)(RemoteObject.createImmutable("parser")));
 BA.debugLineNum = 25;BA.debugLine="Dim m As Map = ElementToObject(elements.Get(0))";
Debug.ShouldStop(16777216);
_m = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");
_m.setObject(__ref.runClassMethod (b4j.example.xml2map.class, "_elementtoobject",(Object)((__ref.getField(false,"_elements").runMethod(false,"Get",(Object)(BA.numberCast(int.class, 0)))))));Debug.locals.put("m", _m);
 BA.debugLineNum = 26;BA.debugLine="Return m";
Debug.ShouldStop(33554432);
if (true) return _m;
 BA.debugLineNum = 27;BA.debugLine="End Sub";
Debug.ShouldStop(67108864);
return RemoteObject.createImmutable(null);
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _parser_endelement(RemoteObject __ref,RemoteObject _uri,RemoteObject _name,RemoteObject _text) throws Exception{
try {
		Debug.PushSubsStack("Parser_EndElement (xml2map) ","xml2map",2,__ref.getField(false, "ba"),__ref,90);
if (RapidSub.canDelegate("parser_endelement")) { return __ref.runUserSub(false, "xml2map","parser_endelement", __ref, _uri, _name, _text);}
RemoteObject _element = RemoteObject.declareNull("b4j.example.xml2map._xmlelement");
Debug.locals.put("Uri", _uri);
Debug.locals.put("Name", _name);
Debug.locals.put("Text", _text);
 BA.debugLineNum = 90;BA.debugLine="Private Sub Parser_EndElement (Uri As String, Name";
Debug.ShouldStop(33554432);
 BA.debugLineNum = 91;BA.debugLine="Dim Element As XmlElement = GetLastElement";
Debug.ShouldStop(67108864);
_element = __ref.runClassMethod (b4j.example.xml2map.class, "_getlastelement");Debug.locals.put("Element", _element);Debug.locals.put("Element", _element);
 BA.debugLineNum = 92;BA.debugLine="Element.Text = Text.ToString";
Debug.ShouldStop(134217728);
_element.setField ("Text",_text.runMethod(true,"ToString"));
 BA.debugLineNum = 93;BA.debugLine="elements.RemoveAt(elements.Size - 1)";
Debug.ShouldStop(268435456);
__ref.getField(false,"_elements").runVoidMethod ("RemoveAt",(Object)(RemoteObject.solve(new RemoteObject[] {__ref.getField(false,"_elements").runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1)));
 BA.debugLineNum = 94;BA.debugLine="End Sub";
Debug.ShouldStop(536870912);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _parser_startelement(RemoteObject __ref,RemoteObject _uri,RemoteObject _name,RemoteObject _attributes) throws Exception{
try {
		Debug.PushSubsStack("Parser_StartElement (xml2map) ","xml2map",2,__ref.getField(false, "ba"),__ref,67);
if (RapidSub.canDelegate("parser_startelement")) { return __ref.runUserSub(false, "xml2map","parser_startelement", __ref, _uri, _name, _attributes);}
RemoteObject _element = RemoteObject.declareNull("b4j.example.xml2map._xmlelement");
RemoteObject _att = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
int _i = 0;
Debug.locals.put("Uri", _uri);
Debug.locals.put("Name", _name);
Debug.locals.put("Attributes", _attributes);
 BA.debugLineNum = 67;BA.debugLine="Private Sub Parser_StartElement (Uri As String, Na";
Debug.ShouldStop(4);
 BA.debugLineNum = 69;BA.debugLine="Dim Element As XmlElement = CreateElement(Name)";
Debug.ShouldStop(16);
_element = __ref.runClassMethod (b4j.example.xml2map.class, "_createelement",(Object)(_name));Debug.locals.put("Element", _element);Debug.locals.put("Element", _element);
 BA.debugLineNum = 70;BA.debugLine="If Attributes.IsInitialized And Attributes.Size >";
Debug.ShouldStop(32);
if (RemoteObject.solveBoolean(".",_attributes.runMethod(true,"IsInitialized")) && RemoteObject.solveBoolean(">",_attributes.runMethod(true,"getSize"),BA.numberCast(double.class, 0))) { 
 BA.debugLineNum = 71;BA.debugLine="Dim att As Map";
Debug.ShouldStop(64);
_att = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");Debug.locals.put("att", _att);
 BA.debugLineNum = 75;BA.debugLine="att.Initialize";
Debug.ShouldStop(1024);
_att.runVoidMethod ("Initialize");
 BA.debugLineNum = 76;BA.debugLine="For i = 0 To Attributes.Size - 1";
Debug.ShouldStop(2048);
{
final int step5 = 1;
final int limit5 = RemoteObject.solve(new RemoteObject[] {_attributes.runMethod(true,"getSize"),RemoteObject.createImmutable(1)}, "-",1, 1).<Integer>get().intValue();
_i = 0 ;
for (;(step5 > 0 && _i <= limit5) || (step5 < 0 && _i >= limit5) ;_i = ((int)(0 + _i + step5))  ) {
Debug.locals.put("i", _i);
 BA.debugLineNum = 77;BA.debugLine="att.Put(Attributes.GetName(i), Attributes.GetVa";
Debug.ShouldStop(4096);
_att.runVoidMethod ("Put",(Object)((_attributes.runMethod(true,"GetName",(Object)(BA.numberCast(int.class, _i))))),(Object)((_attributes.runMethod(true,"GetValue",(Object)(BA.numberCast(int.class, _i))))));
 }
}Debug.locals.put("i", _i);
;
 BA.debugLineNum = 80;BA.debugLine="Element.Attributes = att";
Debug.ShouldStop(32768);
_element.setField ("Attributes",_att);
 };
 BA.debugLineNum = 82;BA.debugLine="GetLastElement.Children.Add(Element)";
Debug.ShouldStop(131072);
__ref.runClassMethod (b4j.example.xml2map.class, "_getlastelement").getField(false,"Children").runVoidMethod ("Add",(Object)((_element)));
 BA.debugLineNum = 83;BA.debugLine="elements.Add(Element)";
Debug.ShouldStop(262144);
__ref.getField(false,"_elements").runVoidMethod ("Add",(Object)((_element)));
 BA.debugLineNum = 84;BA.debugLine="End Sub";
Debug.ShouldStop(524288);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
}