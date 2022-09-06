//
//  JHNewStoreGlobalSearchResultViewController.m
//  TTjianbao
//
//  Created by hao on 2021/8/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreGlobalSearchResultViewController.h"
#import "JHShopHotSellConllectionViewLayout.h"
#import "JHNewShopSortMenuView.h"
#import "JHUIFactory.h"
#import "JHNewStoreClassListViewModel.h"
#import "YDRefreshFooter.h"
#import "JHNewStoreCollectAndTopView.h"
#import "JHPlayerViewController.h"
#import "JHStoreDetailViewController.h"
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHNewStoreSpecialDetailViewController.h"
#import "JHSQCollectViewController.h"

@interface JHNewStoreGlobalSearchResultViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,JHShopHotSellConllectionViewLayoutDelegate,JHNewShopSortMenuViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;
@property (nonatomic, strong) JHNewShopSortMenuView *sortMenuView;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UITextField *highTextField;
@property (nonatomic, strong) UITextField *lowTextField;
@property (nonatomic, strong) JHNewStoreClassListViewModel *searchResultViewModel;
@property (nonatomic, assign) int sortTypeNum;
@property (nonatomic, copy) NSString *keywordStr;
@property (nonatomic, strong) JHNewStoreCollectAndTopView *topView;
@property (nonatomic, strong) JHPlayerViewController *playerController;
/** 当前播放视频的cell*/
@property (nonatomic, strong) JHNewStoreHomeGoodsCollectionViewCell *currentCell;
@property (nonatomic, strong) NSMutableArray * uploadData;

@end

@implementation JHNewStoreGlobalSearchResultViewController


- (void)viewWillDisappear:(BOOL)animated{
    if (self.uploadData.count > 0) {
        
        NSMutableArray * temp = [self.uploadData mutableCopy];
        [self sa_uploadData:temp];
        [self.uploadData removeAllObjects];
    }
    [super viewWillDisappear:animated];
}

//***************
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//***************
///带关键词来源的方法
- (void)refreshSearchResult:(NSString *)keyword from:(ZQSearchFrom)from keywordSource:(id<ZQSearchData>)keywordSource {
    self.keywordStr = keyword;
    self.sortTypeNum = 0;

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(40, 0, 0, 0));
    }];
   
    _sortMenuView.selectIndex = 0;

    [self updateLoadData:YES];
   
    
}
#pragma mark - UI

- (void)setupHeaderView{
    UIView *headerView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.view];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_offset(40);
    }];

    //热卖商品排序
    [headerView addSubview:self.sortMenuView];
    [self.sortMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(12);
        make.top.equalTo(headerView);
        make.size.mas_offset(CGSizeMake(150, 40));
    }];
    
    //价格筛选
    UIButton *sureBtn = [UIButton jh_buttonWithTarget:self action:@selector(clickSureBtnAction:) addToSuperView:headerView];
    self.sureBtn = sureBtn;
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    sureBtn.backgroundColor = HEXCOLOR(0xFED539);
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.cornerRadius = 3;
    sureBtn.alpha = 0.7;
    sureBtn.userInteractionEnabled = NO;
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-12);
        make.size.mas_offset(CGSizeMake(44, 24));
        make.centerY.equalTo(headerView);
    }];
    UITextField *highTF = [UITextField jh_textFieldWithFont:12 textAlignment:NSTextAlignmentCenter textColor:HEXCOLOR(0x333333) placeholderText:@"最高价" placeholderColor:HEXCOLOR(0xBEBEBE) addToSupView:headerView];
    self.highTextField = highTF;
    highTF.delegate = self;
    highTF.layer.cornerRadius = 3.0;
    highTF.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
    highTF.layer.borderWidth = 0.5f;
    highTF.keyboardType = UIKeyboardTypeNumberPad;
    [highTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(sureBtn.mas_left).offset(-5);
        make.size.mas_offset(CGSizeMake(55, 24));
        make.centerY.equalTo(headerView);
    }];
    JHCustomLine *line = [JHUIFactory createLine];
    line.color = HEXCOLOR(0x333333);
    [headerView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(highTF.mas_left).offset(-5);
        make.size.mas_offset(CGSizeMake(6, 1));
        make.centerY.equalTo(headerView);
    }];
    UITextField *lowTF = [UITextField jh_textFieldWithFont:12 textAlignment:NSTextAlignmentCenter textColor:HEXCOLOR(0x333333) placeholderText:@"最低价" placeholderColor:HEXCOLOR(0xBEBEBE) addToSupView:headerView];
    self.lowTextField = lowTF;
    lowTF.delegate = self;
    lowTF.layer.cornerRadius = 3.0;
    lowTF.layer.borderColor = HEXCOLOR(0xCCCCCC).CGColor;
    lowTF.layer.borderWidth = 0.5f;
    lowTF.keyboardType = UIKeyboardTypeNumberPad;
    [lowTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(line.mas_left).offset(-5);
        make.size.mas_offset(CGSizeMake(55, 24));
        make.centerY.equalTo(headerView);
    }];
    
}

- (void)setupCollectAndTopView{
    [self.view addSubview:self.topView];
    [self.topView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 110));
        make.bottom.equalTo(self.view).offset(-100);
        make.right.equalTo(self.view).offset(-10);
    }];
    @weakify(self)
    [self.topView setCollectAndTopViewBlock:^(id obj) {
        @strongify(self)
        UIButton *btn = (UIButton *)obj;
        if (btn.tag == 10000) {//跳收藏页面
            [JHAllStatistics jh_allStatisticsWithEventId:@"scClick" params:@{
                @"store_from":@"商品搜索列表页",
                @"zc_name":@"",
                @"zc_id":@""
            } type:JHStatisticsTypeSensors];
            //判断登录，未登录跳登录
            if (IS_LOGIN) {
                JHSQCollectViewController *collectVC = [[JHSQCollectViewController alloc] init];
                collectVC.defaultSelectedIndex = 1;
                if (self.keywordSource.length > 0) {
                    [JHRootController.currentViewController.navigationController pushViewController:collectVC animated:YES];
                }else{
                    [self.navigationController pushViewController:collectVC animated:YES];
                }
            }
            
        }else{//返回顶部
            [JHAllStatistics jh_allStatisticsWithEventId:@"backTopClick" params:@{@"store_from":@"商品搜索列表页"} type:JHStatisticsTypeSensors];
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];

        }
    }];
}

#pragma mark - LoadData
- (void)updateLoadData:(BOOL)isRefresh {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"type"] = @"sell";
    dicData[@"queryWord"] = self.keywordStr;
    dicData[@"sort"] = @(self.sortTypeNum); //排序规则 0-综合排序 1-价格升序 2:价格降序
    dicData[@"isRefresh"] = @(isRefresh);
    if (self.lowTextField.text.length > 0) {
        dicData[@"minPrice"] = @([self.lowTextField.text doubleValue]);
    }
    if (self.highTextField.text.length > 0) {
        dicData[@"maxPrice"] = @([self.highTextField.text doubleValue]);
    }
    
    [self.searchResultViewModel.searchResultCommand execute:dicData];

}

- (void)loadMoreData {
    [self updateLoadData:NO];
}

- (void)configData{
    @weakify(self)
    [self.searchResultViewModel.updateSearchSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];

        //刷新数据，判断空页面
        [self.collectionView jh_reloadDataWithEmputyView];
        //当数据超过一屏后才显示“已经到底”文案
        if (self.searchResultViewModel.searchListDataArray.count > 6) {
            ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
        }
        //刷新完成，其他操作
        dispatch_async(dispatch_get_main_queue(),^{
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
            [self endScrollToPlayVideo];
        });

    }];
    //更多数据
    [self.searchResultViewModel.moreSearchSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];

    }];
    [self.searchResultViewModel.noMoreDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];
    //请求出错
    [self.searchResultViewModel.errorRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
    }];
   
}
#pragma mark  - Action
//确定筛选
- (void)clickSureBtnAction:(UIButton *)sender{
    [self updateLoadData:YES];
}

#pragma mark - Delegate
#pragma mark - JHNewShopSortMenuViewDelegate
- (void)menuViewDidSelect:(JHNewShopSortType)sortType {
    self.sortTypeNum = (int)sortType;
    
    [self updateLoadData:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat offsetY = scrollView.contentOffset.y;
    
    BOOL goTopHidden = offsetY <= 100;
    self.topView.topButton.hidden = goTopHidden;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    int lengthInt = (int)range.length;
    int locationInt = (int)range.location;
    if (locationInt-lengthInt < 9-1) {//最多8位
        if (locationInt-lengthInt > 7-1) {//7
            textField.font = [UIFont systemFontOfSize:10];
        } else {
            textField.font = [UIFont systemFontOfSize:12];
        }
        
        if (locationInt-lengthInt < 0) {
            self.sureBtn.alpha = 0.7;
            self.sureBtn.userInteractionEnabled = NO;
        }else{
            self.sureBtn.alpha = 1;
            self.sureBtn.userInteractionEnabled = YES;
        }
        
        return YES;
    }
    
    return NO;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(8.0)){
    NSLog(@"---willDisplayCell----%@",indexPath);
    JHNewStoreHomeGoodsProductListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexPath.item];
    NSString * strtemp = [NSString stringWithFormat:@"%@_%ld",self.keywordStr,dataModel.productId];
    if (![self.uploadData containsObject:strtemp]) {
        [self.uploadData addObject:strtemp];
        if (self.uploadData.count>=10) {
            
            NSMutableArray * temp = [self.uploadData mutableCopy];
            [self sa_uploadData:temp];
            [self.uploadData removeAllObjects];
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.searchResultViewModel.searchListDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHNewStoreHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
    cell.curData = self.searchResultViewModel.searchListDataArray[indexPath.row];
    @weakify(self)
    cell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
        @strongify(self)
        if (!isH5) {
            JHNewStoreSpecialDetailViewController * vc = [[JHNewStoreSpecialDetailViewController alloc] init];
            vc.showId = showId;
            vc.fromPage = @"商品搜索列表页";
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [JHAllStatistics jh_allStatisticsWithEventId:@"xrhdClick" params:@{@"store_from":@"商品搜索列表页"} type:JHStatisticsTypeSensors];
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
   
    JHNewStoreHomeGoodsProductListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexPath.row];
    
    JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
    detailVC.productId = [NSString stringWithFormat:@"%ld",dataModel.productId];
    detailVC.fromPage = @"搜索列表页";
    if (self.keywordSource.length > 0) {
        [JHRootController.currentViewController.navigationController pushViewController:detailVC animated:YES];
    }else{
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
    @weakify(self)
    //判断刷新当前商品订单 是否 解除
    [[RACObserve(detailVC, sellStatusDesc) skip:2] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //先改变model值
        dataModel.productSellStatusDesc = x;
        //再更新指定cell
        [UIView performWithoutAnimation:^{
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }];
    }];
    [JHAllStatistics jh_allStatisticsWithEventId:@"searchResultClick" params:@{@"position_sort":@(indexPath.item),
                @"resources_type":@"商品",
                @"resources_id":[NSString stringWithFormat:@"%ld",dataModel.productId],
                @"resources_name":dataModel.productName,
                @"resources_price":dataModel.price,//售价
                @"key_word":self.keywordStr
              } type:JHStatisticsTypeSensors];
    
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:@{
        @"page_position":@"搜索页",
        @"model_type":@"搜索页",
        @"commodity_label":@"无",
        @"commodity_id":[NSString stringWithFormat:@"%ld",dataModel.productId],
        @"commodity_name":dataModel.productName,
    } type:JHStatisticsTypeSensors];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHNewStoreHomeGoodsProductListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexPath.row];
    
    return CGSizeMake((ScreenW-24-9)/2, dataModel.itemHeight);
}

#pragma - LayoutDelegate
- (CGFloat)shopCVLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout heighForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    JHNewStoreHomeGoodsProductListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexPath.row];
    return dataModel.itemHeight;
}
- (NSInteger)numberOfColumnInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 2;
}
- (CGFloat)columnSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 9;
}
- (CGFloat)rowSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 9;
}
- (UIEdgeInsets)itemEdgeInsetInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVFlowLayout{
    return  UIEdgeInsetsMake(10, 12, 10, 12);
}


#pragma mark - WIFI下视频自动播放
///视频自动播放
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self endScrollToPlayVideo];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self endScrollToPlayVideo];
}
// 触发自动播放事件
- (void)endScrollToPlayVideo {
    NSArray *visiableCells = [self.collectionView visibleCells];
    for(id obj in visiableCells) {
        if([obj isKindOfClass:[JHNewStoreHomeGoodsCollectionViewCell class]]) {
            JHNewStoreHomeGoodsCollectionViewCell *cell = (JHNewStoreHomeGoodsCollectionViewCell*)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            CGRect collectionRect = [self.collectionView convertRect:self.collectionView.bounds toView:[UIApplication sharedApplication].keyWindow];
            //只要cell在视图里面显示超过一半就给展示视频 && 视频类型 && 有视频链接
            if (rect.origin.y>=collectionRect.origin.y &&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49 && cell.curData.videoUrl.length > 0) {
                /** 添加视频*/
                if (self.currentCell == cell) {
                    return;
                }
                self.currentCell = cell;
                self.playerController.view.frame = cell.imgView.bounds;
                [self.playerController setSubviewsFrame];
                [cell.imgView addSubview:self.playerController.view];
                self.playerController.urlString = cell.curData.videoUrl;
                return;
            }
        }
    }
    //没有满足条件的 释放视频
    [self.playerController stop];
    self.currentCell = nil;
    [self.playerController.view removeFromSuperview];
}


#pragma mark - Lazy

- (JHNewStoreClassListViewModel *)searchResultViewModel{
    if (!_searchResultViewModel) {
        _searchResultViewModel = [[JHNewStoreClassListViewModel alloc] init];
    }
    return _searchResultViewModel;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        [self setupHeaderView];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.hotSellLayout];
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xF8F8F8);
        [_collectionView registerClass:[JHNewStoreHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class])];
        @weakify(self)
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self updateLoadData:YES];
        }];
        _collectionView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
       
        [self setupCollectAndTopView];
        [self configData];

    }
    return _collectionView;
}

- (JHShopHotSellConllectionViewLayout *)hotSellLayout{
    if (!_hotSellLayout) {
        _hotSellLayout = [[JHShopHotSellConllectionViewLayout alloc]init];
        _hotSellLayout.shopLayoutDelegate = self;
    }
    return _hotSellLayout;;
}

- (JHNewShopSortMenuView *)sortMenuView{
    if (!_sortMenuView) {
        JHNewShopMenuMode *recMode = [[JHNewShopMenuMode alloc] init];
        recMode.title = @"综合排序";
        recMode.isShowImg = NO;
        JHNewShopMenuMode *priceMode = [[JHNewShopMenuMode alloc] init];
        priceMode.title = @"价格排序";
        priceMode.isShowImg = YES;
        NSArray *menuArray = @[recMode, priceMode];
        _sortMenuView = [[JHNewShopSortMenuView alloc] initWithFrame:CGRectZero menuArray:menuArray titleFont:13.0];
        _sortMenuView.delegate = self;
        _sortMenuView.selectIndex = 0;
    }
    return _sortMenuView;
}
- (JHNewStoreCollectAndTopView *)topView{
    if (!_topView) {
        _topView = [[JHNewStoreCollectAndTopView alloc] initWithFrame:CGRectZero];
        _topView.topButton.hidden = YES;
    }
    return _topView;
}
- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.muted = YES;
        _playerController.looping = YES;
        _playerController.hidePlayButton = YES;
        [self addChildViewController:_playerController];
    }
    return _playerController;
}

- (NSMutableArray *)uploadData{
    if (!_uploadData) {
        _uploadData = [NSMutableArray array];
    }
    return _uploadData;
}
- (void)sa_uploadData:(NSMutableArray *)array{
    [JHTracking trackEvent:@"ep" property:@{@"page_position":@"商城搜索结果页",@"model_name":@"搜索结果列表",@"res_type":@"商品feeds",@"item_ids":array}];
}
@end
