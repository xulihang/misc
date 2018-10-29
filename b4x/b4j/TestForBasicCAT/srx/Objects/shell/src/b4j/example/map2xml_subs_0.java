package b4j.example;

import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.pc.*;

public class map2xml_subs_0 {


public static RemoteObject  _class_globals(RemoteObject __ref) throws Exception{
 //BA.debugLineNum = 2;BA.debugLine="Sub Class_Globals";
 //BA.debugLineNum = 3;BA.debugLine="Private builder As XMLBuilder";
map2xml._builder = RemoteObject.createNew ("com.jamesmurty.utils.XMLBuilder");__ref.setField("_builder",map2xml._builder);
 //BA.debugLineNum = 4;BA.debugLine="End Sub";
return RemoteObject.createImmutable("");
}
public static RemoteObject  _handleelement(RemoteObject __ref,RemoteObject _key,RemoteObject _value) throws Exception{
try {
		Debug.PushSubsStack("HandleElement (map2xml) ","map2xml",1,__ref.getField(false, "ba"),__ref,44);
if (RapidSub.canDelegate("handleelement")) { return __ref.runUserSub(false, "map2xml","handleelement", __ref, _key, _value);}
Debug.locals.put("key", _key);
Debug.locals.put("value", _value);
 BA.debugLineNum = 44;BA.debugLine="Private Sub HandleElement (key As String, value As";
Debug.ShouldStop(2048);
 BA.debugLineNum = 45;BA.debugLine="If value Is Map Then";
Debug.ShouldStop(4096);
if (RemoteObject.solveBoolean("i",_value, RemoteObject.createImmutable("anywheresoftware.b4a.objects.collections.Map.MyMap"))) { 
 BA.debugLineNum = 46;BA.debugLine="If key <> \"\" Then builder = builder.element(key)";
Debug.ShouldStop(8192);
if (RemoteObject.solveBoolean("!",_key,BA.ObjectToString(""))) { 
__ref.setField ("_builder",__ref.getField(false,"_builder").runMethod(false,"element",(Object)(_key)));};
 BA.debugLineNum = 47;BA.debugLine="HandleMapElement(value)";
Debug.ShouldStop(16384);
__ref.runClassMethod (b4j.example.map2xml.class, "_handlemapelement",RemoteObject.declareNull("anywheresoftware.b4a.AbsObjectWrapper").runMethod(false, "ConvertToWrapper", RemoteObject.createNew("anywheresoftware.b4a.objects.collections.Map"), _value));
 BA.debugLineNum = 48;BA.debugLine="If key <> \"\" Then builder = builder.up";
Debug.ShouldStop(32768);
if (RemoteObject.solveBoolean("!",_key,BA.ObjectToString(""))) { 
__ref.setField ("_builder",__ref.getField(false,"_builder").runMethod(false,"up"));};
 }else 
{ BA.debugLineNum = 49;BA.debugLine="Else if value Is List Then";
Debug.ShouldStop(65536);
if (RemoteObject.solveBoolean("i",_value, RemoteObject.createImmutable("java.util.List"))) { 
 BA.debugLineNum = 50;BA.debugLine="HandleListElement (key, value)";
Debug.ShouldStop(131072);
__ref.runClassMethod (b4j.example.map2xml.class, "_handlelistelement",(Object)(_key),RemoteObject.declareNull("anywheresoftware.b4a.AbsObjectWrapper").runMethod(false, "ConvertToWrapper", RemoteObject.createNew("anywheresoftware.b4a.objects.collections.List"), _value));
 }else {
 BA.debugLineNum = 52;BA.debugLine="builder = builder.element(key)";
Debug.ShouldStop(524288);
__ref.setField ("_builder",__ref.getField(false,"_builder").runMethod(false,"element",(Object)(_key)));
 BA.debugLineNum = 53;BA.debugLine="builder = builder.text(value)";
Debug.ShouldStop(1048576);
__ref.setField ("_builder",__ref.getField(false,"_builder").runMethod(false,"text",(Object)(BA.ObjectToString(_value))));
 BA.debugLineNum = 54;BA.debugLine="builder = builder.up";
Debug.ShouldStop(2097152);
__ref.setField ("_builder",__ref.getField(false,"_builder").runMethod(false,"up"));
 }}
;
 BA.debugLineNum = 56;BA.debugLine="End Sub";
Debug.ShouldStop(8388608);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _handlelistelement(RemoteObject __ref,RemoteObject _key,RemoteObject _lst) throws Exception{
try {
		Debug.PushSubsStack("HandleListElement (map2xml) ","map2xml",1,__ref.getField(false, "ba"),__ref,58);
if (RapidSub.canDelegate("handlelistelement")) { return __ref.runUserSub(false, "map2xml","handlelistelement", __ref, _key, _lst);}
RemoteObject _value = RemoteObject.declareNull("Object");
Debug.locals.put("key", _key);
Debug.locals.put("lst", _lst);
 BA.debugLineNum = 58;BA.debugLine="Private Sub HandleListElement (key As String, lst";
Debug.ShouldStop(33554432);
 BA.debugLineNum = 59;BA.debugLine="For Each value As Object In lst";
Debug.ShouldStop(67108864);
{
final RemoteObject group1 = _lst;
final int groupLen1 = group1.runMethod(true,"getSize").<Integer>get()
;int index1 = 0;
;
for (; index1 < groupLen1;index1++){
_value = group1.runMethod(false,"Get",index1);Debug.locals.put("value", _value);
Debug.locals.put("value", _value);
 BA.debugLineNum = 60;BA.debugLine="HandleElement(key, value)";
Debug.ShouldStop(134217728);
__ref.runClassMethod (b4j.example.map2xml.class, "_handleelement",(Object)(_key),(Object)(_value));
 }
}Debug.locals.put("value", _value);
;
 BA.debugLineNum = 62;BA.debugLine="End Sub";
Debug.ShouldStop(536870912);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _handlemapelement(RemoteObject __ref,RemoteObject _m) throws Exception{
try {
		Debug.PushSubsStack("HandleMapElement (map2xml) ","map2xml",1,__ref.getField(false, "ba"),__ref,28);
if (RapidSub.canDelegate("handlemapelement")) { return __ref.runUserSub(false, "map2xml","handlemapelement", __ref, _m);}
RemoteObject _attributes = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _attr = RemoteObject.createImmutable("");
RemoteObject _k = RemoteObject.createImmutable("");
RemoteObject _value = RemoteObject.declareNull("Object");
Debug.locals.put("m", _m);
 BA.debugLineNum = 28;BA.debugLine="Private Sub HandleMapElement (m As Map)";
Debug.ShouldStop(134217728);
 BA.debugLineNum = 29;BA.debugLine="Dim attributes As Map = m.Get(\"Attributes\")";
Debug.ShouldStop(268435456);
_attributes = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");
_attributes.setObject(_m.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("Attributes")))));Debug.locals.put("attributes", _attributes);
 BA.debugLineNum = 30;BA.debugLine="If attributes.IsInitialized Then";
Debug.ShouldStop(536870912);
if (_attributes.runMethod(true,"IsInitialized").<Boolean>get().booleanValue()) { 
 BA.debugLineNum = 31;BA.debugLine="For Each attr As String In attributes.Keys";
Debug.ShouldStop(1073741824);
{
final RemoteObject group3 = _attributes.runMethod(false,"Keys");
final int groupLen3 = group3.runMethod(true,"getSize").<Integer>get()
;int index3 = 0;
;
for (; index3 < groupLen3;index3++){
_attr = BA.ObjectToString(group3.runMethod(false,"Get",index3));Debug.locals.put("attr", _attr);
Debug.locals.put("attr", _attr);
 BA.debugLineNum = 32;BA.debugLine="builder.attribute(attr, attributes.Get(attr))";
Debug.ShouldStop(-2147483648);
__ref.getField(false,"_builder").runVoidMethod ("attribute",(Object)(_attr),(Object)(BA.ObjectToString(_attributes.runMethod(false,"Get",(Object)((_attr))))));
 }
}Debug.locals.put("attr", _attr);
;
 BA.debugLineNum = 34;BA.debugLine="If m.ContainsKey(\"Text\") Then builder.text(m.Get";
Debug.ShouldStop(2);
if (_m.runMethod(true,"ContainsKey",(Object)((RemoteObject.createImmutable("Text")))).<Boolean>get().booleanValue()) { 
__ref.getField(false,"_builder").runVoidMethod ("text",(Object)(BA.ObjectToString(_m.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("Text")))))));};
 BA.debugLineNum = 35;BA.debugLine="m.Remove(\"Attributes\")";
Debug.ShouldStop(4);
_m.runVoidMethod ("Remove",(Object)((RemoteObject.createImmutable("Attributes"))));
 BA.debugLineNum = 36;BA.debugLine="m.Remove(\"Text\")";
Debug.ShouldStop(8);
_m.runVoidMethod ("Remove",(Object)((RemoteObject.createImmutable("Text"))));
 };
 BA.debugLineNum = 38;BA.debugLine="For Each k As String In m.Keys";
Debug.ShouldStop(32);
{
final RemoteObject group10 = _m.runMethod(false,"Keys");
final int groupLen10 = group10.runMethod(true,"getSize").<Integer>get()
;int index10 = 0;
;
for (; index10 < groupLen10;index10++){
_k = BA.ObjectToString(group10.runMethod(false,"Get",index10));Debug.locals.put("k", _k);
Debug.locals.put("k", _k);
 BA.debugLineNum = 39;BA.debugLine="Dim value As Object = m.Get(k)";
Debug.ShouldStop(64);
_value = _m.runMethod(false,"Get",(Object)((_k)));Debug.locals.put("value", _value);Debug.locals.put("value", _value);
 BA.debugLineNum = 40;BA.debugLine="HandleElement(k, value)";
Debug.ShouldStop(128);
__ref.runClassMethod (b4j.example.map2xml.class, "_handleelement",(Object)(_k),(Object)(_value));
 }
}Debug.locals.put("k", _k);
;
 BA.debugLineNum = 42;BA.debugLine="End Sub";
Debug.ShouldStop(512);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _initialize(RemoteObject __ref,RemoteObject _ba) throws Exception{
try {
		Debug.PushSubsStack("Initialize (map2xml) ","map2xml",1,__ref.getField(false, "ba"),__ref,6);
if (RapidSub.canDelegate("initialize")) { return __ref.runUserSub(false, "map2xml","initialize", __ref, _ba);}
__ref.runVoidMethodAndSync("innerInitializeHelper", _ba);
Debug.locals.put("ba", _ba);
 BA.debugLineNum = 6;BA.debugLine="Public Sub Initialize";
Debug.ShouldStop(32);
 BA.debugLineNum = 8;BA.debugLine="End Sub";
Debug.ShouldStop(128);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _maptoxml(RemoteObject __ref,RemoteObject _m) throws Exception{
try {
		Debug.PushSubsStack("MapToXml (map2xml) ","map2xml",1,__ref.getField(false, "ba"),__ref,10);
if (RapidSub.canDelegate("maptoxml")) { return __ref.runUserSub(false, "map2xml","maptoxml", __ref, _m);}
RemoteObject _k = RemoteObject.createImmutable("");
RemoteObject _props = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
Debug.locals.put("m", _m);
 BA.debugLineNum = 10;BA.debugLine="Public Sub MapToXml (m As Map) As String";
Debug.ShouldStop(512);
 BA.debugLineNum = 11;BA.debugLine="For Each k As String In m.Keys";
Debug.ShouldStop(1024);
{
final RemoteObject group1 = _m.runMethod(false,"Keys");
final int groupLen1 = group1.runMethod(true,"getSize").<Integer>get()
;int index1 = 0;
;
for (; index1 < groupLen1;index1++){
_k = BA.ObjectToString(group1.runMethod(false,"Get",index1));Debug.locals.put("k", _k);
Debug.locals.put("k", _k);
 BA.debugLineNum = 12;BA.debugLine="builder = builder.create(k)";
Debug.ShouldStop(2048);
__ref.setField ("_builder",__ref.getField(false,"_builder").runMethod(false,"create",(Object)(_k)));
 BA.debugLineNum = 13;BA.debugLine="HandleElement(\"\", m.Get(k))";
Debug.ShouldStop(4096);
__ref.runClassMethod (b4j.example.map2xml.class, "_handleelement",(Object)(BA.ObjectToString("")),(Object)(_m.runMethod(false,"Get",(Object)((_k)))));
 BA.debugLineNum = 14;BA.debugLine="Exit";
Debug.ShouldStop(8192);
if (true) break;
 }
}Debug.locals.put("k", _k);
;
 BA.debugLineNum = 16;BA.debugLine="builder = builder.up";
Debug.ShouldStop(32768);
__ref.setField ("_builder",__ref.getField(false,"_builder").runMethod(false,"up"));
 BA.debugLineNum = 18;BA.debugLine="Dim props As Map";
Debug.ShouldStop(131072);
_props = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");Debug.locals.put("props", _props);
 BA.debugLineNum = 19;BA.debugLine="props.Initialize";
Debug.ShouldStop(262144);
_props.runVoidMethod ("Initialize");
 BA.debugLineNum = 20;BA.debugLine="props.Put(\"{http://xml.apache.org/xslt}indent-amo";
Debug.ShouldStop(524288);
_props.runVoidMethod ("Put",(Object)(RemoteObject.createImmutable(("{http://xml.apache.org/xslt}indent-amount"))),(Object)((RemoteObject.createImmutable("4"))));
 BA.debugLineNum = 21;BA.debugLine="props.Put(\"indent\", \"yes\")";
Debug.ShouldStop(1048576);
_props.runVoidMethod ("Put",(Object)(RemoteObject.createImmutable(("indent"))),(Object)((RemoteObject.createImmutable("yes"))));
 BA.debugLineNum = 22;BA.debugLine="Return builder.asString2(props)";
Debug.ShouldStop(2097152);
if (true) return __ref.getField(false,"_builder").runMethod(true,"asString2",(Object)((_props.getObject())));
 BA.debugLineNum = 26;BA.debugLine="End Sub";
Debug.ShouldStop(33554432);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
}