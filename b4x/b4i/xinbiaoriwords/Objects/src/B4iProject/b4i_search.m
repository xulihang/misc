
#import "b4i_search.h"
#import "b4i_main.h"
#import "b4i_customlistview.h"
#import "b4i_chooselesson.h"
#import "b4i_content.h"
#import "b4i_spinner.h"
#import "b4i_change.h"
#import "b4i_clstoastmsg.h"
#import "b4i_dohelper.h"
#import "b4i_webpageview.h"


@implementation b4i_search 


+ (instancetype)new {
    static b4i_search* shared = nil;
    if (shared == nil) {
        shared = [self alloc];
        shared.bi = [[B4I alloc] init:shared];
        shared.__c = [B4ICommon new];
    }
    return shared;
}

- (NSString*)  _additem:(NSString*) _nihongo :(NSString*) _kana :(NSString*) _kanji :(NSString*) _pronunication :(NSString*) _wordtype :(NSString*) _lesson{
B4IPanelWrapper* _panel1 = nil;
B4ILabelWrapper* _nihongokana = nil;
B4ILabelWrapper* _pronunicationtext = nil;
b4i_change* _change1 = nil;
 //BA.debugLineNum = 81;BA.debugLine="Sub addItem(nihongo As String, kana As String,kanj";
 //BA.debugLineNum = 82;BA.debugLine="Private panel1 As Panel";
_panel1 = [B4IPanelWrapper new];
 //BA.debugLineNum = 83;BA.debugLine="panel1.Initialize(\"panel1\")";
[_panel1 Initialize:self.bi :@"panel1"];
 //BA.debugLineNum = 84;BA.debugLine="panel1.LoadLayout(\"item\")";
[_panel1 LoadLayout:@"item" :self.bi];
 //BA.debugLineNum = 85;BA.debugLine="Dim nihongokana=panel1.GetView(0) As Label";
_nihongokana = [B4ILabelWrapper new];
_nihongokana.object = (UILabel*)(([_panel1 GetView:(int) (0)]).object);
 //BA.debugLineNum = 86;BA.debugLine="nihongokana.Text=nihongo&\" （\"&kana&\"） [\"&wordtype";
[_nihongokana setText:[@[_nihongo,@" （",_kana,@"） [",_wordtype,@"]",@" ",_kanji] componentsJoinedByString:@""]];
 //BA.debugLineNum = 87;BA.debugLine="nihongokana.Multiline=True";
[_nihongokana setMultiline:[self.__c True]];
 //BA.debugLineNum = 88;BA.debugLine="Dim pronunicationText=panel1.GetView(1) As Label";
_pronunicationtext = [B4ILabelWrapper new];
_pronunicationtext.object = (UILabel*)(([_panel1 GetView:(int) (1)]).object);
 //BA.debugLineNum = 89;BA.debugLine="Dim change1 As change";
_change1 = [b4i_change new];
 //BA.debugLineNum = 90;BA.debugLine="change1.Initialize";
[_change1 _initialize:self.bi];
 //BA.debugLineNum = 91;BA.debugLine="pronunicationText.Text=change1.changeToneSymbol(p";
[_pronunicationtext setText:[_change1 _changetonesymbol:_pronunication]];
 //BA.debugLineNum = 92;BA.debugLine="pronunicationText.Tag=nihongo";
[_pronunicationtext setTag:(NSObject*)(_nihongo)];
 //BA.debugLineNum = 93;BA.debugLine="CustomListView1.Add(panel1,40dip,nihongo)";
[self._customlistview1 _add:_panel1 :[self.__c DipToCurrent:(int) (40)] :(NSObject*)(_nihongo)];
 //BA.debugLineNum = 94;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _customlistview1_itemclick:(int) _index :(NSObject*) _value{
 //BA.debugLineNum = 69;BA.debugLine="Sub CustomListView1_ItemClick (Index As Int, Value";
 //BA.debugLineNum = 70;BA.debugLine="If TTS1.IsInitialized=False Then";
if ([self._tts1 IsInitialized]==[self.__c False]) { 
 //BA.debugLineNum = 71;BA.debugLine="TTS1.Initialize(\"TTS1\")";
[self._tts1 Initialize:self.bi :@"TTS1"];
 };
 //BA.debugLineNum = 76;BA.debugLine="TTS1.SpeechRate=0.1";
[self._tts1 setSpeechRate:(float) (0.1)];
 //BA.debugLineNum = 77;BA.debugLine="TTS1.SetLanguage(\"ja-JP\")";
[self._tts1 SetLanguage:@"ja-JP"];
 //BA.debugLineNum = 78;BA.debugLine="TTS1.Speak(Value,True)";
[self._tts1 Speak:[self.bi ObjectToString:_value] :[self.__c True]];
 //BA.debugLineNum = 79;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _label2_click{
B4ILabelWrapper* _lbl = nil;
 //BA.debugLineNum = 96;BA.debugLine="Sub Label2_Click";
 //BA.debugLineNum = 97;BA.debugLine="Dim lbl As Label = Sender";
_lbl = [B4ILabelWrapper new];
_lbl.object = (UILabel*)([self.__c Sender:self.bi]);
 //BA.debugLineNum = 99;BA.debugLine="doHelper.nihongo=lbl.Tag";
self._dohelper._nihongo = [self.bi ObjectToString:[_lbl Tag]];
 //BA.debugLineNum = 100;BA.debugLine="doHelper.Show";
[self._dohelper _show];
 //BA.debugLineNum = 101;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _loaddict:(NSString*) _searchtype{
B4IResultSet* _rs = nil;
int _rowcount = 0;
 //BA.debugLineNum = 54;BA.debugLine="Sub loadDict(searchtype As String)";
 //BA.debugLineNum = 55;BA.debugLine="CustomListView1.Clear";
[self._customlistview1 _clear];
 //BA.debugLineNum = 56;BA.debugLine="If SQL1.IsInitialized=False Then";
if ([self._sql1 IsInitialized]==[self.__c False]) { 
 //BA.debugLineNum = 57;BA.debugLine="SQL1.Initialize(File.DirLibrary,\"dict.db\",Fal";
[self._sql1 Initialize:[[self.__c File] DirLibrary] :@"dict.db" :[self.__c False]];
 };
 //BA.debugLineNum = 59;BA.debugLine="Dim rs As ResultSet = SQL1.ExecQuery(\"SELECT *";
_rs = [self._sql1 ExecQuery:[@[@"SELECT * FROM dict WHERE ",_searchtype,@" like '%",[self._textfield1 Text],@"%'"] componentsJoinedByString:@""]];
 //BA.debugLineNum = 60;BA.debugLine="Dim rowCount As Int";
_rowcount = 0;
 //BA.debugLineNum = 61;BA.debugLine="rowCount=0";
_rowcount = (int) (0);
 //BA.debugLineNum = 62;BA.debugLine="Do While rs.NextRow";
while ([_rs NextRow]) {
 //BA.debugLineNum = 63;BA.debugLine="rowCount=rowCount+1";
_rowcount = (int) (_rowcount+1);
 //BA.debugLineNum = 64;BA.debugLine="addItem(rs.GetString(\"nihongo\"),rs.GetStri";
[self _additem:[_rs GetString:@"nihongo"] :[_rs GetString:@"kana"] :[_rs GetString:@"kanji"] :[_rs GetString:@"pronunication"] :[_rs GetString:@"wordtype"] :[_rs GetString:@"lesson"]];
 }
;
 //BA.debugLineNum = 66;BA.debugLine="Toast.ShowToastMessage(\"搜索到\"&rowCount&\"个结果\",3000)";
[self._toast _showtoastmessage:[@[@"搜索到",[self.bi NumberToString:@(_rowcount)],@"个结果"] componentsJoinedByString:@""] :(int) (3000)];
 //BA.debugLineNum = 67;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _process_globals{
self._main=[b4i_main new];
self._chooselesson=[b4i_chooselesson new];
self._content=[b4i_content new];
self._dohelper=[b4i_dohelper new];
self._webpageview=[b4i_webpageview new];
 //BA.debugLineNum = 3;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 6;BA.debugLine="Private page2 As Page";
self._page2 = [B4IPage new];
 //BA.debugLineNum = 8;BA.debugLine="Private CustomListView1 As CustomListView";
self._customlistview1 = [b4i_customlistview new];
 //BA.debugLineNum = 9;BA.debugLine="Private Spinner1 As Spinner";
self._spinner1 = [b4i_spinner new];
 //BA.debugLineNum = 10;BA.debugLine="Private TextField1 As TextField";
self._textfield1 = [B4ITextFieldWrapper new];
 //BA.debugLineNum = 11;BA.debugLine="Private SQL1 As SQL";
self._sql1 = [B4ISQL new];
 //BA.debugLineNum = 12;BA.debugLine="Private TTS1 As TTS";
self._tts1 = [B4ITTS new];
 //BA.debugLineNum = 13;BA.debugLine="Private Toast As clsToastMsg";
self._toast = [b4i_clstoastmsg new];
 //BA.debugLineNum = 14;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _show{
 //BA.debugLineNum = 16;BA.debugLine="Public Sub Show";
 //BA.debugLineNum = 17;BA.debugLine="If page2.IsInitialized=False Then";
if ([self._page2 IsInitialized]==[self.__c False]) { 
 //BA.debugLineNum = 18;BA.debugLine="page2.Initialize(\"Page2\")";
[self._page2 Initialize:self.bi :@"Page2"];
 //BA.debugLineNum = 19;BA.debugLine="page2.RootPanel.Color = Colors.ARGB(255,215,218,";
[[self._page2 RootPanel] setColor:[[self.__c Colors] ARGB:(int) (255) :(int) (215) :(int) (218) :(int) (192)]];
 //BA.debugLineNum = 20;BA.debugLine="page2.RootPanel.LoadLayout(\"search\")";
[[self._page2 RootPanel] LoadLayout:@"search" :self.bi];
 //BA.debugLineNum = 21;BA.debugLine="page2.Title = \"搜索\"";
[self._page2 setTitle:@"搜索"];
 //BA.debugLineNum = 22;BA.debugLine="Spinner1.Add(\"日语\")";
[self._spinner1 _add:@"日语"];
 //BA.debugLineNum = 23;BA.debugLine="Spinner1.Add(\"假名\")";
[self._spinner1 _add:@"假名"];
 //BA.debugLineNum = 24;BA.debugLine="Spinner1.Add(\"中文意思\")";
[self._spinner1 _add:@"中文意思"];
 //BA.debugLineNum = 25;BA.debugLine="Spinner1.SelectedIndex=0";
[self._spinner1 _setselectedindex:(int) (0)];
 //BA.debugLineNum = 26;BA.debugLine="Toast.Initialize(page2,14,False)";
[self._toast _initialize:self.bi :self._page2 :(float) (14) :[self.__c False]];
 //BA.debugLineNum = 29;BA.debugLine="TextField1.Color=Colors.ARGB(200,32,202,176)";
[self._textfield1 setColor:[[self.__c Colors] ARGB:(int) (200) :(int) (32) :(int) (202) :(int) (176)]];
 //BA.debugLineNum = 30;BA.debugLine="Spinner1.Color=Colors.ARGB(200,32,202,176)";
[self._spinner1 _setcolor:[[self.__c Colors] ARGB:(int) (200) :(int) (32) :(int) (202) :(int) (176)]];
 };
 //BA.debugLineNum = 32;BA.debugLine="Main.NavControl.ShowPage(page2)";
[self._main._navcontrol ShowPage:(UIViewController*)((self._page2).object)];
 //BA.debugLineNum = 34;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _spinner1_itemclick:(int) _index :(NSObject*) _value{
 //BA.debugLineNum = 38;BA.debugLine="Sub Spinner1_ItemClick (index As Int, value As Obj";
 //BA.debugLineNum = 39;BA.debugLine="TextField1.ResignFocus";
[self._textfield1 ResignFocus];
 //BA.debugLineNum = 40;BA.debugLine="If TextField1.Text=\"\" Then";
if ([[self._textfield1 Text] isEqual:@""]) { 
 //BA.debugLineNum = 41;BA.debugLine="Toast.ShowToastMessage(\"关键字不能为空\", 3000)";
[self._toast _showtoastmessage:@"关键字不能为空" :(int) (3000)];
 }else {
 //BA.debugLineNum = 43;BA.debugLine="Select index";
switch (_index) {
case 0: {
 //BA.debugLineNum = 45;BA.debugLine="loadDict(\"nihongo\")";
[self _loaddict:@"nihongo"];
 break; }
case 1: {
 //BA.debugLineNum = 47;BA.debugLine="loadDict(\"kana\")";
[self _loaddict:@"kana"];
 break; }
case 2: {
 //BA.debugLineNum = 49;BA.debugLine="loadDict(\"kanji\")";
[self _loaddict:@"kanji"];
 break; }
}
;
 };
 //BA.debugLineNum = 52;BA.debugLine="End Sub";
return @"";
}
@end
