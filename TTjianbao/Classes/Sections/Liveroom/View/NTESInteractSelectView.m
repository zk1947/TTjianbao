//
//  NTESInteractSelectView.m
//  TTjianbao
//
//  Created by chris on 16/7/19.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESInteractSelectView.h"
#import "UIImage+NTESColor.h"
#import "NTESLiveViewDefine.h"
#import "UIView+NTES.h"

@interface NTESInteractSelectView()

@property (nonatomic, strong) UIView *bar;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation NTESInteractSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 158.f)];
        [_bar setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_bar];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont systemFontOfSize:12.f];
        _titleLabel.text = @"我要与主播";
        [_titleLabel sizeToFit];
        [_bar addSubview:_titleLabel];
        
        _buttons = [[NSMutableArray alloc] init];
        
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)onTapBackground:(id)sender
{
    [self dismiss];
}


- (void)setUpSubViews
{
    for (UIView *view in self.buttons) {
        [view removeFromSuperview];
    }
    
    for (NSNumber *type in self.types) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = type.integerValue;
        [button setBackgroundImage:[[UIImage imageNamed:@"icon_cell_blue_normal"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [button setBackgroundImage:[[UIImage imageNamed:@"icon_cell_blue_pressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch] forState:UIControlStateHighlighted];
        NSString *title = [self buttonTitle:type.integerValue];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        CGFloat height  = 40.f;
        CGFloat spacing = 65.f;
        CGFloat width   = self.width - 2 * spacing;
        
        button.size = CGSizeMake(width, height);
        [button addTarget:self action:@selector(onTouchButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_buttons addObject:button];
        [_bar addSubview:button];
    }
}


- (void)onTouchButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(onSelectInteractType:)]) {
        [self.delegate onSelectInteractType:button.tag];
    }
    [self dismiss];
}

- (NSString *)buttonTitle:(NIMNetCallMediaType)type
{
    switch (type) {
        case NIMNetCallMediaTypeAudio:
            return @"语音连线";
        case NIMNetCallMediaTypeVideo:
            return @"视频连线";
        default:
            return @"";
    }
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bar.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom = self.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setUpSubViews];
    
    _bar.bottom = self.height;
    
    CGFloat titleTop = 10.f;
    self.titleLabel.top = titleTop;
    self.titleLabel.centerX = self.bar.width * .5f;
    
    CGFloat height = self.bar.height - 2 *titleTop - self.titleLabel.height;
    
    CGFloat buttonHeight = 0;
    for (UIButton *button in self.buttons) {
        buttonHeight += button.height;
    }
    CGFloat padding = (height - buttonHeight)/(self.buttons.count + 1);
    
    CGFloat top = self.titleLabel.bottom + titleTop;
    for (UIButton *button in self.buttons) {
        top += padding;
        button.top = top;
        button.centerX = self.bar.width * .5f;
        top += button.height;
    }
}

@end
