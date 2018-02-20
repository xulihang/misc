
#import "iCore.h"
@interface LS_main:NSObject
@end

@implementation LS_main

- (void)LS_general:(B4ILayoutData*)views :(int)width :(int)height{
[B4ILayoutBuilder setScaleRate:0.3];
[B4ILayoutBuilder scaleAll:views :width :height];
[views get:@"customlistview1"].Height = (int)((100 / 100.0 * height));
//BA.debugLineNum = 4;BA.debugLine="CustomListView1.Width=100%x"[main/General script]
[views get:@"customlistview1"].Width = (int)((100 / 100.0 * width));

}
@end