//
//  NTESLiveLikeView.m
//  TTjianbao
//
//  Created by chris on 16/3/29.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveLikeView.h"
#import "UIView+NTES.h"
#import "MJRefresh.h"

#define NTES_ARC_RANDOM_0_(range) (arc4random() % (range)) / 100.f
@interface NTESLiveLikeView()<CAAnimationDelegate>

@property (nonatomic, assign) BOOL isReapeat;

@end

@implementation NTESLiveLikeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.clipsToBounds = NO;
    }
    return self;
}

- (void)fire666 {
    [self piao10];
  
}

-(void)fireRepeat
{
    _isReapeat = YES;
    
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf fireRepeat];
    });
    [self fire666];
}

- (void)piao10 {
    JH_WEAK(self);
    int n = _isReapeat ? 30 : 10;
    for (int i = 0; i < n; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JH_STRONG(self);
            [self fireLike];
        });
    }
}

- (void)fireLike
{
    CALayer *imageLayer = [CALayer new];
    imageLayer.contents = (id)(self.randomLikeImage.CGImage);
    imageLayer.bottom = self.height;
    imageLayer.centerX = self.width * .5f;
    imageLayer.size = CGSizeMake(15, 20);
    imageLayer.contentMode = UIViewContentModeScaleAspectFit;
    [self.layer addSublayer:imageLayer];

    NSTimeInterval trueDuration = 3.f;
    int viewWidth = self.width;
    // 路径曲线
    CGFloat			toOffsetX		= arc4random() %(viewWidth > 0 ? viewWidth : 1);//NTES_ARC_RANDOM_0_(50) * self.width
    CGFloat			toOffsetY		= self.height * NTES_ARC_RANDOM_0_(30);
    CGPoint			controlPonit	= CGPointMake(self.width * NTES_ARC_RANDOM_0_(50), self.height * NTES_ARC_RANDOM_0_(50));
    UIBezierPath	*movePath		= [UIBezierPath bezierPath];
    [movePath moveToPoint:imageLayer.position];
    CGPoint toPoint = CGPointMake(toOffsetX,toOffsetY);
    [movePath addQuadCurveToPoint:toPoint
                     controlPoint:controlPonit];

    // 关键帧
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.path = movePath.CGPath;
    positionAnimation.removedOnCompletion = YES;

    // 放大
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = @(2.5f);

    // 旋转1
    CABasicAnimation *rotateAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation1.beginTime		= .0f * trueDuration;
    rotateAnimation1.duration		= .3f * trueDuration;
    rotateAnimation1.autoreverses	= NO;
    rotateAnimation1.fromValue		= [NSNumber numberWithFloat:0.0];

    CGFloat alpha                   = NTES_ARC_RANDOM_0_(100) * 2 - 1.f; //正负1
    CGFloat middleRotateValue       = (M_PI / 10) * alpha;
    rotateAnimation1.toValue		= [NSNumber numberWithFloat:middleRotateValue];

    // 旋转2
    CABasicAnimation *rotateAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnimation2.beginTime		= .3f * trueDuration;
    rotateAnimation2.duration		= .7f * trueDuration;
    rotateAnimation2.autoreverses	= NO;
    rotateAnimation2.fromValue		= [NSNumber numberWithFloat:middleRotateValue];
    rotateAnimation2.toValue		= [NSNumber numberWithFloat:M_PI / 2 * alpha];

    // 渐隐
    CABasicAnimation *fadeAnimation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation1.beginTime	= .0f * trueDuration;
    fadeAnimation1.duration		= .3f * trueDuration;
    fadeAnimation1.fromValue	= @(1.0);
    fadeAnimation1.toValue		= @(1.0);
    fadeAnimation1.autoreverses = NO;

    CABasicAnimation *fadeAnimation2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation2.beginTime	= .3f * trueDuration;
    fadeAnimation2.duration		= .3f * trueDuration;
    fadeAnimation2.fromValue	= @(1.0);
    fadeAnimation2.toValue		= @(0.0);
    fadeAnimation2.autoreverses = NO;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.beginTime				= CACurrentMediaTime();
    group.duration				= 1.0 * trueDuration;
    group.animations			= [NSArray arrayWithObjects:positionAnimation, rotateAnimation1, rotateAnimation2, scaleAnimation, fadeAnimation1, fadeAnimation2, nil];
    group.timingFunction		= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.delegate				= self;
    group.fillMode				= kCAFillModeForwards;
    group.removedOnCompletion	= YES;
    group.autoreverses			= NO;

    [imageLayer addAnimation:group forKey:@"opacity"];

    imageLayer.opacity = 0.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(group.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imageLayer removeFromSuperlayer];
    });
}

- (UIImage *)randomLikeImage
{
//    return [UIImage imageNamed:@"icon_66"];
    NSInteger value = (arc4random() % 8) + 1;
    NSString *imageName = [NSString stringWithFormat:@"icon_animal_%zd",value];
    return [UIImage imageNamed:imageName];
}



- (void)praiseAnimation {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = self.randomLikeImage;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.mj_size = CGSizeMake(15, 20);
    //    [imageView sizeToFit];
    imageView.bottom  = self.height;
    imageView.centerX = self.width * .5f;
    imageView.alpha = 0;
    CGRect frame = imageView.frame;
    //  用0.2秒的时间将imageView的透明度变成1.0，同时将其放大1.3倍，再缩放至1.1倍，这里参数根据需求设置
    [UIView animateWithDuration:0.2 animations:^{
        imageView.alpha = 1.0;
        imageView.frame = CGRectMake(frame.size.width - 40, frame.size.height - 90, 30, 30);
        CGAffineTransform transfrom = CGAffineTransformMakeScale(1.3, 1.3);
        imageView.transform = CGAffineTransformScale(transfrom, 1, 1);
    }];
    [self addSubview:imageView];
    //  随机产生一个动画结束点的X值
    CGFloat finishX = frame.size.width - round(random() % 200);
    //  动画结束点的Y值
    CGFloat finishY = 200;
    //  imageView在运动过程中的缩放比例
    CGFloat scale = round(random() % 2) + 0.7;
    // 生成一个作为速度参数的随机数
    CGFloat speed = 1 / round(random() % 900) + 0.6;
    //  动画执行时间
    NSTimeInterval duration = 4 * speed;
    //  如果得到的时间是无穷大，就重新附一个值（这里要特别注意，请看下面的特别提醒）
    if (duration == INFINITY) duration = 2.412346;
    // 随机生成一个0~7的数，以便下面拼接图片名
    int imageName = round(random() % 8);
    
    //  开始动画
    [UIView beginAnimations:nil context:(__bridge void *_Nullable)(imageView)];
    //  设置动画时间
    [UIView setAnimationDuration:duration];
    
    //  拼接图片名字
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30_.png",imageName]];
    
    //  设置imageView的结束frame
    imageView.frame = CGRectMake( finishX, finishY, 30 * scale, 30 * scale);
    
    //  设置渐渐消失的效果，这里的时间最好和动画时间一致
    [UIView animateWithDuration:duration animations:^{
        imageView.alpha = 0;
    }];
    
    //  结束动画，调用onAnimationComplete:finished:context:函数
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    //  设置动画代理
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


/// 动画完后销毁iamgeView
- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    UIImageView *imageView = (__bridge UIImageView *)(context);
    [imageView removeFromSuperview];
    imageView = nil;
}

@end
