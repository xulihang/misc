
#import "iCore.h"
@interface LS_item:NSObject
@end

@implementation LS_item

- (void)LS_general:(B4ILayoutData*)views :(int)width :(int)height{
[B4ILayoutBuilder setScaleRate:0.3];
//BA.debugLineNum = 2;BA.debugLine="AutoScaleAll"[item/General script]
[B4ILayoutBuilder scaleAll:views :width :height];
//BA.debugLineNum = 3;BA.debugLine="Label1.Width=100%x-Label2.Width"[item/General script]
[views get:@"label1"].Width = (int)((100 / 100.0 * width)-([views get:@"label2"].Width));
//BA.debugLineNum = 4;BA.debugLine="Label2.Left=Label1.Width"[item/General script]
[views get:@"label2"].Left = (int)(([views get:@"label1"].Width));

}
@end