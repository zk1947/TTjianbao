//
//  YDMediaToolBar.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDMediaToolBar.h"
#import "UIView+SDAutoLayout.h"
#import "TTjianbaoMarcoUI.h"
#import <YDCategoryKit/YDCategoryKit.h>

@interface YDMediaToolBar ()
@property (nonatomic, strong) UIButton *videoButton; //视频切换按钮
@property (nonatomic, strong) UIButton *imageButton; //图片切换按钮
@end

@implementation YDMediaToolBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    _videoButton = [self createBtnTitle:@"视频"];
    _videoButton.selected = YES;
    _imageButton = [self createBtnTitle:@"图片"];
    
    [self sd_addSubviews:@[_videoButton, _imageButton]];
    _videoButton.sd_layout.leftSpaceToView(self, 0).centerYEqualToView(self).widthIs(40).heightIs(20);
    _imageButton.sd_layout.leftSpaceToView(_videoButton, 10).centerYEqualToView(self).widthIs(40).heightIs(20);
    
    [self setupAutoWidthWithRightView:_imageButton rightMargin:0];
    
    @weakify(self);
    [[_videoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self setSelectedIndex:0];
    }];
    
    [[_imageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self setSelectedIndex:1];
    }];
}

- (UIButton *)createBtnTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithTitle:title titleColor:kColor333];
    btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:10];
    btn.clipsToBounds = YES;
    btn.sd_cornerRadiusFromHeightRatio = @(0.5);
    [btn setBackgroundImage:[UIImage imageWithColor:kColorEEE] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:kColorMain] forState:UIControlStateSelected];
    return btn;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (_selectedIndex != selectedIndex) {
        _selectedIndex = selectedIndex;
        _videoButton.selected = (selectedIndex == 0);
        _imageButton.selected = (selectedIndex == 1);
        
        if ([self.delegate respondsToSelector:@selector(mediaToolBar:didSelectAtIndex:)]) {
            [self.delegate mediaToolBar:self didSelectAtIndex:selectedIndex];
        }
    }
}

@end
