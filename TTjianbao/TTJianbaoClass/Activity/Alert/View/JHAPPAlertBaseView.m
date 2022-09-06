//
//  JHAPPAlertBaseView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAPPAlertBaseView.h"
#import "JHAppAlertViewManger.h"
@implementation JHAPPAlertBaseView

- (void)dealloc {
    [JHAppAlertViewManger appAlertshowing:NO];
    NSLog(@"🔥");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        ///由于图层不一致，甚至window,endEditing 不起作用
        [[UIApplication sharedApplication]
        sendAction:@selector(resignFirstResponder) to:nil from:nil
        forEvent:nil];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
