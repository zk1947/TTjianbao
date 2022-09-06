//
//  JHBaseWhiteViewAlert.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseWhiteViewAlert.h"

@implementation JHBaseWhiteViewAlert

-(void)dealloc
{
    NSLog(@"🔥");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        _whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
        [_whiteView jh_cornerRadius:8];
        [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        UIButton *closeButton = [UIButton jh_buttonWithImage:@"btn_detect_close" target:self action:@selector(removeFromSuperview) addToSuperView:_whiteView];
        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.equalTo(self.whiteView);
            make.size.mas_equalTo(45);
        }];
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
