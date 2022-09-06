//
//  JHNewStoreClassListViewController.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreClassListViewController.h"
#import "JHShopHotSellConllectionViewLayout.h"
#import "JHUIFactory.h"
#import "JHNewStoreClassListViewModel.h"
#import "YDRefreshFooter.h"
#import "JHMarketFloatLowerLeftView.h"
#import "JHPlayerViewController.h"
#import "JHStoreDetailViewController.h"
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHNewStoreSpecialDetailViewController.h"
#import "JHNewStoreClassResultHeaderTagsView.h"

#import "JHC2CSubClassTitleScrollView.h"
#import "JHC2CSearchResultBusiness.h"

static CGFloat const TagsViewHeight =44.f;
static CGFloat const ThreeClassScrollViewHeight =44.f;

@interface JHNewStoreClassListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, JHShopHotSellConllectionViewLayoutDelegate, JHNewStoreClassResultHeaderTagsViewDelegate, JHC2CSubClassTitleScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;
@property (nonatomic, strong) JHNewStoreClassResultHeaderTagsView *headerTagsView;
@property (nonatomic, strong) JHC2CSubClassTitleScrollView *threeClassScrollView;//三级分类
@property (nonatomic, strong) JHNewStoreClassListViewModel *searchResultViewModel;
@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;//收藏返回顶部view
@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, assign) int sortTypeNum;
@property (nonatomic,   copy) NSArray *tagArray;
@property (nonatomic, strong) JHNewStoreHomeGoodsCollectionViewCell *currentCell;//当前播放视频的cell
@property (nonatomic, strong) NSMutableArray * uploadData;
@property (nonatomic, assign) NSInteger defaultClassID;//进页面的默认传过来的分类ID
@property (nonatomic, assign) NSInteger childrenCateAllID;//三级分类的全部分类ID
@property (nonatomic, assign) BOOL isFirstEnter;//是否首次加载
@property (nonatomic, assign) NSInteger directDelivery;//筛选服务 0平台鉴定 1商家直发
@property (nonatomic, assign) NSInteger auctionStatus;//筛选即将截拍 0否 1是
@property (nonatomic,   copy) NSString *minPrice;//最低价
@property (nonatomic,   copy) NSString *maxPrice;//最高价
@property (nonatomic,   copy) NSString *titleTagName;//标签 全部 拍卖 一口价;

@end

@implementation JHNewStoreClassListViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.uploadData.count > 0) {
        NSMutableArray * temp = [self.uploadData mutableCopy];
        [self sa_uploadData:temp];
        [self.uploadData removeAllObjects];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //进入当前页面时之前页面的弹窗收起
    [self.headerTagsView viewControllerWillAppear];
    [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(TagsViewHeight);
    }];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    self.titleTagName = @"全部";
    if (self.titleTagIndex == 0) {
        self.titleTagName = @"全部";
    }else if (self.titleTagIndex == 1){
        self.titleTagName = @"拍卖";
    }else{
        self.titleTagName = @"一口价";
    }
    NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
    //搜索
    if (self.keyword.length > 0) {
        [sensorsDic setValue:self.keyword forKey:@"key_word"];
        [sensorsDic setValue:self.keywordSource forKey:@"search_type"];
        [sensorsDic setValue:[NSString stringWithFormat:@"商城搜索结果%@页",self.titleTagName] forKey:@"page_name"];
    }
    //分类
    if (self.className.length > 0) {
        if ([self.classClickFrom intValue] == 1) {//一级分类
            [sensorsDic setValue:self.className forKey:@"first_commodity"];
            [sensorsDic setValue:[NSString stringWithFormat:@"商城一级分类%@页",self.titleTagName] forKey:@"page_name"];
        }else{//二级分类
            [sensorsDic setValue:self.firstClassName forKey:@"first_commodity"];
            [sensorsDic setValue:self.className forKey:@"second_commodity"];
            [sensorsDic setValue:[NSString stringWithFormat:@"商城二级分类%@页",self.titleTagName] forKey:@"page_name"];
        }
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:sensorsDic type:JHStatisticsTypeSensors];
    
    //收藏等数据刷新
    [self.floatView loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sortTypeNum = 0;
    self.isFirstEnter = YES;
    self.defaultClassID = [self.classID integerValue];
    self.childrenCateAllID = [self.classID integerValue];
    [self setupUI];
    [self loadTagsViewData];
    
    [self configData];
    [self.collectionView.mj_header beginRefreshing];
    
}

#pragma mark - UI
- (void)setupUI{
    //商品列表
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(TagsViewHeight, 0, 0, 0));
    }];
    
    //筛选tags
    [self.view addSubview:self.headerTagsView];
    [self.headerTagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_offset(TagsViewHeight);
    }];
    
    //右下角浮窗按钮
    [self.view addSubview:self.floatView];
    
}
///tagsView判断显示处理
- (void)loadTagsViewData{
    self.tagArray = @[@"综合排序",@"价格",@"分类",@"筛选"];
    //MARK: 点击二级分类过来，分类结果页
    if ([self.classClickFrom intValue] != 1 && self.className.length > 0) {
        //不显示筛选分类按钮
        self.tagArray = @[@"综合排序",@"价格",@"筛选"];
        //请求选择分类的子分类
        [self loadChildrenCateData:[self.classID integerValue]];
    }
    self.headerTagsView.titleIndex = self.titleTagIndex;
    self.headerTagsView.tagArray = self.tagArray;
}

///三级分类
- (void)setupThreeClassView {
    [self.threeClassScrollView removeFromSuperview];
    [self.view addSubview:self.threeClassScrollView];
    [self.view bringSubviewToFront:self.headerTagsView];
    [self.threeClassScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerTagsView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_offset(ThreeClassScrollViewHeight);
    }];
}

#pragma mark - LoadData
- (void)updateLoadData:(BOOL)isRefresh {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"isRefresh"] = @(isRefresh);
    //搜索
    if (self.keyword.length > 0) {
        dicData[@"type"] = @"sell";
        dicData[@"queryWord"] = self.keyword;
        dicData[@"source"] = @"";//int 0首页，1分类
    }
    //分类
    if (self.classID.length > 0) {
        dicData[@"subCateId"] = @"";//子分类id 查全部传空
    }
    dicData[@"sort"] = @(self.sortTypeNum); //排序规则 0综合排序 1价格升序 2价格降序 3马上开拍 4最新上架
    dicData[@"productType"] = @(2-self.titleTagIndex);//int商品类型  0一口价  1拍卖  2全部
    dicData[@"directDelivery"] = self.directDelivery > 0 ? @(self.directDelivery - 1) : @"";//int 0平台鉴定 1:商家直发
    dicData[@"auctionStatus"] = @(self.auctionStatus);//int即将截拍 0否1是
    dicData[@"minPrice"] = self.minPrice.length > 0 ? @([self.minPrice integerValue]) : @"";//int最低价格
    dicData[@"maxPrice"] = self.maxPrice.length > 0 ? @([self.maxPrice integerValue]) : @"";//int最高价格
    dicData[@"cateId"] = @([self.classID integerValue]);//前台分类id
    
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
        if (self.isFirstEnter) {
            self.isFirstEnter = NO;
            //分类弹窗参数
            self.headerTagsView.subCateIds = self.searchResultViewModel.goodsModel.cateIds;
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
///选择分类请求其子类
- (void)loadChildrenCateData:(NSInteger )classID {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"id"] = @(classID);
    dicData[@"fromStatus"] = @"B2C";//来源 0:C2C  1:B2C
    [JHC2CSearchResultBusiness requestSearchChildrenCateListWithParams:dicData Completion:^(NSError * _Nullable error, NSArray<JHNewStoreTypeTableCellViewModel *> * _Nullable models) {
        if (!error) {
            if (models.count > 0) {
                //选择了二级分类后显示三级分类
                [self setupThreeClassView];
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(TagsViewHeight+ThreeClassScrollViewHeight, 0, 0, 0));
                }];
            }else{
                [self.threeClassScrollView removeFromSuperview];
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(TagsViewHeight, 0, 0, 0));
                }];
            }
            self.threeClassScrollView.subClassArray = models;
        }else{
            self.threeClassScrollView.subClassArray = @[];
        }
    }];
    
}

#pragma mark  - Action


#pragma mark - Delegate
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - JHC2CSubClassTitleScrollViewDelegate
///三级分类点击
- (void)subClassTitleDidSelect:(NSInteger)selectItem{
    if (selectItem == 0) {
        self.classID = [NSString stringWithFormat:@"%ld",(long)self.childrenCateAllID];
    }else{
        JHNewStoreTypeTableCellViewModel *viewModel = self.threeClassScrollView.subClassArray[selectItem-1];
        self.classID = [NSString stringWithFormat:@"%ld",(long)viewModel.ID];
    }
    //切换标签请求数据
    [self.collectionView.mj_header beginRefreshing];
    
}

#pragma mark - JHNewStoreClassResultHeaderTagsViewDelegate
///tags标签事件点击
- (void)tagsViewSelectedOfIndex:(NSInteger )selectedIndex selected:(BOOL)selected{
    if (selectedIndex == 0 || selectedIndex == 2) {
        if ( self.tagArray.count == 4) {
            if (selected) {
                [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(self.view.height);
                }];
            }else{
                [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(TagsViewHeight);
                }];
            }
        }else{
            if (selectedIndex == 0) {
                if (selected) {
                    [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_offset(self.view.height);
                    }];
                }else{
                    [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_offset(TagsViewHeight);
                    }];
                }
            }else{
                [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_offset(TagsViewHeight);
                }];
            }
        }
    }else{
        [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(TagsViewHeight);
        }];
    }
}

///综合排序事件点击
- (void)sortViewSelectedOfIndex:(JHNewStorePriceSortType)sortType{
    [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(TagsViewHeight);
    }];
    
    if (sortType >= 0) {
        self.sortTypeNum = (int)sortType;
        //一口价时排序少马上开拍，做特殊处理
        if (self.titleTagIndex == 2 && self.sortTypeNum == 3) {
            self.sortTypeNum = 4;
        }
        [self.collectionView.mj_header beginRefreshing];

        //埋点
        NSString *sort_name = @"综合排序";
        switch (self.sortTypeNum) {
            case 0: sort_name = @"综合排序";
                break;
            case 1: sort_name = @"价格升序";
                break;
            case 2: sort_name = @"价格降序";
                break;
            case 3: sort_name = @"马上开拍";
                break;
            case 4: sort_name = @"最新上架";
                break;
            default:
                break;
        }
        NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
        sensorsDic[@"sort_name"] = sort_name;
        sensorsDic[@"position"] = self.titleTagName;
        //搜索
        if (self.keyword.length > 0) {
            sensorsDic[@"page_position"] = @"商城搜索结果页";
        }
        //分类
        if (self.className.length > 0) {
            sensorsDic[@"goods_type"] = self.className;
            sensorsDic[@"page_position"] = @"商城一级分类页";
        }
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickSort" params:sensorsDic type:JHStatisticsTypeSensors];
        
    }
    
}
///分类弹窗事件点击
- (void)classViewDidSelect:(JHNewStoreTypeTableCellViewModel* )subClassModel selectAllClass:(BOOL)selectAllClass dismissView:(BOOL)dismiss{
    [self.headerTagsView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(TagsViewHeight);
    }];
    if (!dismiss) {
        if (subClassModel.cateName.length > 0) {
            self.childrenCateAllID = subClassModel.ID;
            //只有选择二级分类时判断显示三级
            if (selectAllClass) {
                [self.threeClassScrollView removeFromSuperview];
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(TagsViewHeight, 0, 0, 0));
                }];
            } else {
                [self loadChildrenCateData:subClassModel.ID];
            }
            self.classID = [NSString stringWithFormat:@"%ld",(long)subClassModel.ID];
        }
        //重置
        else {
            [self.threeClassScrollView removeFromSuperview];
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(TagsViewHeight, 0, 0, 0));
            }];
            if (self.keyword.length > 0) {
                self.classID = @"";
            } else {
                self.classID = [NSString stringWithFormat:@"%ld",(long)self.defaultClassID];
            }
        }
        //切换标签请求数据
        [self.collectionView.mj_header beginRefreshing];
        
    }
}
///筛选弹窗事件点击
- (void)filterViewSelectedOfService:(NSInteger)serviceIndex auction:(BOOL)isSelected lowPrice:(NSString *)lowPrice highPrice:(NSString *)highPrice{
    //筛选服务
    self.directDelivery = serviceIndex;
    //即将截拍
    self.auctionStatus = isSelected ? 1 : 0;
    //最低价
    self.minPrice = lowPrice;
    //最高价
    self.maxPrice = highPrice;
    
    //切换标签请求数据
    [self.collectionView.mj_header beginRefreshing];
    
    //筛选埋点
    if (lowPrice.length > 0 && highPrice.length > 0) {
        NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
        sensorsDic[@"min_price"] = lowPrice;
        sensorsDic[@"max_price"] = highPrice;
        sensorsDic[@"price_range"] = [NSString stringWithFormat:@"%@_%@",lowPrice,highPrice];
        //搜索
        if (self.keyword.length > 0) {
            sensorsDic[@"key_word"] = self.keyword;
            sensorsDic[@"page_position"] = [NSString stringWithFormat:@"商城搜索结果%@页",self.titleTagName];
        }
        //分类
        if (self.className.length > 0) {
            if ([self.classClickFrom intValue] == 1) {//一级分类
                sensorsDic[@"first_commodity"] = self.className;
                sensorsDic[@"page_position"] = [NSString stringWithFormat:@"商城一级分类%@页",self.titleTagName];
            }else{//二级分类
                sensorsDic[@"first_commodity"] = self.firstClassName;
                sensorsDic[@"second_commodity"] = self.className;
                sensorsDic[@"page_position"] = [NSString stringWithFormat:@"商城二级分类%@页",self.titleTagName];
            }
        }
        
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickPriceAffirm" params:sensorsDic type:JHStatisticsTypeSensors];
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    BOOL goTopHidden = offsetY <= 100;
    self.floatView.topButton.hidden = goTopHidden;

}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(8.0)){
    NSLog(@"---willDisplayCell----%@",indexPath);
    JHNewStoreHomeGoodsProductListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexPath.item];
    NSString *store_from = self.keyword.length > 0 ? self.keyword : self.className;
    NSString * strtemp = [NSString stringWithFormat:@"%@_%ld",store_from,dataModel.productId];
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
        NSString *store_from = self.keyword.length > 0 ? @"商品搜索列表页" : @"商品分类列表页";
        if (!isH5) {
            JHNewStoreSpecialDetailViewController * vc = [[JHNewStoreSpecialDetailViewController alloc] init];
            vc.showId = showId;
            vc.fromPage = store_from;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [JHAllStatistics jh_allStatisticsWithEventId:@"xrhdClick" params:@{@"store_from":store_from} type:JHStatisticsTypeSensors];
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
   
    JHNewStoreHomeGoodsProductListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexPath.row];
    
    JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
    detailVC.productId = [NSString stringWithFormat:@"%ld",dataModel.productId];
    detailVC.fromPage =self.keyword.length > 0 ? @"搜索列表页" : @"分类列表页";
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
    
    //埋点
    if (self.keyword.length > 0) {
        [JHAllStatistics jh_allStatisticsWithEventId:@"searchResultClick" params:@{@"position_sort":@(indexPath.item),
                    @"resources_type":@"商品",
                    @"resources_id":[NSString stringWithFormat:@"%ld",dataModel.productId],
                    @"resources_name":dataModel.productName,
                    @"resources_price":dataModel.price,//售价
                    @"key_word":self.keyword
                  } type:JHStatisticsTypeSensors];
    }
    
    NSString *typeStr = @"搜索页";
    if (self.className.length > 0) {
        typeStr = [self.classClickFrom intValue]== 1 ? @"一级分类列表页" : @"二级分类列表页";
    }
    NSString *sort_name = @"综合排序";
    switch (self.sortTypeNum) {
        case 0: sort_name = @"综合排序";
            break;
        case 1: sort_name = @"价格升序";
            break;
        case 2: sort_name = @"价格降序";
            break;
        case 3: sort_name = @"马上开拍";
            break;
        case 4: sort_name = @"最新上架";
            break;
        default:
            break;
    }
    NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
    sensorsDic[@"page_position"] = self.keyword.length > 0 ? @"搜索页" : self.className;
    sensorsDic[@"model_type"] = typeStr;
    sensorsDic[@"commodity_label"] = @"";
    sensorsDic[@"commodity_id"] = [NSString stringWithFormat:@"%ld",dataModel.productId];
    sensorsDic[@"commodity_name"] = dataModel.productName;
    sensorsDic[@"sort_name"] = sort_name;
    sensorsDic[@"position"] = self.titleTagName;
    if (self.className.length > 0) {
        sensorsDic[@"goods_type"] = self.className;
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:sensorsDic type:JHStatisticsTypeSensors];
    
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
- (JHNewStoreClassResultHeaderTagsView *)headerTagsView{
    if (!_headerTagsView) {
        _headerTagsView = [[JHNewStoreClassResultHeaderTagsView alloc] init];
        _headerTagsView.delegate = self;
    }
    return _headerTagsView;
}
- (JHC2CSubClassTitleScrollView *)threeClassScrollView{
    if (!_threeClassScrollView) {
        _threeClassScrollView = [[JHC2CSubClassTitleScrollView alloc] init];
        _threeClassScrollView.showsHorizontalScrollIndicator = NO;
        _threeClassScrollView.showsHorizontalScrollIndicator = NO;
        _threeClassScrollView.classDelegate = self;
    }
    return _threeClassScrollView;
}

- (JHMarketFloatLowerLeftView *)floatView{
    if (!_floatView) {
        _floatView = [[JHMarketFloatLowerLeftView alloc] initWithShowType:JHMarketFloatShowTypeBackTop];
        _floatView.isHaveTabBar = NO;
        @weakify(self)
        NSString *store_from = @"商品分类列表页";
        if (self.keyword.length > 0) {
            store_from = @"商品搜索列表页";
        }
        //收藏
        _floatView.collectGoodsBlock = ^{
            [JHAllStatistics jh_allStatisticsWithEventId:@"scClick" params:@{
                @"store_from":store_from,
                @"zc_name":@"",
                @"zc_id":@""
            } type:JHStatisticsTypeSensors];
        };
        //返回顶部
        _floatView.backTopViewBlock = ^{
            @strongify(self)
            [JHAllStatistics jh_allStatisticsWithEventId:@"backTopClick" params:@{@"store_from":store_from} type:JHStatisticsTypeSensors];
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];

        };
    }
    return _floatView;
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
    NSString *page_position = self.keyword.length > 0 ? @"商城搜索结果页" : @"商城商品一级分类页";
    NSString *model_name = self.keyword.length > 0 ? @"搜索结果列表" : @"商品一级分类列表";
    [JHTracking trackEvent:@"ep" property:@{@"page_position":page_position,@"model_name":model_name,@"res_type":@"商品feeds",@"item_ids":array}];
}
@end
