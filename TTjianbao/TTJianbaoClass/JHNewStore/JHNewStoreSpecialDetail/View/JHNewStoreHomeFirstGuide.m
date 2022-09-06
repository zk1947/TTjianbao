//
//  JHNewStoreHomeFirstGuide.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeFirstGuide.h"

@implementation JHNewStoreHomeFirstGuide


+ (instancetype)signAppealpopWindow{
    static JHNewStoreHomeFirstGuide * appealPop = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appealPop  = [[self alloc] init];
    });
    return appealPop;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self creatAppealAlertView];
    }
    return self;
}

- (void)creatAppealAlertView{
    
    
    UIImageView *whiteView = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"newStoreHomeFirstGuide"] addToSuperview:self];
    whiteView.userInteractionEnabled = YES;
//    whiteView.layer.cornerRadius
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(270, 317));
    }];
    
//    newStoreHomeFirstGuide_close
    
    UIButton *cancleButton = [UIButton jh_buttonWithTarget:self action:@selector(cancleAction) addToSuperView:self];
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"newStoreHomeFirstGuide_close"] forState:UIControlStateNormal];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.right.equalTo(whiteView).offset(0);
        make.width.mas_equalTo(30);
        make.bottom.mas_equalTo(whiteView.mas_top).offset(-12);
    }];
    

    UIButton *cancleButton1 = [UIButton jh_buttonWithTarget:self action:@selector(cancleAction) addToSuperView:whiteView];
    [cancleButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.right.equalTo(whiteView).offset(-40);
        make.left.mas_equalTo(40);
        make.bottom.mas_equalTo(whiteView.mas_bottom).offset(-20);
    }];
    
}
- (void)show{
    UIView *alertSuperView = [UIApplication sharedApplication].keyWindow;
    [alertSuperView addSubview:self];
}
-(void)cancleAction{
    
    [self removeFromSuperview];
}

@end
