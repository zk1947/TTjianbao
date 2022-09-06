//
//  JHSwitch.m
//  TTjianbao
//
//  Created by Jesse on 2020/3/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSwitch.h"

//默认大小 51.0f 31.0f
#define kDefaultWidth (51.0f)
#define kDefaultHeight (31.0f)

@interface JHSwitch ()
{
    CGFloat widthScale;
    CGFloat heightScale;
}
@end

@implementation JHSwitch

- (instancetype)init
{
    return [self initWithSize:CGSizeMake(38, 22)]; //UI设计默认大小
}

- (instancetype)initWithSize:(CGSize)size
{
    if(self = [super init])
    {
        self.on = YES;
        self.onTintColor = HEXCOLOR(0xFEE100); //打开
        self.tintColor = HEXCOLOR(0xEEEEEE); //关闭
        widthScale = size.width/kDefaultWidth;
        heightScale = size.height/kDefaultHeight;
        self.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    }
    return self;
}

- (CGFloat)leftRightOffset:(CGFloat)offset
{
    return offset/((1-widthScale)/2.0+1);
}

- (CGFloat)topBottomOffset:(CGFloat)offset
{
    return offset/((1-heightScale)/2.0+1);
}

@end
