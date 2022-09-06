//
//  JHNewStoreTypeVC.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreTypeVC.h"

#import "JHPublishCateModel.h"
#import "JHNewPublishChannelCell.h"
#import "TTjianbaoHeader.h"
#import "JHGoodsSearchController.h"
#import "GrowingManager.h"
#import "JHEasyPollSearchBar.h"
#import "JHNewPublishSubCateCollectionCell.h"
#import "JHB2CSubCollectionHeadView.h"
#import "JHNewStoreTypeBusiness.h"
#import "JHStoreApiManager.h"
#import "JHAllStatistics.h"
#import "NTESAudienceLiveViewController.h"

#import "JHNewStoreSearchResultViewController.h"

@interface JHNewStoreTypeVC ()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate,
UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong) JHNewStoreTypePageViewModel *dataModel;

@property(nonatomic, strong)  JHEasyPollSearchBar * searchBar;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;

@property(nonatomic, assign) BOOL  collectionScrolling;

@property (nonatomic, strong) JHNewStoreTypeModel *cateInfoModel;
@end

@implementation JHNewStoreTypeVC

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //默认是发布选择页
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    NSString *pageStr = self.cateFromSoure == JHSearchFromLive ? @"直播全部分类页":@"商城全部分类页";
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":pageStr
    } type:JHStatisticsTypeSensors];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setItems];
    [self layoutItems];
    [self loadData];
}


- (void)setItems {
    self.view.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    //搜索框
    [self.jhNavView addSubview:self.searchBar];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightCollectionView];
    
}

- (void)layoutItems{
    [self.jhLeftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.jhNavView);
        make.left.equalTo(self.jhNavView).offset(12);
        make.size.mas_equalTo(CGSizeMake(30, UI.navBarHeight));
    }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jhLeftButton.mas_right);
        make.centerY.equalTo(self.jhLeftButton);
        make.height.equalTo(@30);
        make.right.equalTo(self.jhNavView).offset(-12);
    }];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.width.equalTo(@90);
    }];
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.mas_right);
        make.right.bottom.equalTo(@0);
        make.top.equalTo(self.leftTableView);
    }];
}

#pragma mark-- Actions

//进入查看全部   section number
- (void)enterAlltypeWithSection:(JHNewStoreTypeModel *)model{
    self.cateInfoModel = model;
    
    JHNewStoreSearchResultViewController *resultVC = [[JHNewStoreSearchResultViewController alloc] init];
    resultVC.searchWord = model.cateName;
    resultVC.searchSource = @"分类搜索";
    resultVC.fromSource = self.cateFromSoure;
    resultVC.cateId = model.ID;
    [self.navigationController pushViewController:resultVC animated:YES];
    
    //统计
    [self addStatisticWithModel:model];
}

//进入搜索页
- (void)enterSearchVC:(NSString *)words {
    JHSearchViewController_NEW *searchVC = [[JHSearchViewController_NEW alloc] init];
    searchVC.fromSource = self.cateFromSoure;
    searchVC.placeholder = words;
    [self.navigationController pushViewController:searchVC animated:NO];
}

//collection Cell点击
- (void)seletedCellWithIndexPath:(NSIndexPath*) path{
    if (self.dataModel.rightCategoryList.count > path.section ) {
        JHNewStoreTypeRightSectionModel *sectionModel = self.dataModel.rightCategoryList[path.section];
        if (sectionModel.secondCateList.count>path.row) {
            JHNewStoreTypeModel *model = sectionModel.secondCateList[path.row];
            self.cateInfoModel = model;
            
            JHNewStoreSearchResultViewController *resultVC = [[JHNewStoreSearchResultViewController alloc] init];
            resultVC.searchWord = model.cateName;
            resultVC.searchSource = @"分类搜索";
            resultVC.fromSource = self.cateFromSoure;
            resultVC.cateId = model.ID;
            [self.navigationController pushViewController:resultVC animated:YES];
            
            //统计
            [self sendMsgToBack:model.cateName isLevelOne:NO];
        }
    }
}

#pragma mark- network
- (void)loadData {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [JHNewStoreTypeBusiness loadClassPageListData:^(NSError * _Nullable error, JHNewStoreTypePageViewModel * _Nonnull model) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error) {
            self.dataModel = model;
            [self reloadData];
        }
    }];
}
- (void)reloadData{
    //轮播热词
    NSMutableArray *hotWordsArr = [NSMutableArray array];
    for (NSString *words in self.dataModel.recommendWordList) {
        JHHotWordModel *wordModel = [JHHotWordModel new];
        wordModel.title = words;
        [hotWordsArr addObject:wordModel];
    }
    self.searchBar.placeholderArray = hotWordsArr;
    //增加底部空白
    JHNewStoreTypeRightSectionModel *lastModel = self.dataModel.rightCategoryList.lastObject;
    CGFloat  addHeight = fabs(self.rightCollectionView.mj_h - lastModel.sectionHeight - ceil(lastModel.secondCateList.count/3.0) * 100);
    self.rightCollectionView.contentInset = UIEdgeInsetsMake(0, 0, addHeight, 0);
    [self.leftTableView reloadData];
    [self.rightCollectionView reloadData];
        
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.rightCollectionView] && !self.collectionScrolling) {
        NSArray<NSIndexPath *> *arr =  [self.rightCollectionView indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionHeader];
        if (arr.count == 0) {return;}
        arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath * _Nonnull obj1, NSIndexPath*  _Nonnull obj2) {
            return  obj1.section < obj2.section ? NSOrderedAscending : NSOrderedDescending;
        }];
        NSIndexPath *path = [NSIndexPath indexPathForRow:arr.firstObject.section inSection:0];
        if(self.leftTableView.indexPathForSelectedRow.row == path.row){return;}
        [self.leftTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}


#pragma mark -- UICollectionViewDatasource and delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataModel.rightCategoryList.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JHNewStoreTypeRightSectionModel *sectionModel = self.dataModel.rightCategoryList[section];
    return sectionModel.secondCateList.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JHB2CSubCollectionHeadView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([JHB2CSubCollectionHeadView class]) forIndexPath:indexPath];
        JHNewStoreTypeRightSectionModel *sectionModel = self.dataModel.rightCategoryList[indexPath.section];
        JHNewStoreTypeModel *leftModel = self.dataModel.leftCategoryList[indexPath.section];
        view.model = sectionModel;
        @weakify(self);
        view.headViewTouchEventBlock = ^(NSInteger eventIndex, NSInteger row) {
            @strongify(self);
            switch (eventIndex) {
                case 0:{//轮播
                    JHNewStoreTypeRightScrollModel *model = sectionModel.operationList[row];
                    [self gotoScrollPage:model leftModel:leftModel];
                }
                    break;
                case 1:{//直播更多
                    [self gotoLiveListPage:leftModel];
                }
                    break;
                case 2:{//直播间
                    JHNewStoreTypeRightLiveModel *model = sectionModel.liveList[row];
                    [self gotoLiveHomePage:model];
                }
                    break;
                case 3:{//分类更多
                    [self enterAlltypeWithSection:leftModel];
                }
                    break;
                    
                default:
                    break;
            }
        };
        return view;
    } else {
        return nil;
    }
}

#pragma mark - 运营位落地页
- (void)gotoScrollPage:(JHNewStoreTypeRightScrollModel*)model leftModel:(JHNewStoreTypeModel *)leftModel{
    NSDictionary *subDic = [self strToDic:model.landingTarget];
    if (subDic) {
        JHNewStoreTypeRightScrollTargetModel *subTowModel = [JHNewStoreTypeRightScrollTargetModel mj_objectWithKeyValues:subDic];
        [JHRootController toNativeVC:subTowModel.vc withParam:subTowModel.params from:JHFromHomeSourceBuy];
        
        //上报
        NSString *url = [subTowModel.vc isEqualToString:@"JHWebViewController"] ? subTowModel.params[@"url"]:subTowModel.componentName;
        NSString *pageName = self.cateFromSoure == JHSearchFromLive ? @"直播全部分类页":@"商城全部分类页";
        NSDictionary *dic = @{
            @"content_url":url,
            @"first_commodity":leftModel.cateName,
            @"spm_type":@"banner",
            @"page_position":pageName
        };
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickSpm" params:dic type:JHStatisticsTypeSensors];
    }
}

#pragma mark - 直播分类列表页
- (void)gotoLiveListPage:(JHNewStoreTypeModel *)model{
    self.cateInfoModel = model;
    JHNewStoreSearchResultViewController *resultVC = [[JHNewStoreSearchResultViewController alloc] init];
    resultVC.searchWord = model.cateName;
    resultVC.searchSource = @"分类搜索";
    resultVC.fromSource = JHSearchFromLive;
    resultVC.cateId = model.ID;
    [self.navigationController pushViewController:resultVC animated:YES];
    
}

#pragma mark - 跳转到直播间
- (void)gotoLiveHomePage:(JHNewStoreTypeRightLiveModel *)model{
    NSString *liveId = [NSString stringWithFormat:@"%ld",model.channelLocalId];
    [JHRootController EnterLiveRoom:liveId fromString:JHEventOnlineauthenticate];
    //上报
    NSString *pageName = self.cateFromSoure == JHSearchFromLive ? @"直播全部分类页":@"商城全部分类页";
    NSDictionary *dic = @{
        @"anchor_nick_name":model.anchorName,
        @"channel_local_id":liveId,
        @"page_position":pageName
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"channelClick" params:dic type:JHStatisticsTypeSensors];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHNewPublishSubCateCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewPublishSubCateCollectionCell class]) forIndexPath:indexPath];
    JHNewStoreTypeRightSectionModel *sectionModel = self.dataModel.rightCategoryList[indexPath.section];
    if (sectionModel.secondCateList.count > indexPath.row) {
        collectionCell.viewModel = sectionModel.secondCateList[indexPath.row];
    }
    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self seletedCellWithIndexPath:indexPath];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    JHNewStoreTypeRightSectionModel *sectionModel = self.dataModel.rightCategoryList[section];
    return CGSizeMake(ScreenW-self.leftTableView.width, sectionModel.sectionHeight);
}

#pragma mark -- <UITableViewDelegate and UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModel.leftCategoryList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHNewPublishChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewPublishChannelCell class]) forIndexPath:indexPath];
    JHNewStoreTypeTableCellViewModel *viewModel = self.dataModel.leftCategoryList[indexPath.row];
    cell.viewModel = viewModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //统计
    JHNewStoreTypeModel *model = self.dataModel.leftCategoryList[indexPath.row];
    [self sendMsgToBack:model.cateName isLevelOne:YES];
//    [self addStatisticWithModel:model];
    
    JHNewStoreTypeRightSectionModel *sectionModel = self.dataModel.rightCategoryList[indexPath.row];
    
    if (sectionModel.secondCateList.count<=0 || self.rightCollectionView.contentSize.height < self.rightCollectionView.mj_h) {return;}
    [self.rightCollectionView layoutIfNeeded];
    UICollectionViewLayoutAttributes *attributes =[self.rightCollectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row]];
    CGRect rect = attributes.frame;
//    JHNewStoreTypeRightSectionModel *sectionModel = self.dataModel.rightCategoryList[indexPath.row];
    CGPoint point = CGPointMake(0, rect.origin.y - sectionModel.sectionHeight);
    self.collectionScrolling = YES;
    self.leftTableView.userInteractionEnabled = NO;
    [self.rightCollectionView setContentOffset:point animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.collectionScrolling = NO;
        self.leftTableView.userInteractionEnabled = YES;
    });
}


#pragma mark -- <setter and getter>

- (UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.estimatedRowHeight = 50;
        _leftTableView.backgroundColor = HEXCOLOR(0xF8F8F8);
        [_leftTableView registerClass:[JHNewPublishChannelCell class] forCellReuseIdentifier:NSStringFromClass([JHNewPublishChannelCell class])];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _leftTableView.contentInset = UIEdgeInsetsMake(0, 0, UI.tabBarAndBottomSafeAreaHeight, 0);
    }
    return _leftTableView;
}

- (UICollectionView *)rightCollectionView{
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(87, 100);
        layout.minimumLineSpacing = 1.0;
        layout.minimumInteritemSpacing = 1.0;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
//        layout.headerReferenceSize = CGSizeMake(ScreenW-self.leftTableView.width, 50);
        
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.contentInset = UIEdgeInsetsMake(0, 0, UI.bottomSafeAreaHeight, 0);
        [_rightCollectionView registerClass:[JHNewPublishSubCateCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewPublishSubCateCollectionCell class])];
        
        [_rightCollectionView registerClass:[JHB2CSubCollectionHeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHB2CSubCollectionHeadView class])];
        _rightCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _rightCollectionView;
}

- (JHEasyPollSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [JHEasyPollSearchBar new];
        _searchBar.backgroundColor = kColorFFF;//[UIColor colorWithHexString:@"F5F6FA"];
        _searchBar.layer.cornerRadius = 15.0;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.layer.borderColor = HEXCOLOR(0xFFD70F).CGColor;
        _searchBar.layer.borderWidth = 1.5;
        @weakify(self);
        _searchBar.didSelectedBlock = ^(NSInteger selectedIndex, BOOL isLeft) {
            @strongify(self);
            JHHotWordModel *wordModel = self.searchBar.placeholderArray[selectedIndex];
            [self enterSearchVC:wordModel.title];
        };
    }
    return _searchBar;
}

#pragma mark -- <打点统计>
- (void)sendMsgToBack:(NSString *)tagName isLevelOne:(BOOL)isLevelOne{
    NSString *pageName = self.cateFromSoure == JHSearchFromLive ? @"直播全部分类页":@"商城全部分类页";
    NSString *levelName = isLevelOne ? @"一级分类":@"二级分类";
    NSDictionary *dic = @{
        @"tab_name":tagName,
        @"positon":levelName,
        @"page_position":pageName,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickTab" params:dic type:JHStatisticsTypeSensors];
}

//打点统计
- (void)addStatisticWithModel:(JHNewStoreTypeModel*)model{
//    分类名称    sort_name
//    分类id    sort_id
//    分类等级    sort_rank  01.一级，02.二级，03.三级
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"sort_name"] = model.cateName;
    parDic[@"sort_id"] = [NSString stringWithFormat:@"%ld", (long)model.ID];
    NSString *levelStr = @"一级";
    if (model.cateLevel == 0) {
        levelStr = @"一级";
    }else if (model.cateLevel == 1){
        levelStr = @"二级";
    }else if (model.cateLevel == 2){
        levelStr = @"三级";
    }
    parDic[@"sort_rank"] = levelStr;
    [JHAllStatistics jh_allStatisticsWithEventId:@"sortClick" params:parDic type:JHStatisticsTypeSensors];

}

#pragma mark -字符串转字典
- (NSDictionary *)strToDic:(NSString *)string{
    if (string == nil){
        return nil;
    }
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
