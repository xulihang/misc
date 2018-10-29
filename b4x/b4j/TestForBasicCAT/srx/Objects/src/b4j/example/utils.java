package b4j.example;


import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.debug.*;

public class utils extends Object{
public static utils mostCurrent = new utils();

public static BA ba;
static {
		ba = new  anywheresoftware.b4a.ShellBA("b4j.example", "b4j.example.utils", null);
		ba.loadHtSubs(utils.class);
        if (ba.getClass().getName().endsWith("ShellBA")) {
			
			ba.raiseEvent2(null, true, "SHELL", false);
			ba.raiseEvent2(null, true, "CREATE", true, "b4j.example.utils", ba);
		}
	}
    public static Class<?> getObject() {
		return utils.class;
	}

 
public static anywheresoftware.b4a.keywords.Common __c = null;
public static anywheresoftware.b4j.objects.JFX _fx = null;
public static b4j.example.main _main = null;
public static b4j.example.srx _srx = null;
public static anywheresoftware.b4a.objects.collections.Map  _getxmlmap(String _xmlstring) throws Exception{
RDebugUtils.currentModule="utils";
if (Debug.shouldDelegate(ba, "getxmlmap"))
	 {return ((anywheresoftware.b4a.objects.collections.Map) Debug.delegate(ba, "getxmlmap", new Object[] {_xmlstring}));}
anywheresoftware.b4a.objects.collections.Map _parseddata = null;
b4j.example.xml2map _xm = null;
RDebugUtils.currentLine=3014656;
 //BA.debugLineNum = 3014656;BA.debugLine="Sub getXmlMap(xmlstring As String) As Map";
RDebugUtils.currentLine=3014657;
 //BA.debugLineNum = 3014657;BA.debugLine="Dim ParsedData As Map";
_parseddata = new anywheresoftware.b4a.objects.collections.Map();
RDebugUtils.currentLine=3014658;
 //BA.debugLineNum = 3014658;BA.debugLine="Dim xm As Xml2Map";
_xm = new b4j.example.xml2map();
RDebugUtils.currentLine=3014659;
 //BA.debugLineNum = 3014659;BA.debugLine="xm.Initialize";
_xm._initialize(null,ba);
RDebugUtils.currentLine=3014660;
 //BA.debugLineNum = 3014660;BA.debugLine="ParsedData = xm.Parse(xmlstring)";
_parseddata = _xm._parse(null,_xmlstring);
RDebugUtils.currentLine=3014661;
 //BA.debugLineNum = 3014661;BA.debugLine="Return ParsedData";
if (true) return _parseddata;
RDebugUtils.currentLine=3014662;
 //BA.debugLineNum = 3014662;BA.debugLine="End Sub";
return null;
}
public static anywheresoftware.b4a.objects.collections.List  _getelements(anywheresoftware.b4a.objects.collections.Map _m,String _key) throws Exception{
RDebugUtils.currentModule="utils";
if (Debug.shouldDelegate(ba, "getelements"))
	 {return ((anywheresoftware.b4a.objects.collections.List) Debug.delegate(ba, "getelements", new Object[] {_m,_key}));}
anywheresoftware.b4a.objects.collections.List _res = null;
Object _value = null;
RDebugUtils.currentLine=3145728;
 //BA.debugLineNum = 3145728;BA.debugLine="Sub GetElements (m As Map, key As String) As List";
RDebugUtils.currentLine=3145729;
 //BA.debugLineNum = 3145729;BA.debugLine="Dim res As List";
_res = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=3145730;
 //BA.debugLineNum = 3145730;BA.debugLine="If m.ContainsKey(key) = False Then";
if (_m.ContainsKey((Object)(_key))==anywheresoftware.b4a.keywords.Common.False) { 
RDebugUtils.currentLine=3145731;
 //BA.debugLineNum = 3145731;BA.debugLine="res.Initialize";
_res.Initialize();
RDebugUtils.currentLine=3145732;
 //BA.debugLineNum = 3145732;BA.debugLine="Return res";
if (true) return _res;
 }else {
RDebugUtils.currentLine=3145734;
 //BA.debugLineNum = 3145734;BA.debugLine="Dim value As Object = m.Get(key)";
_value = _m.Get((Object)(_key));
RDebugUtils.currentLine=3145735;
 //BA.debugLineNum = 3145735;BA.debugLine="If value Is List Then Return value";
if (_value instanceof java.util.List) { 
if (true) return (anywheresoftware.b4a.objects.collections.List) anywheresoftware.b4a.AbsObjectWrapper.ConvertToWrapper(new anywheresoftware.b4a.objects.collections.List(), (java.util.List)(_value));};
RDebugUtils.currentLine=3145736;
 //BA.debugLineNum = 3145736;BA.debugLine="res.Initialize";
_res.Initialize();
RDebugUtils.currentLine=3145737;
 //BA.debugLineNum = 3145737;BA.debugLine="res.Add(value)";
_res.Add(_value);
RDebugUtils.currentLine=3145738;
 //BA.debugLineNum = 3145738;BA.debugLine="Return res";
if (true) return _res;
 };
RDebugUtils.currentLine=3145740;
 //BA.debugLineNum = 3145740;BA.debugLine="End Sub";
return null;
}
public static anywheresoftware.b4a.objects.collections.Map  _getmap(String _key,anywheresoftware.b4a.objects.collections.Map _parentmap) throws Exception{
RDebugUtils.currentModule="utils";
if (Debug.shouldDelegate(ba, "getmap"))
	 {return ((anywheresoftware.b4a.objects.collections.Map) Debug.delegate(ba, "getmap", new Object[] {_key,_parentmap}));}
RDebugUtils.currentLine=3276800;
 //BA.debugLineNum = 3276800;BA.debugLine="Sub getMap(key As String,parentmap As Map) As Map";
RDebugUtils.currentLine=3276801;
 //BA.debugLineNum = 3276801;BA.debugLine="Return parentmap.Get(key)";
if (true) return (anywheresoftware.b4a.objects.collections.Map) anywheresoftware.b4a.AbsObjectWrapper.ConvertToWrapper(new anywheresoftware.b4a.objects.collections.Map(), (anywheresoftware.b4a.objects.collections.Map.MyMap)(_parentmap.Get((Object)(_key))));
RDebugUtils.currentLine=3276802;
 //BA.debugLineNum = 3276802;BA.debugLine="End Sub";
return null;
}
public static String  _getxmlfrommap(anywheresoftware.b4a.objects.collections.Map _map1) throws Exception{
RDebugUtils.currentModule="utils";
if (Debug.shouldDelegate(ba, "getxmlfrommap"))
	 {return ((String) Debug.delegate(ba, "getxmlfrommap", new Object[] {_map1}));}
b4j.example.map2xml _mx = null;
RDebugUtils.currentLine=3080192;
 //BA.debugLineNum = 3080192;BA.debugLine="Sub getXmlFromMap(map1 As Map) As String";
RDebugUtils.currentLine=3080193;
 //BA.debugLineNum = 3080193;BA.debugLine="Dim mx As Map2Xml";
_mx = new b4j.example.map2xml();
RDebugUtils.currentLine=3080194;
 //BA.debugLineNum = 3080194;BA.debugLine="mx.Initialize";
_mx._initialize(null,ba);
RDebugUtils.currentLine=3080195;
 //BA.debugLineNum = 3080195;BA.debugLine="Return mx.MapToXml(map1)";
if (true) return _mx._maptoxml(null,_map1);
RDebugUtils.currentLine=3080196;
 //BA.debugLineNum = 3080196;BA.debugLine="End Sub";
return "";
}
}