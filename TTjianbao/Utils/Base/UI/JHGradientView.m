//
//  JHGradientView.m
//  TTjianbao
//
//  Created by Jesse on 2020/8/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGradientView.h"

@interface JHGradientView ()
{
    JHGradientOrientation gradientOrientation;
    CAGradientLayer* gradientLayer;
    NSArray* colorArray;
}

@end

@implementation JHGradientView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        gradientOrientation = JHGradientOrientationDefault;
        colorArray = [NSArray arrayWithObjects:(id)HEXCOLORA(0xEEEEEE, 0.0).CGColor, (id)HEXCOLORA(0xEEEEEE, 1).CGColor,nil];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if(!gradientLayer)
    {
        gradientLayer = [self customGradientLayer];
        [self.layer insertSublayer:gradientLayer atIndex:0];
    }
}

//设置view渐变色
- (CAGradientLayer*)customGradientLayer
{
    CAGradientLayer* gradient = [CAGradientLayer layer];
//    gradient.opacity = 0.4;
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = CGPointMake(0, 0); //x和y坐标
    if(gradientOrientation == JHGradientOrientationHorizontal)
        gradient.endPoint = CGPointMake(1, 0);//横向渐变
    else
        gradient.endPoint = CGPointMake(0, 1);//纵向渐变
    gradient.frame = self.bounds; //主要指定宽高
    gradient.colors = colorArray;
    return gradient;
}

- (void)setGradientColor:(NSArray*)colors orientation:(JHGradientOrientation)orientation
{
    colorArray = colors;
    gradientOrientation = orientation;
}
@end
