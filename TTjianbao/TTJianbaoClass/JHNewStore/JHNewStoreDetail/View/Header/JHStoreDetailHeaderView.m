//
//  JHStoreHeaderView.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailHeaderView.h"


@interface JHStoreDetailHeaderView()

@end

@implementation JHStoreDetailHeaderView

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
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Action functions
#pragma mark - Private Functions
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = UIColor.blueColor;
    [self addSubview:self.cycleView];
}
- (void)layoutViews {
    [self.cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailHeaderViewModel *)viewModel {
    _viewModel = viewModel;
    self.cycleView.viewModel = self.viewModel.sycleViewModel;
}

- (JHStoreDetailCycleView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[JHStoreDetailCycleView alloc]initWithFrame:CGRectZero];
    }
    return _cycleView;
}
@end
