//
//  JHCelebrateHeaderView.m
//  TTjianbao
//
//  Created by Jesse on 2020/3/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCelebrateHeaderView.h"
#import "UIImage+GIF.h"

#define kCelebrateTag 300
#define kTopOffset (64-7)//(UI.statusAndNavBarHeight-7)
#define kVerticalInterval 7
#define kScale (ScreenW/375.0)
#define kButton2Size CGSizeMake((164+0)*kScale, (87+0)*kScale)
#define kButton4Size CGSizeMake((83+0)*kScale, (90+0)*kScale)
#define kMargin2X ((ScreenW - 8 - (164+0)*kScale*2)/2.0+2 - 1*2) //设计给的尺寸太不准了
#define kMargin4X ((ScreenW - 2*3 - (82+0)*kScale*4)/2.0+2 - 2)

@interface JHCelebrateHeaderView ()
{
    UIView* contentView;
    UIImageView* headImageView;
}
@end

@implementation JHCelebrateHeaderView

- (instancetype)init
{
    if(self = [super initWithFrame:CGRectMake(0, 0, ScreenW, kScale*(490+kVerticalInterval))])
    {
        self.backgroundColor=[UIColor clearColor];
        
        contentView=[[UIView alloc]init];
        contentView.backgroundColor=HEXCOLOR(0xC60036);
        [self addSubview:contentView];
        
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [self drawSubviews];
    }
    return self;
}

- (void)drawSubviews
{
    CGFloat top = 0;
    /*第一行*/
    headImageView = [UIImageView new];
    [headImageView setImage:[UIImage imageNamed:@"celebrate_1_bg"]];
    headImageView.userInteractionEnabled = YES;
    [contentView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(-top);
        make.left.right.equalTo(contentView);
        make.size.mas_offset(CGSizeMake(375*kScale, kScale*256));
    }];
    
    UIImageView* headImageBottomView = [UIImageView new];
    [headImageBottomView setImage:[UIImage imageNamed:@"celebrate_1_bottom"]];
    headImageBottomView.userInteractionEnabled = YES;
    [headImageView addSubview:headImageBottomView];
    [headImageBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(headImageView).offset(0);
        make.left.right.equalTo(contentView);
//        make.size.mas_offset(CGSizeMake(375*kScale, kScale*256));
    }];
    
    //right top ‘s mark
    UIImageView* maskImageView = [UIImageView new];
    [maskImageView setImage:[UIImage imageNamed:@"celebrate_right_mark"]];
    [headImageView addSubview:maskImageView];
    [maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImageView).offset(top);
        make.right.equalTo(headImageView).offset(-10);
    }];
    
    //get coupon button gif
    CGFloat gifOffset = 6;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"celebrate_1_button" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage* gifImage = [UIImage sd_imageWithGIFData:data];
    //get coupon button
    UIImageView* getCouponBtn = [UIImageView new];
    getCouponBtn.userInteractionEnabled=YES;
    [getCouponBtn setImage:gifImage];
    getCouponBtn.tag = kCelebrateTag+JHCelebrateButtonTypeCoupon;
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent)];
    [getCouponBtn addGestureRecognizer:singleTap];
    [headImageView addSubview:getCouponBtn];
    [getCouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(headImageView.mas_bottom).offset(-20+gifOffset);
        make.left.equalTo(headImageView).offset(kScale*(100-gifOffset));
        make.right.mas_equalTo(headImageView).offset(-kScale*(101-gifOffset));
        make.size.mas_equalTo(CGSizeMake(kScale*(178+gifOffset*2), kScale*45));
    }];
    
    /*第二行*/
    CGFloat margin = kScale*(375-371)/2.0;
    UIImageView* secondImageView = [UIImageView new];
    [secondImageView setImage:[UIImage imageNamed:@"celebrate_2_bg"]];
    [secondImageView setContentMode:UIViewContentModeScaleAspectFill];
    secondImageView.userInteractionEnabled = YES;
    [contentView addSubview:secondImageView];
    [secondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headImageView.mas_bottom).offset(0);
        make.left.equalTo(contentView).offset(margin);
        make.right.equalTo(contentView).offset(-margin);
        make.size.mas_offset(CGSizeMake(371*kScale, 122*kScale));
    }];
    
    UIButton* redpacketBtn = [self customButton];
    redpacketBtn.tag = kCelebrateTag+JHCelebrateButtonTypeRedpacket;
    [redpacketBtn setBackgroundImage:[UIImage imageNamed:@"celebrate_2_1"] forState:UIControlStateNormal];
    [secondImageView addSubview:redpacketBtn];
    [redpacketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(secondImageView).offset(14+10);
        make.left.equalTo(secondImageView).offset(kMargin2X);
//        make.bottom.mas_equalTo(secondImageView).offset(-8);
        make.size.mas_offset(kButton2Size);
    }];
    
    UIButton* billBtn = [self customButton];
    billBtn.tag = kCelebrateTag+JHCelebrateButtonTypeBill;
    [billBtn setBackgroundImage:[UIImage imageNamed:@"celebrate_2_2"] forState:UIControlStateNormal];
    [secondImageView addSubview:billBtn];
    [billBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(redpacketBtn);
//        make.left.mas_equalTo(redpacketBtn.mas_right).offset(8);
//        make.bottom.mas_equalTo(redpacketBtn);
        make.right.mas_equalTo(secondImageView).offset(0-kMargin2X+5);
        make.size.mas_offset(kButton2Size);
    }];
    
    /*第三行*/
    UIImageView* thirdImageView = [UIImageView new];
    [thirdImageView setImage:[UIImage imageNamed:@"celebrate_2_bg"]];
    thirdImageView.userInteractionEnabled = YES;
    [contentView addSubview:thirdImageView];
    [thirdImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(secondImageView.mas_bottom).offset(-kVerticalInterval);
        make.left.equalTo(contentView).offset(margin);
        make.right.equalTo(contentView).offset(-margin);
        make.size.mas_offset(CGSizeMake(371*kScale, 122*kScale));
    }];
    
    UIButton* mall1Btn = [self customButton];
    mall1Btn.tag = kCelebrateTag+JHCelebrateButtonTypeResaleStone;
    [mall1Btn setBackgroundImage:[UIImage imageNamed:@"celebrate_4_1"] forState:UIControlStateNormal];
    [thirdImageView addSubview:mall1Btn];
    [mall1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(thirdImageView).offset(14);
        make.left.mas_equalTo(thirdImageView).offset(kMargin4X);
        make.bottom.mas_equalTo(thirdImageView).offset(-8-6);
        make.size.mas_offset(kButton4Size);
    }];
    
    UIButton* mall2Btn = [self customButton];
    mall2Btn.tag = kCelebrateTag+JHCelebrateButtonTypeMallOne;
    [mall2Btn setBackgroundImage:[UIImage imageNamed:@"celebrate_4_2"] forState:UIControlStateNormal];
    [thirdImageView addSubview:mall2Btn];
    [mall2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(mall1Btn);
        make.left.mas_equalTo(mall1Btn.mas_right).offset(2);
        make.bottom.mas_equalTo(mall1Btn);
        make.size.mas_offset(kButton4Size);
    }];
    
    UIButton* mall3Btn = [self customButton];
    mall3Btn.tag = kCelebrateTag+JHCelebrateButtonTypeMallTwo;
    [mall3Btn setBackgroundImage:[UIImage imageNamed:@"celebrate_4_3"] forState:UIControlStateNormal];
    [thirdImageView addSubview:mall3Btn];
    [mall3Btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(mall2Btn);
        make.left.mas_equalTo(mall2Btn.mas_right).offset(2);
        make.bottom.mas_equalTo(mall2Btn);
        make.size.mas_offset(kButton4Size);
    }];
    
    UIButton* mall4Btn = [self customButton];
    mall4Btn.tag = kCelebrateTag+JHCelebrateButtonTypeMallThree;
    [mall4Btn setBackgroundImage:[UIImage imageNamed:@"celebrate_4_4"] forState:UIControlStateNormal];
    [thirdImageView addSubview:mall4Btn];
    [mall4Btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(mall3Btn);
//        make.left.mas_equalTo(mall3Btn.mas_right).offset(2);
        make.bottom.mas_equalTo(mall3Btn);
        make.right.mas_equalTo(thirdImageView).offset(0-kMargin4X+4);
        make.size.mas_offset(kButton4Size);
    }];
}

- (UIButton*)customButton
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn.imageView setContentMode:UIViewContentModeCenter];
    [btn addTarget:self action:@selector(pressButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

#pragma mrak -
#pragma mrak - event
- (void)pressButtonEvent:(UIButton*)button
{
    if([self.delegate respondsToSelector:@selector(clickButtonResponse:)])
    {
        [self.delegate clickButtonResponse:button.tag - kCelebrateTag];
    }
}

- (void)tapEvent
{
    if([self.delegate respondsToSelector:@selector(clickButtonResponse:)])
    {
        [self.delegate clickButtonResponse:JHCelebrateButtonTypeCoupon];
    }
}

@end
