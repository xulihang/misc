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
@class b4i_clstoastmsg;
@interface b4i_change : B4IClass
- (NSString*)  _changetonesymbol:(NSString*) _symbol;
- (NSString*)  _class_globals;
@property (nonatomic)b4i_main* _main;
@property (nonatomic)b4i_chooselesson* _chooselesson;
@property (nonatomic)b4i_content* _content;
@property (nonatomic)b4i_search* _search;
@property (nonatomic)b4i_dohelper* _dohelper;
@property (nonatomic)b4i_webpageview* _webpageview;
- (NSString*)  _initialize:(B4I*) _ba;
@end
