package b4j.example;


import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.B4AClass;
import anywheresoftware.b4a.debug.*;

public class map2xml extends B4AClass.ImplB4AClass implements BA.SubDelegator{
    public static java.util.HashMap<String, java.lang.reflect.Method> htSubs;
    private void innerInitialize(BA _ba) throws Exception {
        if (ba == null) {
            ba = new  anywheresoftware.b4a.ShellBA("b4j.example", "b4j.example.map2xml", this);
            if (htSubs == null) {
                ba.loadHtSubs(this.getClass());
                htSubs = ba.htSubs;
            }
            ba.htSubs = htSubs;
             
        }
        if (BA.isShellModeRuntimeCheck(ba))
                this.getClass().getMethod("_class_globals", b4j.example.map2xml.class).invoke(this, new Object[] {null});
        else
            ba.raiseEvent2(null, true, "class_globals", false);
    }

 
    public void  innerInitializeHelper(anywheresoftware.b4a.BA _ba) throws Exception{
        innerInitialize(_ba);
    }
    public Object callSub(String sub, Object sender, Object[] args) throws Exception {
        return BA.SubDelegator.SubNotFound;
    }
public anywheresoftware.b4a.keywords.Common __c = null;
public com.jamesmurty.utils.XMLBuilder _builder = null;
public b4j.example.main _main = null;
public b4j.example.srx _srx = null;
public b4j.example.utils _utils = null;
public String  _class_globals(b4j.example.map2xml __ref) throws Exception{
__ref = this;
RDebugUtils.currentModule="map2xml";
RDebugUtils.currentLine=196608;
 //BA.debugLineNum = 196608;BA.debugLine="Sub Class_Globals";
RDebugUtils.currentLine=196609;
 //BA.debugLineNum = 196609;BA.debugLine="Private builder As XMLBuilder";
_builder = new com.jamesmurty.utils.XMLBuilder();
RDebugUtils.currentLine=196610;
 //BA.debugLineNum = 196610;BA.debugLine="End Sub";
return "";
}
public String  _handleelement(b4j.example.map2xml __ref,String _key,Object _value) throws Exception{
__ref = this;
RDebugUtils.currentModule="map2xml";
if (Debug.shouldDelegate(ba, "handleelement"))
	 {return ((String) Debug.delegate(ba, "handleelement", new Object[] {_key,_value}));}
RDebugUtils.currentLine=458752;
 //BA.debugLineNum = 458752;BA.debugLine="Private Sub HandleElement (key As String, value As";
RDebugUtils.currentLine=458753;
 //BA.debugLineNum = 458753;BA.debugLine="If value Is Map Then";
if (_value instanceof anywheresoftware.b4a.objects.collections.Map.MyMap) { 
RDebugUtils.currentLine=458754;
 //BA.debugLineNum = 458754;BA.debugLine="If key <> \"\" Then builder = builder.element(key)";
if ((_key).equals("") == false) { 
__ref._builder = __ref._builder.element(_key);};
RDebugUtils.currentLine=458755;
 //BA.debugLineNum = 458755;BA.debugLine="HandleMapElement(value)";
__ref._handlemapelement(null,(anywheresoftware.b4a.objects.collections.Map) anywheresoftware.b4a.AbsObjectWrapper.ConvertToWrapper(new anywheresoftware.b4a.objects.collections.Map(), (anywheresoftware.b4a.objects.collections.Map.MyMap)(_value)));
RDebugUtils.currentLine=458756;
 //BA.debugLineNum = 458756;BA.debugLine="If key <> \"\" Then builder = builder.up";
if ((_key).equals("") == false) { 
__ref._builder = __ref._builder.up();};
 }else 
{RDebugUtils.currentLine=458757;
 //BA.debugLineNum = 458757;BA.debugLine="Else if value Is List Then";
if (_value instanceof java.util.List) { 
RDebugUtils.currentLine=458758;
 //BA.debugLineNum = 458758;BA.debugLine="HandleListElement (key, value)";
__ref._handlelistelement(null,_key,(anywheresoftware.b4a.objects.collections.List) anywheresoftware.b4a.AbsObjectWrapper.ConvertToWrapper(new anywheresoftware.b4a.objects.collections.List(), (java.util.List)(_value)));
 }else {
RDebugUtils.currentLine=458760;
 //BA.debugLineNum = 458760;BA.debugLine="builder = builder.element(key)";
__ref._builder = __ref._builder.element(_key);
RDebugUtils.currentLine=458761;
 //BA.debugLineNum = 458761;BA.debugLine="builder = builder.text(value)";
__ref._builder = __ref._builder.text(BA.ObjectToString(_value));
RDebugUtils.currentLine=458762;
 //BA.debugLineNum = 458762;BA.debugLine="builder = builder.up";
__ref._builder = __ref._builder.up();
 }}
;
RDebugUtils.currentLine=458764;
 //BA.debugLineNum = 458764;BA.debugLine="End Sub";
return "";
}
public String  _handlemapelement(b4j.example.map2xml __ref,anywheresoftware.b4a.objects.collections.Map _m) throws Exception{
__ref = this;
RDebugUtils.currentModule="map2xml";
if (Debug.shouldDelegate(ba, "handlemapelement"))
	 {return ((String) Debug.delegate(ba, "handlemapelement", new Object[] {_m}));}
anywheresoftware.b4a.objects.collections.Map _attributes = null;
String _attr = "";
String _k = "";
Object _value = null;
RDebugUtils.currentLine=393216;
 //BA.debugLineNum = 393216;BA.debugLine="Private Sub HandleMapElement (m As Map)";
RDebugUtils.currentLine=393217;
 //BA.debugLineNum = 393217;BA.debugLine="Dim attributes As Map = m.Get(\"Attributes\")";
_attributes = new anywheresoftware.b4a.objects.collections.Map();
_attributes.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(_m.Get((Object)("Attributes"))));
RDebugUtils.currentLine=393218;
 //BA.debugLineNum = 393218;BA.debugLine="If attributes.IsInitialized Then";
if (_attributes.IsInitialized()) { 
RDebugUtils.currentLine=393219;
 //BA.debugLineNum = 393219;BA.debugLine="For Each attr As String In attributes.Keys";
{
final anywheresoftware.b4a.BA.IterableList group3 = _attributes.Keys();
final int groupLen3 = group3.getSize()
;int index3 = 0;
;
for (; index3 < groupLen3;index3++){
_attr = BA.ObjectToString(group3.Get(index3));
RDebugUtils.currentLine=393220;
 //BA.debugLineNum = 393220;BA.debugLine="builder.attribute(attr, attributes.Get(attr))";
__ref._builder.attribute(_attr,BA.ObjectToString(_attributes.Get((Object)(_attr))));
 }
};
RDebugUtils.currentLine=393222;
 //BA.debugLineNum = 393222;BA.debugLine="If m.ContainsKey(\"Text\") Then builder.text(m.Get";
if (_m.ContainsKey((Object)("Text"))) { 
__ref._builder.text(BA.ObjectToString(_m.Get((Object)("Text"))));};
RDebugUtils.currentLine=393223;
 //BA.debugLineNum = 393223;BA.debugLine="m.Remove(\"Attributes\")";
_m.Remove((Object)("Attributes"));
RDebugUtils.currentLine=393224;
 //BA.debugLineNum = 393224;BA.debugLine="m.Remove(\"Text\")";
_m.Remove((Object)("Text"));
 };
RDebugUtils.currentLine=393226;
 //BA.debugLineNum = 393226;BA.debugLine="For Each k As String In m.Keys";
{
final anywheresoftware.b4a.BA.IterableList group10 = _m.Keys();
final int groupLen10 = group10.getSize()
;int index10 = 0;
;
for (; index10 < groupLen10;index10++){
_k = BA.ObjectToString(group10.Get(index10));
RDebugUtils.currentLine=393227;
 //BA.debugLineNum = 393227;BA.debugLine="Dim value As Object = m.Get(k)";
_value = _m.Get((Object)(_k));
RDebugUtils.currentLine=393228;
 //BA.debugLineNum = 393228;BA.debugLine="HandleElement(k, value)";
__ref._handleelement(null,_k,_value);
 }
};
RDebugUtils.currentLine=393230;
 //BA.debugLineNum = 393230;BA.debugLine="End Sub";
return "";
}
public String  _handlelistelement(b4j.example.map2xml __ref,String _key,anywheresoftware.b4a.objects.collections.List _lst) throws Exception{
__ref = this;
RDebugUtils.currentModule="map2xml";
if (Debug.shouldDelegate(ba, "handlelistelement"))
	 {return ((String) Debug.delegate(ba, "handlelistelement", new Object[] {_key,_lst}));}
Object _value = null;
RDebugUtils.currentLine=524288;
 //BA.debugLineNum = 524288;BA.debugLine="Private Sub HandleListElement (key As String, lst";
RDebugUtils.currentLine=524289;
 //BA.debugLineNum = 524289;BA.debugLine="For Each value As Object In lst";
{
final anywheresoftware.b4a.BA.IterableList group1 = _lst;
final int groupLen1 = group1.getSize()
;int index1 = 0;
;
for (; index1 < groupLen1;index1++){
_value = group1.Get(index1);
RDebugUtils.currentLine=524290;
 //BA.debugLineNum = 524290;BA.debugLine="HandleElement(key, value)";
__ref._handleelement(null,_key,_value);
 }
};
RDebugUtils.currentLine=524292;
 //BA.debugLineNum = 524292;BA.debugLine="End Sub";
return "";
}
public String  _initialize(b4j.example.map2xml __ref,anywheresoftware.b4a.BA _ba) throws Exception{
__ref = this;
innerInitialize(_ba);
RDebugUtils.currentModule="map2xml";
if (Debug.shouldDelegate(ba, "initialize"))
	 {return ((String) Debug.delegate(ba, "initialize", new Object[] {_ba}));}
RDebugUtils.currentLine=262144;
 //BA.debugLineNum = 262144;BA.debugLine="Public Sub Initialize";
RDebugUtils.currentLine=262146;
 //BA.debugLineNum = 262146;BA.debugLine="End Sub";
return "";
}
public String  _maptoxml(b4j.example.map2xml __ref,anywheresoftware.b4a.objects.collections.Map _m) throws Exception{
__ref = this;
RDebugUtils.currentModule="map2xml";
if (Debug.shouldDelegate(ba, "maptoxml"))
	 {return ((String) Debug.delegate(ba, "maptoxml", new Object[] {_m}));}
String _k = "";
anywheresoftware.b4a.objects.collections.Map _props = null;
RDebugUtils.currentLine=327680;
 //BA.debugLineNum = 327680;BA.debugLine="Public Sub MapToXml (m As Map) As String";
RDebugUtils.currentLine=327681;
 //BA.debugLineNum = 327681;BA.debugLine="For Each k As String In m.Keys";
{
final anywheresoftware.b4a.BA.IterableList group1 = _m.Keys();
final int groupLen1 = group1.getSize()
;int index1 = 0;
;
for (; index1 < groupLen1;index1++){
_k = BA.ObjectToString(group1.Get(index1));
RDebugUtils.currentLine=327682;
 //BA.debugLineNum = 327682;BA.debugLine="builder = builder.create(k)";
__ref._builder = __ref._builder.create(_k);
RDebugUtils.currentLine=327683;
 //BA.debugLineNum = 327683;BA.debugLine="HandleElement(\"\", m.Get(k))";
__ref._handleelement(null,"",_m.Get((Object)(_k)));
RDebugUtils.currentLine=327684;
 //BA.debugLineNum = 327684;BA.debugLine="Exit";
if (true) break;
 }
};
RDebugUtils.currentLine=327686;
 //BA.debugLineNum = 327686;BA.debugLine="builder = builder.up";
__ref._builder = __ref._builder.up();
RDebugUtils.currentLine=327688;
 //BA.debugLineNum = 327688;BA.debugLine="Dim props As Map";
_props = new anywheresoftware.b4a.objects.collections.Map();
RDebugUtils.currentLine=327689;
 //BA.debugLineNum = 327689;BA.debugLine="props.Initialize";
_props.Initialize();
RDebugUtils.currentLine=327690;
 //BA.debugLineNum = 327690;BA.debugLine="props.Put(\"{http://xml.apache.org/xslt}indent-amo";
_props.Put((Object)("{http://xml.apache.org/xslt}indent-amount"),(Object)("4"));
RDebugUtils.currentLine=327691;
 //BA.debugLineNum = 327691;BA.debugLine="props.Put(\"indent\", \"yes\")";
_props.Put((Object)("indent"),(Object)("yes"));
RDebugUtils.currentLine=327692;
 //BA.debugLineNum = 327692;BA.debugLine="Return builder.asString2(props)";
if (true) return __ref._builder.asString2((java.util.Map)(_props.getObject()));
RDebugUtils.currentLine=327696;
 //BA.debugLineNum = 327696;BA.debugLine="End Sub";
return "";
}
}