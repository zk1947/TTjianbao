//
//  JHCircleDrawView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/3/5.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHCircleDrawView.h"
@interface JHCircleDrawView ()
@end

@implementation JHCircleDrawView

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (void)drawCicleWithRate:(CGFloat)rate {
    
    CGFloat allAngle = rate*2*M_PI;
    
    CGFloat lineWidth = 15.0f;
    CGFloat viewWidth = self.bounds.size.width;
    BOOL clockWise = true;

    {
        CAShapeLayer *layer = [CAShapeLayer new];
        layer.lineWidth = lineWidth;
        layer.strokeColor = HEXCOLOR(0xeeeeee).CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineCap = kCALineCapRound;
        CGFloat radius = viewWidth/2.0f - layer.lineWidth/2.0f;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(viewWidth/2.0f, viewWidth/2.0f) radius:radius startAngle:(-0.25f*M_PI) endAngle:(1.75*M_PI) clockwise:clockWise];
        layer.path = [path CGPath];

        [self.layer addSublayer:layer];
    }
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.lineWidth = lineWidth;
    layer.strokeColor = HEXCOLOR(0xeeeeee).CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.lineCap = kCALineCapRound;
    CGFloat radius = viewWidth/2.0f - layer.lineWidth/2.0f;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(viewWidth/2.0f, viewWidth/2.0f) radius:radius startAngle:(-0.25f*M_PI) endAngle:(allAngle-0.25*M_PI) clockwise:clockWise];
    layer.path = [path CGPath];

    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor yellowColor] CGColor], (id)[[UIColor redColor] CGColor],nil]];
    gradientLayer.startPoint = CGPointMake(1, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:layer];
    [self.layer addSublayer:gradientLayer];
    

    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 1;
    [layer addAnimation:ani forKey:@"ani"];

   
}


- (CGPoint)endPointWithRate:(CGFloat)rate {
    CGPoint point = CGPointMake(1, 0);
    CGFloat allAngle = (rate*2*M_PI);
    CGFloat zhijiao = (M_PI*0.5);

    if (allAngle<=zhijiao) {
        point = CGPointMake(1, allAngle/zhijiao);
    }else if (allAngle<=2*zhijiao) {
        point = CGPointMake(1-(allAngle-zhijiao)/zhijiao, 0);
    }else if (allAngle<=3*zhijiao) {
        point = CGPointMake(0, 1-(allAngle-2*zhijiao)/zhijiao);
    }else if (allAngle<=4*zhijiao) {
        point = CGPointMake((allAngle-3*zhijiao)/zhijiao, 0);
    }
    
    return point;
    
}

@end
