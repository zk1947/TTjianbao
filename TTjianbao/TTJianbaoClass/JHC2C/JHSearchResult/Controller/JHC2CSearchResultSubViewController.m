//
//  JHC2CSearchResultSubViewController.m
//  TTjianbao
//
//  Created by hao on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSearchResultSubViewController.h"
#import "JHShopHotSellConllectionViewLayout.h"
#import "JHC2CGoodsCollectionViewCell.h"
#import "JHC2CGoodsOperationCollectionCell.h"
#import "YDRefreshFooter.h"
#import "JHC2CSortMenuView.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHC2CClassMenuView.h"
#import "JHC2CSubClassTitleScrollView.h"
#import "JHC2CGoodsListModel.h"
#import "JHC2CSearchResultViewModel.h"

#import "JHPlayerViewController.h"
#import "JHC2CProductDetailController.h"
#import "JHMarketFloatLowerLeftView.h"

@interface JHC2CSearchResultSubViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, JHShopHotSellConllectionViewLayoutDelegate, JHC2CSortMenuViewDelegate, JHC2CClassMenuViewDelegate, JHC2CSubClassTitleScrollViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;
@property (nonatomic, strong) JHC2CSortMenuView *sortMenuView;//排序view
@property (nonatomic, strong) UIView *selectBtnView;//筛选按钮view
@property (nonatomic, strong) UIButton *classBtn;//分类选择按钮
@property (nonatomic, strong) JHC2CClassMenuView *classMenuView;//分类弹窗
@property (nonatomic, assign) BOOL isAddClassMenuView;//是否显示分类弹窗
@property (nonatomic, strong) JHC2CSubClassTitleScrollView *threeClassScrollView;//三级分类view
@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;//收藏返回顶部view
@property (nonatomic, strong) JHC2CSearchResultViewModel *searchResultViewModel;
@property (nonatomic, assign) int sortTypeNum;//排序规则 0:综合排序 1:价格升序 2:价格降序 4:最新上架
@property (nonatomic, assign) NSInteger productType;//商品类型 0一口价 1拍卖 2全部
@property (nonatomic, assign) NSInteger auctionStatus;//即将截拍 1
@property (nonatomic, assign) NSInteger needFreight;//包邮 0否 1是
@property (nonatomic, assign) NSInteger appraisalStatus;//鉴定结果 0否 1真
@property (nonatomic, copy) NSString *defaultClassID;//进页面的默认传过来的分类ID
@property (nonatomic, assign) NSInteger childrenCateAllID;//三级分类的全部分类ID
@property (nonatomic, strong) JHPlayerViewController *playerController;
@property (nonatomic, strong) JHC2CGoodsCollectionViewCell *currentCell;//当前播放视频的cell
@property (nonatomic, assign) BOOL isFirstEnter;//是否首次
@property (nonatomic, assign) BOOL isSelectMenuClass;//是否选择了弹窗分类


@end

@implementation JHC2CSearchResultSubViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    NSString *tagStr = @"全部";
    if (self.titleTagIndex == 0) {
        tagStr = @"全部";
    }else if (self.titleTagIndex == 1){
        tagStr = @"拍卖";
    }else{
        tagStr = @"一口价";
    }
    NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
    //搜索
    if (self.keyword.length > 0) {
        [sensorsDic setValue:self.keyword forKey:@"key_word"];
        [sensorsDic setValue:self.keywordSource forKey:@"key_word_source"];
        [sensorsDic setValue:[NSString stringWithFormat:@"集市搜索结果%@页",tagStr] forKey:@"page_name"];
    }
    //分类
    if (self.className.length > 0) {
        if ([self.classClickFrom intValue] == 1) {//一级分类
            [sensorsDic setValue:self.className forKey:@"first_commodity"];
            [sensorsDic setValue:[NSString stringWithFormat:@"集市一级分类%@页",tagStr] forKey:@"page_name"];
        }else{//二级分类
            [sensorsDic setValue:self.className forKey:@"second_commodity"];
            [sensorsDic setValue:[NSString stringWithFormat:@"集市二级分类%@页",tagStr] forKey:@"page_name"];
        }
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:sensorsDic type:JHStatisticsTypeSensors];
    
    //收藏等数据刷新
    [self.floatView loadData];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //分类弹窗收起
    self.classBtn.selected = NO;
    self.classMenuView.hidden = YES;
    if (self.isSelectMenuClass) {
        [self.classBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [self.classBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFD70F)] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstEnter = YES;
    self.defaultClassID = self.classID;
    self.childrenCateAllID = [self.classID longValue];
    ///titleTagIndex 0：全部 1：拍卖  2：一口价
    if (self.titleTagIndex == 0) {
        self.productType = 2;
    }else if (self.titleTagIndex == 1){
        self.productType = 1;
    }else{
        self.productType = 0;
    }
    
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(84, 0, 0, 0));
    }];
    //顶部筛选
    [self setupHeaderView];

    //右下角浮窗按钮
    [self.view addSubview:self.floatView];
    
    //加载数据
    [self.collectionView.mj_header beginRefreshing];
    [self configData];

}

#pragma mark - UI

///顶部筛选条件
- (void)setupHeaderView{
    UIView *lineView = [UIView jh_viewWithColor:HEXCOLOR(0xE6E6E6) addToSuperview:self.view];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_offset(0.5);
    }];
    //排序
    [self.view addSubview:self.sortMenuView];
    [self.sortMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(12);
        make.top.equalTo(self.view).offset(0.5);
        make.size.mas_offset(CGSizeMake(kScreenWidth-24, 40));
    }];
    //筛选按钮view
    [self.view addSubview:self.selectBtnView];
    [self.selectBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sortMenuView.mas_bottom);
        make.height.mas_offset(44);
        make.left.right.equalTo(self.view);
    }];
    NSArray *btnTitleArray = @[@"分类",@"鉴定为真",@"即将截拍",@"包邮"];
    if (self.titleTagIndex == 2) {//一口价
        btnTitleArray = @[@"分类",@"鉴定为真",@"包邮"];
    }
    UIButton *lastButton;
    for (int i = 0 ; i < btnTitleArray.count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF2F2F2)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFD70F)] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        btn.contentEdgeInsets = UIEdgeInsetsMake(6, 16, 5, 16);
        btn.tag = 100 + i;
        [btn jh_cornerRadius:14];
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;//设置尾部省略
        [btn addTarget:self action:@selector(clickThreeClassAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectBtnView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.selectBtnView);
            make.height.mas_offset(28);
            if (i) {
                make.left.equalTo(lastButton.mas_right).offset(9);
            } else {
                make.left.equalTo(self.selectBtnView).offset(12);
            }
        }];
        if (i == 0) {
            self.classBtn = btn;
            [btn setImage:[UIImage imageNamed:@"c2c_class_down_icon"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"c2c_class_up_icon"] forState:UIControlStateSelected];
            [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];
        }
        lastButton = btn;
    }
    
//MARK: 点击二级分类过来，分类结果页
    if ([self.classClickFrom intValue] != 1 && self.className.length > 0) {
        //不显示筛选分类按钮
        self.classBtn.hidden = YES;
        [self.selectBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(-75);
        }];
        
        //请求选择分类的子分类
        [self loadChildrenCateData:[self.classID integerValue]];
    }
    
}
///三级分类
- (void)setupThreeClassView {
    [self.threeClassScrollView removeFromSuperview];
    [self.view addSubview:self.threeClassScrollView];
    [self.view bringSubviewToFront:self.classMenuView];
    [self.threeClassScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectBtnView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        make.height.mas_offset(40);
    }];
}

#pragma mark - LoadData
- (void)updateLoadData:(BOOL)isRefresh {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"type"] = @"sell";
    dicData[@"imageType"] = @"s,m,b,o";
    dicData[@"businessType"] = @(3);//int //0 直播 1 商城 2小程序 3 C2C
    dicData[@"source"] = self.className.length>0 ? @1 : @0;//来源1分类，0搜索
    dicData[@"queryWord"] = self.keyword;
    dicData[@"sort"] = @(self.sortTypeNum); //排序规则 0:综合排序 1:价格升序 2:价格降序 4:最新上架
    dicData[@"cateId"] = @([self.classID longValue]);//后台分类id
    dicData[@"productType"] = @(self.productType);//商品类型 0一口价 1拍卖 2全部
    dicData[@"auctionStatus"] = @(self.auctionStatus);//int //即将截拍
    dicData[@"needFreight"] = @(self.needFreight);//int //包邮 0否 1是
    dicData[@"appraisalStatus"] = @(self.appraisalStatus);//int //鉴定结果 0否 1真
    dicData[@"isRefresh"] = @(isRefresh);
    [self.searchResultViewModel.searchResultCommand execute:dicData];
}

- (void)loadMoreData{
    [self updateLoadData:NO];
}

- (void)configData{
    @weakify(self)
    //刷新数据
    [self.searchResultViewModel.updateGoodsListSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        //刷新数据，判断空页面
        [self.collectionView jh_reloadDataWithEmputyView];
        //当数据超过一屏后才显示“已经到底”文案
        if (self.searchResultViewModel.searchListDataArray.count > 6) {
            ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
        }else{
            ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = NO;
        }
        //筛选按钮的view
        //首次进页面加载的才做处理 且 搜索分类
        if (self.isFirstEnter == YES && self.keyword.length > 0) {
            //当返回有数据时才显示分类按钮
            if (self.searchResultViewModel.searchListDataArray.count > 0) {
                self.classBtn.hidden = NO;
                [self.selectBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view);
                }];
            }else{
                self.classBtn.hidden = YES;
                [self.selectBtnView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view).offset(-75);
                }];
            }
        }
        
        //添加分类筛选view
        if (!self.isAddClassMenuView) {
            self.isAddClassMenuView = YES;
            self.classMenuView.subCateIds = self.searchResultViewModel.goodsModel.cateIds;
            [self.view addSubview:self.classMenuView];
            [self.classMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(84);
                make.left.right.bottom.equalTo(self.view);
            }];
            self.classMenuView.hidden = YES;
        }
        
        dispatch_async(dispatch_get_main_queue(),^{
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
            //刷新完成，其他操作
            [self endScrollToPlayVideo];
        });
    }];
    //更多数据
    [self.searchResultViewModel.moreGoodsListSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];
    }];
    //没有更多数据
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
///第二排筛选条件
- (void)clickThreeClassAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.isFirstEnter = NO;

    NSInteger tagIndex = sender.tag-100;
    switch (tagIndex) {
        case 0://分类
            self.classMenuView.hidden = sender.selected ? NO : YES;
            break;
            
        case 1://鉴定为真
            self.appraisalStatus = sender.selected ? 1 : 0;
            break;
            
        case 2://即将截拍
            self.auctionStatus = sender.selected ? 1 : 0;
            break;
            
        case 3://包邮
            self.needFreight = sender.selected ? 1 : 0;
            break;
            
        default:
            break;
    }
    if (tagIndex > 0) {
        //分类弹窗收起
        self.classBtn.selected = NO;
        self.classMenuView.hidden = YES;
        if (self.isSelectMenuClass) {
            [self.classBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            [self.classBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFD70F)] forState:UIControlStateNormal];
        }

        [self.collectionView.mj_header beginRefreshing];

    }

}


#pragma mark - Delegate
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    BOOL goTopHidden = offsetY <= 100;
    self.floatView.topButton.hidden = goTopHidden;
}
#pragma mark - JHC2CClassMenuViewDelegate
///分类筛选
- (void)classViewDidSelect:(JHNewStoreTypeTableCellViewModel *)subClassModel selectAllClass:(BOOL)selectAllClass dismissView:(BOOL)dismiss {
    self.isFirstEnter = NO;
    if (dismiss) {
        self.classBtn.selected = NO;
        self.classMenuView.hidden = YES;
        return;
    }
    self.threeClassScrollView.subClassArray = @[];
    CGFloat time = 0;
    NSString *selectClassName = @"分类";
    if (subClassModel.cateName.length > 0) {
        self.isSelectMenuClass = YES;
        
        self.childrenCateAllID = subClassModel.ID;
        time = 0.2;
        selectClassName = subClassModel.cateName;
        if (selectClassName.length > 3) {
            selectClassName = [NSString stringWithFormat:@"%@…",[selectClassName substringToIndex:3]];

        }
        //只有选择二级分类时判断显示三级
        if (selectAllClass) {
            [self.threeClassScrollView removeFromSuperview];
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(84, 0, 0, 0));
            }];
        } else {
            [self loadChildrenCateData:subClassModel.ID];
        }
        self.classID = [NSString stringWithFormat:@"%ld",(long)subClassModel.ID];
        
    }else{
        self.isSelectMenuClass = NO;
        //重置
        [self.threeClassScrollView removeFromSuperview];
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(84, 0, 0, 0));
        }];
        if (self.keyword.length > 0) {
            self.classID = @"";
        }else{
            self.classID = self.defaultClassID;
        }
    }
    //重新加载数据
    [self.collectionView.mj_header beginRefreshing];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.classBtn.selected = NO;
        self.classMenuView.hidden = YES;
        if (self.isSelectMenuClass) {
            [self.classBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            [self.classBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFD70F)] forState:UIControlStateNormal];
        }else{
            [self.classBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
            [self.classBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF2F2F2)] forState:UIControlStateNormal];
        }
        
        [self.classBtn setTitle:selectClassName forState:UIControlStateNormal];
        [self.classBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:3];

    });
}
///选择分类请求其子类
- (void)loadChildrenCateData:(NSInteger )classID {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"id"] = @(classID);
    [JHC2CSearchResultBusiness requestSearchChildrenCateListWithParams:dicData Completion:^(NSError * _Nullable error, NSArray<JHNewStoreTypeTableCellViewModel *> * _Nullable models) {
        if (!error) {
            if (models.count > 0) {
                //选择了二级分类后显示三级分类
                [self setupThreeClassView];
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(84+40, 0, 0, 0));
                }];
            }else{
                [self.threeClassScrollView removeFromSuperview];
                [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(84, 0, 0, 0));
                }];
            }
            self.threeClassScrollView.subClassArray = models;
        }else{
            self.threeClassScrollView.subClassArray = @[];
        }
    }];
    
}
#pragma mark - JHC2CSortMenuViewDelegate
///价格排序筛选
- (void)menuViewDidSelect:(JHC2CSortMenuType)sortType {
    if (self.isSelectMenuClass) {
        [self.classBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [self.classBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFD70F)] forState:UIControlStateNormal];
    }
    //分类弹窗收起
    self.classBtn.selected = NO;
    self.classMenuView.hidden = YES;
    //所选的排序
    if (sortType == 3) { //最新上架
        sortType = 4;
    }
    self.sortTypeNum = (int)sortType;
    [self.collectionView.mj_header beginRefreshing];
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

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.searchResultViewModel.operatingDataArray.count > 0) {
        return self.searchResultViewModel.searchListDataArray.count + 1;
    }else{
        return self.searchResultViewModel.searchListDataArray.count;
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchResultViewModel.operatingDataArray.count > 0 && indexPath.row == 0) {//运营位
        JHC2CGoodsOperationCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsOperationCollectionCell class]) forIndexPath:indexPath];
        [cell bindViewModel:self.searchResultViewModel.operatingDataArray];
        return cell;
    }else{
        NSInteger indexRow = indexPath.row;
        if (self.searchResultViewModel.operatingDataArray.count > 0 ) {
            indexRow = indexPath.row-1;
        }
        JHC2CGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsCollectionViewCell class]) forIndexPath:indexPath];
        JHC2CProductBeanListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexRow];
        [cell bindViewModel:dataModel params:nil];
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.searchResultViewModel.operatingDataArray.count > 0 && indexPath.row == 0) {
       //运营位
    }else{
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
        NSInteger indexRow = indexPath.row;
        if (self.searchResultViewModel.operatingDataArray.count > 0) {
            indexRow = indexPath.row-1;
        }
        
        JHC2CProductBeanListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexRow];
        JHC2CProductDetailController *goodsDetailVC = [[JHC2CProductDetailController alloc] init];
        goodsDetailVC.productId = dataModel.productId;
        [self.navigationController pushViewController:goodsDetailVC animated:YES];
        
        
        //埋点
        NSString *tagStr = @"全部";
        if (self.titleTagIndex == 0) {
            tagStr = @"全部";
        }else if (self.titleTagIndex == 1){
            tagStr = @"拍卖";
        }else{
            tagStr = @"一口价";
        }
        NSMutableDictionary *sensorsDic = [NSMutableDictionary dictionary];
        [sensorsDic setValue:dataModel.productId forKey:@"commodity_id"];
        [sensorsDic setValue:dataModel.price forKey:@"original_price"];
        [sensorsDic setValue:[NSString stringWithFormat:@"%@列表",tagStr] forKey:@"model_type"];
        //搜索
        if (self.keyword.length > 0) {
            [sensorsDic setValue:self.keyword forKey:@"key_word"];
            [sensorsDic setValue:[NSString stringWithFormat:@"集市搜索结果%@页",tagStr] forKey:@"page_position"];
        }
        //分类
        if (self.className.length > 0) {
            if ([self.classClickFrom intValue] == 1) {//一级分类
                [sensorsDic setValue:self.className forKey:@"first_commodity"];
                [sensorsDic setValue:[NSString stringWithFormat:@"集市一级分类%@页",tagStr] forKey:@"page_position"];
            }else{//二级分类
                [sensorsDic setValue:self.className forKey:@"second_commodity"];
                [sensorsDic setValue:[NSString stringWithFormat:@"集市二级分类%@页",tagStr] forKey:@"page_position"];
            }
        }
        
        [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:sensorsDic type:JHStatisticsTypeSensors];
        
    }

}

#pragma - LayoutDelegate
- (CGFloat)shopCVLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout heighForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    if (self.searchResultViewModel.operatingDataArray.count > 0 && indexPath.row == 0) {
        return itemWidth*256/171;
    }else{
        NSInteger indexRow = indexPath.row;
        if (self.searchResultViewModel.operatingDataArray.count > 0) {
            indexRow = indexPath.row-1;
        }
        JHC2CProductBeanListModel *dataModel = self.searchResultViewModel.searchListDataArray[indexRow];
        return dataModel.itemHeight;
    }
}
- (NSInteger)numberOfColumnInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 2;
}
- (CGFloat)columnSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 11;
}
- (CGFloat)rowSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 11;
}
- (UIEdgeInsets)itemEdgeInsetInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVFlowLayout{
    return  UIEdgeInsetsMake(11, 11, 11, 11);
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
        if([obj isKindOfClass:[JHC2CGoodsCollectionViewCell class]]) {
            JHC2CGoodsCollectionViewCell *cell = (JHC2CGoodsCollectionViewCell*)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            CGRect collectionRect = [self.collectionView convertRect:self.collectionView.bounds toView:[UIApplication sharedApplication].keyWindow];
            //只要cell在视图里面显示超过一半就给展示视频 && 视频类型 && 有视频链接
            if (rect.origin.y>=collectionRect.origin.y &&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49 && cell.goodsListModel.videoUrl.length > 0) {
                /** 添加视频*/
                if (self.currentCell == cell) {
                    return;
                }
                self.currentCell = cell;
                self.playerController.view.frame = cell.goodsImgView.bounds;
                [self.playerController setSubviewsFrame];
                [cell.goodsImgView addSubview:self.playerController.view];
                self.playerController.urlString = cell.goodsListModel.videoUrl;
                return;
            }
        }
    }
    //没有满足条件的 释放视频
    [self.playerController stop];
    self.currentCell = nil;
    [self.playerController.view removeFromSuperview];
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

#pragma mark - Lazy
- (JHC2CSearchResultViewModel *)searchResultViewModel{
    if (!_searchResultViewModel) {
        _searchResultViewModel = [[JHC2CSearchResultViewModel alloc] init];
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
        [_collectionView registerClass:[JHC2CGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsCollectionViewCell class])];
        [_collectionView registerClass:[JHC2CGoodsOperationCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHC2CGoodsOperationCollectionCell class])];

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

- (JHC2CSortMenuView *)sortMenuView{
    if (!_sortMenuView) {
        JHC2CSortMenuMode *recMode = [[JHC2CSortMenuMode alloc] init];
        recMode.title = @"综合排序";
        recMode.isShowImg = NO;
        JHC2CSortMenuMode *priceMode = [[JHC2CSortMenuMode alloc] init];
        priceMode.title = @"价格";
        priceMode.isShowImg = YES;
        JHC2CSortMenuMode *newMode = [[JHC2CSortMenuMode alloc] init];
        newMode.title = @"最新上架";
        newMode.isShowImg = NO;
        NSArray *menuArray = @[recMode, priceMode, newMode];
        _sortMenuView = [[JHC2CSortMenuView alloc] initWithFrame:CGRectZero menuArray:menuArray titleFont:13.0];
        _sortMenuView.delegate = self;
        _sortMenuView.selectIndex = 0;
    }
    return _sortMenuView;
}
- (JHC2CClassMenuView *)classMenuView{
    if (!_classMenuView) {
        _classMenuView = [[JHC2CClassMenuView alloc] init];
        _classMenuView.delegate = self;
    }
    return _classMenuView;
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
        //返回顶部
        _floatView.backTopViewBlock = ^{
            @strongify(self)
            [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
        };
    }
    return _floatView;
}

- (UIView *)selectBtnView{
    if (!_selectBtnView) {
        _selectBtnView = [[UIView alloc] init];
    }
    return _selectBtnView;
}
@end
