package b4j.example;

import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.pc.*;

public class main_subs_0 {


public static RemoteObject  _application_error(RemoteObject _error,RemoteObject _stacktrace) throws Exception{
try {
		Debug.PushSubsStack("Application_Error (main) ","main",0,main.ba,main.mostCurrent,21);
if (RapidSub.canDelegate("application_error")) { return b4j.example.main.remoteMe.runUserSub(false, "main","application_error", _error, _stacktrace);}
Debug.locals.put("Error", _error);
Debug.locals.put("StackTrace", _stacktrace);
 BA.debugLineNum = 21;BA.debugLine="Sub Application_Error (Error As Exception, StackTr";
Debug.ShouldStop(1048576);
 BA.debugLineNum = 22;BA.debugLine="Return True";
Debug.ShouldStop(2097152);
if (true) return main.__c.getField(true,"True");
 BA.debugLineNum = 23;BA.debugLine="End Sub";
Debug.ShouldStop(4194304);
return RemoteObject.createImmutable(false);
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _appstart(RemoteObject _form1,RemoteObject _args) throws Exception{
try {
		Debug.PushSubsStack("AppStart (main) ","main",0,main.ba,main.mostCurrent,13);
if (RapidSub.canDelegate("appstart")) { return b4j.example.main.remoteMe.runUserSub(false, "main","appstart", _form1, _args);}
Debug.locals.put("Form1", _form1);
Debug.locals.put("Args", _args);
 BA.debugLineNum = 13;BA.debugLine="Sub AppStart (Form1 As Form, Args() As String)";
Debug.ShouldStop(4096);
 BA.debugLineNum = 14;BA.debugLine="MainForm = Form1";
Debug.ShouldStop(8192);
main._mainform = _form1;
 BA.debugLineNum = 15;BA.debugLine="MainForm.RootPane.LoadLayout(\"main\") 'Load the la";
Debug.ShouldStop(16384);
main._mainform.runMethod(false,"getRootPane").runMethodAndSync(false,"LoadLayout",main.ba,(Object)(RemoteObject.createImmutable("main")));
 BA.debugLineNum = 16;BA.debugLine="MainForm.Show";
Debug.ShouldStop(32768);
main._mainform.runVoidMethodAndSync ("Show");
 BA.debugLineNum = 17;BA.debugLine="TextArea1.Text=\"I love you. I am 1.5m tall. My fa";
Debug.ShouldStop(65536);
main._textarea1.runMethod(true,"setText",BA.ObjectToString("I love you. I am 1.5m tall. My favourite food is rice. Tang is not a famous doctor. Tang is a famous doctor."));
 BA.debugLineNum = 18;BA.debugLine="End Sub";
Debug.ShouldStop(131072);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _button1_mouseclicked(RemoteObject _eventdata) throws Exception{
try {
		Debug.PushSubsStack("Button1_MouseClicked (main) ","main",0,main.ba,main.mostCurrent,29);
if (RapidSub.canDelegate("button1_mouseclicked")) { return b4j.example.main.remoteMe.runUserSub(false, "main","button1_mouseclicked", _eventdata);}
Debug.locals.put("EventData", _eventdata);
 BA.debugLineNum = 29;BA.debugLine="Sub Button1_MouseClicked (EventData As MouseEvent)";
Debug.ShouldStop(268435456);
 BA.debugLineNum = 30;BA.debugLine="rules=SRX.readRules(\"\",\"en\")";
Debug.ShouldStop(536870912);
main._rules = main._srx.runMethod(false,"_readrules",(Object)(BA.ObjectToString("")),(Object)(RemoteObject.createImmutable("en")));
 BA.debugLineNum = 31;BA.debugLine="End Sub";
Debug.ShouldStop(1073741824);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _button2_mouseclicked(RemoteObject _eventdata) throws Exception{
try {
		Debug.PushSubsStack("Button2_MouseClicked (main) ","main",0,main.ba,main.mostCurrent,25);
if (RapidSub.canDelegate("button2_mouseclicked")) { return b4j.example.main.remoteMe.runUserSub(false, "main","button2_mouseclicked", _eventdata);}
Debug.locals.put("EventData", _eventdata);
 BA.debugLineNum = 25;BA.debugLine="Sub Button2_MouseClicked (EventData As MouseEvent)";
Debug.ShouldStop(16777216);
 BA.debugLineNum = 26;BA.debugLine="segment";
Debug.ShouldStop(33554432);
_segment();
 BA.debugLineNum = 27;BA.debugLine="End Sub";
Debug.ShouldStop(67108864);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _button3_mouseclicked(RemoteObject _eventdata) throws Exception{
try {
		Debug.PushSubsStack("Button3_MouseClicked (main) ","main",0,main.ba,main.mostCurrent,136);
if (RapidSub.canDelegate("button3_mouseclicked")) { return b4j.example.main.remoteMe.runUserSub(false, "main","button3_mouseclicked", _eventdata);}
Debug.locals.put("EventData", _eventdata);
 BA.debugLineNum = 136;BA.debugLine="Sub Button3_MouseClicked (EventData As MouseEvent)";
Debug.ShouldStop(128);
 BA.debugLineNum = 137;BA.debugLine="TextArea1.Text=TextArea1.Text.Replace(\"---------\"";
Debug.ShouldStop(256);
main._textarea1.runMethod(true,"setText",main._textarea1.runMethod(true,"getText").runMethod(true,"replace",(Object)(RemoteObject.concat(RemoteObject.createImmutable("---------"),main.__c.getField(true,"CRLF"))),(Object)(RemoteObject.createImmutable(""))));
 BA.debugLineNum = 138;BA.debugLine="End Sub";
Debug.ShouldStop(512);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
public static RemoteObject  _getpositions(RemoteObject _ruleslist,RemoteObject _text) throws Exception{
try {
		Debug.PushSubsStack("getPositions (main) ","main",0,main.ba,main.mostCurrent,96);
if (RapidSub.canDelegate("getpositions")) { return b4j.example.main.remoteMe.runUserSub(false, "main","getpositions", _ruleslist, _text);}
RemoteObject _breakpositions = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _rule = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.Map");
RemoteObject _beforebreak = RemoteObject.createImmutable("");
RemoteObject _afterbreak = RemoteObject.createImmutable("");
RemoteObject _bbm = RemoteObject.declareNull("anywheresoftware.b4a.keywords.Regex.MatcherWrapper");
RemoteObject _abm = RemoteObject.declareNull("anywheresoftware.b4a.keywords.Regex.MatcherWrapper");
Debug.locals.put("rulesList", _ruleslist);
Debug.locals.put("text", _text);
 BA.debugLineNum = 96;BA.debugLine="Sub getPositions(rulesList As List,text As String)";
Debug.ShouldStop(-2147483648);
 BA.debugLineNum = 97;BA.debugLine="Dim breakPositions As List";
Debug.ShouldStop(1);
_breakpositions = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("breakPositions", _breakpositions);
 BA.debugLineNum = 98;BA.debugLine="breakPositions.Initialize";
Debug.ShouldStop(2);
_breakpositions.runVoidMethod ("Initialize");
 BA.debugLineNum = 99;BA.debugLine="For Each rule As Map In rulesList";
Debug.ShouldStop(4);
_rule = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");
{
final RemoteObject group3 = _ruleslist;
final int groupLen3 = group3.runMethod(true,"getSize").<Integer>get()
;int index3 = 0;
;
for (; index3 < groupLen3;index3++){
_rule.setObject(group3.runMethod(false,"Get",index3));
Debug.locals.put("rule", _rule);
 BA.debugLineNum = 101;BA.debugLine="Dim beforeBreak,afterBreak As String";
Debug.ShouldStop(16);
_beforebreak = RemoteObject.createImmutable("");Debug.locals.put("beforeBreak", _beforebreak);
_afterbreak = RemoteObject.createImmutable("");Debug.locals.put("afterBreak", _afterbreak);
 BA.debugLineNum = 102;BA.debugLine="beforeBreak=rule.Get(\"beforebreak\")";
Debug.ShouldStop(32);
_beforebreak = BA.ObjectToString(_rule.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("beforebreak")))));Debug.locals.put("beforeBreak", _beforebreak);
 BA.debugLineNum = 103;BA.debugLine="afterBreak=rule.Get(\"afterbreak\")";
Debug.ShouldStop(64);
_afterbreak = BA.ObjectToString(_rule.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("afterbreak")))));Debug.locals.put("afterBreak", _afterbreak);
 BA.debugLineNum = 105;BA.debugLine="Dim bbm As Matcher";
Debug.ShouldStop(256);
_bbm = RemoteObject.createNew ("anywheresoftware.b4a.keywords.Regex.MatcherWrapper");Debug.locals.put("bbm", _bbm);
 BA.debugLineNum = 106;BA.debugLine="bbm=Regex.Matcher2(beforeBreak,32,text)";
Debug.ShouldStop(512);
_bbm = main.__c.getField(false,"Regex").runMethod(false,"Matcher2",(Object)(_beforebreak),(Object)(BA.numberCast(int.class, 32)),(Object)(_text));Debug.locals.put("bbm", _bbm);
 BA.debugLineNum = 108;BA.debugLine="If beforeBreak<>\"null\" Then";
Debug.ShouldStop(2048);
if (RemoteObject.solveBoolean("!",_beforebreak,BA.ObjectToString("null"))) { 
 BA.debugLineNum = 110;BA.debugLine="Do While bbm.Find";
Debug.ShouldStop(8192);
while (_bbm.runMethod(true,"Find").<Boolean>get().booleanValue()) {
 BA.debugLineNum = 111;BA.debugLine="If afterBreak=\"null\" Then";
Debug.ShouldStop(16384);
if (RemoteObject.solveBoolean("=",_afterbreak,BA.ObjectToString("null"))) { 
 BA.debugLineNum = 112;BA.debugLine="breakPositions.Add(bbm.GetEnd(0))";
Debug.ShouldStop(32768);
_breakpositions.runVoidMethod ("Add",(Object)((_bbm.runMethod(true,"GetEnd",(Object)(BA.numberCast(int.class, 0))))));
 };
 BA.debugLineNum = 115;BA.debugLine="Dim abm As Matcher";
Debug.ShouldStop(262144);
_abm = RemoteObject.createNew ("anywheresoftware.b4a.keywords.Regex.MatcherWrapper");Debug.locals.put("abm", _abm);
 BA.debugLineNum = 116;BA.debugLine="abm=Regex.Matcher2(afterBreak,32,text)";
Debug.ShouldStop(524288);
_abm = main.__c.getField(false,"Regex").runMethod(false,"Matcher2",(Object)(_afterbreak),(Object)(BA.numberCast(int.class, 32)),(Object)(_text));Debug.locals.put("abm", _abm);
 BA.debugLineNum = 117;BA.debugLine="Do While abm.Find";
Debug.ShouldStop(1048576);
while (_abm.runMethod(true,"Find").<Boolean>get().booleanValue()) {
 BA.debugLineNum = 118;BA.debugLine="If bbm.GetEnd(0)=abm.GetStart(0) Then";
Debug.ShouldStop(2097152);
if (RemoteObject.solveBoolean("=",_bbm.runMethod(true,"GetEnd",(Object)(BA.numberCast(int.class, 0))),BA.numberCast(double.class, _abm.runMethod(true,"GetStart",(Object)(BA.numberCast(int.class, 0)))))) { 
 BA.debugLineNum = 119;BA.debugLine="breakPositions.Add(abm.GetEnd(0))";
Debug.ShouldStop(4194304);
_breakpositions.runVoidMethod ("Add",(Object)((_abm.runMethod(true,"GetEnd",(Object)(BA.numberCast(int.class, 0))))));
 BA.debugLineNum = 120;BA.debugLine="Exit";
Debug.ShouldStop(8388608);
if (true) break;
 };
 }
;
 }
;
 }else 
{ BA.debugLineNum = 124;BA.debugLine="Else if afterBreak<>\"null\" Then";
Debug.ShouldStop(134217728);
if (RemoteObject.solveBoolean("!",_afterbreak,BA.ObjectToString("null"))) { 
 BA.debugLineNum = 125;BA.debugLine="Dim abm As Matcher";
Debug.ShouldStop(268435456);
_abm = RemoteObject.createNew ("anywheresoftware.b4a.keywords.Regex.MatcherWrapper");Debug.locals.put("abm", _abm);
 BA.debugLineNum = 126;BA.debugLine="abm=Regex.Matcher2(afterBreak,32,text)";
Debug.ShouldStop(536870912);
_abm = main.__c.getField(false,"Regex").runMethod(false,"Matcher2",(Object)(_afterbreak),(Object)(BA.numberCast(int.class, 32)),(Object)(_text));Debug.locals.put("abm", _abm);
 BA.debugLineNum = 127;BA.debugLine="Do While abm.Find";
Debug.ShouldStop(1073741824);
while (_abm.runMethod(true,"Find").<Boolean>get().booleanValue()) {
 BA.debugLineNum = 128;BA.debugLine="breakPositions.Add(abm.GetEnd(0))";
Debug.ShouldStop(-2147483648);
_breakpositions.runVoidMethod ("Add",(Object)((_abm.runMethod(true,"GetEnd",(Object)(BA.numberCast(int.class, 0))))));
 }
;
 }}
;
 }
}Debug.locals.put("rule", _rule);
;
 BA.debugLineNum = 133;BA.debugLine="Return breakPositions";
Debug.ShouldStop(16);
if (true) return _breakpositions;
 BA.debugLineNum = 134;BA.debugLine="End Sub";
Debug.ShouldStop(32);
return RemoteObject.createImmutable(null);
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}

private static boolean processGlobalsRun;
public static void initializeProcessGlobals() {
    
    if (main.processGlobalsRun == false) {
	    main.processGlobalsRun = true;
		try {
		        main_subs_0._process_globals();
srx_subs_0._process_globals();
utils_subs_0._process_globals();
main.myClass = BA.getDeviceClass ("b4j.example.main");
map2xml.myClass = BA.getDeviceClass ("b4j.example.map2xml");
xml2map.myClass = BA.getDeviceClass ("b4j.example.xml2map");
srx.myClass = BA.getDeviceClass ("b4j.example.srx");
utils.myClass = BA.getDeviceClass ("b4j.example.utils");
		
        } catch (Exception e) {
			throw new RuntimeException(e);
		}
    }
}public static RemoteObject  _process_globals() throws Exception{
 //BA.debugLineNum = 6;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 7;BA.debugLine="Private fx As JFX";
main._fx = RemoteObject.createNew ("anywheresoftware.b4j.objects.JFX");
 //BA.debugLineNum = 8;BA.debugLine="Private MainForm As Form";
main._mainform = RemoteObject.createNew ("anywheresoftware.b4j.objects.Form");
 //BA.debugLineNum = 9;BA.debugLine="Private TextArea1 As TextArea";
main._textarea1 = RemoteObject.createNew ("anywheresoftware.b4j.objects.TextInputControlWrapper.TextAreaWrapper");
 //BA.debugLineNum = 10;BA.debugLine="Private rules As Map";
main._rules = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.Map");
 //BA.debugLineNum = 11;BA.debugLine="End Sub";
return RemoteObject.createImmutable("");
}
public static RemoteObject  _removeduplicated(RemoteObject _source) throws Exception{
try {
		Debug.PushSubsStack("removeDuplicated (main) ","main",0,main.ba,main.mostCurrent,84);
if (RapidSub.canDelegate("removeduplicated")) { return b4j.example.main.remoteMe.runUserSub(false, "main","removeduplicated", _source);}
RemoteObject _newlist = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _index = RemoteObject.createImmutable(0);
Debug.locals.put("source", _source);
 BA.debugLineNum = 84;BA.debugLine="Sub removeDuplicated(source As List)";
Debug.ShouldStop(524288);
 BA.debugLineNum = 85;BA.debugLine="Dim newList As List";
Debug.ShouldStop(1048576);
_newlist = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("newList", _newlist);
 BA.debugLineNum = 86;BA.debugLine="newList.Initialize";
Debug.ShouldStop(2097152);
_newlist.runVoidMethod ("Initialize");
 BA.debugLineNum = 87;BA.debugLine="For Each index As Int In source";
Debug.ShouldStop(4194304);
{
final RemoteObject group3 = _source;
final int groupLen3 = group3.runMethod(true,"getSize").<Integer>get()
;int index3 = 0;
;
for (; index3 < groupLen3;index3++){
_index = BA.numberCast(int.class, group3.runMethod(false,"Get",index3));Debug.locals.put("index", _index);
Debug.locals.put("index", _index);
 BA.debugLineNum = 88;BA.debugLine="If newList.IndexOf(index)=-1 Then";
Debug.ShouldStop(8388608);
if (RemoteObject.solveBoolean("=",_newlist.runMethod(true,"IndexOf",(Object)((_index))),BA.numberCast(double.class, -(double) (0 + 1)))) { 
 BA.debugLineNum = 89;BA.debugLine="newList.Add(index)";
Debug.ShouldStop(16777216);
_newlist.runVoidMethod ("Add",(Object)((_index)));
 };
 }
}Debug.locals.put("index", _index);
;
 BA.debugLineNum = 92;BA.debugLine="source.Clear";
Debug.ShouldStop(134217728);
_source.runVoidMethod ("Clear");
 BA.debugLineNum = 93;BA.debugLine="source.AddAll(newList)";
Debug.ShouldStop(268435456);
_source.runVoidMethod ("AddAll",(Object)(_newlist));
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
public static RemoteObject  _segment() throws Exception{
try {
		Debug.PushSubsStack("segment (main) ","main",0,main.ba,main.mostCurrent,33);
if (RapidSub.canDelegate("segment")) { return b4j.example.main.remoteMe.runUserSub(false, "main","segment");}
RemoteObject _text = RemoteObject.createImmutable("");
RemoteObject _breakrules = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _nonbreakrules = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _previoustext = RemoteObject.createImmutable("");
RemoteObject _segments = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _breakpositions = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _nonbreakpositions = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _finalbreakpositions = RemoteObject.declareNull("anywheresoftware.b4a.objects.collections.List");
RemoteObject _index = RemoteObject.createImmutable(0);
RemoteObject _seg = RemoteObject.createImmutable("");
 BA.debugLineNum = 33;BA.debugLine="Sub segment";
Debug.ShouldStop(1);
 BA.debugLineNum = 34;BA.debugLine="Dim text As String";
Debug.ShouldStop(2);
_text = RemoteObject.createImmutable("");Debug.locals.put("text", _text);
 BA.debugLineNum = 35;BA.debugLine="text=TextArea1.Text";
Debug.ShouldStop(4);
_text = main._textarea1.runMethod(true,"getText");Debug.locals.put("text", _text);
 BA.debugLineNum = 36;BA.debugLine="Dim breakRules,nonbreakRules As List";
Debug.ShouldStop(8);
_breakrules = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("breakRules", _breakrules);
_nonbreakrules = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("nonbreakRules", _nonbreakrules);
 BA.debugLineNum = 37;BA.debugLine="breakRules=rules.Get(\"breakRules\")";
Debug.ShouldStop(16);
_breakrules.setObject(main._rules.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("breakRules")))));
 BA.debugLineNum = 38;BA.debugLine="nonbreakRules=rules.Get(\"nonbreakRules\")";
Debug.ShouldStop(32);
_nonbreakrules.setObject(main._rules.runMethod(false,"Get",(Object)((RemoteObject.createImmutable("nonbreakRules")))));
 BA.debugLineNum = 39;BA.debugLine="Log(breakRules)";
Debug.ShouldStop(64);
main.__c.runVoidMethod ("Log",(Object)(BA.ObjectToString(_breakrules)));
 BA.debugLineNum = 40;BA.debugLine="Log(nonbreakRules)";
Debug.ShouldStop(128);
main.__c.runVoidMethod ("Log",(Object)(BA.ObjectToString(_nonbreakrules)));
 BA.debugLineNum = 41;BA.debugLine="Dim previousText As String";
Debug.ShouldStop(256);
_previoustext = RemoteObject.createImmutable("");Debug.locals.put("previousText", _previoustext);
 BA.debugLineNum = 43;BA.debugLine="Dim segments As List";
Debug.ShouldStop(1024);
_segments = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("segments", _segments);
 BA.debugLineNum = 44;BA.debugLine="segments.Initialize";
Debug.ShouldStop(2048);
_segments.runVoidMethod ("Initialize");
 BA.debugLineNum = 47;BA.debugLine="Dim breakPositions As List";
Debug.ShouldStop(16384);
_breakpositions = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("breakPositions", _breakpositions);
 BA.debugLineNum = 48;BA.debugLine="breakPositions.Initialize";
Debug.ShouldStop(32768);
_breakpositions.runVoidMethod ("Initialize");
 BA.debugLineNum = 49;BA.debugLine="breakPositions.AddAll(getPositions(breakRules,tex";
Debug.ShouldStop(65536);
_breakpositions.runVoidMethod ("AddAll",(Object)(_getpositions(_breakrules,_text)));
 BA.debugLineNum = 50;BA.debugLine="breakPositions.Sort(True)";
Debug.ShouldStop(131072);
_breakpositions.runVoidMethod ("Sort",(Object)(main.__c.getField(true,"True")));
 BA.debugLineNum = 51;BA.debugLine="removeDuplicated(breakPositions)";
Debug.ShouldStop(262144);
_removeduplicated(_breakpositions);
 BA.debugLineNum = 53;BA.debugLine="Dim nonbreakPositions As List";
Debug.ShouldStop(1048576);
_nonbreakpositions = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("nonbreakPositions", _nonbreakpositions);
 BA.debugLineNum = 54;BA.debugLine="nonbreakPositions.Initialize";
Debug.ShouldStop(2097152);
_nonbreakpositions.runVoidMethod ("Initialize");
 BA.debugLineNum = 55;BA.debugLine="nonbreakPositions.AddAll(getPositions(nonbreakRul";
Debug.ShouldStop(4194304);
_nonbreakpositions.runVoidMethod ("AddAll",(Object)(_getpositions(_nonbreakrules,_text)));
 BA.debugLineNum = 56;BA.debugLine="nonbreakPositions.Sort(True)";
Debug.ShouldStop(8388608);
_nonbreakpositions.runVoidMethod ("Sort",(Object)(main.__c.getField(true,"True")));
 BA.debugLineNum = 57;BA.debugLine="removeDuplicated(nonbreakPositions)";
Debug.ShouldStop(16777216);
_removeduplicated(_nonbreakpositions);
 BA.debugLineNum = 59;BA.debugLine="Dim finalBreakPositions As List";
Debug.ShouldStop(67108864);
_finalbreakpositions = RemoteObject.createNew ("anywheresoftware.b4a.objects.collections.List");Debug.locals.put("finalBreakPositions", _finalbreakpositions);
 BA.debugLineNum = 60;BA.debugLine="finalBreakPositions.Initialize";
Debug.ShouldStop(134217728);
_finalbreakpositions.runVoidMethod ("Initialize");
 BA.debugLineNum = 61;BA.debugLine="For Each index As Int In breakPositions";
Debug.ShouldStop(268435456);
{
final RemoteObject group23 = _breakpositions;
final int groupLen23 = group23.runMethod(true,"getSize").<Integer>get()
;int index23 = 0;
;
for (; index23 < groupLen23;index23++){
_index = BA.numberCast(int.class, group23.runMethod(false,"Get",index23));Debug.locals.put("index", _index);
Debug.locals.put("index", _index);
 BA.debugLineNum = 62;BA.debugLine="If nonbreakPositions.IndexOf(index)=-1 Then";
Debug.ShouldStop(536870912);
if (RemoteObject.solveBoolean("=",_nonbreakpositions.runMethod(true,"IndexOf",(Object)((_index))),BA.numberCast(double.class, -(double) (0 + 1)))) { 
 BA.debugLineNum = 63;BA.debugLine="finalBreakPositions.Add(index)";
Debug.ShouldStop(1073741824);
_finalbreakpositions.runVoidMethod ("Add",(Object)((_index)));
 };
 }
}Debug.locals.put("index", _index);
;
 BA.debugLineNum = 66;BA.debugLine="Log(breakPositions)";
Debug.ShouldStop(2);
main.__c.runVoidMethod ("Log",(Object)(BA.ObjectToString(_breakpositions)));
 BA.debugLineNum = 67;BA.debugLine="Log(nonbreakPositions)";
Debug.ShouldStop(4);
main.__c.runVoidMethod ("Log",(Object)(BA.ObjectToString(_nonbreakpositions)));
 BA.debugLineNum = 68;BA.debugLine="Log(finalBreakPositions)";
Debug.ShouldStop(8);
main.__c.runVoidMethod ("Log",(Object)(BA.ObjectToString(_finalbreakpositions)));
 BA.debugLineNum = 69;BA.debugLine="For Each index As Int In finalBreakPositions";
Debug.ShouldStop(16);
{
final RemoteObject group31 = _finalbreakpositions;
final int groupLen31 = group31.runMethod(true,"getSize").<Integer>get()
;int index31 = 0;
;
for (; index31 < groupLen31;index31++){
_index = BA.numberCast(int.class, group31.runMethod(false,"Get",index31));Debug.locals.put("index", _index);
Debug.locals.put("index", _index);
 BA.debugLineNum = 70;BA.debugLine="segments.Add(text.SubString2(previousText.Length";
Debug.ShouldStop(32);
_segments.runVoidMethod ("Add",(Object)((_text.runMethod(true,"substring",(Object)(_previoustext.runMethod(true,"length")),(Object)(_index)))));
 BA.debugLineNum = 71;BA.debugLine="previousText=text.SubString2(0,index)";
Debug.ShouldStop(64);
_previoustext = _text.runMethod(true,"substring",(Object)(BA.numberCast(int.class, 0)),(Object)(_index));Debug.locals.put("previousText", _previoustext);
 }
}Debug.locals.put("index", _index);
;
 BA.debugLineNum = 73;BA.debugLine="If previousText.Length<>text.Length Then";
Debug.ShouldStop(256);
if (RemoteObject.solveBoolean("!",_previoustext.runMethod(true,"length"),BA.numberCast(double.class, _text.runMethod(true,"length")))) { 
 BA.debugLineNum = 74;BA.debugLine="segments.Add(text.SubString2(previousText.Length";
Debug.ShouldStop(512);
_segments.runVoidMethod ("Add",(Object)((_text.runMethod(true,"substring",(Object)(_previoustext.runMethod(true,"length")),(Object)(_text.runMethod(true,"length"))))));
 };
 BA.debugLineNum = 77;BA.debugLine="TextArea1.Text=\"\"";
Debug.ShouldStop(4096);
main._textarea1.runMethod(true,"setText",BA.ObjectToString(""));
 BA.debugLineNum = 78;BA.debugLine="For Each seg As String In segments";
Debug.ShouldStop(8192);
{
final RemoteObject group39 = _segments;
final int groupLen39 = group39.runMethod(true,"getSize").<Integer>get()
;int index39 = 0;
;
for (; index39 < groupLen39;index39++){
_seg = BA.ObjectToString(group39.runMethod(false,"Get",index39));Debug.locals.put("seg", _seg);
Debug.locals.put("seg", _seg);
 BA.debugLineNum = 79;BA.debugLine="TextArea1.Text=TextArea1.Text&seg&\"---------\"&CR";
Debug.ShouldStop(16384);
main._textarea1.runMethod(true,"setText",RemoteObject.concat(main._textarea1.runMethod(true,"getText"),_seg,RemoteObject.createImmutable("---------"),main.__c.getField(true,"CRLF")));
 }
}Debug.locals.put("seg", _seg);
;
 BA.debugLineNum = 81;BA.debugLine="Log(segments)";
Debug.ShouldStop(65536);
main.__c.runVoidMethod ("Log",(Object)(BA.ObjectToString(_segments)));
 BA.debugLineNum = 82;BA.debugLine="End Sub";
Debug.ShouldStop(131072);
return RemoteObject.createImmutable("");
}
catch (Exception e) {
			throw Debug.ErrorCaught(e);
		} 
finally {
			Debug.PopSubsStack();
		}}
}