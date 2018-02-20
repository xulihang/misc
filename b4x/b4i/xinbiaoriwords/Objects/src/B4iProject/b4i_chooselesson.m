
#import "b4i_chooselesson.h"
#import "b4i_main.h"
#import "b4i_customlistview.h"
#import "b4i_content.h"
#import "b4i_search.h"
#import "b4i_spinner.h"
#import "b4i_change.h"
#import "b4i_clstoastmsg.h"
#import "b4i_dohelper.h"
#import "b4i_webpageview.h"


@implementation b4i_chooselesson 


+ (instancetype)new {
    static b4i_chooselesson* shared = nil;
    if (shared == nil) {
        shared = [self alloc];
        shared.bi = [[B4I alloc] init:shared];
        shared.__c = [B4ICommon new];
    }
    return shared;
}

- (NSString*)  _customlistview1_itemclick:(int) _index :(NSObject*) _value{
int _lesson = 0;
 //BA.debugLineNum = 37;BA.debugLine="Sub CustomListView1_ItemClick (Index As Int, Value";
 //BA.debugLineNum = 38;BA.debugLine="Dim lesson As Int";
_lesson = 0;
 //BA.debugLineNum = 39;BA.debugLine="lesson=Value";
_lesson = [self.bi ObjectToNumber:_value].intValue;
 //BA.debugLineNum = 40;BA.debugLine="Log(lesson)";
[self.__c Log:[self.bi NumberToString:@(_lesson)]];
 //BA.debugLineNum = 41;BA.debugLine="If lesson<10 Then";
if (_lesson<10) { 
 //BA.debugLineNum = 42;BA.debugLine="chosenlesson=\"0\"&lesson";
self._chosenlesson = [@[@"0",[self.bi NumberToString:@(_lesson)]] componentsJoinedByString:@""];
 }else {
 //BA.debugLineNum = 44;BA.debugLine="chosenlesson=lesson";
self._chosenlesson = [self.bi NumberToString:@(_lesson)];
 };
 //BA.debugLineNum = 46;BA.debugLine="Log(chosenlesson)";
[self.__c Log:self._chosenlesson];
 //BA.debugLineNum = 47;BA.debugLine="content.Show";
[self._content _show];
 //BA.debugLineNum = 48;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _loadlist{
int _i = 0;
 //BA.debugLineNum = 22;BA.debugLine="Sub loadList";
 //BA.debugLineNum = 23;BA.debugLine="CustomListView1.Clear";
[self._customlistview1 _clear];
 //BA.debugLineNum = 24;BA.debugLine="CustomListView1.DefaultTextBackgroundColor=Colors";
self._customlistview1._defaulttextbackgroundcolor = [[self.__c Colors] ARGB:(int) (255) :(int) (215) :(int) (218) :(int) (192)];
 //BA.debugLineNum = 25;BA.debugLine="If Main.book=0 Then";
if (self._main._book==0) { 
 //BA.debugLineNum = 26;BA.debugLine="For i=1 To 24";
{
const int step4 = 1;
const int limit4 = (int) (24);
for (_i = (int) (1) ; (step4 > 0 && _i <= limit4) || (step4 < 0 && _i >= limit4); _i = ((int)(0 + _i + step4)) ) {
 //BA.debugLineNum = 27;BA.debugLine="CustomListView1.AddTextItem(\"第\"&i&\"课\",i)";
[self._customlistview1 _addtextitem:[@[@"第",[self.bi NumberToString:@(_i)],@"课"] componentsJoinedByString:@""] :(NSObject*)(@(_i))];
 }
};
 }else {
 //BA.debugLineNum = 30;BA.debugLine="For i=25 To 47";
{
const int step8 = 1;
const int limit8 = (int) (47);
for (_i = (int) (25) ; (step8 > 0 && _i <= limit8) || (step8 < 0 && _i >= limit8); _i = ((int)(0 + _i + step8)) ) {
 //BA.debugLineNum = 31;BA.debugLine="CustomListView1.AddTextItem(\"第\"&i&\"课\",i)";
[self._customlistview1 _addtextitem:[@[@"第",[self.bi NumberToString:@(_i)],@"课"] componentsJoinedByString:@""] :(NSObject*)(@(_i))];
 }
};
 };
 //BA.debugLineNum = 34;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _process_globals{
self._main=[b4i_main new];
self._content=[b4i_content new];
self._search=[b4i_search new];
self._dohelper=[b4i_dohelper new];
self._webpageview=[b4i_webpageview new];
 //BA.debugLineNum = 3;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 6;BA.debugLine="Private page2 As Page";
self._page2 = [B4IPage new];
 //BA.debugLineNum = 7;BA.debugLine="Private CustomListView1 As CustomListView";
self._customlistview1 = [b4i_customlistview new];
 //BA.debugLineNum = 8;BA.debugLine="Public chosenlesson As String";
self._chosenlesson = @"";
 //BA.debugLineNum = 9;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _show{
 //BA.debugLineNum = 11;BA.debugLine="Public Sub Show";
 //BA.debugLineNum = 12;BA.debugLine="If page2.IsInitialized=False Then";
if ([self._page2 IsInitialized]==[self.__c False]) { 
 //BA.debugLineNum = 13;BA.debugLine="page2.Initialize(\"Page2\")";
[self._page2 Initialize:self.bi :@"Page2"];
 //BA.debugLineNum = 14;BA.debugLine="page2.RootPanel.Color = Colors.ARGB(255,215,218,";
[[self._page2 RootPanel] setColor:[[self.__c Colors] ARGB:(int) (255) :(int) (215) :(int) (218) :(int) (192)]];
 //BA.debugLineNum = 15;BA.debugLine="page2.RootPanel.LoadLayout(\"main\")";
[[self._page2 RootPanel] LoadLayout:@"main" :self.bi];
 //BA.debugLineNum = 16;BA.debugLine="page2.Title = \"选择课程\"";
[self._page2 setTitle:@"选择课程"];
 };
 //BA.debugLineNum = 18;BA.debugLine="Main.NavControl.ShowPage(page2)";
[self._main._navcontrol ShowPage:(UIViewController*)((self._page2).object)];
 //BA.debugLineNum = 19;BA.debugLine="loadList";
[self _loadlist];
 //BA.debugLineNum = 20;BA.debugLine="End Sub";
return @"";
}
@end
