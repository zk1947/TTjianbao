//
//  JHAnchorLinkerCell.m
//  TTjianbao
//
//  Created by jiangchao on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnchorLinkerCell.h"
#import "NIMAvatarImageView.h"
#import "TTjianbaoHeader.h"

@interface JHAnchorLinkerCell ()

@property (strong, nonatomic) NIMAvatarImageView *avatar;
@property (strong, nonatomic) UILabel *nickLabel;
@property (strong, nonatomic) UILabel *leaveFlag;
@property (strong, nonatomic) UILabel *orderStatus;


@end
@implementation JHAnchorLinkerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.avatar];
        [self addSubview:self.nickLabel];
        [self addSubview:self.leaveFlag];
        
        
        _avatar.mj_size = CGSizeMake(50., 50.);
        _avatar.center = CGPointMake(self.mj_w/2., 30.);
        
      //  _nickLabel.frame = CGRectMake(-5, 60, 70, 30);
        
        _leaveFlag.frame = _avatar.bounds;
        _leaveFlag.layer.cornerRadius = _avatar.mj_w/2.;
        _leaveFlag.layer.masksToBounds = YES;
        
        [self.nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_avatar.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
        
        [self addSubview:self.orderStatus];
        [self.orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_nickLabel.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(40, 18));
        }];
        
        
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
          
        }];

        _avatar.isShowBorder = YES;
    }else {
        CGRect rect = self.avatar.frame;
        rect.size = CGSizeMake(50., 50.);
        
        [UIView animateWithDuration:0.25 animations:^{
            _avatar.frame = rect;
            _avatar.center = CGPointMake(self.mj_w/2., 30.);
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
        _leaveFlag.layer.cornerRadius = _avatar.mj_w/2.;
    }else {
        self.leaveFlag.hidden = YES;

    }
    
    self.orderStatus.hidden = YES;
    if (_model.statusDesc) {
        self.orderStatus.hidden = NO;
        if ([_model.statusDesc length]>5) {
            self.orderStatus.text = [[_model.statusDesc substringToIndex:5] stringByAppendingFormat:@"..."];
        }
        else{
            self.orderStatus.text = _model.statusDesc;
        }
        
        CGFloat titleW = [self.orderStatus.text boundingRectWithSize:CGSizeMake(200, 19) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.orderStatus.font} context:nil].size.width;
        [self.orderStatus mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(_nickLabel.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(titleW+15, 18));
        }];
        
    }
}

- (NIMAvatarImageView *)avatar {
    if (!_avatar) {
        _avatar = [[NIMAvatarImageView alloc] init];
        _avatar.image=kDefaultAvatarImage;
    }
    return _avatar;
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
- (UILabel *)orderStatus {
    if (!_orderStatus) {
        _orderStatus = [UILabel new];
        _orderStatus.backgroundColor = HEXCOLORA(0xeeeeee, 0.8);
        _orderStatus.text = @"";
        _orderStatus.textColor = kColor999;
        _orderStatus.textAlignment = NSTextAlignmentCenter;
        _orderStatus.font = [UIFont fontWithName:kFontNormal size:10];
        _orderStatus.layer.cornerRadius = 9;
        _orderStatus.layer.masksToBounds = YES;

    }
    
    return _orderStatus;
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

