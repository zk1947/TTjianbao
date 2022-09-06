//
//  JHCustomLine.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHLine.h"

@implementation JHCustomLine

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        _isSolid = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andColor:(UIColor *)color
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        _color = color;
        _isSolid = YES;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andColor:(UIColor *)color isSolid:(BOOL)isSolid
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _color = color;
        _isSolid = isSolid;
    }
    return self;
}

- (void)refreshFrame:(CGRect)frame
{
    self.frame = frame;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    //获取图形的上下文，绘图作用域，专门用来保存绘图期间的各种数据
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    //绘制线
    [self drawLine:contextRef];
}

- (void)drawLine:(CGContextRef)contextRef
{
    //路径的设置
    if(self.frame.size.width > self.frame.size.height){
        CGContextMoveToPoint(contextRef, 0.0, self.frame.size.height/2.0);
        CGContextAddLineToPoint(contextRef, self.frame.size.width, self.frame.size.height/2.0);
        CGContextSetLineWidth(contextRef, self.frame.size.height);
    }else{
        
        CGContextMoveToPoint(contextRef, self.frame.size.width/2.0, 0.0);
        CGContextAddLineToPoint(contextRef, self.frame.size.width/2.0, self.frame.size.height);
        CGContextSetLineWidth(contextRef, self.frame.size.width);
    }
    //状态的设置
    CGContextSetStrokeColorWithColor(contextRef, _color ? _color.CGColor : HEXCOLOR(0xEEEEEE).CGColor);
    CGContextSetLineCap(contextRef, kCGLineCapRound);
    /**
     *  @param contextRef 作用域
     *  @param phase    起点向左边的偏移量
     *  @param lengths  实心线长度和虚心的长度
     *  @param count    实心线和虚心线的循环次数（count必须等于lengths数组的长度）
     */
    if (!_isSolid) {
        CGFloat lengths[] = {_solidWidth?_solidWidth:2,_dashWidth?_dashWidth:2};
        CGContextSetLineDash(contextRef, 2.0, lengths, 2);
    }
    //将图形回执到View上来（渲染）
    CGContextStrokePath(contextRef);
}

@end

@implementation JHGradientLine
//{
//    JHGradientOrientation gradientOrientation;
//    CAGradientLayer* gradientLayer;
//    NSArray* colorArray;
//}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame])
//    {
//        self.backgroundColor = [UIColor clearColor];
//        gradientOrientation = JHGradientOrientationDefault;
//        colorArray = [NSArray arrayWithObjects:(id)HEXCOLORA(0xEEEEEE, 0.0).CGColor, (id)HEXCOLORA(0xEEEEEE, 1).CGColor,nil];
//    }
//    return self;
//}
//
//- (void)drawRect:(CGRect)rect
//{
//    if(!gradientLayer)
//    {
//        gradientLayer = [self customGradientLayer];
//        [self.layer insertSublayer:gradientLayer atIndex:0];
//    }
//}
//
////设置view渐变色
//- (CAGradientLayer*)customGradientLayer
//{
//    CAGradientLayer* gradient = [CAGradientLayer layer];
////    gradient.opacity = 0.4;
//    //设置开始和结束位置(设置渐变的方向)
//    gradient.startPoint = CGPointMake(0, 0); //x和y坐标
//    if(gradientOrientation == JHGradientOrientationHorizontal)
//        gradient.endPoint = CGPointMake(1, 0);//横向渐变
//    else
//        gradient.endPoint = CGPointMake(0, 1);//纵向渐变
//    gradient.frame = self.bounds; //主要指定宽高
//    gradient.colors = colorArray;
//    return gradient;
//}
//
//- (void)setGradientColor:(NSArray*)colors orientation:(JHGradientOrientation)orientation
//{
//    colorArray = colors;
//    gradientOrientation = orientation;
//}

@end
