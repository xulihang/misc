package b4j.example;


import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.debug.*;

public class srx extends Object{
public static srx mostCurrent = new srx();

public static BA ba;
static {
		ba = new  anywheresoftware.b4a.ShellBA("b4j.example", "b4j.example.srx", null);
		ba.loadHtSubs(srx.class);
        if (ba.getClass().getName().endsWith("ShellBA")) {
			
			ba.raiseEvent2(null, true, "SHELL", false);
			ba.raiseEvent2(null, true, "CREATE", true, "b4j.example.srx", ba);
		}
	}
    public static Class<?> getObject() {
		return srx.class;
	}

 
public static anywheresoftware.b4a.keywords.Common __c = null;
public static anywheresoftware.b4j.objects.JFX _fx = null;
public static b4j.example.main _main = null;
public static b4j.example.utils _utils = null;
public static anywheresoftware.b4a.objects.collections.Map  _readrules(String _filepath,String _lang) throws Exception{
RDebugUtils.currentModule="srx";
if (Debug.shouldDelegate(ba, "readrules"))
	 {return ((anywheresoftware.b4a.objects.collections.Map) Debug.delegate(ba, "readrules", new Object[] {_filepath,_lang}));}
String _srxstring = "";
anywheresoftware.b4a.objects.collections.Map _rules = null;
anywheresoftware.b4a.objects.collections.List _breakrules = null;
anywheresoftware.b4a.objects.collections.List _nonbreakrules = null;
anywheresoftware.b4a.objects.collections.Map _srxmap = null;
anywheresoftware.b4a.objects.collections.Map _srxbody = null;
anywheresoftware.b4a.objects.collections.Map _maprules = null;
anywheresoftware.b4a.objects.collections.List _languagerulenames = null;
anywheresoftware.b4a.objects.collections.List _languagemaps = null;
anywheresoftware.b4a.objects.collections.Map _languagemap = null;
anywheresoftware.b4a.objects.collections.Map _attributes = null;
String _languagepattern = "";
String _languagerulename = "";
anywheresoftware.b4a.objects.collections.List _languagerules = null;
anywheresoftware.b4a.objects.collections.Map _languagerule = null;
anywheresoftware.b4a.objects.collections.List _onelangrules = null;
anywheresoftware.b4a.objects.collections.Map _rule = null;
anywheresoftware.b4a.objects.collections.Map _tidyrule = null;
RDebugUtils.currentLine=2162688;
 //BA.debugLineNum = 2162688;BA.debugLine="Sub readRules(filepath As String,lang As String) A";
RDebugUtils.currentLine=2162689;
 //BA.debugLineNum = 2162689;BA.debugLine="Dim srxString As String";
_srxstring = "";
RDebugUtils.currentLine=2162692;
 //BA.debugLineNum = 2162692;BA.debugLine="If filepath=\"\" Then";
if ((_filepath).equals("")) { 
RDebugUtils.currentLine=2162693;
 //BA.debugLineNum = 2162693;BA.debugLine="srxString=File.ReadString(File.DirAssets,\"defaul";
_srxstring = anywheresoftware.b4a.keywords.Common.File.ReadString(anywheresoftware.b4a.keywords.Common.File.getDirAssets(),"default_rules.srx");
 }else {
RDebugUtils.currentLine=2162695;
 //BA.debugLineNum = 2162695;BA.debugLine="srxString=File.ReadString(filepath,\"\")";
_srxstring = anywheresoftware.b4a.keywords.Common.File.ReadString(_filepath,"");
 };
RDebugUtils.currentLine=2162698;
 //BA.debugLineNum = 2162698;BA.debugLine="Log(filepath)";
anywheresoftware.b4a.keywords.Common.Log(_filepath);
RDebugUtils.currentLine=2162699;
 //BA.debugLineNum = 2162699;BA.debugLine="Dim rules As Map";
_rules = new anywheresoftware.b4a.objects.collections.Map();
RDebugUtils.currentLine=2162700;
 //BA.debugLineNum = 2162700;BA.debugLine="rules.Initialize";
_rules.Initialize();
RDebugUtils.currentLine=2162701;
 //BA.debugLineNum = 2162701;BA.debugLine="Dim breakRules As List";
_breakrules = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=2162702;
 //BA.debugLineNum = 2162702;BA.debugLine="breakRules.Initialize";
_breakrules.Initialize();
RDebugUtils.currentLine=2162703;
 //BA.debugLineNum = 2162703;BA.debugLine="Dim nonbreakRules As List";
_nonbreakrules = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=2162704;
 //BA.debugLineNum = 2162704;BA.debugLine="nonbreakRules.Initialize";
_nonbreakrules.Initialize();
RDebugUtils.currentLine=2162706;
 //BA.debugLineNum = 2162706;BA.debugLine="Dim srxMap As Map";
_srxmap = new anywheresoftware.b4a.objects.collections.Map();
RDebugUtils.currentLine=2162707;
 //BA.debugLineNum = 2162707;BA.debugLine="srxMap.Initialize";
_srxmap.Initialize();
RDebugUtils.currentLine=2162708;
 //BA.debugLineNum = 2162708;BA.debugLine="srxMap=Utils.getXmlMap(srxString).Get(\"srx\")";
_srxmap.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(_utils._getxmlmap(_srxstring).Get((Object)("srx"))));
RDebugUtils.currentLine=2162709;
 //BA.debugLineNum = 2162709;BA.debugLine="Dim srxBody As Map";
_srxbody = new anywheresoftware.b4a.objects.collections.Map();
RDebugUtils.currentLine=2162710;
 //BA.debugLineNum = 2162710;BA.debugLine="srxBody.Initialize";
_srxbody.Initialize();
RDebugUtils.currentLine=2162711;
 //BA.debugLineNum = 2162711;BA.debugLine="srxBody=srxMap.Get(\"body\")";
_srxbody.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(_srxmap.Get((Object)("body"))));
RDebugUtils.currentLine=2162714;
 //BA.debugLineNum = 2162714;BA.debugLine="Dim mapRules As Map";
_maprules = new anywheresoftware.b4a.objects.collections.Map();
RDebugUtils.currentLine=2162715;
 //BA.debugLineNum = 2162715;BA.debugLine="mapRules=srxBody.Get(\"maprules\")";
_maprules.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(_srxbody.Get((Object)("maprules"))));
RDebugUtils.currentLine=2162716;
 //BA.debugLineNum = 2162716;BA.debugLine="Dim languageRuleNames As List";
_languagerulenames = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=2162717;
 //BA.debugLineNum = 2162717;BA.debugLine="languageRuleNames.Initialize";
_languagerulenames.Initialize();
RDebugUtils.currentLine=2162718;
 //BA.debugLineNum = 2162718;BA.debugLine="Dim languageMaps As List";
_languagemaps = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=2162719;
 //BA.debugLineNum = 2162719;BA.debugLine="languageMaps=mapRules.Get(\"languagemap\")";
_languagemaps.setObject((java.util.List)(_maprules.Get((Object)("languagemap"))));
RDebugUtils.currentLine=2162720;
 //BA.debugLineNum = 2162720;BA.debugLine="For Each languageMap As Map In languageMaps";
_languagemap = new anywheresoftware.b4a.objects.collections.Map();
{
final anywheresoftware.b4a.BA.IterableList group26 = _languagemaps;
final int groupLen26 = group26.getSize()
;int index26 = 0;
;
for (; index26 < groupLen26;index26++){
_languagemap.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(group26.Get(index26)));
RDebugUtils.currentLine=2162722;
 //BA.debugLineNum = 2162722;BA.debugLine="Dim attributes As Map";
_attributes = new anywheresoftware.b4a.objects.collections.Map();
RDebugUtils.currentLine=2162723;
 //BA.debugLineNum = 2162723;BA.debugLine="attributes=languageMap.Get(\"Attributes\")";
_attributes.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(_languagemap.Get((Object)("Attributes"))));
RDebugUtils.currentLine=2162724;
 //BA.debugLineNum = 2162724;BA.debugLine="Dim languagePattern As String";
_languagepattern = "";
RDebugUtils.currentLine=2162725;
 //BA.debugLineNum = 2162725;BA.debugLine="languagePattern=attributes.Get(\"languagepattern\"";
_languagepattern = BA.ObjectToString(_attributes.Get((Object)("languagepattern")));
RDebugUtils.currentLine=2162726;
 //BA.debugLineNum = 2162726;BA.debugLine="Dim languageRuleName As String";
_languagerulename = "";
RDebugUtils.currentLine=2162727;
 //BA.debugLineNum = 2162727;BA.debugLine="languageRuleName=attributes.Get(\"languagerulenam";
_languagerulename = BA.ObjectToString(_attributes.Get((Object)("languagerulename")));
RDebugUtils.currentLine=2162728;
 //BA.debugLineNum = 2162728;BA.debugLine="If Regex.IsMatch(languagePattern,lang) Then";
if (anywheresoftware.b4a.keywords.Common.Regex.IsMatch(_languagepattern,_lang)) { 
RDebugUtils.currentLine=2162729;
 //BA.debugLineNum = 2162729;BA.debugLine="languageRuleNames.Add(languageRuleName)";
_languagerulenames.Add((Object)(_languagerulename));
 };
 }
};
RDebugUtils.currentLine=2162732;
 //BA.debugLineNum = 2162732;BA.debugLine="Log(languageRuleNames)";
anywheresoftware.b4a.keywords.Common.Log(BA.ObjectToString(_languagerulenames));
RDebugUtils.currentLine=2162734;
 //BA.debugLineNum = 2162734;BA.debugLine="Dim languageRules As List";
_languagerules = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=2162735;
 //BA.debugLineNum = 2162735;BA.debugLine="languageRules=Utils.GetElements(srxBody.Get(\"lang";
_languagerules = _utils._getelements((anywheresoftware.b4a.objects.collections.Map) anywheresoftware.b4a.AbsObjectWrapper.ConvertToWrapper(new anywheresoftware.b4a.objects.collections.Map(), (anywheresoftware.b4a.objects.collections.Map.MyMap)(_srxbody.Get((Object)("languagerules")))),"languagerule");
RDebugUtils.currentLine=2162737;
 //BA.debugLineNum = 2162737;BA.debugLine="For Each languageRule As Map In languageRules";
_languagerule = new anywheresoftware.b4a.objects.collections.Map();
{
final anywheresoftware.b4a.BA.IterableList group40 = _languagerules;
final int groupLen40 = group40.getSize()
;int index40 = 0;
;
for (; index40 < groupLen40;index40++){
_languagerule.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(group40.Get(index40)));
RDebugUtils.currentLine=2162739;
 //BA.debugLineNum = 2162739;BA.debugLine="Dim attributes As Map";
_attributes = new anywheresoftware.b4a.objects.collections.Map();
RDebugUtils.currentLine=2162740;
 //BA.debugLineNum = 2162740;BA.debugLine="attributes=languageRule.Get(\"Attributes\")";
_attributes.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(_languagerule.Get((Object)("Attributes"))));
RDebugUtils.currentLine=2162741;
 //BA.debugLineNum = 2162741;BA.debugLine="Dim languageRuleName As String";
_languagerulename = "";
RDebugUtils.currentLine=2162742;
 //BA.debugLineNum = 2162742;BA.debugLine="languageRuleName=attributes.Get(\"languagerulenam";
_languagerulename = BA.ObjectToString(_attributes.Get((Object)("languagerulename")));
RDebugUtils.currentLine=2162743;
 //BA.debugLineNum = 2162743;BA.debugLine="If languageRuleNames.IndexOf(languageRuleName)<>";
if (_languagerulenames.IndexOf((Object)(_languagerulename))!=-1) { 
RDebugUtils.currentLine=2162745;
 //BA.debugLineNum = 2162745;BA.debugLine="Dim oneLangRules As List";
_onelangrules = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=2162746;
 //BA.debugLineNum = 2162746;BA.debugLine="oneLangRules=Utils.GetElements(languageRule,\"ru";
_onelangrules = _utils._getelements(_languagerule,"rule");
RDebugUtils.currentLine=2162748;
 //BA.debugLineNum = 2162748;BA.debugLine="For Each rule As Map In oneLangRules";
_rule = new anywheresoftware.b4a.objects.collections.Map();
{
final anywheresoftware.b4a.BA.IterableList group48 = _onelangrules;
final int groupLen48 = group48.getSize()
;int index48 = 0;
;
for (; index48 < groupLen48;index48++){
_rule.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(group48.Get(index48)));
RDebugUtils.currentLine=2162749;
 //BA.debugLineNum = 2162749;BA.debugLine="Dim tidyRule As Map";
_tidyrule = new anywheresoftware.b4a.objects.collections.Map();
RDebugUtils.currentLine=2162750;
 //BA.debugLineNum = 2162750;BA.debugLine="tidyRule.Initialize";
_tidyrule.Initialize();
RDebugUtils.currentLine=2162751;
 //BA.debugLineNum = 2162751;BA.debugLine="tidyRule.Put(\"break\",Utils.getMap(\"Attributes\"";
_tidyrule.Put((Object)("break"),_utils._getmap("Attributes",_rule).Get((Object)("break")));
RDebugUtils.currentLine=2162752;
 //BA.debugLineNum = 2162752;BA.debugLine="tidyRule.Put(\"beforebreak\",rule.Get(\"beforebre";
_tidyrule.Put((Object)("beforebreak"),_rule.Get((Object)("beforebreak")));
RDebugUtils.currentLine=2162753;
 //BA.debugLineNum = 2162753;BA.debugLine="tidyRule.Put(\"afterbreak\",rule.Get(\"afterbreak";
_tidyrule.Put((Object)("afterbreak"),_rule.Get((Object)("afterbreak")));
RDebugUtils.currentLine=2162755;
 //BA.debugLineNum = 2162755;BA.debugLine="If tidyRule.Get(\"break\")=\"yes\" Then";
if ((_tidyrule.Get((Object)("break"))).equals((Object)("yes"))) { 
RDebugUtils.currentLine=2162756;
 //BA.debugLineNum = 2162756;BA.debugLine="breakRules.Add(tidyRule)";
_breakrules.Add((Object)(_tidyrule.getObject()));
 }else {
RDebugUtils.currentLine=2162758;
 //BA.debugLineNum = 2162758;BA.debugLine="nonbreakRules.Add(tidyRule)";
_nonbreakrules.Add((Object)(_tidyrule.getObject()));
 };
 }
};
 };
 }
};
RDebugUtils.currentLine=2162766;
 //BA.debugLineNum = 2162766;BA.debugLine="rules.Put(\"breakRules\",breakRules)";
_rules.Put((Object)("breakRules"),(Object)(_breakrules.getObject()));
RDebugUtils.currentLine=2162767;
 //BA.debugLineNum = 2162767;BA.debugLine="rules.Put(\"nonbreakRules\",nonbreakRules)";
_rules.Put((Object)("nonbreakRules"),(Object)(_nonbreakrules.getObject()));
RDebugUtils.currentLine=2162768;
 //BA.debugLineNum = 2162768;BA.debugLine="Log(rules)";
anywheresoftware.b4a.keywords.Common.Log(BA.ObjectToString(_rules));
RDebugUtils.currentLine=2162769;
 //BA.debugLineNum = 2162769;BA.debugLine="Return rules";
if (true) return _rules;
RDebugUtils.currentLine=2162770;
 //BA.debugLineNum = 2162770;BA.debugLine="End Sub";
return null;
}
}