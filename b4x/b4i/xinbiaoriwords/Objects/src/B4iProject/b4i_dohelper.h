#import "iCore.h"
#import "iSQL.h"
#import "iPhone.h"
#import "iStringUtils.h"
@class b4i_main;
@class b4i_chooselesson;
@class b4i_content;
@class b4i_search;
@class b4i_webpageview;
@class b4i_customlistview;
@class b4i_spinner;
@class b4i_change;
@class b4i_clstoastmsg;
@interface b4i_dohelper : B4IStaticModule
- (NSString*)  _customlistview1_itemclick:(int) _index :(NSObject*) _value;
- (NSString*)  _loadlist;
- (NSString*)  _process_globals;
@property (nonatomic)B4IPage* _page2;
@property (nonatomic)b4i_customlistview* _customlistview1;
@property (nonatomic)NSString* _lesson;
@property (nonatomic)NSString* _nihongo;
@property (nonatomic)b4i_clstoastmsg* _toast;
@property (nonatomic)b4i_main* _main;
@property (nonatomic)b4i_chooselesson* _chooselesson;
@property (nonatomic)b4i_content* _content;
@property (nonatomic)b4i_search* _search;
@property (nonatomic)b4i_webpageview* _webpageview;
- (NSString*)  _show;
@end
