
#import "b4i_change.h"
#import "b4i_main.h"
#import "b4i_customlistview.h"
#import "b4i_chooselesson.h"
#import "b4i_content.h"
#import "b4i_search.h"
#import "b4i_spinner.h"
#import "b4i_clstoastmsg.h"
#import "b4i_dohelper.h"
#import "b4i_webpageview.h"


@implementation b4i_change 


+ (B4I*)createBI {
    return [B4I alloc];
}

- (void)dealloc {
    if (self.bi != nil)
        NSLog(@"Class (b4i_change) instance released.");
}
- (NSString*)  _changetonesymbol:(NSString*) _symbol{
 //BA.debugLineNum = 11;BA.debugLine="Public Sub changeToneSymbol(symbol As String) As S";
 //BA.debugLineNum = 12;BA.debugLine="symbol=symbol.Replace(\"0\",\"◎\")";
_symbol = [_symbol Replace:@"0" :@"◎"];
 //BA.debugLineNum = 13;BA.debugLine="symbol=symbol.Replace(\"1\",\"①\")";
_symbol = [_symbol Replace:@"1" :@"①"];
 //BA.debugLineNum = 14;BA.debugLine="symbol=symbol.Replace(\"2\",\"②\")";
_symbol = [_symbol Replace:@"2" :@"②"];
 //BA.debugLineNum = 15;BA.debugLine="symbol=symbol.Replace(\"3\",\"③\")";
_symbol = [_symbol Replace:@"3" :@"③"];
 //BA.debugLineNum = 16;BA.debugLine="symbol=symbol.Replace(\"4\",\"④\")";
_symbol = [_symbol Replace:@"4" :@"④"];
 //BA.debugLineNum = 17;BA.debugLine="symbol=symbol.Replace(\"5\",\"⑤\")";
_symbol = [_symbol Replace:@"5" :@"⑤"];
 //BA.debugLineNum = 18;BA.debugLine="symbol=symbol.Replace(\"6\",\"⑥\")";
_symbol = [_symbol Replace:@"6" :@"⑥"];
 //BA.debugLineNum = 19;BA.debugLine="Return symbol";
if (true) return _symbol;
 //BA.debugLineNum = 20;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _class_globals{
self._main=[b4i_main new];
self._chooselesson=[b4i_chooselesson new];
self._content=[b4i_content new];
self._search=[b4i_search new];
self._dohelper=[b4i_dohelper new];
self._webpageview=[b4i_webpageview new];
 //BA.debugLineNum = 2;BA.debugLine="Sub Class_Globals";
 //BA.debugLineNum = 4;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _initialize:(B4I*) _ba{
[self initializeClassModule];
 //BA.debugLineNum = 7;BA.debugLine="Public Sub Initialize";
 //BA.debugLineNum = 9;BA.debugLine="End Sub";
return @"";
}
@end
