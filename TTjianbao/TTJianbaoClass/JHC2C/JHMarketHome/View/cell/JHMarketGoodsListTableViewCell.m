//
//  JHMarketGoodsListTableViewCell.m
//  TTjianbao
//
//  Created by zk on 2021/6/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketGoodsListTableViewCell.h"
#import "JHMarketGoodsListViewController.h"
#import "JHNewStoreHomeSingelton.h"

@interface JHMarketGoodsListTableViewCell () <JHMarketGoodsListViewControllerDelegate>

@property (nonatomic, strong) JHMarketGoodsListViewController *goodListVc;

@end

@implementation JHMarketGoodsListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupNewViews];
    }
    return self;
}

- (CGFloat)bottomCellHeight {
//    if ([JHNewStoreHomeSingelton shared].hasBoutiqueValue) {
//        return ScreenH - UI.statusBarHeight - UI.bottomSafeAreaHeight - 173;
//    } else {
        return ScreenH - UI.statusBarHeight - UI.bottomSafeAreaHeight - 133;
//    }
}

- (void)setupNewViews {
    _goodListVc = [[JHMarketGoodsListViewController alloc] init];
    _goodListVc.delegate = self;
    [self.contentView addSubview:_goodListVc.view];
    [self.viewController addChildViewController:_goodListVc];
    [_goodListVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
        make.height.mas_equalTo([self bottomCellHeight] + 50);//_addH
    }];
}

- (void)releaseGoodListVC {
    [_goodListVc.view removeFromSuperview];
    _goodListVc = nil;
    [self setupNewViews];
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

- (void)JHMarketGoodsListViewControllerLeaveTop{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JHMarketGoodsListTableViewCellLeaveTopd)]) {
        [self.delegate JHMarketGoodsListTableViewCellLeaveTopd];
    }
}

- (void)setTabAlpha:(CGFloat)tabAlpha{
    _goodListVc.tabAlpha = tabAlpha;
}

- (void)setAddH:(CGFloat)addH{
    _addH = addH;
    [[self tableView] beginUpdates];
    [_goodListVc.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
        make.height.mas_equalTo([self bottomCellHeight] + _addH);
    }];
    [[self tableView] endUpdates];
}

- (UITableView *)tableView{
    UIResponder *nextResponder = self.nextResponder;
    while (![nextResponder isKindOfClass:[UITableView class]] && nextResponder != nil) {
        nextResponder = nextResponder.nextResponder;
    }
    return (UITableView *)nextResponder;
}

@end
