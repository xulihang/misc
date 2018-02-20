#import "iCore.h"
#import "iSQL.h"
#import "iPhone.h"
#import "iStringUtils.h"
@class b4i_chooselesson;
@class b4i_content;
@class b4i_search;
@class b4i_dohelper;
@class b4i_webpageview;
@class b4i_customlistview;
@class b4i_spinner;
@class b4i_change;
@class b4i_clstoastmsg;
@interface b4i_main : B4IStaticModule
- (NSString*)  _application_background;
- (NSString*)  _application_start:(B4INavigationControllerWrapper*) _nav;
- (NSString*)  _customlistview1_itemclick:(int) _index :(NSObject*) _value;
- (NSString*)  _loadlist;
- (NSString*)  _page1_resize:(int) _width :(int) _height;
- (NSString*)  _process_globals;
@property (nonatomic)B4IApplicationWrapper* _app;
@property (nonatomic)B4INavigationControllerWrapper* _navcontrol;
@property (nonatomic)int _book;
@property (nonatomic)B4IPage* _page1;
@property (nonatomic)b4i_customlistview* _customlistview1;
@property (nonatomic)b4i_chooselesson* _chooselesson;
@property (nonatomic)b4i_content* _content;
@property (nonatomic)b4i_search* _search;
@property (nonatomic)b4i_dohelper* _dohelper;
@property (nonatomic)b4i_webpageview* _webpageview;
@end
