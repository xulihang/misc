
#import "b4i_dohelper.h"
#import "b4i_main.h"
#import "b4i_customlistview.h"
#import "b4i_chooselesson.h"
#import "b4i_content.h"
#import "b4i_search.h"
#import "b4i_spinner.h"
#import "b4i_change.h"
#import "b4i_clstoastmsg.h"
#import "b4i_webpageview.h"


@implementation b4i_dohelper 


+ (instancetype)new {
    static b4i_dohelper* shared = nil;
    if (shared == nil) {
        shared = [self alloc];
        shared.bi = [[B4I alloc] init:shared];
        shared.__c = [B4ICommon new];
    }
    return shared;
}

- (NSString*)  _customlistview1_itemclick:(int) _index :(NSObject*) _value{
iStringUtils* _su = nil;
 //BA.debugLineNum = 33;BA.debugLine="Sub CustomListView1_ItemClick (Index As Int, Value";
 //BA.debugLineNum = 34;BA.debugLine="Dim su As StringUtils";
_su = [iStringUtils new];
 //BA.debugLineNum = 35;BA.debugLine="nihongo=su.EncodeUrl(nihongo,\"UTF-8\")";
self._nihongo = [_su EncodeUrl:self._nihongo :@"UTF-8"];
 //BA.debugLineNum = 36;BA.debugLine="Select Index";
switch (_index) {
case 0: {
 //BA.debugLineNum = 38;BA.debugLine="webPageView.uri=\"http://dict.hjenglish.com/jp/j";
self._webpageview._uri = [@[@"http://dict.hjenglish.com/jp/jc/",self._nihongo] componentsJoinedByString:@""];
 break; }
case 1: {
 //BA.debugLineNum = 40;BA.debugLine="webPageView.uri=\"http://dic.search.yahoo.co.jp/";
self._webpageview._uri = [@[@"http://dic.search.yahoo.co.jp/search?p=",self._nihongo,@"&ei=UTF-8&fr=top_ga1_sa"] componentsJoinedByString:@""];
 break; }
}
;
 //BA.debugLineNum = 42;BA.debugLine="webPageView.Show";
[self._webpageview _show];
 //BA.debugLineNum = 43;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _loadlist{
 //BA.debugLineNum = 26;BA.debugLine="Sub loadlist";
 //BA.debugLineNum = 27;BA.debugLine="CustomListView1.Clear";
[self._customlistview1 _clear];
 //BA.debugLineNum = 28;BA.debugLine="CustomListView1.DefaultTextBackgroundColor=Colors";
self._customlistview1._defaulttextbackgroundcolor = [[self.__c Colors] ARGB:(int) (255) :(int) (215) :(int) (218) :(int) (192)];
 //BA.debugLineNum = 29;BA.debugLine="CustomListView1.AddTextItem(\"在沪江词典上查询\",\"hjdict\")";
[self._customlistview1 _addtextitem:@"在沪江词典上查询" :(NSObject*)(@"hjdict")];
 //BA.debugLineNum = 30;BA.debugLine="CustomListView1.AddTextItem(\"在雅虎词典上查询\",\"yahoodict";
[self._customlistview1 _addtextitem:@"在雅虎词典上查询" :(NSObject*)(@"yahoodict")];
 //BA.debugLineNum = 31;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _process_globals{
self._main=[b4i_main new];
self._chooselesson=[b4i_chooselesson new];
self._content=[b4i_content new];
self._search=[b4i_search new];
self._webpageview=[b4i_webpageview new];
 //BA.debugLineNum = 3;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 6;BA.debugLine="Private page2 As Page";
self._page2 = [B4IPage new];
 //BA.debugLineNum = 7;BA.debugLine="Private CustomListView1 As CustomListView";
self._customlistview1 = [b4i_customlistview new];
 //BA.debugLineNum = 8;BA.debugLine="Public lesson As String";
self._lesson = @"";
 //BA.debugLineNum = 9;BA.debugLine="Public nihongo As String";
self._nihongo = @"";
 //BA.debugLineNum = 10;BA.debugLine="Private Toast As clsToastMsg";
self._toast = [b4i_clstoastmsg new];
 //BA.debugLineNum = 11;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _show{
 //BA.debugLineNum = 13;BA.debugLine="Public Sub Show";
 //BA.debugLineNum = 14;BA.debugLine="If page2.IsInitialized=False Then";
if ([self._page2 IsInitialized]==[self.__c False]) { 
 //BA.debugLineNum = 15;BA.debugLine="page2.Initialize(\"Page2\")";
[self._page2 Initialize:self.bi :@"Page2"];
 //BA.debugLineNum = 16;BA.debugLine="page2.RootPanel.Color = Colors.ARGB(255,215,218,";
[[self._page2 RootPanel] setColor:[[self.__c Colors] ARGB:(int) (255) :(int) (215) :(int) (218) :(int) (192)]];
 //BA.debugLineNum = 17;BA.debugLine="page2.RootPanel.LoadLayout(\"main\")";
[[self._page2 RootPanel] LoadLayout:@"main" :self.bi];
 //BA.debugLineNum = 18;BA.debugLine="page2.Title = \"选择操作\"";
[self._page2 setTitle:@"选择操作"];
 //BA.debugLineNum = 19;BA.debugLine="Toast.Initialize(page2,14,False)";
[self._toast _initialize:self.bi :self._page2 :(float) (14) :[self.__c False]];
 };
 //BA.debugLineNum = 22;BA.debugLine="Main.NavControl.ShowPage(page2)";
[self._main._navcontrol ShowPage:(UIViewController*)((self._page2).object)];
 //BA.debugLineNum = 23;BA.debugLine="loadlist";
[self _loadlist];
 //BA.debugLineNum = 24;BA.debugLine="End Sub";
return @"";
}
@end
