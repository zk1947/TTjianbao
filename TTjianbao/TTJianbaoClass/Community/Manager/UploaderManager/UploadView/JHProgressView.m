//
//  JHProgressView.m
//  TTjianbao
//
//  Created by apple on 2019/10/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHProgressView.h"

@interface JHProgressView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation JHProgressView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        _isNeedGradient = NO;
        [self initSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isNeedGradient = NO;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    _bgImgeView = [[UIImageView alloc] init];
    _bgImgeView.layer.borderColor = [UIColor clearColor].CGColor;
    [self addSubview:_bgImgeView];
        
    _leftImgView = [[UIImageView alloc] init];
    _leftImgView.layer.borderColor = [UIColor clearColor].CGColor;
    [self addSubview:_leftImgView];

    [self.bgImgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@100);
    }];
}

-(void)setPresent:(int)present {
    dispatch_async(dispatch_get_main_queue(), ^{
        ///更新UI需要在主线程中操作>>>>
        [_leftImgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(self.frame.size.width/self.maxValue*present));
        }];
        [self setNeedsDisplay];
    });
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    self.layer.borderWidth = 1.f;
    self.layer.borderColor = [_borderColor CGColor];
}

- (void)setIsNeedGradient:(BOOL)isNeedGradient {
    _isNeedGradient = isNeedGradient;
    [self.leftImgView layoutIfNeeded];
    if (_isNeedGradient) {
        [self.leftImgView.layer insertSublayer:self.gradientLayer atIndex:0];
        [self setNeedsDisplay];
    }
}

- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = _leftImgView.bounds;
        _gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor];
        _gradientLayer.locations = @[@0, @1];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
    }
    return _gradientLayer;
}

@end
