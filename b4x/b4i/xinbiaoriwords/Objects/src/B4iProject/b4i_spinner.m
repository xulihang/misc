
#import "b4i_spinner.h"
#import "b4i_main.h"
#import "b4i_customlistview.h"
#import "b4i_chooselesson.h"
#import "b4i_content.h"
#import "b4i_search.h"
#import "b4i_change.h"
#import "b4i_clstoastmsg.h"
#import "b4i_dohelper.h"
#import "b4i_webpageview.h"


@implementation b4i_spinner 


+ (B4I*)createBI {
    return [B4I alloc];
}

- (void)dealloc {
    if (self.bi != nil)
        NSLog(@"Class (b4i_spinner) instance released.");
}
- (NSString*)  _actspinner_click:(NSString*) _item{
 //BA.debugLineNum = 125;BA.debugLine="Sub actSpinner_Click (item As String)";
 //BA.debugLineNum = 127;BA.debugLine="lblSpinner.Text = item";
[self._lblspinner setText:_item];
 //BA.debugLineNum = 128;BA.debugLine="selectedIdx = itemList.IndexOf (item)";
self._selectedidx = [self._itemlist IndexOf:(NSObject*)(_item)];
 //BA.debugLineNum = 130;BA.debugLine="If SubExists(CallBack, mEventName & \"_ItemClick\",";
if ([self.__c SubExists:self._callback :[@[self._meventname,@"_ItemClick"] componentsJoinedByString:@""] :(int) (2)]) { 
 //BA.debugLineNum = 131;BA.debugLine="CallSub3(CallBack, mEventName & \"_ItemClick\", se";
[self.__c CallSub3:self.bi :self._callback :[@[self._meventname,@"_ItemClick"] componentsJoinedByString:@""] :(NSObject*)(@(self._selectedidx)) :(NSObject*)(_item)];
 };
 //BA.debugLineNum = 133;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _add:(NSString*) _item{
 //BA.debugLineNum = 109;BA.debugLine="public Sub Add (item As String)";
 //BA.debugLineNum = 110;BA.debugLine="itemList.Add(item)";
[self._itemlist Add:(NSObject*)(_item)];
 //BA.debugLineNum = 111;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _addall:(B4IList*) _items{
B4IList* _listcopy = nil;
 //BA.debugLineNum = 99;BA.debugLine="public Sub AddAll (items As List)";
 //BA.debugLineNum = 101;BA.debugLine="Dim listCopy As List";
_listcopy = [B4IList new];
 //BA.debugLineNum = 102;BA.debugLine="listCopy.Initialize";
[_listcopy Initialize];
 //BA.debugLineNum = 103;BA.debugLine="listCopy.AddAll(items)";
[_listcopy AddAll:_items];
 //BA.debugLineNum = 104;BA.debugLine="itemList = listCopy";
self._itemlist = _listcopy;
 //BA.debugLineNum = 106;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _base_resize:(double) _width :(double) _height{
 //BA.debugLineNum = 138;BA.debugLine="Private Sub Base_Resize (Width As Double, Height A";
 //BA.debugLineNum = 139;BA.debugLine="lblSpinner.Width  = Width";
[self._lblspinner setWidth:(float) (_width)];
 //BA.debugLineNum = 140;BA.debugLine="lblSpinner.Height = Height";
[self._lblspinner setHeight:(float) (_height)];
 //BA.debugLineNum = 141;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _bringtofront{
 //BA.debugLineNum = 343;BA.debugLine="public Sub BringToFront";
 //BA.debugLineNum = 344;BA.debugLine="If pnlBase.IsInitialized Then";
if ([self._pnlbase IsInitialized]) { 
 //BA.debugLineNum = 345;BA.debugLine="pnlBase.BringToFront";
[self._pnlbase BringToFront];
 }else {
 //BA.debugLineNum = 347;BA.debugLine="lblSpinner.BringToFront";
[self._lblspinner BringToFront];
 };
 //BA.debugLineNum = 349;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _class_globals{
self._main=[b4i_main new];
self._chooselesson=[b4i_chooselesson new];
self._content=[b4i_content new];
self._search=[b4i_search new];
self._dohelper=[b4i_dohelper new];
self._webpageview=[b4i_webpageview new];
 //BA.debugLineNum = 46;BA.debugLine="Sub Class_Globals";
 //BA.debugLineNum = 47;BA.debugLine="Private isInit      As Boolean = False";
self._isinit = [self.__c False];
 //BA.debugLineNum = 48;BA.debugLine="Private pnlBase     As Panel";
self._pnlbase = [B4IPanelWrapper new];
 //BA.debugLineNum = 49;BA.debugLine="Private lblSpinner  As Label";
self._lblspinner = [B4ILabelWrapper new];
 //BA.debugLineNum = 50;BA.debugLine="Private CallBack    As Object";
self._callback = [NSObject new];
 //BA.debugLineNum = 51;BA.debugLine="Private mEventName  As String";
self._meventname = @"";
 //BA.debugLineNum = 52;BA.debugLine="Private selectedIdx As Int";
self._selectedidx = 0;
 //BA.debugLineNum = 53;BA.debugLine="Private itemList    As List";
self._itemlist = [B4IList new];
 //BA.debugLineNum = 54;BA.debugLine="Private actSheet    As ActionSheet";
self._actsheet = [B4IActionSheetWrapper new];
 //BA.debugLineNum = 55;BA.debugLine="Private isEnabled   As Boolean";
self._isenabled = false;
 //BA.debugLineNum = 57;BA.debugLine="Public ALIGNMENT_CENTER As Int = lblSpinner.ALIGN";
self._alignment_center = [self._lblspinner ALIGNMENT_CENTER];
 //BA.debugLineNum = 58;BA.debugLine="Public ALIGNMENT_LEFT   As Int = lblSpinner.ALIGN";
self._alignment_left = [self._lblspinner ALIGNMENT_LEFT];
 //BA.debugLineNum = 59;BA.debugLine="Public ALIGNMENT_RIGHT  As Int = lblSpinner.ALIGN";
self._alignment_right = [self._lblspinner ALIGNMENT_RIGHT];
 //BA.debugLineNum = 60;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _clear{
 //BA.debugLineNum = 219;BA.debugLine="Public Sub Clear";
 //BA.debugLineNum = 220;BA.debugLine="itemList.Clear";
[self._itemlist Clear];
 //BA.debugLineNum = 221;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _designercreateview:(B4IPanelWrapper*) _base :(B4ILabelWrapper*) _lbl :(B4IMap*) _props{
 //BA.debugLineNum = 64;BA.debugLine="Public Sub DesignerCreateView (Base As Panel, Lbl";
 //BA.debugLineNum = 65;BA.debugLine="pnlBase = Base";
self._pnlbase = _base;
 //BA.debugLineNum = 68;BA.debugLine="lblSpinner.TextColor           = Lbl.TextColor";
[self._lblspinner setTextColor:[_lbl TextColor]];
 //BA.debugLineNum = 69;BA.debugLine="lblSpinner.Font                = Lbl.Font";
[self._lblspinner setFont:[_lbl Font]];
 //BA.debugLineNum = 70;BA.debugLine="lblSpinner.Multiline           = Lbl.Multiline";
[self._lblspinner setMultiline:[_lbl Multiline]];
 //BA.debugLineNum = 71;BA.debugLine="lblSpinner.TextAlignment       = Lbl.TextAlignmen";
[self._lblspinner setTextAlignment:[_lbl TextAlignment]];
 //BA.debugLineNum = 72;BA.debugLine="lblSpinner.AdjustFontSizeToFit = Lbl.AdjustFontSi";
[self._lblspinner setAdjustFontSizeToFit:[_lbl AdjustFontSizeToFit]];
 //BA.debugLineNum = 74;BA.debugLine="lblSpinner.Tag = pnlBase.Tag";
[self._lblspinner setTag:[self._pnlbase Tag]];
 //BA.debugLineNum = 76;BA.debugLine="Base.AddView (lblSpinner, 0, 0, Base.Width, Base.";
[_base AddView:(UIView*)((self._lblspinner).object) :(float) (0) :(float) (0) :[_base Width] :[_base Height]];
 //BA.debugLineNum = 77;BA.debugLine="End Sub";
return @"";
}
- (B4IViewWrapper*)  _getbase{
 //BA.debugLineNum = 207;BA.debugLine="Public Sub GetBase As View";
 //BA.debugLineNum = 208;BA.debugLine="If pnlBase.IsInitialized Then";
if ([self._pnlbase IsInitialized]) { 
 //BA.debugLineNum = 209;BA.debugLine="Return pnlBase";
if (true) return (B4IViewWrapper*) [B4IObjectWrapper createWrapper:[B4IViewWrapper new] object:(UIView*)((self._pnlbase).object)];
 }else {
 //BA.debugLineNum = 211;BA.debugLine="Return lblSpinner";
if (true) return (B4IViewWrapper*) [B4IObjectWrapper createWrapper:[B4IViewWrapper new] object:(UIView*)((self._lblspinner).object)];
 };
 //BA.debugLineNum = 213;BA.debugLine="End Sub";
return nil;
}
- (BOOL)  _getenabled{
 //BA.debugLineNum = 181;BA.debugLine="Public Sub getEnabled As Boolean";
 //BA.debugLineNum = 182;BA.debugLine="Return isEnabled";
if (true) return self._isenabled;
 //BA.debugLineNum = 183;BA.debugLine="End Sub";
return false;
}
- (int)  _getheight{
 //BA.debugLineNum = 296;BA.debugLine="Public Sub getHeight As Int";
 //BA.debugLineNum = 297;BA.debugLine="Return lblSpinner.Height";
if (true) return (int) ([self._lblspinner Height]);
 //BA.debugLineNum = 298;BA.debugLine="End Sub";
return 0;
}
- (NSString*)  _getitem:(int) _index{
 //BA.debugLineNum = 198;BA.debugLine="Public Sub GetItem (Index As Int) As String";
 //BA.debugLineNum = 199;BA.debugLine="Return itemList.Get(Index)";
if (true) return [self.bi ObjectToString:[self._itemlist Get:_index]];
 //BA.debugLineNum = 200;BA.debugLine="End Sub";
return @"";
}
- (int)  _getleft{
 //BA.debugLineNum = 255;BA.debugLine="Public Sub getLeft As Int";
 //BA.debugLineNum = 256;BA.debugLine="If pnlBase.IsInitialized Then";
if ([self._pnlbase IsInitialized]) { 
 //BA.debugLineNum = 257;BA.debugLine="Return pnlBase.Left";
if (true) return (int) ([self._pnlbase Left]);
 }else {
 //BA.debugLineNum = 259;BA.debugLine="Return lblSpinner.Left";
if (true) return (int) ([self._lblspinner Left]);
 };
 //BA.debugLineNum = 261;BA.debugLine="End Sub";
return 0;
}
- (B4IViewWrapper*)  _getparent:(B4IViewWrapper*) _v{
B4INativeObject* _r = nil;
 //BA.debugLineNum = 383;BA.debugLine="Private Sub GetParent(v As View) As View";
 //BA.debugLineNum = 384;BA.debugLine="Dim r As NativeObject = v";
_r = [B4INativeObject new];
_r.object = (NSObject*)((_v).object);
 //BA.debugLineNum = 385;BA.debugLine="Return r.GetField(\"superview\")";
if (true) return (B4IViewWrapper*) [B4IObjectWrapper createWrapper:[B4IViewWrapper new] object:(UIView*)(([_r GetField:@"superview"]).object)];
 //BA.debugLineNum = 386;BA.debugLine="End Sub'Class module";
return nil;
}
- (int)  _getselectedindex{
 //BA.debugLineNum = 190;BA.debugLine="Public Sub getSelectedIndex As Int";
 //BA.debugLineNum = 191;BA.debugLine="Return selectedIdx";
if (true) return self._selectedidx;
 //BA.debugLineNum = 192;BA.debugLine="End Sub";
return 0;
}
- (NSString*)  _getselecteditem{
 //BA.debugLineNum = 194;BA.debugLine="Public Sub getSelectedItem As String";
 //BA.debugLineNum = 195;BA.debugLine="Return itemList.Get(selectedIdx)";
if (true) return [self.bi ObjectToString:[self._itemlist Get:self._selectedidx]];
 //BA.debugLineNum = 196;BA.debugLine="End Sub";
return @"";
}
- (NSObject*)  _gettag{
 //BA.debugLineNum = 375;BA.debugLine="Public Sub getTag As Object";
 //BA.debugLineNum = 376;BA.debugLine="Return lblSpinner.Tag";
if (true) return [self._lblspinner Tag];
 //BA.debugLineNum = 377;BA.debugLine="End Sub";
return nil;
}
- (int)  _gettextalignment{
 //BA.debugLineNum = 245;BA.debugLine="Public Sub getTextAlignment As Int";
 //BA.debugLineNum = 246;BA.debugLine="Return lblSpinner.TextAlignment";
if (true) return [self._lblspinner TextAlignment];
 //BA.debugLineNum = 247;BA.debugLine="End Sub";
return 0;
}
- (int)  _gettextcolor{
 //BA.debugLineNum = 229;BA.debugLine="Public Sub getTextColor As Int";
 //BA.debugLineNum = 230;BA.debugLine="Return lblSpinner.TextColor";
if (true) return [self._lblspinner TextColor];
 //BA.debugLineNum = 231;BA.debugLine="End Sub";
return 0;
}
- (int)  _gettextsize{
 //BA.debugLineNum = 236;BA.debugLine="Public Sub getTextSize As Int";
 //BA.debugLineNum = 237;BA.debugLine="Return lblSpinner.Font.Size";
if (true) return (int) ([[self._lblspinner Font] Size]);
 //BA.debugLineNum = 238;BA.debugLine="End Sub";
return 0;
}
- (int)  _gettop{
 //BA.debugLineNum = 271;BA.debugLine="Public Sub getTop As Int";
 //BA.debugLineNum = 272;BA.debugLine="If pnlBase.IsInitialized Then";
if ([self._pnlbase IsInitialized]) { 
 //BA.debugLineNum = 273;BA.debugLine="Return pnlBase.Top";
if (true) return (int) ([self._pnlbase Top]);
 }else {
 //BA.debugLineNum = 275;BA.debugLine="Return lblSpinner.Top";
if (true) return (int) ([self._lblspinner Top]);
 };
 //BA.debugLineNum = 277;BA.debugLine="End Sub";
return 0;
}
- (B4IViewWrapper*)  _getview{
 //BA.debugLineNum = 215;BA.debugLine="Public Sub getView As View";
 //BA.debugLineNum = 216;BA.debugLine="Return lblSpinner";
if (true) return (B4IViewWrapper*) [B4IObjectWrapper createWrapper:[B4IViewWrapper new] object:(UIView*)((self._lblspinner).object)];
 //BA.debugLineNum = 217;BA.debugLine="End Sub";
return nil;
}
- (BOOL)  _getvisible{
 //BA.debugLineNum = 159;BA.debugLine="Public Sub getVisible As Boolean";
 //BA.debugLineNum = 160;BA.debugLine="If (pnlBase.IsInitialized) Then";
if (([self._pnlbase IsInitialized])) { 
 //BA.debugLineNum = 161;BA.debugLine="Return pnlBase.Visible";
if (true) return [self._pnlbase Visible];
 }else {
 //BA.debugLineNum = 163;BA.debugLine="Return lblSpinner.Visible";
if (true) return [self._lblspinner Visible];
 };
 //BA.debugLineNum = 165;BA.debugLine="End Sub";
return false;
}
- (int)  _getwidth{
 //BA.debugLineNum = 287;BA.debugLine="Public Sub getWidth As Int";
 //BA.debugLineNum = 288;BA.debugLine="Return lblSpinner.Width";
if (true) return (int) ([self._lblspinner Width]);
 //BA.debugLineNum = 289;BA.debugLine="End Sub";
return 0;
}
- (int)  _indexof:(NSString*) _value{
 //BA.debugLineNum = 202;BA.debugLine="Public Sub IndexOf (value As String) As Int";
 //BA.debugLineNum = 203;BA.debugLine="Return itemList.IndexOf(value)";
if (true) return [self._itemlist IndexOf:(NSObject*)(_value)];
 //BA.debugLineNum = 204;BA.debugLine="End Sub";
return 0;
}
- (NSString*)  _initialize:(B4I*) _ba :(NSObject*) _targetmodule :(NSString*) _eventname{
[self initializeClassModule];
 //BA.debugLineNum = 80;BA.debugLine="Public Sub Initialize(TargetModule As Object, Even";
 //BA.debugLineNum = 81;BA.debugLine="mEventName = EventName";
self._meventname = _eventname;
 //BA.debugLineNum = 82;BA.debugLine="CallBack   = TargetModule";
self._callback = _targetmodule;
 //BA.debugLineNum = 84;BA.debugLine="isEnabled = True";
self._isenabled = [self.__c True];
 //BA.debugLineNum = 85;BA.debugLine="isInit    = True";
self._isinit = [self.__c True];
 //BA.debugLineNum = 87;BA.debugLine="lblSpinner.Initialize(\"lblSpinner\")";
[self._lblspinner Initialize:self.bi :@"lblSpinner"];
 //BA.debugLineNum = 88;BA.debugLine="lblSpinner.Color     = Colors.Transparent ' So we";
[self._lblspinner setColor:[[self.__c Colors] Transparent]];
 //BA.debugLineNum = 89;BA.debugLine="lblSpinner.Multiline = False";
[self._lblspinner setMultiline:[self.__c False]];
 //BA.debugLineNum = 90;BA.debugLine="lblSpinner.Text  = \"\"";
[self._lblspinner setText:@""];
 //BA.debugLineNum = 91;BA.debugLine="lblSpinner.TextAlignment = lblSpinner.ALIGNMENT_C";
[self._lblspinner setTextAlignment:[self._lblspinner ALIGNMENT_CENTER]];
 //BA.debugLineNum = 93;BA.debugLine="itemList.Initialize";
[self._itemlist Initialize];
 //BA.debugLineNum = 95;BA.debugLine="selectedIdx = 0";
self._selectedidx = (int) (0);
 //BA.debugLineNum = 96;BA.debugLine="End Sub";
return @"";
}
- (BOOL)  _isinitialized{
 //BA.debugLineNum = 147;BA.debugLine="Public Sub IsInitialized As Boolean";
 //BA.debugLineNum = 148;BA.debugLine="Return isInit";
if (true) return self._isinit;
 //BA.debugLineNum = 149;BA.debugLine="End Sub";
return false;
}
- (NSString*)  _lblspinner_click{
 //BA.debugLineNum = 120;BA.debugLine="Private Sub lblSpinner_Click";
 //BA.debugLineNum = 121;BA.debugLine="actSheet.Initialize (\"actSpinner\", \"\", itemList.G";
[self._actsheet Initialize:self.bi :@"actSpinner" :@"" :[self.bi ObjectToString:[self._itemlist Get:self._selectedidx]] :@"" :self._itemlist];
 //BA.debugLineNum = 122;BA.debugLine="actSheet.Show (GetParent(lblSpinner))";
[self._actsheet Show:(UIView*)(([self _getparent:(B4IViewWrapper*) [B4IObjectWrapper createWrapper:[B4IViewWrapper new] object:(UIView*)((self._lblspinner).object)]]).object)];
 //BA.debugLineNum = 123;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _removeview{
 //BA.debugLineNum = 359;BA.debugLine="Public Sub RemoveView";
 //BA.debugLineNum = 360;BA.debugLine="If pnlBase.IsInitialized Then";
if ([self._pnlbase IsInitialized]) { 
 //BA.debugLineNum = 361;BA.debugLine="pnlBase.RemoveViewFromParent";
[self._pnlbase RemoveViewFromParent];
 }else {
 //BA.debugLineNum = 363;BA.debugLine="lblSpinner.RemoveViewFromParent";
[self._lblspinner RemoveViewFromParent];
 };
 //BA.debugLineNum = 365;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _removeviewfromparent{
 //BA.debugLineNum = 368;BA.debugLine="Public Sub RemoveViewFromParent";
 //BA.debugLineNum = 369;BA.debugLine="RemoveView";
[self _removeview];
 //BA.debugLineNum = 370;BA.debugLine="End Sub";
return @"";
}
- (BOOL)  _requestfocus{
 //BA.debugLineNum = 167;BA.debugLine="public Sub RequestFocus As Boolean";
 //BA.debugLineNum = 168;BA.debugLine="Return lblSpinner.RequestFocus";
if (true) return [self._lblspinner RequestFocus];
 //BA.debugLineNum = 169;BA.debugLine="End Sub";
return false;
}
- (NSString*)  _sendtoback{
 //BA.debugLineNum = 351;BA.debugLine="Public Sub SendToBack";
 //BA.debugLineNum = 352;BA.debugLine="If pnlBase.IsInitialized Then";
if ([self._pnlbase IsInitialized]) { 
 //BA.debugLineNum = 353;BA.debugLine="pnlBase.SendToBack";
[self._pnlbase SendToBack];
 }else {
 //BA.debugLineNum = 355;BA.debugLine="lblSpinner.SendToBack";
[self._lblspinner SendToBack];
 };
 //BA.debugLineNum = 357;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _setborder:(float) _width :(int) _colour :(float) _radius{
 //BA.debugLineNum = 339;BA.debugLine="Sub SetBorder (width As Float, colour As Int, radi";
 //BA.debugLineNum = 340;BA.debugLine="lblSpinner.SetBorder (width, colour, radius)";
[self._lblspinner SetBorder:_width :_colour :_radius];
 //BA.debugLineNum = 341;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _setcallbackmodule:(NSObject*) _parentmod{
 //BA.debugLineNum = 115;BA.debugLine="Sub SetCallbackModule (parentMod As Object)";
 //BA.debugLineNum = 116;BA.debugLine="CallBack   = parentMod";
self._callback = _parentmod;
 //BA.debugLineNum = 117;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _setcolor:(int) _color{
 //BA.debugLineNum = 304;BA.debugLine="Public Sub setColor (color As Int)";
 //BA.debugLineNum = 305;BA.debugLine="lblSpinner.Color = color";
[self._lblspinner setColor:_color];
 //BA.debugLineNum = 306;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _setenabled:(BOOL) _enab{
 //BA.debugLineNum = 171;BA.debugLine="Public Sub setEnabled(enab As Boolean)";
 //BA.debugLineNum = 172;BA.debugLine="isEnabled = enab";
self._isenabled = _enab;
 //BA.debugLineNum = 173;BA.debugLine="lblSpinner.UserInteractionEnabled = isEnabled";
[self._lblspinner setUserInteractionEnabled:self._isenabled];
 //BA.debugLineNum = 174;BA.debugLine="If isEnabled Then";
if (self._isenabled) { 
 //BA.debugLineNum = 175;BA.debugLine="lblSpinner.Alpha = 1.0";
[self._lblspinner setAlpha:(float) (1.0)];
 }else {
 //BA.debugLineNum = 177;BA.debugLine="lblSpinner.Alpha = 0.3";
[self._lblspinner setAlpha:(float) (0.3)];
 };
 //BA.debugLineNum = 179;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _setheight:(int) _height{
 //BA.debugLineNum = 299;BA.debugLine="Public Sub setHeight(Height As Int)";
 //BA.debugLineNum = 300;BA.debugLine="If pnlBase.IsInitialized Then pnlBase.Height = He";
if ([self._pnlbase IsInitialized]) { 
[self._pnlbase setHeight:(float) (_height)];};
 //BA.debugLineNum = 301;BA.debugLine="lblSpinner.Height = Height";
[self._lblspinner setHeight:(float) (_height)];
 //BA.debugLineNum = 302;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _setlayout:(int) _left :(int) _top :(int) _width :(int) _height{
 //BA.debugLineNum = 308;BA.debugLine="public Sub SetLayout (left As Int, top As Int, wid";
 //BA.debugLineNum = 309;BA.debugLine="If pnlBase.IsInitialized Then";
if ([self._pnlbase IsInitialized]) { 
 //BA.debugLineNum = 310;BA.debugLine="pnlBase.Left   = left";
[self._pnlbase setLeft:(float) (_left)];
 //BA.debugLineNum = 311;BA.debugLine="pnlBase.Top    = top";
[self._pnlbase setTop:(float) (_top)];
 //BA.debugLineNum = 312;BA.debugLine="pnlBase.Width  = width";
[self._pnlbase setWidth:(float) (_width)];
 //BA.debugLineNum = 313;BA.debugLine="pnlBase.Height = height";
[self._pnlbase setHeight:(float) (_height)];
 //BA.debugLineNum = 315;BA.debugLine="lblSpinner.Width  = width";
[self._lblspinner setWidth:(float) (_width)];
 //BA.debugLineNum = 316;BA.debugLine="lblSpinner.Height = height";
[self._lblspinner setHeight:(float) (_height)];
 }else {
 //BA.debugLineNum = 318;BA.debugLine="lblSpinner.Left   = left";
[self._lblspinner setLeft:(float) (_left)];
 //BA.debugLineNum = 319;BA.debugLine="lblSpinner.Top    = top";
[self._lblspinner setTop:(float) (_top)];
 //BA.debugLineNum = 320;BA.debugLine="lblSpinner.Width  = width";
[self._lblspinner setWidth:(float) (_width)];
 //BA.debugLineNum = 321;BA.debugLine="lblSpinner.Height = height";
[self._lblspinner setHeight:(float) (_height)];
 };
 //BA.debugLineNum = 323;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _setlayoutanimated:(int) _durationms :(int) _left :(int) _top :(int) _width :(int) _height{
 //BA.debugLineNum = 326;BA.debugLine="Public Sub SetLayoutAnimated (durationMS As Int, l";
 //BA.debugLineNum = 327;BA.debugLine="If pnlBase.IsInitialized Then";
if ([self._pnlbase IsInitialized]) { 
 //BA.debugLineNum = 328;BA.debugLine="pnlBase.SetLayoutAnimated   (durationMS, 1.0, le";
[self._pnlbase SetLayoutAnimated:_durationms :(float) (1.0) :(float) (_left) :(float) (_top) :(float) (_width) :(float) (_height)];
 //BA.debugLineNum = 329;BA.debugLine="lblSpinner.SetLayoutAnimated(durationMS, 1.0, 0";
[self._lblspinner SetLayoutAnimated:_durationms :(float) (1.0) :(float) (0) :(float) (0) :(float) (_width) :(float) (_height)];
 }else {
 //BA.debugLineNum = 331;BA.debugLine="lblSpinner.SetLayoutAnimated   (durationMS, 1.0,";
[self._lblspinner SetLayoutAnimated:_durationms :(float) (1.0) :(float) (_left) :(float) (_top) :(float) (_width) :(float) (_height)];
 };
 //BA.debugLineNum = 333;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _setleft:(int) _left{
 //BA.debugLineNum = 263;BA.debugLine="Public Sub setLeft(Left As Int)";
 //BA.debugLineNum = 264;BA.debugLine="If pnlBase.IsInitialized Then";
if ([self._pnlbase IsInitialized]) { 
 //BA.debugLineNum = 265;BA.debugLine="pnlBase.Left = Left";
[self._pnlbase setLeft:(float) (_left)];
 }else {
 //BA.debugLineNum = 267;BA.debugLine="lblSpinner.Left = Left";
[self._lblspinner setLeft:(float) (_left)];
 };
 //BA.debugLineNum = 269;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _setselectedindex:(int) _idx{
 //BA.debugLineNum = 185;BA.debugLine="Public Sub setSelectedIndex (idx As Int)";
 //BA.debugLineNum = 186;BA.debugLine="selectedIdx = idx";
self._selectedidx = _idx;
 //BA.debugLineNum = 187;BA.debugLine="lblSpinner.Text = itemList.Get(idx)";
[self._lblspinner setText:[self.bi ObjectToString:[self._itemlist Get:_idx]]];
 //BA.debugLineNum = 188;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _settag:(NSObject*) _tag{
 //BA.debugLineNum = 378;BA.debugLine="Public Sub setTag(Tag As Object)";
 //BA.debugLineNum = 379;BA.debugLine="lblSpinner.Tag = Tag";
[self._lblspinner setTag:_tag];
 //BA.debugLineNum = 380;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _settextalignment:(int) _align{
 //BA.debugLineNum = 249;BA.debugLine="Public Sub setTextAlignment (align As Int)";
 //BA.debugLineNum = 250;BA.debugLine="lblSpinner.TextAlignment = align";
[self._lblspinner setTextAlignment:_align];
 //BA.debugLineNum = 251;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _settextcolor:(int) _col{
 //BA.debugLineNum = 232;BA.debugLine="Public Sub setTextColor(Col As Int)";
 //BA.debugLineNum = 233;BA.debugLine="lblSpinner.TextColor = Col";
[self._lblspinner setTextColor:_col];
 //BA.debugLineNum = 234;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _settextsize:(int) _textsize{
 //BA.debugLineNum = 240;BA.debugLine="Public Sub setTextSize(TextSize As Int)";
 //BA.debugLineNum = 241;BA.debugLine="lblSpinner.Font = lblSpinner.Font.CreateNew(TextS";
[self._lblspinner setFont:[[self._lblspinner Font] CreateNew:(float) (_textsize)]];
 //BA.debugLineNum = 242;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _settop:(int) _top{
 //BA.debugLineNum = 279;BA.debugLine="Public Sub setTop(Top As Int)";
 //BA.debugLineNum = 280;BA.debugLine="If pnlBase.IsInitialized Then";
if ([self._pnlbase IsInitialized]) { 
 //BA.debugLineNum = 281;BA.debugLine="pnlBase.Top = Top";
[self._pnlbase setTop:(float) (_top)];
 }else {
 //BA.debugLineNum = 283;BA.debugLine="lblSpinner.Top = Top";
[self._lblspinner setTop:(float) (_top)];
 };
 //BA.debugLineNum = 285;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _setvisible:(BOOL) _visible{
 //BA.debugLineNum = 151;BA.debugLine="Public Sub setVisible(Visible As Boolean)";
 //BA.debugLineNum = 152;BA.debugLine="If (pnlBase.IsInitialized) Then";
if (([self._pnlbase IsInitialized])) { 
 //BA.debugLineNum = 153;BA.debugLine="pnlBase.Visible = Visible";
[self._pnlbase setVisible:_visible];
 }else {
 //BA.debugLineNum = 155;BA.debugLine="lblSpinner.Visible = Visible";
[self._lblspinner setVisible:_visible];
 };
 //BA.debugLineNum = 157;BA.debugLine="End Sub";
return @"";
}
- (NSString*)  _setwidth:(int) _width{
 //BA.debugLineNum = 291;BA.debugLine="Public Sub setWidth(Width As Int)";
 //BA.debugLineNum = 292;BA.debugLine="If pnlBase.IsInitialized Then pnlBase.Width = Wid";
if ([self._pnlbase IsInitialized]) { 
[self._pnlbase setWidth:(float) (_width)];};
 //BA.debugLineNum = 293;BA.debugLine="lblSpinner.Width = Width";
[self._lblspinner setWidth:(float) (_width)];
 //BA.debugLineNum = 294;BA.debugLine="End Sub";
return @"";
}
- (int)  _size{
 //BA.debugLineNum = 223;BA.debugLine="Public Sub Size As Int";
 //BA.debugLineNum = 224;BA.debugLine="Return itemList.Size";
if (true) return [self._itemlist Size];
 //BA.debugLineNum = 225;BA.debugLine="End Sub";
return 0;
}
@end
