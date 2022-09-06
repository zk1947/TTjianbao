//
//  JHStoreDetailCycleVideoItem.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCycleVideoItem.h"

@interface JHStoreDetailCycleVideoItem()

@property (nonatomic, strong) UIButton *playButton;

@end

@implementation JHStoreDetailCycleVideoItem
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
    [self.playSubject sendNext:nil];
}
#pragma mark - Bind
- (void)setupViewModel:(JHStoreDetailCycleItemViewModel *)viewModel {
    self.viewModel = viewModel;
    [self bindData];
}
- (void) bindData {
    @weakify(self)
    [[RACObserve(self.viewModel, imageUrl)
      takeUntil:self.rac_prepareForReuseSignal]
      subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        [self.imageView jh_setImageWithUrl:x placeHolder:@"newStore_default_header_placeholder"];
    }];
    [[self.playSubject
      takeUntil:self.rac_prepareForReuseSignal]
      subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.playButton.hidden = true;
        self.imageView.hidden = true;
        self.imageView.userInteractionEnabled = false;
    }];
}
#pragma mark - setupUI
- (void) setupUI {
    [super setupUI];
    self.backgroundColor = UIColor.whiteColor;
    
    [self addSubview:self.playButton];
}
- (void) layoutViews {
    [super layoutViews];

    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(30);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
}
#pragma mark - Lazy

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.jh_imageName(@"newStore_play_icon")
        .jh_action(self, @selector(didClickPlay:));
    }
    return _playButton;
}
- (RACReplaySubject *)playSubject {
    if (!_playSubject) {
        _playSubject = [RACReplaySubject subject];
    }
    return _playSubject;
}
@end
