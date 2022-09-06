//
//  JHConnetcMicDetailView.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/28.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "LiveRedPacketView.h"
#import "UIView+NTES.h"
#import "NTESDataManager.h"
#import "NIMAvatarImageView.h"
#import "NTESLiveManager.h"
#import "UIImage+GIF.h"
#import "HKClipperHelper.h"
#import "CoponPackageMode.h"
#import "NSString+AttributedString.h"
#import <QBImagePickerController/QBImagePickerController.h>
@interface LiveRedPacketView()<UIActionSheetDelegate>
{
    UILabel  *moneyLabel;
}
@end

@implementation LiveRedPacketView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [redBtn setImage:[UIImage imageNamed:@"new_live_redpocket"] forState:UIControlStateNormal];
        [redBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        redBtn.frame = CGRectMake(0, 0,self.width, self.height);
        [self addSubview:redBtn];
        
//        moneyLabel=[[UILabel alloc]init];
//        moneyLabel.font=[UIFont fontWithName:@"DINCondensed-Bold" size:14.f];
//        moneyLabel.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
//        moneyLabel.numberOfLines = 1;
//        moneyLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
//        moneyLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        [redBtn addSubview:moneyLabel];
//        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(redBtn);
//            make.top.equalTo(redBtn).offset(40);
//
//        }];
//
//        NSString * string=@"";
//        NSRange range = [string rangeOfString:@"¥"];
//        moneyLabel.attributedText=[string attributedFont:[UIFont fontWithName:@"DINCondensed-Bold" size:6.f] color:[CommHelp toUIColorByStr:@"#ffffff"] range:range];
//
//        UILabel  *title =[[UILabel alloc]init];
//        title.font=[UIFont systemFontOfSize:8];
//        title.textColor=[CommHelp toUIColorByStr:@"#ffffff"];
//        title.numberOfLines = 1;
//        title.text=@"新人红包";
//        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
//        title.lineBreakMode = NSLineBreakByWordWrapping;
//        [redBtn addSubview:title];
//        [title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(redBtn);
//            make.top.equalTo(moneyLabel.mas_bottom).offset(-2);
//
//        }];
        
    }
    return self;
}
-(void)buttonPress:(UIButton*)button{
    
    [self dismiss];
    
    if (self.buttonClick) {
        self.buttonClick(button);
    }
}
-(void)showAnimation{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.8f];
    [UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationRepeatCount:1000];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    self.frame = CGRectMake(self.mj_x, self.mj_y +10,self.width,self.height);
     [UIView commitAnimations];
  
}
-(void)setMode:(CoponPackageMode *)mode{
    
    _mode=mode;
    NSString * string=[@"¥" stringByAppendingString:_mode.totalFrPrice?:@""];
    NSRange range = [string rangeOfString:@"¥"];
    moneyLabel.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:15.f] color:[CommHelp toUIColorByStr:@"#ffffff"] range:range];
    
}
- (void)dismiss
{
    [UIView animateWithDuration:0 animations:^{
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)dealloc
{
    
    
}
@end




