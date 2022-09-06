//
//  JHLinkerTableViewCell.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/12.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHLinkerTableViewCell.h"
#import "NIMAvatarImageView.h"
#import "TTjianbaoHeader.h"

@interface JHLinkerTableViewCell ()

@property (strong, nonatomic) NIMAvatarImageView *avatar;
@property (strong, nonatomic) UIImageView *buyLogo;
@property (strong, nonatomic) UILabel *nickLabel;
@property (strong, nonatomic) UILabel *leaveFlag;

@end
@implementation JHLinkerTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.avatar];
        [self addSubview:self.buyLogo];
        [self addSubview:self.nickLabel];
        [self addSubview:self.leaveFlag];
        
        _avatar.mj_size = CGSizeMake(50., 50.);
        _avatar.center = CGPointMake(self.mj_w/2., 30.);
        
        _buyLogo.mj_size = CGSizeMake(25.,25.);
        _buyLogo.top=_avatar.top;
        _buyLogo.right=_avatar.right;
        
         [_buyLogo setHidden:YES];
        
        _nickLabel.frame = CGRectMake(-5, 60, 70, 30);
        _leaveFlag.frame = _avatar.bounds;
        _leaveFlag.layer.cornerRadius = _avatar.mj_w/2.;
        _leaveFlag.layer.masksToBounds = YES;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    
    if (selected) {
        CGRect rect = self.avatar.frame;
        rect.size = CGSizeMake(60., 60.);
        [UIView animateWithDuration:0.25 animations:^{
            _avatar.frame = rect;
            _avatar.center = CGPointMake(self.mj_w/2., 30.);
            _buyLogo.mj_size = CGSizeMake(25.,25.);
            _buyLogo.top=_avatar.top;
            _buyLogo.right=_avatar.right;
        }];

        _avatar.isShowBorder = YES;
    }else {
        CGRect rect = self.avatar.frame;
        rect.size = CGSizeMake(50., 50.);
        
        [UIView animateWithDuration:0.25 animations:^{
            _avatar.frame = rect;
            _avatar.center = CGPointMake(self.mj_w/2., 30.);
            _buyLogo.mj_size = CGSizeMake(20.,20.);
            _buyLogo.top=_avatar.top;
            _buyLogo.right=_avatar.right;
        }];
        _avatar.isShowBorder = NO;

    }
    
    self.leaveFlag.frame = _avatar.frame;
    _leaveFlag.layer.cornerRadius = _avatar.mj_w/2.;
}

- (void)setModel:(NTESMicConnector *)model {
    if (!model) {
        [_avatar nim_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:kDefaultAvatarImage];
        _nickLabel.text = @(self.tag).stringValue;
        return;
    }
    
    _model = model;
    if ([model.avatar length]!=0) {
           [_avatar nim_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:kDefaultAvatarImage];
    }
    _nickLabel.text = model.nick;
    if (model.onlineState == NTESLiveMicOnlineStateExitRoom) {
        self.leaveFlag.hidden = NO;
    }else {
        self.leaveFlag.hidden = YES;

    }
    
    if (model.bought ) {
         [_buyLogo setHidden:NO];
        if (model.isBiggerThen) {
            _buyLogo .image=[UIImage imageNamed:@"icon_audience_buy_morethan"];
        }
        else{
            _buyLogo .image=[UIImage imageNamed:@"icon_audience_buy"];
        }
    }else {
       [_buyLogo setHidden:YES];
    }
}

- (NIMAvatarImageView *)avatar {
    if (!_avatar) {
        _avatar = [[NIMAvatarImageView alloc] init];
        _avatar.image=kDefaultAvatarImage;
    }
    return _avatar;
}
- (UIImageView *) buyLogo{
    if (!_buyLogo) {
        _buyLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_audience_buy"]];
          _buyLogo.contentMode = UIViewContentModeScaleToFill;
        
    }
    return _buyLogo;
}
- (UILabel *)nickLabel {
    if (!_nickLabel) {
        _nickLabel = [UILabel new];
        _nickLabel.textColor = [UIColor colorWithRGB:0X333333];
        _nickLabel.textAlignment = NSTextAlignmentCenter;
        _nickLabel.font = [UIFont systemFontOfSize:10];
        _nickLabel.numberOfLines = 0;
        _nickLabel.lineBreakMode = NSLineBreakByClipping;
        
    }
    
    return _nickLabel;
}

- (UILabel *)leaveFlag {
    if (!_leaveFlag) {
        _leaveFlag = [UILabel new];
        _leaveFlag.backgroundColor = HEXCOLORA(0x000000, 0.8);
        _leaveFlag.hidden = YES;
        _leaveFlag.text = @"离开";
        
        _leaveFlag.textColor = [UIColor whiteColor];
        _leaveFlag.textAlignment = NSTextAlignmentCenter;
        _leaveFlag.font = [UIFont systemFontOfSize:12];

    }
    
    return _leaveFlag;
}

- (void)selectedAction:(UIControl *)btn {
    btn.selected = !btn.selected;
    if (btn.selected) {
        CGRect rect = btn.frame;
        rect.size = CGSizeMake(60., 60.);
       [UIView animateWithDuration:0.25 animations:^{
            _avatar.frame = rect;
            _avatar.center = CGPointMake(self.mj_w/2., 30.);
        
           
        }];
        
    }else {
        CGRect rect = btn.frame;
        rect.size = CGSizeMake(50., 50.);
       
        [UIView animateWithDuration:0.25 animations:^{
            _avatar.frame = rect;
            _avatar.center = CGPointMake(self.mj_w/2., 30.);
          

        }];

        
        
    }

}

- (UIImage*)grayImage:(UIImage*)sourceImage {

    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil, width, height,8,0, colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);

    if (context ==NULL) {
        return nil;
    }

    CGContextDrawImage(context,CGRectMake(0,0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

@end

