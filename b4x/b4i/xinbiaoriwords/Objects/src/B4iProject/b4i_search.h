#import "iCore.h"
#import "iSQL.h"
#import "iPhone.h"
#import "iStringUtils.h"
@class b4i_main;
@class b4i_chooselesson;
@class b4i_content;
@class b4i_dohelper;
@class b4i_webpageview;
@class b4i_customlistview;
@class b4i_spinner;
@class b4i_change;
@class b4i_clstoastmsg;
@interface b4i_search : B4IStaticModule
- (NSString*)  _additem:(NSString*) _nihongo :(NSString*) _kana :(NSString*) _kanji :(NSString*) _pronunication :(NSString*) _wordtype :(NSString*) _lesson;
- (NSString*)  _customlistview1_itemclick:(int) _index :(NSObject*) _value;
- (NSString*)  _label2_click;
- (NSString*)  _loaddict:(NSString*) _searchtype;
- (NSString*)  _process_globals;
@property (nonatomic)B4IPage* _page2;
@property (nonatomic)b4i_customlistview* _customlistview1;
@property (nonatomic)b4i_spinner* _spinner1;
@property (nonatomic)B4ITextFieldWrapper* _textfield1;
@property (nonatomic)B4ISQL* _sql1;
@property (nonatomic)B4ITTS* _tts1;
@property (nonatomic)b4i_clstoastmsg* _toast;
@property (nonatomic)b4i_main* _main;
@property (nonatomic)b4i_chooselesson* _chooselesson;
@property (nonatomic)b4i_content* _content;
@property (nonatomic)b4i_dohelper* _dohelper;
@property (nonatomic)b4i_webpageview* _webpageview;
- (NSString*)  _show;
- (NSString*)  _spinner1_itemclick:(int) _index :(NSObject*) _value;
@end
