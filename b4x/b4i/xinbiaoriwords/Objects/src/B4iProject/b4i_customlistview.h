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
@class b4i_spinner;
@class b4i_change;
@class b4i_clstoastmsg;
@interface b4i_customlistview : B4IClass
- (NSString*)  _add:(B4IPanelWrapper*) _pnl :(int) _itemheight :(NSObject*) _value;
- (NSString*)  _addtextitem:(NSString*) _text :(NSObject*) _value;
- (NSString*)  _base_resize:(double) _width :(double) _height;
- (NSString*)  _class_globals;
@property (nonatomic)NSString* _eventname;
@property (nonatomic)NSObject* _callback;
@property (nonatomic)B4IWeakRef* _mbase;
@property (nonatomic)B4IScrollView* _sv;
@property (nonatomic)B4IList* _items;
@property (nonatomic)B4IList* _panels;
@property (nonatomic)float _dividerheight;
@property (nonatomic)B4IFontWrapper* _defaulttextfont;
@property (nonatomic)int _defaulttextcolor;
@property (nonatomic)int _defaulttextbackgroundcolor;
@property (nonatomic)int _highlightcolor;
@property (nonatomic)b4i_main* _main;
@property (nonatomic)b4i_chooselesson* _chooselesson;
@property (nonatomic)b4i_content* _content;
@property (nonatomic)b4i_search* _search;
@property (nonatomic)b4i_dohelper* _dohelper;
@property (nonatomic)b4i_webpageview* _webpageview;
- (NSString*)  _clear;
- (NSString*)  _designercreateview:(B4IPanelWrapper*) _base :(B4ILabelWrapper*) _lbl :(B4IMap*) _props;
- (B4IPanelWrapper*)  _getbase;
- (int)  _getitemfromview:(B4IViewWrapper*) _v;
- (B4IPanelWrapper*)  _getpanel:(int) _index;
- (int)  _getsize;
- (NSObject*)  _getvalue:(int) _index;
- (NSString*)  _initialize:(B4I*) _ba :(NSObject*) _vcallback :(NSString*) _veventname;
- (NSString*)  _insertat:(int) _index :(B4IPanelWrapper*) _pnl :(int) _itemheight :(NSObject*) _value;
- (NSString*)  _insertattextitem:(int) _index :(NSString*) _text :(NSObject*) _value;
- (NSString*)  _jumptoitem:(int) _index;
- (NSString*)  _panel_click;
- (NSString*)  _panel_longclick;
- (NSString*)  _removeat:(int) _index;
- (NSString*)  _setoffset:(int) _y;
@end
