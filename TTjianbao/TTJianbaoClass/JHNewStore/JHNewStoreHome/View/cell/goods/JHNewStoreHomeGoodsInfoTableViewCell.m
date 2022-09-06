//
//  JHNewStoreHomeGoodsInfoTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeGoodsInfoTableViewCell.h"
#import "JHNewStoreHomeGoodsCagetoryView.h"
#import "JHNewStoreHomeViewModel.h"
#import "JHNewStoreGoodsInfoView.h"
#import "UIScrollView+JHEmpty.h"
#import "JXCategoryListContainerView.h"
#import "JHNewstoreGoodsListViewController.h"
#import "JHNewStoreHomeSingelton.h"

@interface JHNewStoreHomeGoodsInfoTableViewCell () <JHNewstoreGoodsListViewControllerDelegate>

@end

@implementation JHNewStoreHomeGoodsInfoTableViewCell
- (void)dealloc {
    NSLog(@"JHNewStoreHomeGoodsInfoTableViewCell release");
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupNewViews];
    }
    return self;
}

- (CGFloat)bottomCellHeight {
    if ([JHNewStoreHomeSingelton shared].hasBoutiqueValue) {
        return ScreenH - UI.statusBarHeight - 69.f + 9.f + 7.f - 40.f - 49.f;
    } else {
        return ScreenH - UI.statusBarHeight - 69.f + 9.f + 7.f - 40.f - 49.f + 40.f;
    }
}

- (void)setupNewViews {
    _goodListVc = [[JHNewstoreGoodsListViewController alloc] init];
    _goodListVc.delegate = self;
    [self.contentView addSubview:_goodListVc.view];
    [self.viewController addChildViewController:_goodListVc];
    [_goodListVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo([self bottomCellHeight]);
    }];
    @weakify(self);
    _goodListVc.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
        @strongify(self);
        if (self.goToBoutiqueDetailClickBlock) {
            self.goToBoutiqueDetailClickBlock(isH5,showId,boutiqueName);
        }
    };
    _goodListVc.goodsClickBlock = ^(JHNewStoreHomeGoodsProductListModel * _Nonnull model, NSIndexPath * _Nonnull indexPath) {
        @strongify(self);
        if (self.goodsClickBlock) {
            self.goodsClickBlock(model, indexPath);
        }
    };
}

- (void)releaseGoodListVC {
    [_goodListVc.view removeFromSuperview];
    _goodListVc = nil;
    [self setupNewViews];
}

- (void)refresh {
    [self.goodListVc refresh];
}

- (void)setHasBoutiqueValue:(BOOL)hasBoutiqueValue {
    _hasBoutiqueValue = hasBoutiqueValue;
    [_goodListVc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo([self bottomCellHeight]);
    }];
    _goodListVc.hasBoutiqueValue = hasBoutiqueValue;
}

#pragma mark - private
- (void)reloadCategoryViewBackgroundColor:(BOOL)isFFF {
    [self.goodListVc reloadCategoryViewBackgroundColor:isFFF];
}

- (UIScrollView *)getSubScrollViewFromSelf {
    return [self.goodListVc getSubScrollViewFromSelf];
}

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll {
    [self.goodListVc makeDeatilDescModuleScroll:canScroll];
}

- (void)makeDeatilDescModuleScrollToTop {
    [self.goodListVc makeDeatilDescModuleScrollToTop];
}

#pragma mark - JHNewstoreGoodsListViewControllerDelegate
- (void)JHNewstoreGoodsListViewControllerLeaveTop {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JHNewStoreHomeGoodsInfoTableViewCellLeaveTopd)]) {
        [self.delegate JHNewStoreHomeGoodsInfoTableViewCellLeaveTopd];
    }
}

@end
