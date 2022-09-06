//
//  JHRecycleOrderDetailToolbar.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailToolbar.h"
#import "JHRecycleOrderToolbarView.h"

@interface JHRecycleOrderDetailToolbar()
@property (nonatomic, strong) UIView *line;
///
@property (nonatomic, strong) JHRecycleOrderToolbarView *toolbar;
@end

@implementation JHRecycleOrderDetailToolbar

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Action functions


#pragma mark - Private Functions

#pragma mark - Bind
- (void)bindData {
  
    
}
#pragma mark - setupUI
- (void)setupUI {
    self.userInteractionEnabled = true;
    [self addSubview:self.toolbar];
    [self addSubview:self.line];
}
- (void)layoutViews {
    [self.toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(7);
        make.left.equalTo(self).offset(ContentLeftSpace);
        make.right.equalTo(self).offset(-ContentLeftSpace);
        make.height.mas_equalTo(RecycleOrderArbitrationToolbarHeight);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.right.equalTo(self).offset(0);
        make.height.mas_equalTo(0.5);
    }];
}

#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderDetailToolbarViewModel *)viewModel {
    _viewModel = viewModel;
    self.toolbar.viewModel = self.viewModel.toolbarViewModel;
    [self bindData];
}

- (JHRecycleOrderToolbarView *)toolbar {
    if (!_toolbar) {
        _toolbar = [[JHRecycleOrderToolbarView alloc] initWithFrame:CGRectZero];
        _toolbar.leftSpace = ContentLeftSpace;
    }
    return _toolbar;
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame: CGRectZero];
        _line.backgroundColor = HEXCOLOR(0xf0f0f0);
    }
    return _line;
}
@end
