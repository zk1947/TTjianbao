//
//  JHAutoRunView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/3/22.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHAutoRunView.h"
#import "NSString+NTES.h"
#import "TTjianbaoHeader.h"
static CGFloat const leftMarge = 10.0;
static CGFloat const topMarge = 80.0;
@implementation JHAutoRunViewModel
@end
@interface JHAutoRunView()<CAAnimationDelegate>
{
    CGFloat _width;
    CGFloat _height;
    BOOL _stoped;
    UIView *_contentView;//滚动内容视图
    NSInteger index;
    
}
@property (nonatomic, strong) UIImageView *animationView;//放置滚动内容视图
@property (nonatomic, strong) UIView * rightView;
@property (nonatomic, strong) UIButton *imageIcon;
@property (nonatomic, copy) NSMutableArray *textArray;

@end

@implementation JHAutoRunView

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =  [UIColor clearColor];
        _stoped = YES;
        _width = frame.size.width;
        _height = frame.size.height;
        _textArray = [NSMutableArray array];
        self.speed = 1.0f;
        self.directionType = LeftType;
//        self.layer.cornerRadius = _height/2.;
//        self.layer.masksToBounds = YES;
        self.animationView = [[UIImageView alloc] initWithFrame:CGRectMake(_width, 0, _width, _height)];
        self.animationView.backgroundColor = HEXCOLORA(0xFF9A0B,1);
        self.animationView.layer.cornerRadius = _height/2.;
        self.animationView.layer.masksToBounds = YES;
        self.animationView.userInteractionEnabled = YES;
        [self addSubview:self.animationView];
        
        self.imageIcon = [UIButton buttonWithType:UIButtonTypeCustom];
        self.imageIcon.frame = CGRectMake(0, 0, 30, _height);
        self.imageIcon.backgroundColor = HEXCOLORA(0xFF9A0B,1);
        [self.imageIcon setImage:[UIImage imageNamed:@"icon_notic_laba"] forState:UIControlStateNormal];
        [self.animationView addSubview:self.imageIcon];
        
        self.rightView = [[UIView alloc] init];
        self.rightView.backgroundColor = HEXCOLORA(0xFF9A0B,1);
        [self.animationView addSubview:self.rightView];
        [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.animationView.mas_right);
            make.width.mas_equalTo(10);
            make.top.mas_equalTo(self.animationView.mas_top);
            make.bottom.mas_equalTo(self.animationView.mas_bottom);
        }];
        
        [UIView setAnimationsEnabled:YES];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)addContentView:(UIView *)view {
    
    [_contentView removeFromSuperview];
    view.frame = CGRectMake(30, 0, view.frame.size.width, view.frame.size.height);
    _contentView = view;
    float animationWidth = view.frame.size.width + 30;
    if (view.frame.size.width>ScreenW-2*leftMarge-30) {
        animationWidth = ScreenW-2*leftMarge;
    }
    self.animationView.frame = CGRectMake(ScreenW, topMarge, animationWidth, view.frame.size.height);
    [self.animationView addSubview:_contentView];
    [self.animationView sendSubviewToBack:_contentView];
}

-(void)addAnimationText:(NSString *)text andIcon:(NSString *)iconurl andshowStyle:(NSInteger)showStyle{
    if (text) {
        JHAutoRunViewModel *model = [[JHAutoRunViewModel alloc] init];
        model.text = text;
        model.iconUrl = iconurl;
        model.showStyle = showStyle;
        [_textArray addObject:model];
    }
}

- (void)startAnimation {
    [self animationBegin];
}

- (void)animationBegin {
    if (!_stoped) {
        return;
    }
    if (self.textArray.count == 0) {
        return;
    }
    
    JHAutoRunViewModel *model = self.textArray.firstObject;
    if (model.showStyle == 2) {
        self.animationView.backgroundColor = HEXCOLORA(0xFF380B,1);
        self.rightView.backgroundColor = HEXCOLORA(0xFF380B,1);
        self.imageIcon.backgroundColor = HEXCOLORA(0xFF380B,1);
    }else{
        self.animationView.backgroundColor = HEXCOLORA(0xFF9A0B,1);
        self.rightView.backgroundColor = HEXCOLORA(0xFF9A0B,1);
        self.imageIcon.backgroundColor = HEXCOLORA(0xFF9A0B,1);
    }
    _stoped = NO;
    [self addContentView:[self createLabelWithText:model textColor:HEXCOLOR(0xffffff) labelFont:[UIFont fontWithName:@"PingFangSC-Semibold" size:12.0]]];
    [self.textArray removeObjectAtIndex:0];
    [self.animationView.layer removeAllAnimations];
    [_contentView.layer removeAllAnimations];
    
    CFTimeInterval currentTime = CACurrentMediaTime();
    CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position.x"];
    positionAni.fromValue = @(ScreenW + self.animationView.width/2);
    positionAni.toValue = @(leftMarge + self.animationView.width/2);
    positionAni.duration = 1.0f;
    positionAni.fillMode = kCAFillModeForwards;
    positionAni.removedOnCompletion = NO;
    positionAni.beginTime = currentTime;
    [positionAni setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.animationView.layer addAnimation:positionAni forKey:@"groupAnimation"];
    
    currentTime = currentTime + 1;
    if (_contentView.width > self.animationView.width-30) {
        CABasicAnimation *positionAni = [CABasicAnimation animationWithKeyPath:@"position.x"];
        positionAni.fromValue = @(_contentView.width/2 + 30);
        positionAni.toValue = @(_contentView.width/2 -(_contentView.width - self.animationView.width));
        positionAni.duration = (_contentView.width - self.animationView.width+30)/50;
        positionAni.fillMode = kCAFillModeForwards;
        positionAni.removedOnCompletion = NO;
        positionAni.beginTime = currentTime+1;
        [_contentView.layer addAnimation:positionAni forKey:@"positionconAnimation"];
        currentTime = currentTime + (_contentView.width - self.animationView.width+30)/50 + 1;
    }
    currentTime = currentTime + 2;
    
    CABasicAnimation *positionAni3 = [CABasicAnimation animationWithKeyPath:@"position.x"];
    positionAni3.delegate = self;
    positionAni3.fromValue = @(leftMarge + self.animationView.width/2);
    positionAni3.toValue = @(-(self.animationView.width+leftMarge)/2);
    positionAni3.duration = 1.0f;
    positionAni3.fillMode = kCAFillModeForwards;
    positionAni3.removedOnCompletion = NO;
    positionAni3.beginTime = currentTime;
    [positionAni3 setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [self.animationView.layer addAnimation:positionAni3 forKey:@"positionAnimation3"];
}

- (void)stopAnimation {
    _stoped = YES;
    [self.animationView.layer removeAllAnimations];
    [_contentView.layer removeAllAnimations];
}

- (void)stopAndRemove {
    [self removeFromSuperview];
    [self stopAnimation];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    [self stopAnimation];
    
    if (flag && _textArray.count) {
        [self startAnimation];
        return;
    }
    
    if (flag && self.delegate && [self.delegate respondsToSelector:@selector(operateLabel:animationDidStopFinished:)]) {
        [self.delegate operateLabel:self animationDidStopFinished:flag];
    }
    
}


- (UIView *)createLabelWithText: (JHAutoRunViewModel *)model textColor:(UIColor *)textColor labelFont:(UIFont *)font {
    
    UIView * conView = [[UIView alloc] init];
    
    NSString *string = [NSString stringWithFormat:@"%@", model.text];
    CGFloat width =  [string stringSizeWithFont:font].width;
    CGFloat leftM = 0;
    if (model.iconUrl.length>0) {
        leftM = 30;
        UIImageView * leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 6, 22, 12)];
        leftIcon.contentMode = UIViewContentModeScaleAspectFit;
        [conView addSubview:leftIcon];
        [leftIcon jhSetImageWithURL:[NSURL URLWithString:model.iconUrl] placeholder:nil];
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(leftM, 0, width+10, self.frame.size.height)];
    label.font = font;
    label.text = string;
    label.textColor = textColor;
    [conView addSubview:label];
    conView.frame = CGRectMake(0, 0, width+10+leftM , self.frame.size.height);
    return conView;
}

@end

