//
//  JHStoreDetailCycleItem.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCycleItem.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"


@interface JHStoreDetailCycleItem()


@end

@implementation JHStoreDetailCycleItem
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
- (void)didClickPlay : (UIButton *)sender {
    
}
#pragma mark - Bind
- (void)setupViewModel : (JHStoreDetailCycleItemViewModel *)viewModel {
    self.viewModel = viewModel;
    [self bindData];
}
- (void) bindData {
    @weakify(self)
    [[RACObserve(self.viewModel, imageUrl)
     takeUntil:self.rac_prepareForReuseSignal]
    subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self.imageView jh_setImageWithUrl:x placeHolder: @"newStore_default_header_placeholder"];  //channel_place  cover_default_image
    }];
}
#pragma mark - setupUI
- (void) setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.imageView];
}
- (void) layoutViews {
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailCycleItemViewModel *)viewModel {
    _viewModel = viewModel;
}
- (YYAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[YYAnimatedImageView alloc]initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return _imageView;
}



@end
