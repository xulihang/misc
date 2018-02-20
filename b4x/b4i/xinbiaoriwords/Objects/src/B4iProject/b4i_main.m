
#import "b4i_main.h"
#import "b4i_customlistview.h"
#import "b4i_chooselesson.h"
#import "b4i_content.h"
#import "b4i_search.h"
#import "b4i_spinner.h"
#import "b4i_change.h"
#import "b4i_clstoastmsg.h"
#import "b4i_dohelper.h"
#import "b4i_webpageview.h"


@implementation b4i_main 


+ (instancetype)new {
    static b4i_main* shared = nil;
    if (shared == nil) {
        shared = [self alloc];
        shared.bi = [[B4I alloc] init:shared];
        shared.__c = [B4ICommon new];
    }
    return shared;
}

- (NSString*)  _application_background{
 //BA.debugLineNum = 42;BA.debugLine="Private Sub Application_Background";
 //BA.debugLineNum = 44;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _application_start:(B4INavigationControllerWrapper*) _nav{
[self initializeStaticModules];
 //BA.debugLineNum = 23;BA.debugLine="Private Sub Application_Start (Nav As NavigationCo";
 //BA.debugLineNum = 24;BA.debugLine="NavControl = Nav";
self._navcontrol = _nav;
 //BA.debugLineNum = 25;BA.debugLine="Page1.Initialize(\"Page1\")";
[self._page1 Initialize:self.bi :@"Page1"];
 //BA.debugLineNum = 26;BA.debugLine="Page1.RootPanel.Color =Colors.ARGB(255,215,218,19";
[[self._page1 RootPanel] setColor:[[self.__c Colors] ARGB:(int) (255) :(int) (215) :(int) (218) :(int) (192)]];
 //BA.debugLineNum = 27;BA.debugLine="Page1.RootPanel.LoadLayout(\"main\")";
[[self._page1 RootPanel] LoadLayout:@"main" :self.bi];
 //BA.debugLineNum = 28;BA.debugLine="NavControl.ShowPage(Page1)";
[self._navcontrol ShowPage:(UIViewController*)((self._page1).object)];
 //BA.debugLineNum = 29;BA.debugLine="Page1.Title = \"新标日单词\"";
[self._page1 setTitle:@"新标日单词"];
 //BA.debugLineNum = 30;BA.debugLine="loadList";
[self _loadlist];
 //BA.debugLineNum = 36;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _customlistview1_itemclick:(int) _index :(NSObject*) _value{
 //BA.debugLineNum = 56;BA.debugLine="Sub CustomListView1_ItemClick (Index As Int, Value";
 //BA.debugLineNum = 57;BA.debugLine="Select Value";
switch ([self.bi switchObjectToInt:_value :@[(NSObject*)(@(0)),(NSObject*)(@(1)),(NSObject*)(@(2)),(NSObject*)(@(3)),(NSObject*)(@(4))]]) {
case 0: {
 //BA.debugLineNum = 59;BA.debugLine="book=0";
self._book = (int) (0);
 //BA.debugLineNum = 60;BA.debugLine="chooseLesson.Show";
[self._chooselesson _show];
 break; }
case 1: {
 //BA.debugLineNum = 62;BA.debugLine="book=1";
self._book = (int) (1);
 //BA.debugLineNum = 63;BA.debugLine="chooseLesson.Show";
[self._chooselesson _show];
 break; }
case 2: {
 //BA.debugLineNum = 65;BA.debugLine="search.Show";
[self._search _show];
 break; }
case 3: {
 //BA.debugLineNum = 67;BA.debugLine="chooseLesson.Show";
[self._chooselesson _show];
 break; }
case 4: {
 //BA.debugLineNum = 69;BA.debugLine="chooseLesson.Show";
[self._chooselesson _show];
 break; }
}
;
 //BA.debugLineNum = 71;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _loadlist{
 //BA.debugLineNum = 46;BA.debugLine="Sub loadList";
 //BA.debugLineNum = 47;BA.debugLine="CustomListView1.DefaultTextBackgroundColor=Colors";
self._customlistview1._defaulttextbackgroundcolor = [[self.__c Colors] ARGB:(int) (255) :(int) (215) :(int) (218) :(int) (192)];
 //BA.debugLineNum = 48;BA.debugLine="CustomListView1.AddTextItem(\"☀标日初级上册\",0)";
[self._customlistview1 _addtextitem:@"☀标日初级上册" :(NSObject*)(@(0))];
 //BA.debugLineNum = 49;BA.debugLine="CustomListView1.AddTextItem(\"☀标日初级下册\",1)";
[self._customlistview1 _addtextitem:@"☀标日初级下册" :(NSObject*)(@(1))];
 //BA.debugLineNum = 50;BA.debugLine="CustomListView1.AddTextItem(\"🔍查单词\",2)";
[self._customlistview1 _addtextitem:@"🔍查单词" :(NSObject*)(@(2))];
 //BA.debugLineNum = 51;BA.debugLine="CustomListView1.AddTextItem(\"⭐收藏\",3)";
[self._customlistview1 _addtextitem:@"⭐收藏" :(NSObject*)(@(3))];
 //BA.debugLineNum = 52;BA.debugLine="CustomListView1.AddTextItem(\"👀说明\",4)";
[self._customlistview1 _addtextitem:@"👀说明" :(NSObject*)(@(4))];
 //BA.debugLineNum = 54;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _page1_resize:(int) _width :(int) _height{
 //BA.debugLineNum = 38;BA.debugLine="Private Sub Page1_Resize(Width As Int, Height As I";
 //BA.debugLineNum = 40;BA.debugLine="End Sub";
return @"";
}

- (void)initializeStaticModules {
    [[b4i_main new]initializeModule];
[[b4i_chooselesson new]initializeModule];
[[b4i_content new]initializeModule];
[[b4i_search new]initializeModule];
[[b4i_dohelper new]initializeModule];
[[b4i_webpageview new]initializeModule];

}
- (NSString*)  _process_globals{
self._chooselesson=[b4i_chooselesson new];
self._content=[b4i_content new];
self._search=[b4i_search new];
self._dohelper=[b4i_dohelper new];
self._webpageview=[b4i_webpageview new];
 //BA.debugLineNum = 12;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 15;BA.debugLine="Public App As Application";
self._app = [B4IApplicationWrapper new];
 //BA.debugLineNum = 16;BA.debugLine="Public NavControl As NavigationController";
self._navcontrol = [B4INavigationControllerWrapper new];
 //BA.debugLineNum = 17;BA.debugLine="Public book As Int";
self._book = 0;
 //BA.debugLineNum = 18;BA.debugLine="Private Page1 As Page";
self._page1 = [B4IPage new];
 //BA.debugLineNum = 20;BA.debugLine="Private CustomListView1 As CustomListView";
self._customlistview1 = [b4i_customlistview new];
 //BA.debugLineNum = 21;BA.debugLine="End Sub";
return @"";
}
@end
