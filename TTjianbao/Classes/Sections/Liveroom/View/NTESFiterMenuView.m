//
//  NTESFiterMenuView.m
//  NEUIDemo
//
//  Created by Netease on 17/1/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "NTESFiterMenuView.h"
#import "NTESFilterMenuBar.h"
#import "UIView+NTES.h"

@interface NTESFiterMenuView ()
{
    NSInteger _selectedIndex;
}
@property (nonatomic, assign) NTESMenuType type;
@property (nonatomic, strong) NTESFilterMenuBar *filterBar;
@property (nonatomic, strong) NTESFilterMenuBar *bar;
@end

@implementation NTESFiterMenuView

- (instancetype)initWithType:(NTESMenuType)type
{
    if (self = [super init])
    {
        _type = type;
        
        self.frame = [UIScreen mainScreen].bounds;
        
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:self.bar];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.bar];
    }
    return self;

}

- (void)onTapBackground:(id)sender
{
    [self.bar cancel];
}

-(void)layoutSubviews
{
    self.bar.height = self.bar.barHeight;
    self.bar.bottom = self.height;
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

#pragma mark - Getter/Setter
- (UIView *)bar
{
    return self.filterBar;
}


- (void)setDelegate:(id<NTESMenuViewProtocol>)delegate
{
    _delegate = delegate;
    _filterBar.delegate = delegate;
}

- (NTESFilterMenuBar *)filterBar
{
    if (!_filterBar)
    {
        _filterBar = [[NTESFilterMenuBar alloc] init];
        _filterBar.frame = CGRectMake(0, self.height, self.width, _filterBar.barHeight);
        
        __weak typeof(self) weakSelf = self;
        _filterBar.selectBlock = ^(NSInteger index) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            //选择回调
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:didSelect:)]) {
                [strongSelf.delegate menuView:strongSelf didSelect:index];
            }
        };
        
        _filterBar.contrastChangedBlock = ^(CGFloat value) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:contrastDidChanged:)]) {
                [strongSelf.delegate menuView:strongSelf contrastDidChanged:value];
            }
        };
        
        _filterBar.smoothChangedBlock = ^(CGFloat value) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(menuView:smoothDidChanged:)]) {
                [strongSelf.delegate menuView:strongSelf smoothDidChanged:value];
            }
        };
    }
    return _filterBar;
}


- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    self.bar.selectedIndex = selectedIndex;
     _selectedIndex= selectedIndex;
}

- (void)setConstrastValue:(CGFloat)constrastValue
{
    if (_type == NTESMenuTypeFilter)
    {
        self.filterBar.constrastValue = constrastValue;
        
        _constrastValue = constrastValue;
    }
}

- (void)setSmoothValue:(CGFloat)smoothValue
{
    if (_type == NTESMenuTypeFilter)
    {
        self.filterBar.smoothValue = smoothValue;
        
        _smoothValue = smoothValue;
    }
}

-(NSInteger)selectedIndex
{
    return self.bar.selectedIndex;
}
@end

