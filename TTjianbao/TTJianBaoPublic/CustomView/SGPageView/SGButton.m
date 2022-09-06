//
//  SGButton.m
//  TTjianbao
//
//  Created by YJ on 2020/12/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "SGButton.h"

#define BTN_HEIGHT    105
#define IMAGE_WIDTH   44
#define TITLE_HEIGHT  17
#define TOP_PAD       15

@implementation SGButton


//重写button设置imageView尺寸的方法
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{

    CGFloat imageW = IMAGE_WIDTH;
    CGFloat imageH = IMAGE_WIDTH;
    CGFloat imageX = (contentRect.size.width - imageW) * 0.5;
    CGFloat imageY = TOP_PAD;//距离button顶部的距2
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}

//重写button设置titleLabel尺寸的方法
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    //CGFloat titleW = [self SG_widthWithString:self.currentTitle font:self.font] + 20;
    CGFloat titleW = [self SG_widthWithString:self.currentTitle font:[UIFont systemFontOfSize:12.0f]] + 12;
    CGFloat titleH = TITLE_HEIGHT;
    CGFloat titleX = (contentRect.size.width - titleW) * 0.5;
    CGFloat titleY = TOP_PAD + IMAGE_WIDTH + 5;//距离button顶部的距离
    
    return CGRectMake(titleX, titleY, titleW, titleH);
}

//计算字符串宽度
- (CGFloat)SG_widthWithString:(NSString *)string font:(UIFont *)font;
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
