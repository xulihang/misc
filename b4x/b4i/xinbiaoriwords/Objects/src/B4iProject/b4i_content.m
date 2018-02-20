
#import "b4i_content.h"
#import "b4i_main.h"
#import "b4i_customlistview.h"
#import "b4i_chooselesson.h"
#import "b4i_search.h"
#import "b4i_spinner.h"
#import "b4i_change.h"
#import "b4i_clstoastmsg.h"
#import "b4i_dohelper.h"
#import "b4i_webpageview.h"


@implementation b4i_content 


+ (instancetype)new {
    static b4i_content* shared = nil;
    if (shared == nil) {
        shared = [self alloc];
        shared.bi = [[B4I alloc] init:shared];
        shared.__c = [B4ICommon new];
    }
    return shared;
}

- (NSString*)  _additem:(NSString*) _nihongo :(NSString*) _kana :(NSString*) _kanji :(NSString*) _pronunication :(NSString*) _wordtype :(BOOL) _star{
B4IPanelWrapper* _panel1 = nil;
B4ILabelWrapper* _nihongokana = nil;
B4ILabelWrapper* _pronunicationtext = nil;
b4i_change* _change1 = nil;
 //BA.debugLineNum = 52;BA.debugLine="Sub addItem(nihongo As String, kana As String,kanj";
 //BA.debugLineNum = 54;BA.debugLine="Private panel1 As Panel";
_panel1 = [B4IPanelWrapper new];
 //BA.debugLineNum = 55;BA.debugLine="panel1.Initialize(\"panel1\")";
[_panel1 Initialize:self.bi :@"panel1"];
 //BA.debugLineNum = 56;BA.debugLine="panel1.LoadLayout(\"item\")";
[_panel1 LoadLayout:@"item" :self.bi];
 //BA.debugLineNum = 57;BA.debugLine="Dim nihongokana=panel1.GetView(0) As Label";
_nihongokana = [B4ILabelWrapper new];
_nihongokana.object = (UILabel*)(([_panel1 GetView:(int) (0)]).object);
 //BA.debugLineNum = 58;BA.debugLine="nihongokana.Text=nihongo&\" （\"&kana&\"） [\"&wordtype";
[_nihongokana setText:[@[_nihongo,@" （",_kana,@"） [",_wordtype,@"]",@" ",_kanji] componentsJoinedByString:@""]];
 //BA.debugLineNum = 59;BA.debugLine="nihongokana.Multiline=True";
[_nihongokana setMultiline:[self.__c True]];
 //BA.debugLineNum = 60;BA.debugLine="Dim pronunicationText=panel1.GetView(1) As Label";
_pronunicationtext = [B4ILabelWrapper new];
_pronunicationtext.object = (UILabel*)(([_panel1 GetView:(int) (1)]).object);
 //BA.debugLineNum = 61;BA.debugLine="Dim change1 As change";
_change1 = [b4i_change new];
 //BA.debugLineNum = 62;BA.debugLine="change1.Initialize";
[_change1 _initialize:self.bi];
 //BA.debugLineNum = 63;BA.debugLine="pronunicationText.Tag=nihongo";
[_pronunicationtext setTag:(NSObject*)(_nihongo)];
 //BA.debugLineNum = 64;BA.debugLine="pronunicationText.Text=change1.changeToneSymbol(p";
[_pronunicationtext setText:[_change1 _changetonesymbol:_pronunication]];
 //BA.debugLineNum = 65;BA.debugLine="CustomListView1.Add(panel1,40dip,nihongo)";
[self._customlistview1 _add:_panel1 :[self.__c DipToCurrent:(int) (40)] :(NSObject*)(_nihongo)];
 //BA.debugLineNum = 66;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _customlistview1_itemclick:(int) _index :(NSObject*) _value{
 //BA.debugLineNum = 28;BA.debugLine="Sub CustomListView1_ItemClick (Index As Int, Value";
 //BA.debugLineNum = 29;BA.debugLine="If TTS1.IsInitialized=False Then";
if ([self._tts1 IsInitialized]==[self.__c False]) { 
 //BA.debugLineNum = 30;BA.debugLine="TTS1.Initialize(\"TTS1\")";
[self._tts1 Initialize:self.bi :@"TTS1"];
 };
 //BA.debugLineNum = 35;BA.debugLine="TTS1.SpeechRate=0.1";
[self._tts1 setSpeechRate:(float) (0.1)];
 //BA.debugLineNum = 36;BA.debugLine="TTS1.SetLanguage(\"ja-JP\")";
[self._tts1 SetLanguage:@"ja-JP"];
 //BA.debugLineNum = 37;BA.debugLine="TTS1.Speak(Value,True)";
[self._tts1 Speak:[self.bi ObjectToString:_value] :[self.__c True]];
 //BA.debugLineNum = 38;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _label2_click{
B4ILabelWrapper* _lbl = nil;
 //BA.debugLineNum = 68;BA.debugLine="Sub Label2_Click";
 //BA.debugLineNum = 69;BA.debugLine="Dim lbl As Label = Sender";
_lbl = [B4ILabelWrapper new];
_lbl.object = (UILabel*)([self.__c Sender:self.bi]);
 //BA.debugLineNum = 71;BA.debugLine="doHelper.nihongo=lbl.Tag";
self._dohelper._nihongo = [self.bi ObjectToString:[_lbl Tag]];
 //BA.debugLineNum = 72;BA.debugLine="doHelper.Show";
[self._dohelper _show];
 //BA.debugLineNum = 73;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _loaddict{
B4IResultSet* _rs = nil;
 //BA.debugLineNum = 40;BA.debugLine="Sub loadDict()";
 //BA.debugLineNum = 41;BA.debugLine="CustomListView1.Clear";
[self._customlistview1 _clear];
 //BA.debugLineNum = 42;BA.debugLine="Log(chooseLesson.chosenlesson)";
[self.__c Log:self._chooselesson._chosenlesson];
 //BA.debugLineNum = 43;BA.debugLine="If SQL1.IsInitialized=False Then";
if ([self._sql1 IsInitialized]==[self.__c False]) { 
 //BA.debugLineNum = 44;BA.debugLine="SQL1.Initialize(File.DirLibrary,\"dict.db\",Fal";
[self._sql1 Initialize:[[self.__c File] DirLibrary] :@"dict.db" :[self.__c False]];
 };
 //BA.debugLineNum = 46;BA.debugLine="Dim rs As ResultSet = SQL1.ExecQuery(\"SELECT *";
_rs = [self._sql1 ExecQuery:[@[@"SELECT * FROM dict WHERE lesson like '%",self._chooselesson._chosenlesson,@"%'"] componentsJoinedByString:@""]];
 //BA.debugLineNum = 47;BA.debugLine="Do While rs.NextRow";
while ([_rs NextRow]) {
 //BA.debugLineNum = 48;BA.debugLine="addItem(rs.GetString(\"nihongo\"),rs.GetStri";
[self _additem:[_rs GetString:@"nihongo"] :[_rs GetString:@"kana"] :[_rs GetString:@"kanji"] :[_rs GetString:@"pronunication"] :[_rs GetString:@"wordtype"] :[self.bi ObjectToBoolean:[_rs GetString:@"nihongo"]]];
 }
;
 //BA.debugLineNum = 50;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _process_globals{
self._main=[b4i_main new];
self._chooselesson=[b4i_chooselesson new];
self._search=[b4i_search new];
self._dohelper=[b4i_dohelper new];
self._webpageview=[b4i_webpageview new];
 //BA.debugLineNum = 3;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 6;BA.debugLine="Private page3 As Page";
self._page3 = [B4IPage new];
 //BA.debugLineNum = 7;BA.debugLine="Private CustomListView1 As CustomListView";
self._customlistview1 = [b4i_customlistview new];
 //BA.debugLineNum = 8;BA.debugLine="Private SQL1 As SQL";
self._sql1 = [B4ISQL new];
 //BA.debugLineNum = 9;BA.debugLine="Private TTS1 As TTS";
self._tts1 = [B4ITTS new];
 //BA.debugLineNum = 10;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _show{
 //BA.debugLineNum = 12;BA.debugLine="Public Sub Show";
 //BA.debugLineNum = 13;BA.debugLine="If page3.IsInitialized=False Then";
if ([self._page3 IsInitialized]==[self.__c False]) { 
 //BA.debugLineNum = 14;BA.debugLine="page3.Initialize(\"Page3\")";
[self._page3 Initialize:self.bi :@"Page3"];
 //BA.debugLineNum = 15;BA.debugLine="page3.RootPanel.Color = Colors.ARGB(255,215,218,";
[[self._page3 RootPanel] setColor:[[self.__c Colors] ARGB:(int) (255) :(int) (215) :(int) (218) :(int) (192)]];
 //BA.debugLineNum = 16;BA.debugLine="page3.RootPanel.LoadLayout(\"main\")";
[[self._page3 RootPanel] LoadLayout:@"main" :self.bi];
 //BA.debugLineNum = 17;BA.debugLine="page3.Title = \"单词\"";
[self._page3 setTitle:@"单词"];
 //BA.debugLineNum = 18;BA.debugLine="page3.RootPanel.TintColor=Colors.Black";
[[self._page3 RootPanel] setTintColor:[[self.__c Colors] Black]];
 };
 //BA.debugLineNum = 20;BA.debugLine="Main.NavControl.ShowPage(page3)";
[self._main._navcontrol ShowPage:(UIViewController*)((self._page3).object)];
 //BA.debugLineNum = 21;BA.debugLine="Log(chooseLesson.chosenlesson)";
[self.__c Log:self._chooselesson._chosenlesson];
 //BA.debugLineNum = 22;BA.debugLine="If File.Exists(File.DirLibrary,\"dict.db\")=False T";
if ([[self.__c File] Exists:[[self.__c File] DirLibrary] :@"dict.db"]==[self.__c False]) { 
 //BA.debugLineNum = 23;BA.debugLine="File.Copy(File.DirAssets,\"dict.db\",File.DirLibra";
[[self.__c File] Copy:[[self.__c File] DirAssets] :@"dict.db" :[[self.__c File] DirLibrary] :@"dict.db"];
 };
 //BA.debugLineNum = 25;BA.debugLine="loadDict";
[self _loaddict];
 //BA.debugLineNum = 26;BA.debugLine="End Sub";
return @"";
}
@end
