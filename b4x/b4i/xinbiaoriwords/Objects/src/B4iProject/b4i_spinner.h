#import "iCore.h"
#import "iSQL.h"
#import "iPhone.h"
#import "iStringUtils.h"
@class b4i_main;
@class b4i_chooselesson;
@class b4i_content;
@class b4i_search;
@class b4i_dohelper;
@class b4i_webpageview;
@class b4i_customlistview;
@class b4i_change;
@class b4i_clstoastmsg;
@interface b4i_spinner : B4IClass
- (NSString*)  _actspinner_click:(NSString*) _item;
- (NSString*)  _add:(NSString*) _item;
- (NSString*)  _addall:(B4IList*) _items;
- (NSString*)  _base_resize:(double) _width :(double) _height;
- (NSString*)  _bringtofront;
- (NSString*)  _class_globals;
@property (nonatomic)BOOL _isinit;
@property (nonatomic)B4IPanelWrapper* _pnlbase;
@property (nonatomic)B4ILabelWrapper* _lblspinner;
@property (nonatomic)NSObject* _callback;
@property (nonatomic)NSString* _meventname;
@property (nonatomic)int _selectedidx;
@property (nonatomic)B4IList* _itemlist;
@property (nonatomic)B4IActionSheetWrapper* _actsheet;
@property (nonatomic)BOOL _isenabled;
@property (nonatomic)int _alignment_center;
@property (nonatomic)int _alignment_left;
@property (nonatomic)int _alignment_right;
@property (nonatomic)b4i_main* _main;
@property (nonatomic)b4i_chooselesson* _chooselesson;
@property (nonatomic)b4i_content* _content;
@property (nonatomic)b4i_search* _search;
@property (nonatomic)b4i_dohelper* _dohelper;
@property (nonatomic)b4i_webpageview* _webpageview;
- (NSString*)  _clear;
- (NSString*)  _designercreateview:(B4IPanelWrapper*) _base :(B4ILabelWrapper*) _lbl :(B4IMap*) _props;
- (B4IViewWrapper*)  _getbase;
- (BOOL)  _getenabled;
- (int)  _getheight;
- (NSString*)  _getitem:(int) _index;
- (int)  _getleft;
- (B4IViewWrapper*)  _getparent:(B4IViewWrapper*) _v;
- (int)  _getselectedindex;
- (NSString*)  _getselecteditem;
- (NSObject*)  _gettag;
- (int)  _gettextalignment;
- (int)  _gettextcolor;
- (int)  _gettextsize;
- (int)  _gettop;
- (B4IViewWrapper*)  _getview;
- (BOOL)  _getvisible;
- (int)  _getwidth;
- (int)  _indexof:(NSString*) _value;
- (NSString*)  _initialize:(B4I*) _ba :(NSObject*) _targetmodule :(NSString*) _eventname;
- (BOOL)  _isinitialized;
- (NSString*)  _lblspinner_click;
- (NSString*)  _removeview;
- (NSString*)  _removeviewfromparent;
- (BOOL)  _requestfocus;
- (NSString*)  _sendtoback;
- (NSString*)  _setborder:(float) _width :(int) _colour :(float) _radius;
- (NSString*)  _setcallbackmodule:(NSObject*) _parentmod;
- (NSString*)  _setcolor:(int) _color;
- (NSString*)  _setenabled:(BOOL) _enab;
- (NSString*)  _setheight:(int) _height;
- (NSString*)  _setlayout:(int) _left :(int) _top :(int) _width :(int) _height;
- (NSString*)  _setlayoutanimated:(int) _durationms :(int) _left :(int) _top :(int) _width :(int) _height;
- (NSString*)  _setleft:(int) _left;
- (NSString*)  _setselectedindex:(int) _idx;
- (NSString*)  _settag:(NSObject*) _tag;
- (NSString*)  _settextalignment:(int) _align;
- (NSString*)  _settextcolor:(int) _col;
- (NSString*)  _settextsize:(int) _textsize;
- (NSString*)  _settop:(int) _top;
- (NSString*)  _setvisible:(BOOL) _visible;
- (NSString*)  _setwidth:(int) _width;
- (int)  _size;
@end
