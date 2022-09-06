//
//  JHStoreDetailView.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailView.h"
#import "JHStoreDetailFunctionView.h"
#import "JHStoreDetailBaseCell.h"
#import "JHStoreDetailPriceCell.h"
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
#import "MJRefreshHeader.h"
#import "MBProgressHUD.h"
#import "JHB2CAuctionInfoCell.h"
#import "JHB2CCommentHeader.h"
#import "JHB2CCommentCell.h"
#import "JHB2CSameShopCell.h"
#import "JHB2CReCommendCell.h"

static const CGFloat AlertLabelHeight = 30.0f;

@interface JHStoreDetailView ()<UITableViewDelegate, UITableViewDataSource>
{
    BOOL canSetIndex;
    BOOL canResetContentInset;
}
/// 列表
@property (nonatomic, strong) UITableView *tableView;

/// 底部工具区
@property (nonatomic, strong) JHStoreDetailFunctionView *functionView;
/// 规格参数的
@property (nonatomic, assign) CGFloat specOffset;
@property (nonatomic, strong) UILabel *alertLabel;
@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;//收藏返回顶部view

@property(nonatomic) BOOL  hasShowSameShopOrRecoment;

@property(nonatomic, strong) JHB2CReCommendCell * reComCell;

@property(nonatomic) BOOL ignoreCanScroll;

@end

@implementation JHStoreDetailView

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
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
    [cellViewModel.pushvc sendNext:nil];
//    if (cellViewModel.cellType != ImageCell) {
//        [cellViewModel.pushvc sendNext:nil];
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
- (void)scrollToIndex:(NSUInteger)index  andTitle:(NSString*)title{
    canSetIndex = false;
    if ([title isEqualToString:@"推荐"]) {
        index = 3;
    }
    if (self.reComCell.canScroll) {
        self.ignoreCanScroll = YES;
        self.reComCell.canScroll = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.ignoreCanScroll = NO;
        });
    }

    if (index == 0) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.tableView scrollToTopAnimated:true];
    }else if(index == 1){
        canResetContentInset = true;
        self.tableView.contentInset = UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0 );
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.viewModel.specSectionIndex];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
    }else if(index == 2){
        canResetContentInset = true;
        self.tableView.contentInset = UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0 );
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.viewModel.commentSectionIndex];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
    }else if(index == 3){
        canResetContentInset = true;
        self.tableView.contentInset = UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0 );
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.viewModel.reCommentSectionIndex];
        if (!self.hasShowSameShopOrRecoment) {
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:false];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
            });
        }else{
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:true];
        }
    }
    //埋点
    [self addStatisticNav:title];
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

/// 设置选项卡index
- (void)setCategoryTitleIndexWithOffsetY : (CGFloat)y {
    if (!canSetIndex) { return; }// 滚动与点击冲突
    NSArray *visArr = self.tableView.indexPathsForVisibleRows;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.viewModel.specSectionIndex];
    NSIndexPath *indexPathCom = [NSIndexPath indexPathForRow:0 inSection:self.viewModel.commentSectionIndex];
    NSIndexPath *indexPathRecom = [NSIndexPath indexPathForRow:0 inSection:self.viewModel.reCommentSectionIndex];

    //基准线
    CGFloat baseOrignY = y + UI.statusAndNavBarHeight;
    if ([visArr containsObject:indexPath]) {
        JHStoreDetailBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (CGRectGetMaxY(cell.frame) > baseOrignY &&  CGRectGetMinY(cell.frame) < baseOrignY) {
            self.viewModel.categoryTitleIndex = 1;
        }else if(CGRectGetMinY(cell.frame) > baseOrignY){
            self.viewModel.categoryTitleIndex = 0;
        }
    }else if ([visArr containsObject:indexPathCom]) {
        JHStoreDetailBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPathCom];
        if (CGRectGetMaxY(cell.frame) > baseOrignY &&  CGRectGetMinY(cell.frame) < baseOrignY) {
            self.viewModel.categoryTitleIndex = 2;
        }else if(CGRectGetMinY(cell.frame) > baseOrignY + 38.f){
            self.viewModel.categoryTitleIndex = 1;
        }
    }else if([visArr containsObject:indexPathRecom]){
        JHStoreDetailBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPathRecom];
        if (CGRectGetMaxY(cell.frame) > baseOrignY &&  CGRectGetMinY(cell.frame) < baseOrignY) {
            self.viewModel.categoryTitleIndex = 3;
        }else if(CGRectGetMinY(cell.frame) > baseOrignY){
            self.viewModel.categoryTitleIndex = 2;
        }
    }
}
- (void)reSetTableViewContent {
    if (canResetContentInset == true){ // 避免滚动冲突
        canResetContentInset = false;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [self.viewModel.refreshTableView subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    [self.viewModel.endRefreshing subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
        [self hideProgressHUD];
    }];
    [self.viewModel.refreshCell subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if (x == nil) { return; }
        NSUInteger section = [x[0] integerValue];
        NSUInteger row = [x[1] integerValue];
        if (section >= self.viewModel.cellViewModelList.count ) {
            return;
        }
        JHStoreDetailSectionCellViewModel *viewModel = self.viewModel.cellViewModelList[section];
        if (row >= viewModel.cellViewModelList.count ) {
            return;
        }
        [self.tableView beginUpdates];
        [self.tableView reloadRow:row inSection:section
                 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }];
    [RACObserve(self.viewModel, productSellStatusDesc) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self updateAlertViewWithText:x];
    }];
}
- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self animated:true];
}
#pragma mark - SetUI
- (void)setupUI {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.tableView];
    [self addSubview:self.functionView];
    [self addSubview:self.alertLabel];
    //右下角浮窗按钮
    [self addSubview:self.floatView];
}
- (void)layoutViews {
    if (self.shotScreen) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.left.right.equalTo(self).offset(0);
        }];
    }else{
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self).offset(0);
            make.bottom.equalTo(self.alertLabel.mas_top).offset(0);
        }];
    }
    [self.functionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self).offset(0);
        make.height.mas_equalTo(60);
    }];
    [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.functionView.mas_top).offset(0);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(AlertLabelHeight);
    }];
    
}
- (void)registerCells {
    [self.tableView registerClass:[JHStoreDetailPriceCell class]
           forCellReuseIdentifier:@"JHStoreDetailPriceCell"];
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
           forCellReuseIdentifier:@"JHStoreDetailSectionTitleCell"];
    [self.tableView registerClass:[JHStoreDetailGoodsDesCell class]
           forCellReuseIdentifier:@"JHStoreDetailGoodsDesCell"];
    [self.tableView registerClass:[JHB2CAuctionInfoCell class]
           forCellReuseIdentifier:@"JHB2CAuctionInfoCell"];
    [self.tableView registerClass:[JHB2CCommentCell class]
           forCellReuseIdentifier:@"JHB2CCommentCell"];
    [self.tableView registerClass:[JHB2CSameShopCell class]
           forCellReuseIdentifier:@"JHB2CSameShopCell"];
    [self.tableView registerClass:[JHB2CReCommendCell class]
           forCellReuseIdentifier:@"JHB2CReCommendCell"];
    [self.tableView registerClass:[JHB2CCommentHeader class]
           forCellReuseIdentifier:@"JHB2CCommentHeader"];

    

}

#pragma mark - Tableview Delegate DataSource
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.scrollSubject sendNext:scrollView];
    // 重置contentInset
    if (scrollView.contentOffset.y < 100) {
        [self reSetTableViewContent];
    }
    [self setCategoryTitleIndexWithOffsetY:scrollView.contentOffset.y];
    // 设置顶部返回按钮是否隐藏
    BOOL goTopHidden = scrollView.contentOffset.y <= 100;
    self.floatView.topButton.hidden = goTopHidden;
    
    if (self.reComCell  && self.reComCell.supportScroll && !self.ignoreCanScroll) {
        NSInteger contentOffy  = scrollView.contentOffset.y;
        NSInteger maxY  = scrollView.contentSize.height;
        NSInteger viewHeight = CGRectGetHeight(scrollView.frame);
        NSInteger maxOffSetY = maxY - viewHeight;
        if (contentOffy + viewHeight >= maxY) {
            scrollView.contentOffset = CGPointMake(0, maxOffSetY);
            self.reComCell.canScroll = YES;
        }else{
            if (self.reComCell.canScroll) {
                scrollView.contentOffset = CGPointMake(0, maxOffSetY);
            }
        }
    }
    
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
        JHStoreDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailPriceCell"
                                                                       forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailPriceViewModel class]]) {
            cell.viewModel = (JHStoreDetailPriceViewModel *)cellViewModel;
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
            JHStoreDetailSpecViewModel *newViewModel = (JHStoreDetailSpecViewModel *)cellViewModel;
            newViewModel.index = indexPath.row;
            cell.viewModel = newViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == SectionTitleCell) {
        JHStoreDetailSectionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHStoreDetailSectionTitleCell"
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
    }else if (cellViewModel.cellType == AuctionListCell) {
        JHB2CAuctionInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHB2CAuctionInfoCell"
                                                                          forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHStoreDetailAuctionListViewModel class]]) {
            cell.viewModel = (JHStoreDetailAuctionListViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == CommentCell) {
        JHB2CCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHB2CCommentCell"
                                                                 forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHB2CCommentViewModel class]]) {
            cell.viewModel = (JHB2CCommentViewModel *)cellViewModel;
        }
        return cell;
    }else if (cellViewModel.cellType == SameShopCell) {
        JHB2CSameShopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHB2CSameShopCell"
                                                                 forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHB2CSameShopCellViewModel class]]) {
            cell.viewModel = (JHB2CSameShopCellViewModel *)cellViewModel;
        }
        self.hasShowSameShopOrRecoment = YES;
        return cell;
    }else if (cellViewModel.cellType == RecommentCell) {
        JHB2CReCommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHB2CReCommendCell"
                                                                 forIndexPath: indexPath];
        self.reComCell = cell;
        if ([cellViewModel isKindOfClass:[JHB2CRecommenViewModel class]]) {
            cell.viewModel = (JHB2CRecommenViewModel *)cellViewModel;
        }
        self.hasShowSameShopOrRecoment = YES;
        return cell;
    }else if (cellViewModel.cellType == CommentHeaderCell) {
        JHB2CCommentHeader *cell = [tableView dequeueReusableCellWithIdentifier:@"JHB2CCommentHeader"
                                                                 forIndexPath: indexPath];
        if ([cellViewModel isKindOfClass:[JHB2CCommentHeaderViewModel class]]) {
            cell.viewModel = (JHB2CCommentHeaderViewModel *)cellViewModel;
        }
        self.hasShowSameShopOrRecoment = YES;
        return cell;
    }
    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JHStoreDetailSectionCellViewModel *viewModel = self.viewModel.cellViewModelList[indexPath.section];
    JHStoreDetailCellBaseViewModel *cellViewModel = viewModel.cellViewModelList[indexPath.item];
    if (cellViewModel.cellType == CommentCell || cellViewModel.cellType == GoodsDesCell || cellViewModel.cellType == CommentHeaderCell
        || cellViewModel.cellType == SpecCell) {
        return UITableViewAutomaticDimension;
    }
    return cellViewModel.height;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.viewModel.cellViewModelList.count - 1 == section) {return 0.1f;}
    ///拍卖类型没有记录时候 0.1
    JHStoreDetailSectionCellViewModel *viewModel = self.viewModel.cellViewModelList[section];
    if (viewModel.sectionType == SectionType_AuctionList) {
        JHStoreDetailCellBaseViewModel *cellViewModel = viewModel.cellViewModelList[0];
        if (cellViewModel.height < 1) {
            return 0.1f;
        }else{
            return 10.0f;
        }
    }
    if (viewModel.sectionType == SectionType_ProductDetail || viewModel.sectionType == SectionType_BaoZhang ) {
        return 0.1f;
    }
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
    [self showProgressHUD];
    [self.viewModel getDetailInfo];
}
- (JHStoreDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[JHStoreDetailViewModel alloc] init];
    }
    return _viewModel;
}
- (UITableView *)tableView {
    if (!_tableView) {
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
        _tableView.scrollsToTop = false;
//        _tableView.estimatedRowHeight = 210;
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self.viewModel getDetailInfo];
        }];
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
            if (self.reComCell.canScroll) {
                self.ignoreCanScroll = YES;
                self.reComCell.canScroll = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.ignoreCanScroll = NO;
                });
            }
            [self.tableView scrollToTop];
            [self statisticsBackTop];
            [self.viewModel reportBackTopEvent];

        };
    }
    return _floatView;
}

- (void)setShotScreen:(BOOL)shotScreen{
    _shotScreen = shotScreen;
    self.functionView.hidden = shotScreen;
    self.floatView.hidden = shotScreen;
    
    self.viewModel.shotScreen = shotScreen;
}
#pragma mark - 埋点
- (void)statisticsBackTop {
    
    
}


/// 顶部区域切换点击打点
/// @param navTitle
- (void)addStatisticNav:(NSString*)navTitle{
    if (!navTitle.length) {return;}
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_position"] = @"商城商品详情页";
    parDic[@"button_name"] = navTitle;
    parDic[@"operation_type"] = @"click";
    parDic[@"location_commodity_id"] = self.productId;
    parDic[@"original_price"] = [NSNumber numberWithString:self.viewModel.dataModel.price]; 
    parDic[@"post_coupon_price"] = [NSNumber numberWithString:self.viewModel.dataModel.discountPrice];
    parDic[@"location_goods_type"] = self.viewModel.dataModel.thirdCateName;
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickDetailElement" params:parDic type:JHStatisticsTypeSensors];
}


@end
