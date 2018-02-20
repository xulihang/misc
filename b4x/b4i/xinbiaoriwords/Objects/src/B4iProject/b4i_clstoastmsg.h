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
@class b4i_spinner;
@class b4i_change;
@interface b4i_clstoastmsg : B4IClass
- (NSString*)  _class_globals;
@property (nonatomic)B4IPage* _pgparent;
@property (nonatomic)B4IPanelWrapper* _pnlmessage;
@property (nonatomic)B4ILabelWrapper* _lblmessage;
@property (nonatomic)B4ITimer* _tmrtimer;
@property (nonatomic)B4ITimer* _tmrtimer2;
@property (nonatomic)b4i_main* _main;
@property (nonatomic)b4i_chooselesson* _chooselesson;
@property (nonatomic)b4i_content* _content;
@property (nonatomic)b4i_search* _search;
@property (nonatomic)b4i_dohelper* _dohelper;
@property (nonatomic)b4i_webpageview* _webpageview;
- (NSString*)  _hidemessage;
- (NSString*)  _initialize:(B4I*) _ba :(B4IPage*) _parentpage :(float) _textsize :(BOOL) _shadow;
- (NSString*)  _pnlmessage_touch:(int) _action :(float) _x :(float) _y;
- (NSString*)  _showtoastmessage:(NSString*) _message :(int) _tinterval;
- (NSString*)  _tmrtimer_tick;
- (NSString*)  _tmrtimer2_tick;
@end
