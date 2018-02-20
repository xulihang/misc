
#import "b4i_webpageview.h"
#import "b4i_main.h"
#import "b4i_customlistview.h"
#import "b4i_chooselesson.h"
#import "b4i_content.h"
#import "b4i_search.h"
#import "b4i_spinner.h"
#import "b4i_change.h"
#import "b4i_clstoastmsg.h"
#import "b4i_dohelper.h"


@implementation b4i_webpageview 


+ (instancetype)new {
    static b4i_webpageview* shared = nil;
    if (shared == nil) {
        shared = [self alloc];
        shared.bi = [[B4I alloc] init:shared];
        shared.__c = [B4ICommon new];
    }
    return shared;
}

- (NSString*)  _page2_barbuttonclick:(NSString*) _tag{
 //BA.debugLineNum = 26;BA.debugLine="Sub  Page2_BarButtonClick (Tag As String)";
 //BA.debugLineNum = 27;BA.debugLine="Log(Tag)";
[self.__c Log:_tag];
 //BA.debugLineNum = 28;BA.debugLine="If Tag=\"back\" Then";
if ([_tag isEqual:@"back"]) { 
 //BA.debugLineNum = 29;BA.debugLine="If WebView1.CanGoBack Then";
if ([self._webview1 CanGoBack]) { 
 //BA.debugLineNum = 30;BA.debugLine="WebView1.GoBack";
[self._webview1 GoBack];
 };
 }else if([_tag isEqual:@"forward"]) { 
 //BA.debugLineNum = 33;BA.debugLine="If WebView1.CanGoForward Then";
if ([self._webview1 CanGoForward]) { 
 //BA.debugLineNum = 34;BA.debugLine="WebView1.GoForward";
[self._webview1 GoForward];
 };
 }else {
 //BA.debugLineNum = 37;BA.debugLine="Main.NavControl.ToolBarVisible=False";
[self._main._navcontrol setToolBarVisible:[self.__c False]];
 //BA.debugLineNum = 38;BA.debugLine="Main.NavControl.RemoveCurrentPage";
[self._main._navcontrol RemoveCurrentPage];
 };
 //BA.debugLineNum = 40;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _process_globals{
self._main=[b4i_main new];
self._chooselesson=[b4i_chooselesson new];
self._content=[b4i_content new];
self._search=[b4i_search new];
self._dohelper=[b4i_dohelper new];
 //BA.debugLineNum = 3;BA.debugLine="Sub Process_Globals";
 //BA.debugLineNum = 6;BA.debugLine="Private page2 As Page";
self._page2 = [B4IPage new];
 //BA.debugLineNum = 7;BA.debugLine="Private WebView1 As WebView";
self._webview1 = [B4IWebViewWrapper new];
 //BA.debugLineNum = 8;BA.debugLine="Public uri As String";
self._uri = @"";
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
 //BA.debugLineNum = 15;BA.debugLine="page2.RootPanel.LoadLayout(\"webview\")";
[[self._page2 RootPanel] LoadLayout:@"webview" :self.bi];
 //BA.debugLineNum = 16;BA.debugLine="page2.Title = \"选择操作\"";
[self._page2 setTitle:@"选择操作"];
 };
 //BA.debugLineNum = 18;BA.debugLine="Main.NavControl.ToolBarVisible=True";
[self._main._navcontrol setToolBarVisible:[self.__c True]];
 //BA.debugLineNum = 19;BA.debugLine="Main.NavControl.ShowPage(page2)";
[self._main._navcontrol ShowPage:(UIViewController*)((self._page2).object)];
 //BA.debugLineNum = 20;BA.debugLine="Log(uri)";
[self.__c Log:self._uri];
 //BA.debugLineNum = 21;BA.debugLine="WebView1.LoadUrl(uri)";
[self._webview1 LoadUrl:self._uri];
 //BA.debugLineNum = 23;BA.debugLine="End Sub";
return @"";
}
@end
