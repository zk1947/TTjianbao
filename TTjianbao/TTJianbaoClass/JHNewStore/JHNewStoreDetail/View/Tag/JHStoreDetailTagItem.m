//
//  JHStoreDetailTagItem.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailTagItem.h"
@interface JHStoreDetailTagItem()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation JHStoreDetailTagItem
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
#pragma mark - Public Functions

#pragma mark - Private Functions

#pragma mark - Action functions
#pragma mark - Bind
- (void) bindData {
    RAC(self.titleLabel, text) = [RACObserve(self.viewModel, titleText) takeUntil: self.rac_prepareForReuseSignal];
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self jh_cornerRadius:2];
    [self jh_borderWithColor:[UIColor colorWithHexString:@"FA9990"] borderWidth:0.5];
    [self addSubview:self.titleLabel];
}
- (void) layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(TagItemTitleLeftSpace);
        make.right.equalTo(self).offset(-TagItemTitleLeftSpace);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailTagItemViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:TagItemTitleTextFontSize];
        _titleLabel.textColor = [UIColor colorWithHexString:@"F63421"];
    }
    return _titleLabel;
}
@end
