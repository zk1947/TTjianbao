//
//  NTESLiveSelectButton.m
//  TTjianbao
//
//  Created by chris on 16/7/14.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLiveSelectButton.h"
#import "UIView+NTES.h"

@interface NTESLiveSelectActiveButton : UIButton

@property (nonatomic,weak) NTESLiveSelectButton *selectButton;

@end

@interface NTESLiveSelectButton ()

@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic,strong) NSMutableArray *subButtons;

@property (nonatomic,strong) NTESLiveSelectActiveButton *activeButton;

@end

@implementation NTESLiveSelectButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.subButtons = [[NSMutableArray alloc] init];
        [self setTitleColor:HEXCOLOR(0x238efa) forState:UIControlStateNormal];
        [self setTitleColor:HEXCOLOR(0x238efa) forState:UIControlStateHighlighted];

        [self addTarget:self action:@selector(onTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)setCandidateObjects:(NSArray<NTESLiveSelectObject *> *)candidateObjects
{
    _candidateObjects = candidateObjects;
    for(UIButton *button in self.subButtons)
    {
        [button removeFromSuperview];
    }
    [self.subButtons removeAllObjects];
    CGFloat width  = self.size.width;
    CGFloat height = self.size.height;
    
    for (NTESLiveSelectObject *object in candidateObjects) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = object.tag;
        [button addTarget:self action:@selector(onTouchSubButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:object.title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11.f];
        button.size = CGSizeMake(width, height);
        button.hidden = YES;
        [self addSubview:button];
        [self.subButtons addObject:button];
    }
    [self sizeToFit];
}

- (void)setUnitFrame:(CGRect)unitFrame
{
    _unitFrame = unitFrame;
    [self sizeToFit];
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    for (UIButton *button in self.subButtons) {
        button.hidden = !isSelected;
    }
}


- (CGSize)sizeThatFits:(CGSize)size
{
    CGFloat width  = self.unitFrame.size.width;
    CGFloat height = self.isSelected? self.unitFrame.size.height * self.candidateObjects.count : self.unitFrame.size.height;
    return CGSizeMake(width, height);
}



- (void)layoutSubviews
{
    if (self.isSelected)
    {
        [self setTitle:self.selectTitle forState:UIControlStateNormal];
        [self setBackgroundImage:self.selectImageNormal forState:UIControlStateNormal];
        [self setBackgroundImage:self.selectImageHighlighted forState:UIControlStateHighlighted];
    }
    else
    {
        [self setTitle:self.deselectTitle forState:UIControlStateNormal];
        [self setBackgroundImage:self.deselectImageNormal forState:UIControlStateNormal];
        [self setBackgroundImage:self.deselectImageHighlighted forState:UIControlStateHighlighted];
    }
    for (UIButton *button in self.subButtons) {
        if ([button.titleLabel.text isEqualToString:self.titleLabel.text])
        {
            [button setTitleColor:HEXCOLOR(0x238efa) forState:UIControlStateNormal];
            [button setTitleColor:HEXCOLOR(0x238efa) forState:UIControlStateHighlighted];
        }
        else
        {
            [button setTitleColor:HEXCOLOR(0x0) forState:UIControlStateNormal];
            [button setTitleColor:HEXCOLOR(0x0) forState:UIControlStateHighlighted];

        }
    }
    [super layoutSubviews];
}


- (void)onTouch
{
    self.isSelected = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.activeButton];
    
    NSTimeInterval duartion = .25f;
    CGFloat bottom = self.superview.height - self.bottom;
    [UIView animateWithDuration:duartion animations:^{
        [self sizeToFit];
        self.bottom = self.superview.height - bottom;
        CGFloat offset = 0;
        for (UIButton *button in self.subButtons) {
            button.bottom = self.height - offset;
            offset += self.unitFrame.size.height;
        }
    }];
}

- (void)onTouchSubButton:(id)sender
{
    [self close:sender];
}


- (void)close:(UIButton *)button
{
    self.isSelected = NO;
    [self.activeButton removeFromSuperview];
    
    NSTimeInterval duartion = .25f;
    CGFloat bottom = self.superview.height - self.bottom;
    if (button) {
        NTESLiveSelectObject *obj = [self findObject:button.tag];
        self.deselectTitle = obj.title;
        [self setNeedsLayout];
        if ([self.delegate respondsToSelector:@selector(onSelectObject:)]) {
            [self.delegate onSelectObject:obj];
        }
    }
    [UIView animateWithDuration:duartion animations:^{
        [self sizeToFit];
        self.bottom = self.superview.height - bottom;
        for (UIButton *button in self.subButtons) {
            button.bottom = self.height;
        }
    } completion:^(BOOL finished) {
        if (button) {
            [self.subButtons removeObject:button];
            [self.subButtons insertObject:button atIndex:0];
        }
    }];
}

- (void)setCurrentObject:(NSInteger)tag
{
    UIButton *button = [self findButton:tag];
    [self close:button];
}

- (NTESLiveSelectObject *)findObject:(NSInteger)tag
{
    for (NTESLiveSelectObject *obj in self.candidateObjects) {
        if (obj.tag == tag) {
            return obj;
        }
    }
    return nil;
}


- (UIButton *)findButton:(NSInteger)tag
{
    for (UIButton *button in self.subButtons) {
        if (button.tag == tag) {
            return button;
        }
    }
    return nil;
}

- (NTESLiveSelectActiveButton *)activeButton
{
    if (!_activeButton) {
        _activeButton = [[NTESLiveSelectActiveButton alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_activeButton addTarget:self action:@selector(onActive:) forControlEvents:UIControlEventTouchUpInside];
        _activeButton.selectButton = self;
    }
    return _activeButton;
}

- (void)onActive:(id)sender
{
    [self close:nil];
}

@end



@implementation NTESLiveSelectObject
@end

@implementation NTESLiveSelectActiveButton

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    for (UIView *view in self.selectButton.subButtons) {
        CGRect frame = [view convertRect:view.bounds toView:nil];
        if (CGRectContainsPoint(frame, point)) {
            return view;
        }
    }
    return [super hitTest:point withEvent:event];
}

@end


