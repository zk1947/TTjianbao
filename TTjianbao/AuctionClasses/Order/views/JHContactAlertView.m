//
//  JHContactAlertView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHContactAlertView.h"

@interface JHContactAlertView ()

@end

@implementation JHContactAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        
        [self addSelfSubViews];
        
    }
    return self;
}

- (void)addSelfSubViews
{
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [whiteView jh_cornerRadius:8];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(260, 214));
    }];
    
    UIButton *closeButton = [UIButton jh_buttonWithImage:JHImageNamed(@"btn_detect_close") target:self action:@selector(removeFromSuperview) addToSuperView:whiteView];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(whiteView);
        make.width.height.mas_equalTo(40);
    }];
    
    {
        @weakify(self);
        UIView *grayView = [UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:whiteView];
        [grayView jh_cornerRadius:8];
        [grayView jh_addTapGesture:^{
            @strongify(self);
            if(self.clickBlock)
            {
                self.clickBlock();
            }
            [self removeFromSuperview];
        }];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView).offset(30);
            make.left.equalTo(whiteView).offset(30);
            make.right.equalTo(whiteView).offset(-30);
            make.height.mas_equalTo(60);
        }];
        
        UIImageView *imageView = [UIImageView jh_imageViewWithImage:@"icon_person_chat" addToSuperview:grayView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(grayView).offset(44);
            make.centerY.equalTo(grayView);
            make.width.height.mas_equalTo(30);
        }];
        
        UILabel *label = [UILabel jh_labelWithBoldText:@"在线客服" font:18 textColor:RGB515151 textAlignment:1 addToSuperView:grayView];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(grayView);
            make.left.equalTo(imageView.mas_right).offset(10);
        }];
        
        UIImageView *imageView2 = [UIImageView jh_imageViewWithImage:@"common_recommend" addToSuperview:grayView];
        [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(grayView).offset(-20);
            make.top.equalTo(grayView).offset(5);
        }];
    }
    
    {
        UIView *grayView = [UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:whiteView];
        [grayView jh_cornerRadius:8];
        [grayView jh_addTapGesture:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006230666"]];
            [self removeFromSuperview];
        }];
        [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView).offset(102);
            make.left.equalTo(whiteView).offset(30);
            make.right.equalTo(whiteView).offset(-30);
            make.height.mas_equalTo(60);
        }];
        
        UIImageView *imageView = [UIImageView jh_imageViewWithImage:@"icon_person_phone" addToSuperview:grayView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(grayView).offset(44);
            make.centerY.equalTo(grayView);
            make.width.height.mas_equalTo(30);
        }];
        
        UILabel *label = [UILabel jh_labelWithBoldText:@"电话客服" font:18 textColor:RGB515151 textAlignment:1 addToSuperView:grayView];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(grayView);
            make.left.equalTo(imageView.mas_right).offset(10);
        }];
    }
    
    UILabel *tipLabel = [UILabel jh_labelWithBoldText:@"客服竭诚为您服务" font:12 textColor:RGB153153153 textAlignment:1 addToSuperView:whiteView];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(whiteView);
        make.bottom.equalTo(whiteView).offset(-20);
    }];
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
