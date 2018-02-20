
#import "iCore.h"
@interface LS_search:NSObject
@end

@implementation LS_search

- (void)LS_general:(B4ILayoutData*)views :(int)width :(int)height{
[B4ILayoutBuilder setScaleRate:0.3];
[B4ILayoutBuilder scaleAll:views :width :height];
[views get:@"textfield1"].Width = (int)((100 / 100.0 * width)-([views get:@"spinner1"].Width));
//BA.debugLineNum = 4;BA.debugLine="Spinner1.Left=TextField1.Width"[search/General script]
[views get:@"spinner1"].Left = (int)(([views get:@"textfield1"].Width));
//BA.debugLineNum = 5;BA.debugLine="CustomListView1.Top=TextField1.Height"[search/General script]
[views get:@"customlistview1"].Top = (int)(([views get:@"textfield1"].Height));
//BA.debugLineNum = 6;BA.debugLine="CustomListView1.Height=100%y-Spinner1.Height"[search/General script]
[views get:@"customlistview1"].Height = (int)((100 / 100.0 * height)-([views get:@"spinner1"].Height));
//BA.debugLineNum = 7;BA.debugLine="CustomListView1.Width=100%x"[search/General script]
[views get:@"customlistview1"].Width = (int)((100 / 100.0 * width));

}
@end