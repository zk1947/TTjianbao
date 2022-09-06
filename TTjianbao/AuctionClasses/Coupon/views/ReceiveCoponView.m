//
//  JHConnetcMicDetailView.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/28.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "ReceiveCoponView.h"
#import "UIView+NTES.h"
#import "NTESDataManager.h"
#import "NIMAvatarImageView.h"
#import "NTESLiveManager.h"
#import "UIImage+GIF.h"
#import "HKClipperHelper.h"
#import "CoponPackageMode.h"
#import "TTjianbaoHeader.h"
#import "NSString+AttributedString.h"
#import "UserInfoRequestManager.h"
#import <QBImagePickerController/QBImagePickerController.h>
@interface ReceiveCoponView()<UIActionSheetDelegate>
{
    UIImageView *animationImageView;
    UIImageView * backImageView ;
    UILabel  *moneyLabel;
    UIButton  * btn;
    UIButton  * closeBtn;
}
@property (nonatomic, strong)  UIControl *back;
@property(nonatomic,strong) UIScrollView * contentScroll;

@end

@implementation ReceiveCoponView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
       // self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.8f];
//        _back=[[UIControl alloc]initWithFrame:self.frame];
//        [self addSubview:_back];
//
//        animationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"receive_copon-loading"]];
//        animationImageView.contentMode=UIViewContentModeScaleAspectFill;
//        [_back addSubview:animationImageView];
//
//        [animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(_back);
//            make.centerY.equalTo(_back).offset(-50);
//        }];
//
//        CABasicAnimation*rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
//        rotationAnimation.duration = 4.0;
//        rotationAnimation.cumulative =NO;
//        rotationAnimation.repeatCount = INTMAX_MAX;
//        [animationImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
        
        backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_copon_back"]];
      //  backImageView.contentMode=UIViewContentModeScaleAspectFill;
        backImageView.userInteractionEnabled=YES;
        backImageView.frame= CGRectMake((ScreenW-255)/2.,( ScreenH-302)/2., 255, 302);
        [self addSubview:backImageView];
        
//        [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self);
//            make.centerY.equalTo(self).offset(0);
//            make.size.mas_equalTo(CGSizeMake(255, 302));
//        }];
        
        
       //
//        moneyLabel=[[UILabel alloc]init];
//        moneyLabel.font=[UIFont fontWithName:@"DINCondensed-Bold" size:33.f];
//        moneyLabel.textColor=[CommHelp toUIColorByStr:@"#e60012"];
//        moneyLabel.numberOfLines = 1;
//        moneyLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
//        moneyLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        [backImageView addSubview:moneyLabel];
//        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(backImageView);
//            make.top.equalTo(backImageView).offset(150);
//
//        }];
//
//        NSString * string=@"¥ 1000";
//        NSRange range = [string rangeOfString:@"¥"];
//        moneyLabel.attributedText=[string attributedFont:[UIFont fontWithName:@"DINCondensed-Bold" size:15.f] color:[CommHelp toUIColorByStr:@"#e60012"] range:range];
//
//
//        UILabel  *title =[[UILabel alloc]init];
//        title.font=[UIFont systemFontOfSize:12];
//        title.textColor=[CommHelp toUIColorByStr:@"#333333"];
//        title.numberOfLines = 1;
//        title.text=@"新人专享 天天鉴宝大礼";
//        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
//        title.lineBreakMode = NSLineBreakByWordWrapping;
//        [backImageView addSubview:title];
//        [title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(backImageView);
//            make.top.equalTo(moneyLabel.mas_bottom).offset(0);
//
//        }];
        
        btn=[[UIButton alloc]init];
        btn.translatesAutoresizingMaskIntoConstraints=NO;
        //[btn setTitle:@"立即领取" forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:14];
          btn.contentMode=UIViewContentModeScaleAspectFit;
       // [btn setTitleColor:[CommHelp toUIColorByStr:@"#ffffff"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"new_copon_btn.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(-10, 0, 0, 0)];
        [backImageView addSubview:btn];
        
        [ btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(backImageView.mas_bottom).offset(-2);
            make.centerX.equalTo(backImageView);
           // make.left.equalTo(backImageView);
          //   make.right.equalTo(backImageView);
        }];
        
       closeBtn=[[UIButton alloc]init];
        [closeBtn setBackgroundImage:[[UIImage imageNamed:@"copon_close.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0,60,0,60)resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
          closeBtn.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:closeBtn];
        
        [ closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(backImageView.mas_top);
            make.right.equalTo(backImageView.mas_right).offset(10);
        }];
    }
    return self;
}
-(void)buttonPress:(UIButton*)button{
    
  [[NSUserDefaults standardUserDefaults] setObject:[CommHelp getCurrentDate] forKey:[LASTDATE stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId?:@""]];
     [[NSUserDefaults standardUserDefaults]synchronize];
    [self removeFromSuperview];
    if (self.buttonClick) {
        self.buttonClick(button);
    }
}
- (void)onTapBackground:(UIButton *)button
{
 
    [self dismiss];
}
-(void)setMode:(CoponPackageMode *)mode{
    
    _mode=mode;
    NSString * string=[@"¥" stringByAppendingString:_mode.totalFrPrice?:@""];
    NSRange range = [string rangeOfString:@"¥"];
    moneyLabel.attributedText=[string attributedFont:[UIFont fontWithName:kFontBoldDIN size:15.f] color:[CommHelp toUIColorByStr:@"#e60012"] range:range];
    
    [self beginAnimation];
}
- (void)show
{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    [window addSubview:self];
    self.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottom = self.height;
    }];
   
}

- (void)dismiss
{
    [[NSUserDefaults standardUserDefaults] setObject:[CommHelp getCurrentDate] forKey:[LASTDATE stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId?:@""]];
      [[NSUserDefaults standardUserDefaults]synchronize];
//    [UIView animateWithDuration:0 animations:^{
//        self.back.top = self.height;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    
    [btn removeFromSuperview];
    [closeBtn removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        
        backImageView.frame=CGRectMake(ScreenW-100, ScreenH/2+50, 90, 103);
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.block) {
            self.block();
        }
        
    }];
   
}
- (void)beginAnimation
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 1.0;
    group.repeatCount = MAXFLOAT;
    CABasicAnimation *animation1 = [self scaleAnimationFrom:1 to:1.1 begintime:0];
    CABasicAnimation *animation2 = [self scaleAnimationFrom:1.1 to:1 begintime:0.5];
    
    [group setAnimations:[NSArray arrayWithObjects:animation1,animation2, nil]];
    
    [btn.layer addAnimation:group forKey:@"scale"];
}

-(CABasicAnimation *)scaleAnimationFrom:(CGFloat)from to:(CGFloat)to begintime:(CGFloat)beginTime
{
    CABasicAnimation *_animation = [[CABasicAnimation alloc] init];
    [_animation setKeyPath:@"transform.scale"];
    _animation.duration = 0.5;
    _animation.beginTime = beginTime;
    _animation.removedOnCompletion = false;
    [_animation setFromValue:[NSNumber numberWithFloat:from]];
    [_animation setToValue:[NSNumber numberWithFloat:to]];
    return _animation;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
- (void)dealloc
{
    
    
}
@end



