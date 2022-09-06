//
//  JHLiveAnimationView.m
//  TTjianbao
//
//  Created by LiHui on 2020/3/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveAnimationView.h"
#import "UIImage+GIF.h"
#import "UIImageView+JHWebImage.h"

@interface JHLiveAnimationView ()

@property (nonatomic, strong) UIImageView *animationImageView;

@end

@implementation JHLiveAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isAnimation = NO;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:imageV];
    _animationImageView = imageV;
    [_animationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    ///添加动画
    if (_isAnimation) {
        [self addAnimation];
    }
}

- (void)addAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat duration = 1.f;
    CGFloat height = 7.f;
    CGFloat currentY = self.transform.ty;
    animation.duration = duration;
    animation.values = @[@(currentY),@(currentY - height/4),@(currentY - height/4*2),@(currentY - height/4*3),@(currentY - height),@(currentY - height/ 4*3),@(currentY - height/4*2),@(currentY - height/4),@(currentY)];
    animation.keyTimes = @[@(0), @(0.025), @(0.085), @(0.2), @(0.5), @(0.8), @(0.915), @(0.975), @(1)];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}

- (void)setIsAnimation:(BOOL)isAnimation {
    _isAnimation = isAnimation;
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
}

- (void)setSourceType:(JHLiveAnimationSourceType)sourceType {
    _sourceType = sourceType;
    switch (_sourceType) {
        case JHLiveAnimationSourceTypeGif:
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:_imageName ofType:@"gif"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            UIImage* gifImage = [UIImage sd_imageWithGIFData:data];
            _animationImageView.image = gifImage;
        }
            break;
        case JHLiveAnimationSourceTypeURL:
        {
            [_animationImageView jhSetImageWithURL:[NSURL URLWithString:_imageName]];
        }
            break;
        default:
            _animationImageView.image = [UIImage imageNamed:self.imageName];
            break;
    }
}

@end
