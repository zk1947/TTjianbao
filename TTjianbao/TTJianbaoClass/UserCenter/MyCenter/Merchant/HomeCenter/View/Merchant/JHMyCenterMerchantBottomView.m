//
//  JHMyCenterMerchantBottomView.m
//  TTjianbao
//
//  Created by lihui on 2021/4/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCenterMerchantBottomView.h"
#import "JHMyCenterMerchantContentView.h"

@interface JHMyCenterMerchantBottomView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) JHMyCenterMerchantContentView *livingView;
@property (nonatomic, strong) JHMyCenterMerchantContentView *storeView;
@property (nonatomic, assign) CGFloat livingHeight;
@property (nonatomic, assign) CGFloat storeHeight;
@end

@implementation JHMyCenterMerchantBottomView

- (void)updateOrderInfo:(NSInteger)index {
    if (index == 1) {
        self.storeView.lastDayCompleteMoney = self.lastDayCompleteMoney;
        [self.storeView.tableView reloadData];
    }
    else {
        self.livingView.lastDayCompleteMoney = self.lastDayCompleteMoney;
        [self.livingView.tableView reloadData];
    }
}

- (void)changeContentOffset:(NSInteger)index {
    [self changeContentOffset:index animated:YES];
}

- (void)changeContentOffset:(NSInteger)index animated:(BOOL)animated {
    [_scrollView setContentOffset:CGPointMake(index*ScreenW, 0) animated:animated];
    if (index == 1) {
        _contentHeight = self.storeHeight;
        [self.storeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.contentHeight);
        }];
    }
    else {
        _contentHeight = self.livingHeight;
        [self.livingView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.contentHeight);
        }];
    }
    [self changeHeight:_contentHeight];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    [self changeContentOffset:currentIndex animated:NO];
}

- (void)setWithDrawMoney:(NSString *)withDrawMoney {
    _withDrawMoney = withDrawMoney;
    if ([withDrawMoney isNotBlank]) {
        if (self.currentIndex == 1) {
            _storeView.withDrawMoney = withDrawMoney;
        }
        else {
            _livingView.withDrawMoney = withDrawMoney;
        }
    }
}

- (void)setLastDayCompleteMoney:(NSString *)lastDayCompleteMoney {
    _lastDayCompleteMoney = lastDayCompleteMoney;
    if ([lastDayCompleteMoney isNotBlank]) {
        if (self.currentIndex == 1) {
            _storeView.lastDayCompleteMoney = lastDayCompleteMoney;
        } else {
            _livingView.lastDayCompleteMoney = lastDayCompleteMoney;
        }
    }
}


- (void)setLivingData:(NSArray *)livingData {
    if (!livingData) {
        return;
    }
    _livingData = livingData;
    self.livingView.contentData = livingData;
}

- (void)setStoreData:(NSArray *)storeData {
    if (!storeData) {
        return;
    }
    _storeData = storeData;
    self.storeView.contentData = storeData;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _livingHeight = CGFLOAT_MIN;
        _storeHeight = CGFLOAT_MIN;
        [self initViews];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.scrollView.contentOffset = CGPointMake(ScreenW, 0);
        });
    }
    return self;
}

- (void)initViews {
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    [self addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(2*ScreenW, self.bounds.size.height);
    [_scrollView addSubview:self.livingView];
    [_scrollView addSubview:self.storeView];
    
    [self.livingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.scrollView);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(self.scrollView.mas_height);
    }];
    [self.storeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.livingView.mas_right);
        make.top.bottom.equalTo(self.livingView);
        make.width.mas_equalTo(ScreenW);
        make.height.mas_equalTo(self.scrollView.mas_height);
    }];
}

- (JHMyCenterMerchantContentView *)livingView {
    if (!_livingView) {
        _livingView = [[JHMyCenterMerchantContentView alloc] initWithContentData:@[]];
        _livingView.type = JHMyCenterContentTypeLiving;
        @weakify(self);
        _livingView.changeHeightBlock = ^(CGFloat height) {
            @strongify(self);
            self.livingHeight = MAX(self.livingHeight, height);
//            [self.livingView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(self.livingHeight);
//            }];
//            [self changeHeight:self.livingHeight];
        };
    }
    return _livingView;
}

- (void)changeHeight:(CGFloat)height {
    if (self.changeHeightBlock) {
        self.changeHeightBlock(height);
    }
}

- (JHMyCenterMerchantContentView *)storeView {
    if (!_storeView) {
        _storeView = [[JHMyCenterMerchantContentView alloc] initWithContentData:@[]];
        _storeView.type = JHMyCenterContentTypeStore;
        @weakify(self);
        _storeView.changeHeightBlock = ^(CGFloat height) {
            @strongify(self);
            self.storeHeight = MAX(self.storeHeight, height);
//            [self.storeView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(self.storeHeight);
//            }];
//            [self changeHeight:self.storeHeight];
        };
    }
    return _storeView;
}

@end
