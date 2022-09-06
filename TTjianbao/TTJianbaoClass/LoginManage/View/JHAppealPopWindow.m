//
//  JHAppealPopWindow.m
//  TTjianbao
//
//  Created by apple on 2020/9/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAppealPopWindow.h"
#import "UIView+JHGradient.h"

@implementation JHAppealPopWindow

+ (instancetype)signAppealpopVindow{
    static JHAppealPopWindow * appealPop = nil;
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
        self.backgroundColor = RGBA(0, 0, 0, 0.6);
        [self creatAppealAlertView];
    }
    return self;
}

- (void)creatAppealAlertView{
    
    
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [whiteView jh_cornerRadius:4];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(260, 198));
    }];
    
    
    NSMutableParagraphStyle * pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.lineSpacing = 7;
    pstyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSParagraphStyleAttributeName:pstyle};
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:@"因涉嫌严重违规行为你的账号已被封禁" attributes:attributes];
    UILabel *titleLabel = [UILabel jh_labelWithText:@"" font:15 textColor:RGB(51, 51, 51) textAlignment:NSTextAlignmentCenter addToSuperView:whiteView];
    titleLabel.attributedText = attStr;
    titleLabel.numberOfLines = 0;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView).offset(39.f);
        make.left.equalTo(whiteView).offset(40.f);
        make.right.equalTo(whiteView).offset(-40.f);
    }];
    
    
    UILabel *descLabel = [UILabel jh_labelWithText:@"可通过下方申诉入口申请解封" font:12 textColor:HEXCOLOR(0x999999) textAlignment:NSTextAlignmentCenter addToSuperView:whiteView];
       descLabel.attributedText = attStr;
       descLabel.numberOfLines = 0;
       [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(titleLabel.mas_bottom).offset(10.f);
           make.left.equalTo(whiteView).offset(20.f);
           make.right.equalTo(whiteView).offset(-20.f);
       }];
    
    UIButton *cancleButton = [UIButton jh_buttonWithTarget:self action:@selector(cancleAction) addToSuperView:whiteView];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancleButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [cancleButton jh_cornerRadius:20.f];
    [cancleButton jh_borderWithColor:HEXCOLOR(0xBDBFC2) borderWidth:0.5];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(whiteView).offset(15);
        make.width.mas_equalTo(110);
        make.bottom.equalTo(whiteView).offset(-20);
    }];
    
    UIButton *signButton = [UIButton jh_buttonWithTitle:@"去申诉" fontSize:15 textColor:RGB(51, 51, 51) target:self action:@selector(signAction) addToSuperView:whiteView];
    [signButton jh_cornerRadius:20.f];
    [signButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.bottom.equalTo(cancleButton);
        make.right.equalTo(whiteView).offset(-15);
    }];
    
}
- (void)show{
    UIView *alertSuperView = [UIApplication sharedApplication].keyWindow;
    [alertSuperView addSubview:self];
}
-(void)cancleAction{
    
    [self removeFromSuperview];
}

- (void)signAction{
    [self cancleAction];
    if (self.btnClickedBlock) {
        self.btnClickedBlock();
    }
}

@end
