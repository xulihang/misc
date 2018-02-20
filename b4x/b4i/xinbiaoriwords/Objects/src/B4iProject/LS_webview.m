
#import "iCore.h"
@interface LS_webview:NSObject
@end

@implementation LS_webview

- (void)LS_general:(B4ILayoutData*)views :(int)width :(int)height{
[B4ILayoutBuilder setScaleRate:0.3];
[B4ILayoutBuilder scaleAll:views :width :height];
[views get:@"webview1"].Width = (int)((100 / 100.0 * width));
[views get:@"webview1"].Height = (int)((100 / 100.0 * height));

}
@end