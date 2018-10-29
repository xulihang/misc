package b4j.example;


import anywheresoftware.b4a.BA;
import anywheresoftware.b4a.debug.*;

public class main extends javafx.application.Application{
public static main mostCurrent = new main();

public static BA ba;
static {
		ba = new  anywheresoftware.b4a.ShellBA("b4j.example", "b4j.example.main", null);
		ba.loadHtSubs(main.class);
        if (ba.getClass().getName().endsWith("ShellBA")) {
			anywheresoftware.b4a.ShellBA.delegateBA = new anywheresoftware.b4j.objects.FxBA("b4j.example", null, null);
			ba.raiseEvent2(null, true, "SHELL", false);
			ba.raiseEvent2(null, true, "CREATE", true, "b4j.example.main", ba);
		}
	}
    public static Class<?> getObject() {
		return main.class;
	}

 
    public static void main(String[] args) {
    	launch(args);
    }
    public void start (javafx.stage.Stage stage) {
        try {
            if (!false)
                System.setProperty("prism.lcdtext", "false");
            anywheresoftware.b4j.objects.FxBA.application = this;
		    anywheresoftware.b4a.keywords.Common.setDensity(javafx.stage.Screen.getPrimary().getDpi());
            anywheresoftware.b4a.keywords.Common.LogDebug("Program started.");
            initializeProcessGlobals();
            anywheresoftware.b4j.objects.Form frm = new anywheresoftware.b4j.objects.Form();
            frm.initWithStage(ba, stage, 600, 600);
            ba.raiseEvent(null, "appstart", frm, (String[])getParameters().getRaw().toArray(new String[0]));
        } catch (Throwable t) {
            BA.printException(t, true);
            System.exit(1);
        }
    }


private static boolean processGlobalsRun;
public static void initializeProcessGlobals() {
    
    if (main.processGlobalsRun == false) {
	    main.processGlobalsRun = true;
		try {
		        		
        } catch (Exception e) {
			throw new RuntimeException(e);
		}
    }
}public static anywheresoftware.b4a.keywords.Common __c = null;
public static anywheresoftware.b4j.objects.JFX _fx = null;
public static anywheresoftware.b4j.objects.Form _mainform = null;
public static anywheresoftware.b4j.objects.TextInputControlWrapper.TextAreaWrapper _textarea1 = null;
public static anywheresoftware.b4a.objects.collections.Map _rules = null;
public static b4j.example.srx _srx = null;
public static b4j.example.utils _utils = null;
public static boolean  _application_error(anywheresoftware.b4a.objects.B4AException _error,String _stacktrace) throws Exception{
RDebugUtils.currentModule="main";
if (Debug.shouldDelegate(ba, "application_error"))
	 {return ((Boolean) Debug.delegate(ba, "application_error", new Object[] {_error,_stacktrace}));}
RDebugUtils.currentLine=131072;
 //BA.debugLineNum = 131072;BA.debugLine="Sub Application_Error (Error As Exception, StackTr";
RDebugUtils.currentLine=131073;
 //BA.debugLineNum = 131073;BA.debugLine="Return True";
if (true) return anywheresoftware.b4a.keywords.Common.True;
RDebugUtils.currentLine=131074;
 //BA.debugLineNum = 131074;BA.debugLine="End Sub";
return false;
}
public static String  _appstart(anywheresoftware.b4j.objects.Form _form1,String[] _args) throws Exception{
RDebugUtils.currentModule="main";
if (Debug.shouldDelegate(ba, "appstart"))
	 {return ((String) Debug.delegate(ba, "appstart", new Object[] {_form1,_args}));}
RDebugUtils.currentLine=65536;
 //BA.debugLineNum = 65536;BA.debugLine="Sub AppStart (Form1 As Form, Args() As String)";
RDebugUtils.currentLine=65537;
 //BA.debugLineNum = 65537;BA.debugLine="MainForm = Form1";
_mainform = _form1;
RDebugUtils.currentLine=65538;
 //BA.debugLineNum = 65538;BA.debugLine="MainForm.RootPane.LoadLayout(\"main\") 'Load the la";
_mainform.getRootPane().LoadLayout(ba,"main");
RDebugUtils.currentLine=65539;
 //BA.debugLineNum = 65539;BA.debugLine="MainForm.Show";
_mainform.Show();
RDebugUtils.currentLine=65540;
 //BA.debugLineNum = 65540;BA.debugLine="TextArea1.Text=\"I love you. I am 1.5m tall. My fa";
_textarea1.setText("I love you. I am 1.5m tall. My favourite food is rice. Tang is not a famous doctor. Tang is a famous doctor.");
RDebugUtils.currentLine=65541;
 //BA.debugLineNum = 65541;BA.debugLine="End Sub";
return "";
}
public static String  _button1_mouseclicked(anywheresoftware.b4j.objects.NodeWrapper.MouseEventWrapper _eventdata) throws Exception{
RDebugUtils.currentModule="main";
if (Debug.shouldDelegate(ba, "button1_mouseclicked"))
	 {return ((String) Debug.delegate(ba, "button1_mouseclicked", new Object[] {_eventdata}));}
RDebugUtils.currentLine=1245184;
 //BA.debugLineNum = 1245184;BA.debugLine="Sub Button1_MouseClicked (EventData As MouseEvent)";
RDebugUtils.currentLine=1245185;
 //BA.debugLineNum = 1245185;BA.debugLine="rules=SRX.readRules(\"\",\"en\")";
_rules = _srx._readrules("","en");
RDebugUtils.currentLine=1245186;
 //BA.debugLineNum = 1245186;BA.debugLine="End Sub";
return "";
}
public static String  _button2_mouseclicked(anywheresoftware.b4j.objects.NodeWrapper.MouseEventWrapper _eventdata) throws Exception{
RDebugUtils.currentModule="main";
if (Debug.shouldDelegate(ba, "button2_mouseclicked"))
	 {return ((String) Debug.delegate(ba, "button2_mouseclicked", new Object[] {_eventdata}));}
RDebugUtils.currentLine=1179648;
 //BA.debugLineNum = 1179648;BA.debugLine="Sub Button2_MouseClicked (EventData As MouseEvent)";
RDebugUtils.currentLine=1179649;
 //BA.debugLineNum = 1179649;BA.debugLine="segment";
_segment();
RDebugUtils.currentLine=1179650;
 //BA.debugLineNum = 1179650;BA.debugLine="End Sub";
return "";
}
public static String  _segment() throws Exception{
RDebugUtils.currentModule="main";
if (Debug.shouldDelegate(ba, "segment"))
	 {return ((String) Debug.delegate(ba, "segment", null));}
String _text = "";
anywheresoftware.b4a.objects.collections.List _breakrules = null;
anywheresoftware.b4a.objects.collections.List _nonbreakrules = null;
String _previoustext = "";
anywheresoftware.b4a.objects.collections.List _segments = null;
anywheresoftware.b4a.objects.collections.List _breakpositions = null;
anywheresoftware.b4a.objects.collections.List _nonbreakpositions = null;
anywheresoftware.b4a.objects.collections.List _finalbreakpositions = null;
int _index = 0;
String _seg = "";
RDebugUtils.currentLine=3801088;
 //BA.debugLineNum = 3801088;BA.debugLine="Sub segment";
RDebugUtils.currentLine=3801089;
 //BA.debugLineNum = 3801089;BA.debugLine="Dim text As String";
_text = "";
RDebugUtils.currentLine=3801090;
 //BA.debugLineNum = 3801090;BA.debugLine="text=TextArea1.Text";
_text = _textarea1.getText();
RDebugUtils.currentLine=3801091;
 //BA.debugLineNum = 3801091;BA.debugLine="Dim breakRules,nonbreakRules As List";
_breakrules = new anywheresoftware.b4a.objects.collections.List();
_nonbreakrules = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=3801092;
 //BA.debugLineNum = 3801092;BA.debugLine="breakRules=rules.Get(\"breakRules\")";
_breakrules.setObject((java.util.List)(_rules.Get((Object)("breakRules"))));
RDebugUtils.currentLine=3801093;
 //BA.debugLineNum = 3801093;BA.debugLine="nonbreakRules=rules.Get(\"nonbreakRules\")";
_nonbreakrules.setObject((java.util.List)(_rules.Get((Object)("nonbreakRules"))));
RDebugUtils.currentLine=3801094;
 //BA.debugLineNum = 3801094;BA.debugLine="Log(breakRules)";
anywheresoftware.b4a.keywords.Common.Log(BA.ObjectToString(_breakrules));
RDebugUtils.currentLine=3801095;
 //BA.debugLineNum = 3801095;BA.debugLine="Log(nonbreakRules)";
anywheresoftware.b4a.keywords.Common.Log(BA.ObjectToString(_nonbreakrules));
RDebugUtils.currentLine=3801096;
 //BA.debugLineNum = 3801096;BA.debugLine="Dim previousText As String";
_previoustext = "";
RDebugUtils.currentLine=3801098;
 //BA.debugLineNum = 3801098;BA.debugLine="Dim segments As List";
_segments = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=3801099;
 //BA.debugLineNum = 3801099;BA.debugLine="segments.Initialize";
_segments.Initialize();
RDebugUtils.currentLine=3801102;
 //BA.debugLineNum = 3801102;BA.debugLine="Dim breakPositions As List";
_breakpositions = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=3801103;
 //BA.debugLineNum = 3801103;BA.debugLine="breakPositions.Initialize";
_breakpositions.Initialize();
RDebugUtils.currentLine=3801104;
 //BA.debugLineNum = 3801104;BA.debugLine="breakPositions.AddAll(getPositions(breakRules,tex";
_breakpositions.AddAll(_getpositions(_breakrules,_text));
RDebugUtils.currentLine=3801105;
 //BA.debugLineNum = 3801105;BA.debugLine="breakPositions.Sort(True)";
_breakpositions.Sort(anywheresoftware.b4a.keywords.Common.True);
RDebugUtils.currentLine=3801106;
 //BA.debugLineNum = 3801106;BA.debugLine="removeDuplicated(breakPositions)";
_removeduplicated(_breakpositions);
RDebugUtils.currentLine=3801108;
 //BA.debugLineNum = 3801108;BA.debugLine="Dim nonbreakPositions As List";
_nonbreakpositions = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=3801109;
 //BA.debugLineNum = 3801109;BA.debugLine="nonbreakPositions.Initialize";
_nonbreakpositions.Initialize();
RDebugUtils.currentLine=3801110;
 //BA.debugLineNum = 3801110;BA.debugLine="nonbreakPositions.AddAll(getPositions(nonbreakRul";
_nonbreakpositions.AddAll(_getpositions(_nonbreakrules,_text));
RDebugUtils.currentLine=3801111;
 //BA.debugLineNum = 3801111;BA.debugLine="nonbreakPositions.Sort(True)";
_nonbreakpositions.Sort(anywheresoftware.b4a.keywords.Common.True);
RDebugUtils.currentLine=3801112;
 //BA.debugLineNum = 3801112;BA.debugLine="removeDuplicated(nonbreakPositions)";
_removeduplicated(_nonbreakpositions);
RDebugUtils.currentLine=3801114;
 //BA.debugLineNum = 3801114;BA.debugLine="Dim finalBreakPositions As List";
_finalbreakpositions = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=3801115;
 //BA.debugLineNum = 3801115;BA.debugLine="finalBreakPositions.Initialize";
_finalbreakpositions.Initialize();
RDebugUtils.currentLine=3801116;
 //BA.debugLineNum = 3801116;BA.debugLine="For Each index As Int In breakPositions";
{
final anywheresoftware.b4a.BA.IterableList group23 = _breakpositions;
final int groupLen23 = group23.getSize()
;int index23 = 0;
;
for (; index23 < groupLen23;index23++){
_index = (int)(BA.ObjectToNumber(group23.Get(index23)));
RDebugUtils.currentLine=3801117;
 //BA.debugLineNum = 3801117;BA.debugLine="If nonbreakPositions.IndexOf(index)=-1 Then";
if (_nonbreakpositions.IndexOf((Object)(_index))==-1) { 
RDebugUtils.currentLine=3801118;
 //BA.debugLineNum = 3801118;BA.debugLine="finalBreakPositions.Add(index)";
_finalbreakpositions.Add((Object)(_index));
 };
 }
};
RDebugUtils.currentLine=3801121;
 //BA.debugLineNum = 3801121;BA.debugLine="Log(breakPositions)";
anywheresoftware.b4a.keywords.Common.Log(BA.ObjectToString(_breakpositions));
RDebugUtils.currentLine=3801122;
 //BA.debugLineNum = 3801122;BA.debugLine="Log(nonbreakPositions)";
anywheresoftware.b4a.keywords.Common.Log(BA.ObjectToString(_nonbreakpositions));
RDebugUtils.currentLine=3801123;
 //BA.debugLineNum = 3801123;BA.debugLine="Log(finalBreakPositions)";
anywheresoftware.b4a.keywords.Common.Log(BA.ObjectToString(_finalbreakpositions));
RDebugUtils.currentLine=3801124;
 //BA.debugLineNum = 3801124;BA.debugLine="For Each index As Int In finalBreakPositions";
{
final anywheresoftware.b4a.BA.IterableList group31 = _finalbreakpositions;
final int groupLen31 = group31.getSize()
;int index31 = 0;
;
for (; index31 < groupLen31;index31++){
_index = (int)(BA.ObjectToNumber(group31.Get(index31)));
RDebugUtils.currentLine=3801125;
 //BA.debugLineNum = 3801125;BA.debugLine="segments.Add(text.SubString2(previousText.Length";
_segments.Add((Object)(_text.substring(_previoustext.length(),_index)));
RDebugUtils.currentLine=3801126;
 //BA.debugLineNum = 3801126;BA.debugLine="previousText=text.SubString2(0,index)";
_previoustext = _text.substring((int) (0),_index);
 }
};
RDebugUtils.currentLine=3801128;
 //BA.debugLineNum = 3801128;BA.debugLine="If previousText.Length<>text.Length Then";
if (_previoustext.length()!=_text.length()) { 
RDebugUtils.currentLine=3801129;
 //BA.debugLineNum = 3801129;BA.debugLine="segments.Add(text.SubString2(previousText.Length";
_segments.Add((Object)(_text.substring(_previoustext.length(),_text.length())));
 };
RDebugUtils.currentLine=3801132;
 //BA.debugLineNum = 3801132;BA.debugLine="TextArea1.Text=\"\"";
_textarea1.setText("");
RDebugUtils.currentLine=3801133;
 //BA.debugLineNum = 3801133;BA.debugLine="For Each seg As String In segments";
{
final anywheresoftware.b4a.BA.IterableList group39 = _segments;
final int groupLen39 = group39.getSize()
;int index39 = 0;
;
for (; index39 < groupLen39;index39++){
_seg = BA.ObjectToString(group39.Get(index39));
RDebugUtils.currentLine=3801134;
 //BA.debugLineNum = 3801134;BA.debugLine="TextArea1.Text=TextArea1.Text&seg&\"---------\"&CR";
_textarea1.setText(_textarea1.getText()+_seg+"---------"+anywheresoftware.b4a.keywords.Common.CRLF);
 }
};
RDebugUtils.currentLine=3801136;
 //BA.debugLineNum = 3801136;BA.debugLine="Log(segments)";
anywheresoftware.b4a.keywords.Common.Log(BA.ObjectToString(_segments));
RDebugUtils.currentLine=3801137;
 //BA.debugLineNum = 3801137;BA.debugLine="End Sub";
return "";
}
public static String  _button3_mouseclicked(anywheresoftware.b4j.objects.NodeWrapper.MouseEventWrapper _eventdata) throws Exception{
RDebugUtils.currentModule="main";
if (Debug.shouldDelegate(ba, "button3_mouseclicked"))
	 {return ((String) Debug.delegate(ba, "button3_mouseclicked", new Object[] {_eventdata}));}
RDebugUtils.currentLine=5767168;
 //BA.debugLineNum = 5767168;BA.debugLine="Sub Button3_MouseClicked (EventData As MouseEvent)";
RDebugUtils.currentLine=5767169;
 //BA.debugLineNum = 5767169;BA.debugLine="TextArea1.Text=TextArea1.Text.Replace(\"---------\"";
_textarea1.setText(_textarea1.getText().replace("---------"+anywheresoftware.b4a.keywords.Common.CRLF,""));
RDebugUtils.currentLine=5767170;
 //BA.debugLineNum = 5767170;BA.debugLine="End Sub";
return "";
}
public static anywheresoftware.b4a.objects.collections.List  _getpositions(anywheresoftware.b4a.objects.collections.List _ruleslist,String _text) throws Exception{
RDebugUtils.currentModule="main";
if (Debug.shouldDelegate(ba, "getpositions"))
	 {return ((anywheresoftware.b4a.objects.collections.List) Debug.delegate(ba, "getpositions", new Object[] {_ruleslist,_text}));}
anywheresoftware.b4a.objects.collections.List _breakpositions = null;
anywheresoftware.b4a.objects.collections.Map _rule = null;
String _beforebreak = "";
String _afterbreak = "";
anywheresoftware.b4a.keywords.Regex.MatcherWrapper _bbm = null;
anywheresoftware.b4a.keywords.Regex.MatcherWrapper _abm = null;
RDebugUtils.currentLine=5701632;
 //BA.debugLineNum = 5701632;BA.debugLine="Sub getPositions(rulesList As List,text As String)";
RDebugUtils.currentLine=5701633;
 //BA.debugLineNum = 5701633;BA.debugLine="Dim breakPositions As List";
_breakpositions = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=5701634;
 //BA.debugLineNum = 5701634;BA.debugLine="breakPositions.Initialize";
_breakpositions.Initialize();
RDebugUtils.currentLine=5701635;
 //BA.debugLineNum = 5701635;BA.debugLine="For Each rule As Map In rulesList";
_rule = new anywheresoftware.b4a.objects.collections.Map();
{
final anywheresoftware.b4a.BA.IterableList group3 = _ruleslist;
final int groupLen3 = group3.getSize()
;int index3 = 0;
;
for (; index3 < groupLen3;index3++){
_rule.setObject((anywheresoftware.b4a.objects.collections.Map.MyMap)(group3.Get(index3)));
RDebugUtils.currentLine=5701637;
 //BA.debugLineNum = 5701637;BA.debugLine="Dim beforeBreak,afterBreak As String";
_beforebreak = "";
_afterbreak = "";
RDebugUtils.currentLine=5701638;
 //BA.debugLineNum = 5701638;BA.debugLine="beforeBreak=rule.Get(\"beforebreak\")";
_beforebreak = BA.ObjectToString(_rule.Get((Object)("beforebreak")));
RDebugUtils.currentLine=5701639;
 //BA.debugLineNum = 5701639;BA.debugLine="afterBreak=rule.Get(\"afterbreak\")";
_afterbreak = BA.ObjectToString(_rule.Get((Object)("afterbreak")));
RDebugUtils.currentLine=5701641;
 //BA.debugLineNum = 5701641;BA.debugLine="Dim bbm As Matcher";
_bbm = new anywheresoftware.b4a.keywords.Regex.MatcherWrapper();
RDebugUtils.currentLine=5701642;
 //BA.debugLineNum = 5701642;BA.debugLine="bbm=Regex.Matcher2(beforeBreak,32,text)";
_bbm = anywheresoftware.b4a.keywords.Common.Regex.Matcher2(_beforebreak,(int) (32),_text);
RDebugUtils.currentLine=5701644;
 //BA.debugLineNum = 5701644;BA.debugLine="If beforeBreak<>\"null\" Then";
if ((_beforebreak).equals("null") == false) { 
RDebugUtils.currentLine=5701646;
 //BA.debugLineNum = 5701646;BA.debugLine="Do While bbm.Find";
while (_bbm.Find()) {
RDebugUtils.currentLine=5701647;
 //BA.debugLineNum = 5701647;BA.debugLine="If afterBreak=\"null\" Then";
if ((_afterbreak).equals("null")) { 
RDebugUtils.currentLine=5701648;
 //BA.debugLineNum = 5701648;BA.debugLine="breakPositions.Add(bbm.GetEnd(0))";
_breakpositions.Add((Object)(_bbm.GetEnd((int) (0))));
 };
RDebugUtils.currentLine=5701651;
 //BA.debugLineNum = 5701651;BA.debugLine="Dim abm As Matcher";
_abm = new anywheresoftware.b4a.keywords.Regex.MatcherWrapper();
RDebugUtils.currentLine=5701652;
 //BA.debugLineNum = 5701652;BA.debugLine="abm=Regex.Matcher2(afterBreak,32,text)";
_abm = anywheresoftware.b4a.keywords.Common.Regex.Matcher2(_afterbreak,(int) (32),_text);
RDebugUtils.currentLine=5701653;
 //BA.debugLineNum = 5701653;BA.debugLine="Do While abm.Find";
while (_abm.Find()) {
RDebugUtils.currentLine=5701654;
 //BA.debugLineNum = 5701654;BA.debugLine="If bbm.GetEnd(0)=abm.GetStart(0) Then";
if (_bbm.GetEnd((int) (0))==_abm.GetStart((int) (0))) { 
RDebugUtils.currentLine=5701655;
 //BA.debugLineNum = 5701655;BA.debugLine="breakPositions.Add(abm.GetEnd(0))";
_breakpositions.Add((Object)(_abm.GetEnd((int) (0))));
RDebugUtils.currentLine=5701656;
 //BA.debugLineNum = 5701656;BA.debugLine="Exit";
if (true) break;
 };
 }
;
 }
;
 }else 
{RDebugUtils.currentLine=5701660;
 //BA.debugLineNum = 5701660;BA.debugLine="Else if afterBreak<>\"null\" Then";
if ((_afterbreak).equals("null") == false) { 
RDebugUtils.currentLine=5701661;
 //BA.debugLineNum = 5701661;BA.debugLine="Dim abm As Matcher";
_abm = new anywheresoftware.b4a.keywords.Regex.MatcherWrapper();
RDebugUtils.currentLine=5701662;
 //BA.debugLineNum = 5701662;BA.debugLine="abm=Regex.Matcher2(afterBreak,32,text)";
_abm = anywheresoftware.b4a.keywords.Common.Regex.Matcher2(_afterbreak,(int) (32),_text);
RDebugUtils.currentLine=5701663;
 //BA.debugLineNum = 5701663;BA.debugLine="Do While abm.Find";
while (_abm.Find()) {
RDebugUtils.currentLine=5701664;
 //BA.debugLineNum = 5701664;BA.debugLine="breakPositions.Add(abm.GetEnd(0))";
_breakpositions.Add((Object)(_abm.GetEnd((int) (0))));
 }
;
 }}
;
 }
};
RDebugUtils.currentLine=5701669;
 //BA.debugLineNum = 5701669;BA.debugLine="Return breakPositions";
if (true) return _breakpositions;
RDebugUtils.currentLine=5701670;
 //BA.debugLineNum = 5701670;BA.debugLine="End Sub";
return null;
}
public static String  _removeduplicated(anywheresoftware.b4a.objects.collections.List _source) throws Exception{
RDebugUtils.currentModule="main";
if (Debug.shouldDelegate(ba, "removeduplicated"))
	 {return ((String) Debug.delegate(ba, "removeduplicated", new Object[] {_source}));}
anywheresoftware.b4a.objects.collections.List _newlist = null;
int _index = 0;
RDebugUtils.currentLine=4849664;
 //BA.debugLineNum = 4849664;BA.debugLine="Sub removeDuplicated(source As List)";
RDebugUtils.currentLine=4849665;
 //BA.debugLineNum = 4849665;BA.debugLine="Dim newList As List";
_newlist = new anywheresoftware.b4a.objects.collections.List();
RDebugUtils.currentLine=4849666;
 //BA.debugLineNum = 4849666;BA.debugLine="newList.Initialize";
_newlist.Initialize();
RDebugUtils.currentLine=4849667;
 //BA.debugLineNum = 4849667;BA.debugLine="For Each index As Int In source";
{
final anywheresoftware.b4a.BA.IterableList group3 = _source;
final int groupLen3 = group3.getSize()
;int index3 = 0;
;
for (; index3 < groupLen3;index3++){
_index = (int)(BA.ObjectToNumber(group3.Get(index3)));
RDebugUtils.currentLine=4849668;
 //BA.debugLineNum = 4849668;BA.debugLine="If newList.IndexOf(index)=-1 Then";
if (_newlist.IndexOf((Object)(_index))==-1) { 
RDebugUtils.currentLine=4849669;
 //BA.debugLineNum = 4849669;BA.debugLine="newList.Add(index)";
_newlist.Add((Object)(_index));
 };
 }
};
RDebugUtils.currentLine=4849672;
 //BA.debugLineNum = 4849672;BA.debugLine="source.Clear";
_source.Clear();
RDebugUtils.currentLine=4849673;
 //BA.debugLineNum = 4849673;BA.debugLine="source.AddAll(newList)";
_source.AddAll(_newlist);
RDebugUtils.currentLine=4849674;
 //BA.debugLineNum = 4849674;BA.debugLine="End Sub";
return "";
}
}