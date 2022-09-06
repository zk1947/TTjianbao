//
//  JHBubbleWindow.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBubbleWindow.h"

@implementation JHBubbleWindow

- (void)dealloc
{
    DDLogInfo(@"JHBubbleWindow ~~~ dealloc");
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.frame = CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH);
        self.backgroundColor = HEXCOLORA(0xFFFFFF, 0);
        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.bubbleView];
    }
    return self;
}

- (JHBubbleView *)bubbleView
{
    if(!_bubbleView)
    {
        _bubbleView = [[JHBubbleView alloc]init];
        _bubbleView.layer.shadowColor = HEXCOLOR(0x000000).CGColor;
        _bubbleView.layer.shadowOpacity = 0.8;//阴影透明度，默认为0，如果不设置的话看不到阴影，切记
        _bubbleView.layer.shadowOffset = CGSizeMake(0, 0);//设置偏移量
        _bubbleView.layer.cornerRadius = 10.0;
        _bubbleView.layer.shadowRadius = 6;
    }
    
    return _bubbleView;
}

#pragma mark - event & method
- (void)setText:(NSString*)text click:(JHActionBlock)action
{
    JH_WEAK(self)
    [_bubbleView setTitle:text ? : @"" andArrowDirection:JHBubbleViewArrowDirectionenTopRight click:^(id sender) {
        JH_STRONG(self)
        [self dismiss];
        action(sender);
    }];
}

- (void)dismiss
{
    [self setHidden:YES];
}

@end
