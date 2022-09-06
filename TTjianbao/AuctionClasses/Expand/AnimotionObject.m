//
//  AnimotionObject.m
//  TTjianbao
//
//  Created by mac on 2019/6/5.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "AnimotionObject.h"

@implementation AnimotionObject
+ (CABasicAnimation *)scaleAnimationFrom:(CGFloat)from to:(CGFloat)to begintime:(CGFloat)beginTime
{
    CABasicAnimation *_animation = [[CABasicAnimation alloc] init];
    [_animation setKeyPath:@"transform.scale"];
    _animation.duration = 0.5;
    _animation.beginTime = beginTime;
    _animation.removedOnCompletion = NO;
    [_animation setFromValue:[NSNumber numberWithFloat:from]];
    [_animation setToValue:[NSNumber numberWithFloat:to]];
    return _animation;
    
}

+ (CAAnimationGroup *)beginAnimationGroup
{
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.duration = 1;
    group.repeatCount = 3;
    CABasicAnimation *animation1 = [self scaleAnimationFrom:1 to:0.7 begintime:0];
    CABasicAnimation *animation2 = [self scaleAnimationFrom:0.7 to:1 begintime:0.5];
    [group setAnimations:[NSArray arrayWithObjects:animation1,animation2, nil]];
    
    return group;
}

+ (CAKeyframeAnimation *)shakeAnimation
{
    CGFloat value = M_PI/8.f;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[@(-value), @(value) , @(-value)];
    anim.duration = 0.2;
    anim.repeatCount = 5;
    anim.removedOnCompletion = NO;
    anim.fillMode = kCAFillModeForwards;
    
    return anim;
}

+ (CAAnimationGroup *)shakeAnimalGroup {
    CAAnimationGroup *group = [[CAAnimationGroup alloc] init];
    group.removedOnCompletion = NO;
    group.duration = 3;
    group.repeatCount = MAXFLOAT;
    CAKeyframeAnimation *animation1 = [self shakeAnimation];
    
    CGFloat value = M_PI/8.f;
       CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
       anim.keyPath = @"transform.rotation";
       anim.values = @[@(-value), @(0)];
       anim.duration = 0.05;
    anim.beginTime = 1;

       anim.repeatCount = 1;
       anim.removedOnCompletion = NO;
       anim.fillMode = kCAFillModeForwards;
           
    [group setAnimations:[NSArray arrayWithObjects:animation1,anim, nil]];
    
    return group;
}

@end
