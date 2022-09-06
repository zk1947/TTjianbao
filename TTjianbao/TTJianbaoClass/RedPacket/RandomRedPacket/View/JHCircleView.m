//
//  JHCircleView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCircleView.h"

@interface JHCircleView ()

@property (nonatomic, strong) CAShapeLayer *jh_progressLayer;

@end

@implementation JHCircleView

- (void)setJh_progress:(CGFloat)jh_progress
{
    _jh_progress = jh_progress;
    [_jh_progressLayer removeFromSuperlayer];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self jh_drawCycleProgress];
}

- (void)jh_drawCycleProgress
{
    CGPoint center = CGPointMake(_jh_height/2.0, _jh_height/2.0);
    CGFloat radius = _jh_height/2.0;
    //设置进度条起点位置
    CGFloat startA = - M_PI_2;
    //设置进度条终点位置
    CGFloat endA = - M_PI_2 + M_PI * 2 * _jh_progress;
    _jh_progressLayer = [CAShapeLayer layer];
    _jh_progressLayer.frame = CGRectMake(0, 0, _jh_height, _jh_height);
    _jh_progressLayer.fillColor = [[UIColor clearColor] CGColor];
    _jh_progressLayer.strokeColor = RGB(255, 232, 145).CGColor;
    _jh_progressLayer.opacity = 1;
    _jh_progressLayer.lineCap = kCALineCapRound;
    _jh_progressLayer.lineWidth = 5;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];
    _jh_progressLayer.path = [path CGPath];
    [self.layer addSublayer:_jh_progressLayer];

}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
