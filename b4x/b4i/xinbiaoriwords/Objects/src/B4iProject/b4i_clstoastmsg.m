
#import "b4i_clstoastmsg.h"
#import "b4i_main.h"
#import "b4i_customlistview.h"
#import "b4i_chooselesson.h"
#import "b4i_content.h"
#import "b4i_search.h"
#import "b4i_spinner.h"
#import "b4i_change.h"
#import "b4i_dohelper.h"
#import "b4i_webpageview.h"


@implementation b4i_clstoastmsg 


+ (B4I*)createBI {
    return [B4I alloc];
}

- (void)dealloc {
    if (self.bi != nil)
        NSLog(@"Class (b4i_clstoastmsg) instance released.");
}
- (NSString*)  _class_globals{
self._main=[b4i_main new];
self._chooselesson=[b4i_chooselesson new];
self._content=[b4i_content new];
self._search=[b4i_search new];
self._dohelper=[b4i_dohelper new];
self._webpageview=[b4i_webpageview new];
 //BA.debugLineNum = 8;BA.debugLine="Sub Class_Globals";
 //BA.debugLineNum = 10;BA.debugLine="Private pgParent As Page";
self._pgparent = [B4IPage new];
 //BA.debugLineNum = 11;BA.debugLine="Private pnlMessage As Panel";
self._pnlmessage = [B4IPanelWrapper new];
 //BA.debugLineNum = 12;BA.debugLine="Private lblMessage As Label";
self._lblmessage = [B4ILabelWrapper new];
 //BA.debugLineNum = 13;BA.debugLine="Private tmrTimer As Timer";
self._tmrtimer = [B4ITimer new];
 //BA.debugLineNum = 14;BA.debugLine="Private tmrTimer2 As Timer";
self._tmrtimer2 = [B4ITimer new];
 //BA.debugLineNum = 16;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _hidemessage{
 //BA.debugLineNum = 81;BA.debugLine="Public Sub HideMessage";
 //BA.debugLineNum = 83;BA.debugLine="tmrTimer_Tick";
[self _tmrtimer_tick];
 //BA.debugLineNum = 85;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _initialize:(B4I*) _ba :(B4IPage*) _parentpage :(float) _textsize :(BOOL) _shadow{
[self initializeClassModule];
 //BA.debugLineNum = 23;BA.debugLine="Public Sub Initialize (ParentPage As Page, TextSiz";
 //BA.debugLineNum = 25;BA.debugLine="pgParent = ParentPage";
self._pgparent = _parentpage;
 //BA.debugLineNum = 26;BA.debugLine="If TextSize < 10 Then TextSize = 10";
if (_textsize<10) { 
_textsize = (float) (10);};
 //BA.debugLineNum = 27;BA.debugLine="tmrTimer.Initialize(\"tmrTimer\", 500)";
[self._tmrtimer Initialize:self.bi :@"tmrTimer" :(long long) (500)];
 //BA.debugLineNum = 28;BA.debugLine="tmrTimer.Enabled = False";
[self._tmrtimer setEnabled:[self.__c False]];
 //BA.debugLineNum = 29;BA.debugLine="tmrTimer2.Initialize(\"tmrTimer2\", 300)";
[self._tmrtimer2 Initialize:self.bi :@"tmrTimer2" :(long long) (300)];
 //BA.debugLineNum = 30;BA.debugLine="tmrTimer2.Enabled = False";
[self._tmrtimer2 setEnabled:[self.__c False]];
 //BA.debugLineNum = 31;BA.debugLine="pnlMessage.Initialize(\"pnlMessage\")";
[self._pnlmessage Initialize:self.bi :@"pnlMessage"];
 //BA.debugLineNum = 32;BA.debugLine="pnlMessage.Color = Colors.ARGB(200, 0, 0, 0)";
[self._pnlmessage setColor:[[self.__c Colors] ARGB:(int) (200) :(int) (0) :(int) (0) :(int) (0)]];
 //BA.debugLineNum = 34;BA.debugLine="lblMessage.Initialize(\"\")";
[self._lblmessage Initialize:self.bi :@""];
 //BA.debugLineNum = 35;BA.debugLine="lblMessage.TextColor = Colors.White";
[self._lblmessage setTextColor:[[self.__c Colors] White]];
 //BA.debugLineNum = 36;BA.debugLine="lblMessage.TextAlignment = lblMessage.ALIGNMENT_C";
[self._lblmessage setTextAlignment:[self._lblmessage ALIGNMENT_CENTER]];
 //BA.debugLineNum = 37;BA.debugLine="lblMessage.Font = Font.CreateNew(TextSize)";
[self._lblmessage setFont:[[self.__c Font] CreateNew:_textsize]];
 //BA.debugLineNum = 38;BA.debugLine="lblMessage.Multiline = True";
[self._lblmessage setMultiline:[self.__c True]];
 //BA.debugLineNum = 40;BA.debugLine="pnlMessage.AddView(lblMessage, 0, 0, 10, 10)";
[self._pnlmessage AddView:(UIView*)((self._lblmessage).object) :(float) (0) :(float) (0) :(float) (10) :(float) (10)];
 //BA.debugLineNum = 41;BA.debugLine="pnlMessage.SetBorder(0, Colors.Black, 10)";
[self._pnlmessage SetBorder:(float) (0) :[[self.__c Colors] Black] :(float) (10)];
 //BA.debugLineNum = 43;BA.debugLine="pgParent.RootPanel.AddView(pnlMessage, 0, 0, pgPa";
[[self._pgparent RootPanel] AddView:(UIView*)((self._pnlmessage).object) :(float) (0) :(float) (0) :[[self._pgparent RootPanel] Width] :[[self._pgparent RootPanel] Height]];
 //BA.debugLineNum = 45;BA.debugLine="If Shadow Then";
if (_shadow) { 
 //BA.debugLineNum = 46;BA.debugLine="pnlMessage.SetShadow(Colors.Black, 0, 0, 0.8, Fa";
[self._pnlmessage SetShadow:[[self.__c Colors] Black] :(float) (0) :(float) (0) :(float) (0.8) :[self.__c False]];
 };
 //BA.debugLineNum = 48;BA.debugLine="pnlMessage.SetAlphaAnimated(1, 0)";
[self._pnlmessage SetAlphaAnimated:(int) (1) :(float) (0)];
 //BA.debugLineNum = 49;BA.debugLine="pnlMessage.Visible = False";
[self._pnlmessage setVisible:[self.__c False]];
 //BA.debugLineNum = 51;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _pnlmessage_touch:(int) _action :(float) _x :(float) _y{
 //BA.debugLineNum = 106;BA.debugLine="Private Sub pnlMessage_Touch(Action As Int, X As F";
 //BA.debugLineNum = 108;BA.debugLine="HideMessage";
[self _hidemessage];
 //BA.debugLineNum = 110;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _showtoastmessage:(NSString*) _message :(int) _tinterval{
 //BA.debugLineNum = 56;BA.debugLine="Public Sub ShowToastMessage(Message As String, tIn";
 //BA.debugLineNum = 58;BA.debugLine="tmrTimer.Enabled = False";
[self._tmrtimer setEnabled:[self.__c False]];
 //BA.debugLineNum = 59;BA.debugLine="tmrTimer2.Enabled = False";
[self._tmrtimer2 setEnabled:[self.__c False]];
 //BA.debugLineNum = 60;BA.debugLine="If tInterval <= 0 Then tInterval = 500";
if (_tinterval<=0) { 
_tinterval = (int) (500);};
 //BA.debugLineNum = 61;BA.debugLine="tmrTimer.Interval = tInterval";
[self._tmrtimer setInterval:(long long) (_tinterval)];
 //BA.debugLineNum = 62;BA.debugLine="pnlMessage.Width = (pgParent.RootPanel.Width / 10";
[self._pnlmessage setWidth:(float) (([[self._pgparent RootPanel] Width]/(double)100)*90)];
 //BA.debugLineNum = 63;BA.debugLine="pnlMessage.Left = pgParent.RootPanel.Width / 2 -";
[self._pnlmessage setLeft:(float) ([[self._pgparent RootPanel] Width]/(double)2-[self._pnlmessage Width]/(double)2)];
 //BA.debugLineNum = 64;BA.debugLine="lblMessage.SetLayoutAnimated(0, 0, 10, 10, pnlMes";
[self._lblmessage SetLayoutAnimated:(int) (0) :(float) (0) :(float) (10) :(float) (10) :(float) ([self._pnlmessage Width]-20) :(float) (10)];
 //BA.debugLineNum = 65;BA.debugLine="lblMessage.Text = Message";
[self._lblmessage setText:_message];
 //BA.debugLineNum = 66;BA.debugLine="lblMessage.SizeToFit";
[self._lblmessage SizeToFit];
 //BA.debugLineNum = 67;BA.debugLine="pnlMessage.Height = lblMessage.Height + 20";
[self._pnlmessage setHeight:(float) ([self._lblmessage Height]+20)];
 //BA.debugLineNum = 68;BA.debugLine="pnlMessage.Width = lblMessage.Width + 20";
[self._pnlmessage setWidth:(float) ([self._lblmessage Width]+20)];
 //BA.debugLineNum = 70;BA.debugLine="pnlMessage.Left = pgParent.RootPanel.Width / 2 -";
[self._pnlmessage setLeft:(float) ([[self._pgparent RootPanel] Width]/(double)2-[self._pnlmessage Width]/(double)2)];
 //BA.debugLineNum = 71;BA.debugLine="pnlMessage.Top  = pgParent.RootPanel.Height / 2 -";
[self._pnlmessage setTop:(float) ([[self._pgparent RootPanel] Height]/(double)2-[self._pnlmessage Height]/(double)2)];
 //BA.debugLineNum = 73;BA.debugLine="pnlMessage.Visible = True";
[self._pnlmessage setVisible:[self.__c True]];
 //BA.debugLineNum = 74;BA.debugLine="pnlMessage.BringToFront";
[self._pnlmessage BringToFront];
 //BA.debugLineNum = 75;BA.debugLine="pnlMessage.SetAlphaAnimated(300, 1)";
[self._pnlmessage SetAlphaAnimated:(int) (300) :(float) (1)];
 //BA.debugLineNum = 76;BA.debugLine="tmrTimer.Enabled = True";
[self._tmrtimer setEnabled:[self.__c True]];
 //BA.debugLineNum = 78;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _tmrtimer_tick{
 //BA.debugLineNum = 88;BA.debugLine="Private Sub tmrTimer_Tick";
 //BA.debugLineNum = 90;BA.debugLine="tmrTimer.Enabled = False";
[self._tmrtimer setEnabled:[self.__c False]];
 //BA.debugLineNum = 91;BA.debugLine="pnlMessage.SetAlphaAnimated(300, 0)";
[self._pnlmessage SetAlphaAnimated:(int) (300) :(float) (0)];
 //BA.debugLineNum = 92;BA.debugLine="tmrTimer2.Enabled = True";
[self._tmrtimer2 setEnabled:[self.__c True]];
 //BA.debugLineNum = 94;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _tmrtimer2_tick{
 //BA.debugLineNum = 97;BA.debugLine="Private Sub tmrTimer2_Tick";
 //BA.debugLineNum = 99;BA.debugLine="tmrTimer2.Enabled = False";
[self._tmrtimer2 setEnabled:[self.__c False]];
 //BA.debugLineNum = 100;BA.debugLine="pnlMessage.SendToBack";
[self._pnlmessage SendToBack];
 //BA.debugLineNum = 101;BA.debugLine="pnlMessage.Visible = False";
[self._pnlmessage setVisible:[self.__c False]];
 //BA.debugLineNum = 103;BA.debugLine="End Sub";
return @"";
}
@end
