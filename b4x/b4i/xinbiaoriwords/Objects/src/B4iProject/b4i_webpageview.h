#import "iCore.h"
#import "iSQL.h"
#import "iPhone.h"
#import "iStringUtils.h"
@class b4i_main;
@class b4i_chooselesson;
@class b4i_content;
@class b4i_search;
@class b4i_dohelper;
@class b4i_customlistview;
@class b4i_spinner;
@class b4i_change;
@class b4i_clstoastmsg;
@interface b4i_webpageview : B4IStaticModule
- (NSString*)  _page2_barbuttonclick:(NSString*) _tag;
- (NSString*)  _process_globals;
@property (nonatomic)B4IPage* _page2;
@property (nonatomic)B4IWebViewWrapper* _webview1;
@property (nonatomic)NSString* _uri;
@property (nonatomic)b4i_main* _main;
@property (nonatomic)b4i_chooselesson* _chooselesson;
@property (nonatomic)b4i_content* _content;
@property (nonatomic)b4i_search* _search;
@property (nonatomic)b4i_dohelper* _dohelper;
- (NSString*)  _show;
@end
