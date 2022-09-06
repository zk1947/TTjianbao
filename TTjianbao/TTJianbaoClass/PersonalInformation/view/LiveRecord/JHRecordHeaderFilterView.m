//
//  JHRecordHeaderFilterView.m
//  TTjianbao
//
//  Created by lihui on 2021/3/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecordHeaderFilterView.h"
#import "JHRecordFilterMenuView.h"
#import "JHLiveRecordModel.h"

#define bottomHeight  9.f
#define filterViewHeight  43.f

@interface JHRecordHeaderFilterView ()
@property (nonatomic, strong) NSMutableArray <JHRecordFilterMenuView *>*filterMenuArray;
@property (nonatomic, assign) NSInteger filterCount;
@end

@implementation JHRecordHeaderFilterView

+ (CGFloat)viewHeight {
    return bottomHeight + filterViewHeight*[[self alloc] filterCount];
}

- (void)setFilterModels:(NSArray<JHRecordFilterModel *> *)filterModels {
    if (!filterModels || filterModels.count == 0) {
        return;
    }
    _filterModels = filterModels;
    for (int i = 0; i < filterModels.count; i ++) {
        JHRecordFilterMenuView *filterView = self.filterMenuArray[i];
        filterView.model = filterModels[i];
    }
}

- (NSMutableArray<JHRecordFilterMenuView *> *)filterMenuArray {
    if (!_filterMenuArray) {
        _filterMenuArray = [NSMutableArray array];
    }
    return _filterMenuArray;
}

- (instancetype)initWithFrame:(CGRect)frame filterCount:(NSInteger)filterCount {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kColorFFF;
        _filterCount = filterCount;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    for (int i = 0; i < self.filterCount; i ++) {
        JHRecordFilterMenuView *menuView = [[JHRecordFilterMenuView alloc] init];
        @weakify(self);
        menuView.completeSelectBlock = ^(JHRecordFilterMenuModel * _Nonnull tagModel) {
            @strongify(self);
            if (self.selectBlock) {
                self.selectBlock(tagModel, i);
            }
        };
        [self.filterMenuArray addObject:menuView];
        [self addSubview:menuView];
        [menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self).offset(filterViewHeight*i+7.5);
            make.height.mas_equalTo(filterViewHeight);
        }];
    }
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = kColorF5F5F8;
    [self addSubview:bottomLine];
    
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.mas_equalTo(bottomHeight);
    }];
}

@end
