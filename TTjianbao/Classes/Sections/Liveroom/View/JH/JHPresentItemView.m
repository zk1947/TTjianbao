//
//  JHPresentItemView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/3.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHPresentItemView.h"
#import "TTjianbaoHeader.h"

@interface JHPresentItemView ()

@property (strong, nonatomic) UIImageView *backImage;
@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *beanLabel;


@end
@implementation JHPresentItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.backImage];
        [self addSubview:self.iconImage];
        [self addSubview:self.nameLabel];
        [self addSubview:self.beanLabel];
        CGFloat ww = 50.;
        self.iconImage.frame = CGRectMake((self.mj_w-ww)/2., 10, ww, ww);
        self.nameLabel.frame = CGRectMake(0, 10+ww+10, self.mj_w, 15);
        self.beanLabel.frame = CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame), self.mj_w, 15);
        
        self.backImage.frame = CGRectMake(5, 5, self.mj_w-10, 100);
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.backImage.hidden = !selected;
    if (selected) {
        [self beginAnimation];
    }else {
        [self endAnimation];
    }
    
}

- (UIImageView *)backImage {
    if (!_backImage) {
        _backImage = [UIImageView new];
        _backImage.layer.cornerRadius = 4;
        _backImage.layer.masksToBounds = YES;
        _backImage.layer.borderColor = kGlobalThemeColor.CGColor;
        _backImage.layer.borderWidth = 1;
        _backImage.hidden = YES;
        _backImage.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _backImage;
}

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [UIImageView new];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
        _iconImage.backgroundColor = [UIColor clearColor];
        
    }
    return _iconImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:12];
        
    }
    
    return _nameLabel;
}

- (UILabel *)beanLabel {
    if (!_beanLabel) {
        _beanLabel = [UILabel new];
        _beanLabel.textColor = HEXCOLOR(0xa7a7a7);
        _beanLabel.textAlignment = NSTextAlignmentCenter;
        _beanLabel.font = [UIFont systemFontOfSize:10];
    }
    
    return _beanLabel;

}



- (void)setModel:(NTESPresent *)model {
    self.nameLabel.text = model.name;
    self.iconImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_gift_%@",model.Id]];
    [self.iconImage jhSetImageWithURL:[NSURL URLWithString:model.icon] placeholder:nil];
    if (model.price == 0) {
        self.beanLabel.text = @"免费";
    }else {
        self.beanLabel.text = [NSString stringWithFormat:@"%zd鉴豆",model.price];

    }
}



- (void)beginAnimation
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 1;
    group.repeatCount = MAXFLOAT;
    CABasicAnimation *animation1 = [self scaleAnimationFrom:1 to:1.4 begintime:0];
    CABasicAnimation *animation2 = [self scaleAnimationFrom:1.4 to:1 begintime:0.5];

    [group setAnimations:[NSArray arrayWithObjects:animation1,animation2, nil]];
    
    [self.iconImage.layer addAnimation:group forKey:@"scale"];
}

- (void)endAnimation {
    [self.iconImage.layer removeAllAnimations];
}

- (CABasicAnimation *)scaleAnimationFrom:(CGFloat)from to:(CGFloat)to begintime:(CGFloat)beginTime
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
@end
