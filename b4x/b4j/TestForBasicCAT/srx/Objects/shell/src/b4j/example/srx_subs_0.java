package b4j.example;

import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.pc.*;

public class srx_subs_0 {


public static RemoteObject  _process_globals() throws Exception{
 //BA.debugLineNum = 2;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 3;BA.debugLine="Private fx As JFX";
srx._fx = RemoteObject.createNew ("anywheresoftware.b4j.objects.JFX");
 //BA.debugLineNum = 4;BA.debugLine="End Sub";
return RemoteObject.createImmutable("");
}
public static RemoteObject  _readrules(RemoteObject _filepath,RemoteObject _lang) throws Exception{
try {
		Debug.PushSubsStack("readRules (srx) ","srx",3,srx.ba,srx.mostCurrent,7);
if (RapidSub.canDelegate("readrules")) { return b4j.example.srx.remoteMe.runUserSub(false, "srx","readrules", _filepath, _lang);}
RemoteObject _srxstring = RemoteObject.createImmutable("");
RemoteObject _rules = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _breakrules = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _nonbreakrules = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _srxmap = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _srxbody = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _maprules = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _languagerulenames = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _languagemaps = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _languagemap = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _attributes = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _languagepattern = RemoteObject.createImmutable("");
RemoteObject _languagerulename = RemoteObject.createImmutable("");
RemoteObject _languagerules = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _languagerule = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _onelangrules = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _rule = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _tidyrule = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
Debug.locals.put("filepath", _filepath);
Debug.locals.put("lang", _lang);
 BA.debugLineNum = 7;BA.debugLine="Sub readRules(filepath As String,lang As String) A";
Debug.ShouldStop(64);
 BA.debugLineNum = 8;BA.debugLine="Dim srxString As String";
Debug.ShouldStop(128);
_srxstring = RemoteObject.createImmutable("");Debug.locals.put("srxString", _srxstring);
 BA.debugLineNum = 11;BA.debugLine="If filepath=\"\" Then";
Debug.ShouldStop(1024);
if (RemoteObject.solveBoolean("=",_filepath,BA.ObjectToString(""))) { 
 BA.debugLineNum = 12;BA.debugLine="srxString=File.ReadString(File.DirAssets,\"defaul";
Debug.ShouldStop(2048);
_srxstring = srx.__c.getField(false,"File").runMethod(true,"ReadString",(Object)(srx.__c.getField(false,"File").runMethod(true,"getDirAssets")),(Object)(RemoteObject.createImmutable("default_rules.srx")));Debug.locals.put("srxString", _srxstring);
 }else {
 BA.debugLineNum = 14;BA.debugLine="srxString=File.ReadString(filepath,\"\")";
Debug.ShouldStop(8192);
_srxstring = srx.__c.getField(false,"File").runMethod(true,"ReadString",(Object)(_filepath),(Object)(RemoteObject.createImmutable("")));Debug.locals.put("srxString", _srxstring);
 };
 BA.debugLineNum = 17;BA.debugLine="Log(filepath)";
Debug.ShouldStop(65536);
srx.__c.runVoidMethod ("Log",(Object)(_filepath));
 BA.debugLineNum = 18;BA.debugLine="Dim rules As Map";
Debug.ShouldStop(131072);
_rules = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");Debug.locals.put("rules", _rules);
 BA.debugLineNum = 19;BA.debugLine="rules.Initialize";
Debug.ShouldStop(262144);
_rules.runVoidMethod ("Initialize");
 BA.debugLineNum = 20;BA.debugLine="Dim breakRules As List";
Debug.ShouldStop(524288);
_breakrules = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("breakRules", _breakrules);
 BA.debugLineNum = 21;BA.debugLine="breakRules.Initialize";
Debug.ShouldStop(1048576);
_breakrules.runVoidMethod ("Initialize");
 BA.debugLineNum = 22;BA.debugLine="Dim nonbreakRules As List";
Debug.ShouldStop(2097152);
_nonbreakrules = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("nonbreakRules", _nonbreakrules);
 BA.debugLineNum = 23;BA.debugLine="nonbreakRules.Initialize";
Debug.ShouldStop(4194304);
_nonbreakrules.runVoidMethod ("Initialize");
 BA.debugLineNum = 25;BA.debugLine="Dim srxMap As Map";
Debug.ShouldStop(16777216);
_srxmap = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");Debug.locals.put("srxMap", _srxmap);
 BA.debugLineNum = 26;BA.debugLine="srxMap.Initialize";
Debug.ShouldStop(33554432);
_srxmap.runVoidMethod ("Initialize");
 BA.debugLineNum = 27;BA.debugLine="srxMap=Utils.getXmlMap(srxString).Get(\"srx\")";
Debug.ShouldStop(67108864);
_srxmap.setObject(srx._utils.runMethod(false,"_getxmlmap",(Object)(_srxstring)).runMethod(false,"Get",(Object)((RemoteObject.createImmutable("srx")))));
 BA.debugLineNum = 28;BA.debugLine="Dim srxBody As Map";
Debug.ShouldStop(134217728);
_srxbody = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");Debug.locals.put("srxBody", _srxbody);
 BA.debugLineNum = 29;BA.debugLine="srxBody.Initialize";
Debug.ShouldStop(268435456);
_srxbody.runVoidMethod ("Initialize");
 BA.debugLineNum = 30;BA.debugLine="srxBody=srxMap.Get(\"body\")";
Debug.ShouldStop(536870912);
_srxbody.setObject(_srxmap.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("body")))));
 BA.debugLineNum = 33;BA.debugLine="Dim mapRules As Map";
Debug.ShouldStop(1);
_maprules = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");Debug.locals.put("mapRules", _maprules);
 BA.debugLineNum = 34;BA.debugLine="mapRules=srxBody.Get(\"maprules\")";
Debug.ShouldStop(2);
_maprules.setObject(_srxbody.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("maprules")))));
 BA.debugLineNum = 35;BA.debugLine="Dim languageRuleNames As List";
Debug.ShouldStop(4);
_languagerulenames = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("languageRuleNames", _languagerulenames);
 BA.debugLineNum = 36;BA.debugLine="languageRuleNames.Initialize";
Debug.ShouldStop(8);
_languagerulenames.runVoidMethod ("Initialize");
 BA.debugLineNum = 37;BA.debugLine="Dim languageMaps As List";
Debug.ShouldStop(16);
_languagemaps = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("languageMaps", _languagemaps);
 BA.debugLineNum = 38;BA.debugLine="languageMaps=mapRules.Get(\"languagemap\")";
Debug.ShouldStop(32);
_languagemaps.setObject(_maprules.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("languagemap")))));
 BA.debugLineNum = 39;BA.debugLine="For Each languageMap As Map In languageMaps";
Debug.ShouldStop(64);
_languagemap = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");
{
final RemoteObject group26 = _languagemaps;
final int groupLen26 = group26.runMethod(true,"getSize").<Integer>get()
;int index26 = 0;
;
for (; index26 < groupLen26;index26++){
_languagemap.setObject(group26.runMethod(false,"Get",index26));
Debug.locals.put("languageMap", _languagemap);
 BA.debugLineNum = 41;BA.debugLine="Dim attributes As Map";
Debug.ShouldStop(256);
_attributes = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");Debug.locals.put("attributes", _attributes);
 BA.debugLineNum = 42;BA.debugLine="attributes=languageMap.Get(\"Attributes\")";
Debug.ShouldStop(512);
_attributes.setObject(_languagemap.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("Attributes")))));
 BA.debugLineNum = 43;BA.debugLine="Dim languagePattern As String";
Debug.ShouldStop(1024);
_languagepattern = RemoteObject.createImmutable("");Debug.locals.put("languagePattern", _languagepattern);
 BA.debugLineNum = 44;BA.debugLine="languagePattern=attributes.Get(\"languagepattern\"";
Debug.ShouldStop(2048);
_languagepattern = BA.ObjectToString(_attributes.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("languagepattern")))));Debug.locals.put("languagePattern", _languagepattern);
 BA.debugLineNum = 45;BA.debugLine="Dim languageRuleName As String";
Debug.ShouldStop(4096);
_languagerulename = RemoteObject.createImmutable("");Debug.locals.put("languageRuleName", _languagerulename);
 BA.debugLineNum = 46;BA.debugLine="languageRuleName=attributes.Get(\"languagerulenam";
Debug.ShouldStop(8192);
_languagerulename = BA.ObjectToString(_attributes.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("languagerulename")))));Debug.locals.put("languageRuleName", _languagerulename);
 BA.debugLineNum = 47;BA.debugLine="If Regex.IsMatch(languagePattern,lang) Then";
Debug.ShouldStop(16384);
if (srx.__c.getField(false,"Regex").runMethod(true,"IsMatch",(Object)(_languagepattern),(Object)(_lang)).<Boolean>get().booleanValue()) { 
 BA.debugLineNum = 48;BA.debugLine="languageRuleNames.Add(languageRuleName)";
Debug.ShouldStop(32768);
_languagerulenames.runVoidMethod ("Add",(Object)((_languagerulename)));
 };
 }
}Debug.locals.put("languageMap", _languagemap);
;
 BA.debugLineNum = 51;BA.debugLine="Log(languageRuleNames)";
Debug.ShouldStop(262144);
srx.__c.runVoidMethod ("Log",(Object)(BA.ObjectToString(_languagerulenames)));
 BA.debugLineNum = 53;BA.debugLine="Dim languageRules As List";
Debug.ShouldStop(1048576);
_languagerules = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("languageRules", _languagerules);
 BA.debugLineNum = 54;BA.debugLine="languageRules=Utils.GetElements(srxBody.Get(\"lang";
Debug.ShouldStop(2097152);
_languagerules = srx._utils.runMethod(false,"_getelements",RemoteObject.declareNull("anywheresoftware.b4a.AbsObjectWrapper").runMethod(false, "ConvertToWrapper", RemoteObject.createNew("anywheresoftware.b4a.objects.collections.Map"), _srxbody.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("languagerules"))))),(Object)(RemoteObject.createImmutable("languagerule")));Debug.locals.put("languageRules", _languagerules);
 BA.debugLineNum = 56;BA.debugLine="For Each languageRule As Map In languageRules";
Debug.ShouldStop(8388608);
_languagerule = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");
{
final RemoteObject group40 = _languagerules;
final int groupLen40 = group40.runMethod(true,"getSize").<Integer>get()
;int index40 = 0;
;
for (; index40 < groupLen40;index40++){
_languagerule.setObject(group40.runMethod(false,"Get",index40));
Debug.locals.put("languageRule", _languagerule);
 BA.debugLineNum = 58;BA.debugLine="Dim attributes As Map";
Debug.ShouldStop(33554432);
_attributes = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");Debug.locals.put("attributes", _attributes);
 BA.debugLineNum = 59;BA.debugLine="attributes=languageRule.Get(\"Attributes\")";
Debug.ShouldStop(67108864);
_attributes.setObject(_languagerule.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("Attributes")))));
 BA.debugLineNum = 60;BA.debugLine="Dim languageRuleName As String";
Debug.ShouldStop(134217728);
_languagerulename = RemoteObject.createImmutable("");Debug.locals.put("languageRuleName", _languagerulename);
 BA.debugLineNum = 61;BA.debugLine="languageRuleName=attributes.Get(\"languagerulenam";
Debug.ShouldStop(268435456);
_languagerulename = BA.ObjectToString(_attributes.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("languagerulename")))));Debug.locals.put("languageRuleName", _languagerulename);
 BA.debugLineNum = 62;BA.debugLine="If languageRuleNames.IndexOf(languageRuleName)<>";
Debug.ShouldStop(536870912);
if (RemoteObject.solveBoolean("!",_languagerulenames.runMethod(true,"IndexOf",(Object)((_languagerulename))),BA.numberCast(double.class, -(double) (0 + 1)))) { 
 BA.debugLineNum = 64;BA.debugLine="Dim oneLangRules As List";
Debug.ShouldStop(-2147483648);
_onelangrules = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("oneLangRules", _onelangrules);
 BA.debugLineNum = 65;BA.debugLine="oneLangRules=Utils.GetElements(languageRule,\"ru";
Debug.ShouldStop(1);
_onelangrules = srx._utils.runMethod(false,"_getelements",(Object)(_languagerule),(Object)(RemoteObject.createImmutable("rule")));Debug.locals.put("oneLangRules", _onelangrules);
 BA.debugLineNum = 67;BA.debugLine="For Each rule As Map In oneLangRules";
Debug.ShouldStop(4);
_rule = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");
{
final RemoteObject group48 = _onelangrules;
final int groupLen48 = group48.runMethod(true,"getSize").<Integer>get()
;int index48 = 0;
;
for (; index48 < groupLen48;index48++){
_rule.setObject(group48.runMethod(false,"Get",index48));
Debug.locals.put("rule", _rule);
 BA.debugLineNum = 68;BA.debugLine="Dim tidyRule As Map";
Debug.ShouldStop(8);
_tidyrule = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");Debug.locals.put("tidyRule", _tidyrule);
 BA.debugLineNum = 69;BA.debugLine="tidyRule.Initialize";
Debug.ShouldStop(16);
_tidyrule.runVoidMethod ("Initialize");
 BA.debugLineNum = 70;BA.debugLine="tidyRule.Put(\"break\",Utils.getMap(\"Attributes\"";
Debug.ShouldStop(32);
_tidyrule.runVoidMethod ("Put",(Object)(RemoteObject.createImmutable(("break"))),(Object)(srx._utils.runMethod(false,"_getmap",(Object)(BA.ObjectToString("Attributes")),(Object)(_rule)).runMethod(false,"Get",(Object)((RemoteObject.createImmutable("break"))))));
 BA.debugLineNum = 71;BA.debugLine="tidyRule.Put(\"beforebreak\",rule.Get(\"beforebre";
Debug.ShouldStop(64);
_tidyrule.runVoidMethod ("Put",(Object)(RemoteObject.createImmutable(("beforebreak"))),(Object)(_rule.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("beforebreak"))))));
 BA.debugLineNum = 72;BA.debugLine="tidyRule.Put(\"afterbreak\",rule.Get(\"afterbreak";
Debug.ShouldStop(128);
_tidyrule.runVoidMethod ("Put",(Object)(RemoteObject.createImmutable(("afterbreak"))),(Object)(_rule.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("afterbreak"))))));
 BA.debugLineNum = 74;BA.debugLine="If tidyRule.Get(\"break\")=\"yes\" Then";
Debug.ShouldStop(512);
if (RemoteObject.solveBoolean("=",_tidyrule.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("break")))),RemoteObject.createImmutable(("yes")))) { 
 BA.debugLineNum = 75;BA.debugLine="breakRules.Add(tidyRule)";
Debug.ShouldStop(1024);
_breakrules.runVoidMethod ("Add",(Object)((_tidyrule.getObject())));
 }else {
 BA.debugLineNum = 77;BA.debugLine="nonbreakRules.Add(tidyRule)";
Debug.ShouldStop(4096);
_nonbreakrules.runVoidMethod ("Add",(Object)((_tidyrule.getObject())));
 };
 }
}Debug.locals.put("rule", _rule);
;
 };
 }
}Debug.locals.put("languageRule", _languagerule);
;
 BA.debugLineNum = 85;BA.debugLine="rules.Put(\"breakRules\",breakRules)";
Debug.ShouldStop(1048576);
_rules.runVoidMethod ("Put",(Object)(RemoteObject.createImmutable(("breakRules"))),(Object)((_breakrules.getObject())));
 BA.debugLineNum = 86;BA.debugLine="rules.Put(\"nonbreakRules\",nonbreakRules)";
Debug.ShouldStop(2097152);
_rules.runVoidMethod ("Put",(Object)(RemoteObject.createImmutable(("nonbreakRules"))),(Object)((_nonbreakrules.getObject())));
 BA.debugLineNum = 87;BA.debugLine="Log(rules)";
Debug.ShouldStop(4194304);
srx.__c.runVoidMethod ("Log",(Object)(BA.ObjectToString(_rules)));
 BA.debugLineNum = 88;BA.debugLine="Return rules";
Debug.ShouldStop(8388608);
if (true) return _rules;
 BA.debugLineNum = 89;BA.debugLine="End Sub";
Debug.ShouldStop(16777216);
return RemoteObject.createImmutable(null);
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
}