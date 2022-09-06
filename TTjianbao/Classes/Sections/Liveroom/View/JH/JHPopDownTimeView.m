//
//  JHPopDownTimeView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/3/30.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHPopDownTimeView.h"
#import "TTjianbaoHeader.h"

@interface JHPopDownTimeView () {
    NSInteger waitNum;
    NSInteger waitSecond;
}
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) CAShapeLayer *allCornerLayer;
@property (nonatomic, strong) CAShapeLayer *leftCornerLayer;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *iconImage;

@end

@implementation JHPopDownTimeView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self.backView addSubview:self.iconImage];
        [self.backView addSubview:self.label];
        self.iconImage.hidden = YES;
        self.iconImage.frame = CGRectMake(13, 0, 14, self.mj_h);
        self.label.frame = CGRectMake(0, 0, 0, self.mj_h);
        self.backView.frame = CGRectMake(self.mj_w, 0, 0, self.mj_h);
        
    }
    return self;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_laba_downtime"]];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImage;
}

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textColor = [UIColor whiteColor];
    }
    
    return _label;
}


- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = HEXCOLORA(0x000000, 0.6);
        _backView.userInteractionEnabled = YES;
        
    }
    return _backView;
}

- (CAShapeLayer *)allCornerLayer {
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds byRoundingCorners: UIRectCornerAllCorners cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    _allCornerLayer = maskLayer;
    
    
    return _allCornerLayer;
}

- (CAShapeLayer *)leftCornerLayer {
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:_backView.bounds byRoundingCorners: UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(12, 12)];
    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    _leftCornerLayer = maskLayer;
    
    
    return _leftCornerLayer;
}

- (void)tapAction {
    self.isSelected = !self.isSelected;
}

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    NSAttributedString *string = [self labelString];
    CGFloat ww = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.mj_h) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
    if (isSelected) {
        self.iconImage.hidden = NO;
        self.label.mj_x = self.iconImage.right + 4;
        self.label.width = ww;
        self.backView.mj_w = self.label.right+5;
        self.label.attributedText = string;

        [UIView animateWithDuration:0.25 animations:^{
            self.backView.mj_x = self.mj_w - self.backView.mj_w;
        } completion:^(BOOL finished) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.isSelected = NO;
            });
        }];
        self.backView.layer.mask = self.allCornerLayer;

    }else {
        self.iconImage.hidden = YES;
        self.label.mj_x = 7;
        self.label.width = ww;
        
        [UIView animateWithDuration:0.25 animations:^{
            self.backView.mj_x = self.mj_w - (ww+12);
        } completion:^(BOOL finished) {
            if (finished) {
                self.label.attributedText = string;
                self.backView.mj_w = self.label.right+5;
                self.backView.layer.mask = self.leftCornerLayer;

            }
            
        }];
        
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (!self.isSelected) {
        self.isSelected = !self.isSelected;
        
    }
}


- (NSAttributedString *)labelString {
    NSString *time =  [CommHelp getHMSWithSecond:waitSecond];
    NSString *count = [NSString stringWithFormat:@"%ld", (long)waitNum];
    NSString *string = @"";
    if (self.isSelected) {
        
        string = [NSString stringWithFormat:@"您申请的鉴定前面还有 %@ 人 预计等待 %@ 分", count, time];
        
    }else {
        string = [NSString stringWithFormat:@"%@ 人 %@ 分", count, time];
        
    }
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:string];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:10] range:NSMakeRange(0, string.length)];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, string.length)];
    
    NSRange rang = [string rangeOfString:count];
    
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINAlternate-Bold" size:13] range:rang];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rang];
    
    rang = [string rangeOfString:time];
    [attString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"DINAlternate-Bold" size:13] range:rang];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:rang];
    return attString;
}


- (void)setWaitNum:(NSInteger)num waitSecond:(NSInteger)second {
    waitNum = num;
    waitSecond = second;
    if (self.backView.mj_w == 0.0) {
        _isSelected = YES;
        self.iconImage.hidden = NO;
        self.label.mj_x = 31;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isSelected = NO;
        });
    }
    self.label.attributedText = [self labelString];
    CGFloat ww = [self.label.attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.mj_h) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.width;
    
   
    self.label.width = ww;
    self.backView.mj_w = self.label.right+5;
    self.backView.mj_x = self.mj_w - self.backView.mj_w;
    self.backView.layer.mask = self.isSelected?self.allCornerLayer:self.leftCornerLayer;

    
}

@end
