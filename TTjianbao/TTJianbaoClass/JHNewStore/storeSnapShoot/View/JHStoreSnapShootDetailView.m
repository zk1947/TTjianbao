//
//  JHStoreSnapShootDetailView.m
//  TTjianbao
//
//  Created by jiangchao on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreSnapShootDetailView.h"
#import "JHStoreDetailFunctionView.h"
#import "JHStoreDetailBaseCell.h"
#import "JHStoreSnapShootPriceCell.h"
#import "JHStoreDetailTitleCell.h"
#import "JHStoreDetailTagCell.h"
#import "JHStoreDetailSpecialCell.h"
#import "JHStoreDetailCouponCell.h"
#import "JHStoreDetailEducationCell.h"
#import "JHStoreDetailShopTitleCell.h"
#import "JHStoreDetailShopCell.h"
#import "JHStoreDetailSpecCell.h"
#import "JHStoreDetailImageCell.h"
#import "JHStoreDetailSecurityCell.h"
#import "JHStoreDetailSectionTitleCell.h"
#import "JHStoreDetailGoodsDesCell.h"
#import "JHRefreshGifHeader.h"
#import "JHMarketFloatLowerLeftView.h"
#import "JHPhotoBrowserManager.h"
#import "JHStoreSnapShootPriceViewModel.h"

static const CGFloat AlertLabelHeight = 30.0f;

@interface JHStoreSnapShootDetailView ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL canSetIndex;
    CGFloat specCellY;
}
/// 列表
@property (nonatomic, strong) UITableView *tableView;

/// 底部工具区
@property (nonatomic, strong) JHStoreDetailFunctionView *functionView;
/// 规格参数的
@property (nonatomic, assign) CGFloat specOffset;
@property (nonatomic, strong) UILabel *alertLabel;
/// 浮层
@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;
@end

@implementation JHStoreSnapShootDetailView

#pragma mark - Life Cycle Functions
- (instancetype)init {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setupUI];
        [self registerCells];
        [self bindData];
        canSetIndex = true;
    }
    
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}

- (void)viewDidAppear{
    //收藏等数据刷新
    [self.floatView loadData];
}

- (void)dealloc {
    NSLog(@"商品详情-home-%@ 释放", [self class]);
}
#pragma mark - Action functions
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailSectionCellViewModel *viewModel = self.viewModel.cellViewModelList[indexPath.section];
    JHStoreDetailCellBaseViewModel *cellViewModel = viewModel.cellViewModelList[indexPath.item];
    
//    if (cellViewModel.cellType != ImageCell) {
        [cellViewModel.pushvc sendNext:nil];
//    }else {
        // 暂不需要查看大图
//    [self showPhotoBrowserWithModel:cellViewModel];
//    }
}
- (void)showPhotoBrowserWithModel : (JHStoreDetailCellBaseViewModel *)model {
    JHStoreDetailImageViewModel *imageModel = (JHStoreDetailImageViewModel *) model;

    [JHPhotoBrowserManager showPhotoBrowserThumbImages:self.viewModel.goodsThumbsUrls
                                          mediumImages:self.viewModel.goodsMediumUrls
                                            origImages:self.viewModel.goodsLargeUrls
                                               sources:@[[UIImageView new]]
                                          currentIndex:imageModel.index
                                   canPreviewOrigImage:true
                                             showStyle:GKPhotoBrowserShowStyleZoom];
}
#pragma mark - Public Functions
- (void)scrollToTop {
    canSetIndex = false;
    [self.tableView scrollToTop];
}
- (void)scrollToSpec {
    canSetIndex = false;
    self.tableView.contentInset = UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0 );
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.viewModel.specSectionIndex];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
}
- (void)updateAlertViewWithText : (NSString *)text {
    if (text.length > 0) {
        self.alertLabel.hidden = false;
        self.alertLabel.text = text;
        [self.alertLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(AlertLabelHeight);
        }];
    }else {
        self.alertLabel.hidden = true;
        [self.alertLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }
}
#pragma mark - Private Functions
/// 记录规格参数的位置。方便滚动
- (void)setSpecCellY {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.viewModel.specSectionIndex];
    JHStoreDetailBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    specCellY = cell.frame.origin.y;
}
/// 设置选项卡index
- (void)setCategoryTitleIndexWithOffsetY : (CGFloat)y {
    if (!canSetIndex) { return; }// 滚动与点击冲突
    if (specCellY == 0) {
        [self setSpecCellY];
    }
    
    if ((y) > specCellY - UI.statusAndNavBarHeight) {
        self.viewModel.categoryTitleIndex = 1;
    }else {
        self.viewModel.categoryTitleIndex = 0;
    }
}
-(void)setupMJRefresh
{
//    @weakify(self);
//    self.tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
//        @strongify(self);
//        [self.viewModel getDetailInfo];
//    }];
//    [self.tableView.mj_header beginRefreshing];
    [self.viewModel getDetailInfo];
}

#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [self.viewModel.refreshTableView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
//        [self.tableView jh_reloadDataWithEmputyView];
        [self.tableView reloadData];
    }];
    [self.viewModel.endRefreshing subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
    }];
    [self.viewModel.refreshCell subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        NSUInteger section = [x[0] integerValue];
        NSUInteger row = [x[1] integerValue];
        [self.tableView beginUpdates];
        [self.tableView reloadRow:row inSection:section
                 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self setSpecCellY];
    }];
    [RACObserve(self.viewModel, productSellStatusDesc) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self updateAlertViewWithText:x];
    }];
}
#pragma mark - SetUI
- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.tableView];
    
    //右下角浮窗按钮
    [self addSubview:self.floatView];
}
- (void)layoutViews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
    }];
//    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self).offset(0);
//        make.left.right.equalTo(self).offset(0);
//        make.height.mas_equalTo(60);
//    }];
//    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.functionView.mas_top).offset(0);
//        make.left.right.equalTo(self);
//        make.height.mas_equalTo(AlertLabelHeight);
//    }];
//    [self.floatingView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(50, 110));
//        make.bottom.equalTo(self.functionView.mas_top).offset(-(AlertLabelHeight + 10));
//        make.right.equalTo(self).offset(-10);
//    }];
    
}
- (void)registerCells {
    [self.tableView registerClass:[JHStoreSnapShootPriceCell class]
           forCellReuseIdentifier:@"JHStoreSnapShootPriceCell"];
    [self.tableView registerClass:[JHStoreDetailTitleCell class]
           forCellReuseIdentifier:@"JHStoreDetailTitleCell"];
    [self.tableView registerClass:[JHStoreDetailTagCell class]
           forCellReuseIdentifier:@"JHStoreDetailTagCell"];
    [self.tableView registerClass:[JHStoreDetailSpecialCell class]
           forCellReuseIdentifier:@"JHStoreDetailSpecialCell"];
    [self.tableView registerClass:[JHStoreDetailCouponCell class]
           forCellReuseIdentifier:@"JHStoreDetailCouponCell"];
    [self.tableView registerClass:[JHStoreDetailEducationCell class]
           forCellReuseIdentifier:@"JHStoreDetailEducationCell"];
    [self.tableView registerClass:[JHStoreDetailShopTitleCell class]
           forCellReuseIdentifier:@"JHStoreDetailShopTitleCell"];
    [self.tableView registerClass:[JHStoreDetailShopCell class]
           forCellReuseIdentifier:@"JHStoreDetailShopCell"];
    [self.tableView registerClass:[JHStoreDetailSpecCell class]
           forCellReuseIdentifier:@"JHStoreDetailSpecCell"];
    [self.tableView registerClass:[JHStoreDetailImageCell class]
           forCellReuseIdentifier:@"JHStoreDetailImageCell"];
    [self.tableView registerClass:[JHStoreDetailSecurityCell class]
           forCellReuseIdentifier:@"JHStoreDetailSecurityCell"];
    [self.tableView registerClass:[JHStoreDetailSectionTitleCell class]
           forCellReuseIdentifier:@"JHStoreDetailGoodsDesTitleCell"];
    [self.tableView registerClass:[JHStoreDetailGoodsDesCell class]
           forCellReuseIdentifier:@"JHStoreDetailGoodsDesCell"];
    
    
}

#pragma mark - Tableview Delegate DataSource
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.scrollSubject sendNext:scrollView];
    NSLog(@"s1s%f",scrollView.contentOffset.y);
    // 重置contentInset
    if (scrollView.contentOffset.y < 100) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self setCategoryTitleIndexWithOffsetY:scrollView.contentOffset.y];
    // 设置顶部返回按钮是否隐藏
    BOOL goTopHidden = scrollView.contentOffset.y <= 100;
    self.floatView.topButton.hidden = goTopHidden;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    canSetIndex = true;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.cellViewModelList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    JHStoreDetailSectionCellViewModel *viewModel = self.viewModel.cellViewModelList[section];
    return viewModel.cellViewModelList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailSectionCellViewModel *viewModel = self.viewModel.cellViewModelList[indexPath.section];
    JHStoreDetailCellBaseViewModel *cellViewModel = viewModel.cellViewModelList[indexPath.item];

    if (cellViewModel.cellType == PriceCell) {
        JHStoreSnapShootPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreSnapShootPriceCell"
                                                                       forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreSnapShootPriceViewModel class]]) {
            cell.viewModel = (JHStoreSnapShootPriceViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == TitleCell) {
        JHStoreDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailTitleCell"
                                                                       forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailTitleViewModel class]]) {
            cell.viewModel = (JHStoreDetailTitleViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == TagCell) {
        JHStoreDetailTagCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailTagCell"
                                                                     forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailTagViewModel class]]) {
            cell.viewModel = (JHStoreDetailTagViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == SpecialCell) {
        JHStoreDetailSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailSpecialCell"
                                                                         forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailSpecialViewModel class]]) {
            cell.viewModel = (JHStoreDetailSpecialViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == CouponCell) {
        JHStoreDetailCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailCouponCell"
                                                                        forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailCouponViewModel class]]) {
            cell.viewModel = (JHStoreDetailCouponViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == EducationCell) {
        JHStoreDetailEducationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailEducationCell"
                                                                           forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailEducationViewModel class]]) {
            cell.viewModel = (JHStoreDetailEducationViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == ShopTitleCell) {
        JHStoreDetailShopTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailShopTitleCell"
                                                                      forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailShopTitleViewModel class]]) {
            cell.viewModel = (JHStoreDetailShopTitleViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == ShopCell) {
        JHStoreDetailShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailShopCell"
                                                                      forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailShopViewModel class]]) {
            cell.viewModel = (JHStoreDetailShopViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == SpecCell) {
        JHStoreDetailSpecCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailSpecCell"
                                                                      forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailSpecViewModel class]]) {
            cell.viewModel = (JHStoreDetailSpecViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == SectionTitleCell) {
        JHStoreDetailSectionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailGoodsDesTitleCell"
                                                                              forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailSectionTitleViewModel class]]) {
            cell.viewModel = (JHStoreDetailSectionTitleViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == GoodsDesCell) {
        JHStoreDetailGoodsDesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailGoodsDesCell"
                                                                          forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailGoodsDesViewModel class]]) {
            cell.viewModel = (JHStoreDetailGoodsDesViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == ImageCell) {
        JHStoreDetailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailImageCell"
                                                                       forIndexPath: indexPath];
        
        if ([cellViewModel isKindOfClass:[JHStoreDetailImageViewModel class]]) {
            cell.viewModel = (JHStoreDetailImageViewModel *)cellViewModel;
            cell.viewModel.sectionIndex = indexPath.section;
            cell.viewModel.rowIndex = indexPath.row;
        }
        return cell;
    }else if (cellViewModel.cellType == SecurityCell) {
        JHStoreDetailSecurityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailSecurityCell"
                                                                          forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailSecurityViewModel class]]) {
            cell.viewModel = (JHStoreDetailSecurityViewModel *)cellViewModel;
        }
        return cell;
    }

    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHStoreDetailSectionCellViewModel *viewModel = self.viewModel.cellViewModelList[indexPath.section];
    JHStoreDetailCellBaseViewModel *cellViewModel = viewModel.cellViewModelList[indexPath.item];

    return cellViewModel.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithHexString:@"F5F5F8"];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithHexString:@"F5F5F8"];
    return view;
}

#pragma mark - Lazy
- (void)setProductId:(NSString *)productId {
    _productId = productId;
    self.viewModel.productId = productId;
    [self setupMJRefresh];
}
- (JHStoreSnapShootViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHStoreSnapShootViewModel alloc] init];
    }
    return _viewModel;
}
- (UITableView *)tableView {
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = false;
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
    }
    return _tableView;
}
- (JHStoreDetailHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JHStoreDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.viewModel.headerViewModel.height)];
        _headerView.viewModel = self.viewModel.headerViewModel;
    }
    return _headerView;
}
- (JHStoreDetailFunctionView *)functionView {
    if (!_functionView) {
        _functionView = [[JHStoreDetailFunctionView alloc]initWithViewModel:self.viewModel.functionViewModel];
        @weakify(self);
        _functionView.collectButtonClickBlock = ^{
            @strongify(self);
            //收藏等数据刷新
            [self.floatView loadData];
        };
    }
    return _functionView;
}
- (RACSubject *)scrollSubject {
    if (!_scrollSubject) {
        _scrollSubject = [RACSubject subject];
    }
    return _scrollSubject;
}
- (UILabel *)alertLabel {
    if (!_alertLabel) {
        _alertLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _alertLabel.hidden = true;
        _alertLabel.font = [UIFont fontWithName:kFontMedium size:12];
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.textColor = [UIColor colorWithHexString:@"FF6A00"];
        _alertLabel.backgroundColor = [UIColor colorWithHexString:@"FFFAF2"];
    }
    return _alertLabel;
}

- (JHMarketFloatLowerLeftView *)floatView{
    if (!_floatView) {
        _floatView = [[JHMarketFloatLowerLeftView alloc] initWithShowType:JHMarketFloatShowTypeBackTop];
        _floatView.isHaveTabBar = NO;
        @weakify(self)
        //收藏
        _floatView.collectGoodsBlock = ^{
            @strongify(self)
            [self.viewModel pushCollectList];
        };
        //返回顶部
        _floatView.backTopViewBlock = ^{
            @strongify(self)
            [self.tableView scrollToTop];

        };
    }
    return _floatView;
}
@end
