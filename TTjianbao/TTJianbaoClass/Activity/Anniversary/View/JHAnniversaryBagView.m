//
//  JHAnniversaryBagView.m
//  TTjianbao
//
//  Created by apple on 2020/3/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "UserInfoRequestManager.h"
#import "JHAnniversaryBagView.h"

@implementation JHAnniversaryBagView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        
        UIImageView *imageview = [UIImageView jh_imageViewWithImage:@"activity_anniversary" addToSuperview:self];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(244, 282));
        }];
        imageview.userInteractionEnabled = YES;
        [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoBViewController)]];
        
        UIButton *button = [UIButton jh_buttonWithImage:@"red_packet_alert_close" target:self action:@selector(removeFromSuperview) addToSuperView:imageview];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageview).offset(10);
            make.right.equalTo(imageview).offset(-10);
            make.size.mas_equalTo(CGSizeMake(45, 45));
        }];
    }
    return self;
}

-(void)gotoBViewController
{
    if (![JHRootController isLogin])
    {
        [JHRootController presentLoginVC];
    }
    else
    {
        [JHRouterManager pushMyCouponViewController];
    }
    [self removeFromSuperview];
}

+(void)show
{
    if([UserInfoRequestManager sharedInstance].anniversaryViewShow)
    {
       [UserInfoRequestManager sharedInstance].anniversaryViewShow = NO;
        UIView *bgView = [UIApplication sharedApplication].keyWindow;
        JHAnniversaryBagView *view = [[JHAnniversaryBagView alloc]initWithFrame:bgView.bounds];
        [bgView addSubview:view];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
