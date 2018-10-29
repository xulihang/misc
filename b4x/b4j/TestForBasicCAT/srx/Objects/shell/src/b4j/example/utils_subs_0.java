package b4j.example;

import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.pc.*;

public class utils_subs_0 {


public static RemoteObject  _getelements(RemoteObject _m,RemoteObject _key) throws Exception{
try {
		Debug.PushSubsStack("GetElements (utils) ","utils",4,utils.ba,utils.mostCurrent,24);
if (RapidSub.canDelegate("getelements")) { return b4j.example.utils.remoteMe.runUserSub(false, "utils","getelements", _m, _key);}
RemoteObject _res = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _value = RemoteObject.declareNull("Object");
Debug.locals.put("m", _m);
Debug.locals.put("key", _key);
 BA.debugLineNum = 24;BA.debugLine="Sub GetElements (m As Map, key As String) As List";
Debug.ShouldStop(8388608);
 BA.debugLineNum = 25;BA.debugLine="Dim res As List";
Debug.ShouldStop(16777216);
_res = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("res", _res);
 BA.debugLineNum = 26;BA.debugLine="If m.ContainsKey(key) = False Then";
Debug.ShouldStop(33554432);
if (RemoteObject.solveBoolean("=",_m.runMethod(true,"ContainsKey",(Object)((_key))),utils.__c.getField(true,"False"))) { 
 BA.debugLineNum = 27;BA.debugLine="res.Initialize";
Debug.ShouldStop(67108864);
_res.runVoidMethod ("Initialize");
 BA.debugLineNum = 28;BA.debugLine="Return res";
Debug.ShouldStop(134217728);
if (true) return _res;
 }else {
 BA.debugLineNum = 30;BA.debugLine="Dim value As Object = m.Get(key)";
Debug.ShouldStop(536870912);
_value = _m.runMethod(false,"Get",(Object)((_key)));Debug.locals.put("value", _value);Debug.locals.put("value", _value);
 BA.debugLineNum = 31;BA.debugLine="If value Is List Then Return value";
Debug.ShouldStop(1073741824);
if (RemoteObject.solveBoolean("i",_value, RemoteObject.createImmutable("java.util.List"))) { 
if (true) return RemoteObject.declareNull("anywheresoftware.b4a.AbsObjectWrapper").runMethod(false, "ConvertToWrapper", RemoteObject.createNew("anywheresoftware.b4a.objects.collections.List"), _value);};
 BA.debugLineNum = 32;BA.debugLine="res.Initialize";
Debug.ShouldStop(-2147483648);
_res.runVoidMethod ("Initialize");
 BA.debugLineNum = 33;BA.debugLine="res.Add(value)";
Debug.ShouldStop(1);
_res.runVoidMethod ("Add",(Object)(_value));
 BA.debugLineNum = 34;BA.debugLine="Return res";
Debug.ShouldStop(2);
if (true) return _res;
 };
 BA.debugLineNum = 36;BA.debugLine="End Sub";
Debug.ShouldStop(8);
return RemoteObject.createImmutable(null);
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _getmap(RemoteObject _key,RemoteObject _parentmap) throws Exception{
try {
		Debug.PushSubsStack("getMap (utils) ","utils",4,utils.ba,utils.mostCurrent,6);
if (RapidSub.canDelegate("getmap")) { return b4j.example.utils.remoteMe.runUserSub(false, "utils","getmap", _key, _parentmap);}
Debug.locals.put("key", _key);
Debug.locals.put("parentmap", _parentmap);
 BA.debugLineNum = 6;BA.debugLine="Sub getMap(key As String,parentmap As Map) As Map";
Debug.ShouldStop(32);
 BA.debugLineNum = 7;BA.debugLine="Return parentmap.Get(key)";
Debug.ShouldStop(64);
if (true) return RemoteObject.declareNull("anywheresoftware.b4a.AbsObjectWrapper").runMethod(false, "ConvertToWrapper", RemoteObject.createNew("anywheresoftware.b4a.objects.collections.Map"), _parentmap.runMethod(false,"Get",(Object)((_key))));
 BA.debugLineNum = 8;BA.debugLine="End Sub";
Debug.ShouldStop(128);
return RemoteObject.createImmutable(null);
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _getxmlfrommap(RemoteObject _map1) throws Exception{
try {
		Debug.PushSubsStack("getXmlFromMap (utils) ","utils",4,utils.ba,utils.mostCurrent,18);
if (RapidSub.canDelegate("getxmlfrommap")) { return b4j.example.utils.remoteMe.runUserSub(false, "utils","getxmlfrommap", _map1);}
RemoteObject _mx = RemoteObject.declareNull("b4j.example.map2xml");
Debug.locals.put("map1", _map1);
 BA.debugLineNum = 18;BA.debugLine="Sub getXmlFromMap(map1 As Map) As String";
Debug.ShouldStop(131072);
 BA.debugLineNum = 19;BA.debugLine="Dim mx As Map2Xml";
Debug.ShouldStop(262144);
_mx = RemoteObject.createNew ("b4j.example.map2xml");Debug.locals.put("mx", _mx);
 BA.debugLineNum = 20;BA.debugLine="mx.Initialize";
Debug.ShouldStop(524288);
_mx.runClassMethod (b4j.example.map2xml.class, "_initialize",utils.ba);
 BA.debugLineNum = 21;BA.debugLine="Return mx.MapToXml(map1)";
Debug.ShouldStop(1048576);
if (true) return _mx.runClassMethod (b4j.example.map2xml.class, "_maptoxml",(Object)(_map1));
 BA.debugLineNum = 22;BA.debugLine="End Sub";
Debug.ShouldStop(2097152);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _getxmlmap(RemoteObject _xmlstring) throws Exception{
try {
		Debug.PushSubsStack("getXmlMap (utils) ","utils",4,utils.ba,utils.mostCurrent,10);
if (RapidSub.canDelegate("getxmlmap")) { return b4j.example.utils.remoteMe.runUserSub(false, "utils","getxmlmap", _xmlstring);}
RemoteObject _parseddata = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _xm = RemoteObject.declareNull("b4j.example.xml2map");
Debug.locals.put("xmlstring", _xmlstring);
 BA.debugLineNum = 10;BA.debugLine="Sub getXmlMap(xmlstring As String) As Map";
Debug.ShouldStop(512);
 BA.debugLineNum = 11;BA.debugLine="Dim ParsedData As Map";
Debug.ShouldStop(1024);
_parseddata = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");Debug.locals.put("ParsedData", _parseddata);
 BA.debugLineNum = 12;BA.debugLine="Dim xm As Xml2Map";
Debug.ShouldStop(2048);
_xm = RemoteObject.createNew ("b4j.example.xml2map");Debug.locals.put("xm", _xm);
 BA.debugLineNum = 13;BA.debugLine="xm.Initialize";
Debug.ShouldStop(4096);
_xm.runClassMethod (b4j.example.xml2map.class, "_initialize",utils.ba);
 BA.debugLineNum = 14;BA.debugLine="ParsedData = xm.Parse(xmlstring)";
Debug.ShouldStop(8192);
_parseddata = _xm.runClassMethod (b4j.example.xml2map.class, "_parse",(Object)(_xmlstring));Debug.locals.put("ParsedData", _parseddata);
 BA.debugLineNum = 15;BA.debugLine="Return ParsedData";
Debug.ShouldStop(16384);
if (true) return _parseddata;
 BA.debugLineNum = 16;BA.debugLine="End Sub";
Debug.ShouldStop(32768);
return RemoteObject.createImmutable(null);
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _process_globals() throws Exception{
 //BA.debugLineNum = 2;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 3;BA.debugLine="Private fx As JFX";
utils._fx = RemoteObject.createNew ("anywheresoftware.b4j.objects.JFX");
 //BA.debugLineNum = 4;BA.debugLine="End Sub";
return RemoteObject.createImmutable("");
}
}