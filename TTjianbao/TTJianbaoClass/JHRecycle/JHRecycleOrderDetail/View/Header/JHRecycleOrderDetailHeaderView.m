//
//  JHRecycleOrderDetailHeaderView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailHeaderView.h"
#import "UIView+JHGradient.h"

@interface JHRecycleOrderDetailHeaderView()

@property (nonatomic, strong) JHRecycleOrderNodeView *nodeView;

@end
@implementation JHRecycleOrderDetailHeaderView

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
#pragma mark - setupUI
- (void)setupUI {
//    self.backgroundColor = UIColor.redColor;
    [self jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xfe5e19), HEXCOLOR(0xf12429)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [self addSubview:self.nodeView];
}
- (void)layoutViews {
    [self.nodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(LeftSpace);
        make.right.equalTo(self).offset(-LeftSpace);
        make.centerY.equalTo(self.mas_centerY).offset(0);
        make.height.mas_equalTo(RecycloOrderNodeHeight);
        
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHRecycleOrderDetailHeaderViewModel *)viewModel {
    _viewModel = viewModel;
    self.nodeView.viewModel = viewModel.nodeViewModel;
}

- (JHRecycleOrderNodeView *)nodeView {
    if (!_nodeView) {
        _nodeView = [[JHRecycleOrderNodeView alloc] initWithFrame:CGRectZero];
        
    }
    return _nodeView;
}
@end
