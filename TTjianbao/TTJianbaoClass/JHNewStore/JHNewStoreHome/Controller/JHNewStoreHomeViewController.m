//
//  JHNewStoreHomeViewController.m
//  TTjianbao
//
//  Created by user on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeViewController.h"
#import "JHNewStoreHomeNavView.h"
#import "JXCategoryTitleView.h"
#import "JXCategoryIndicatorImageView.h"
#import "JHStoreHomeCardModel.h"
#import "JHNewStoreHomeBannerTableViewCell.h"
#import "JHNewStoreCategoryTableCellTableViewCell.h"
#import "JHNewStoreKillActivityTableViewCell.h"
#import "JHStoreHomeNewPeopleGiftTableViewCell.h"
#import "JHNewStoreMallOpreationTableViewCell.h"
/// 精品专场
#import "JHNewStoreBoutiqueTableViewCell.h"
/// 精选商品
#import "JHNewStoreHomeGoosTitleTableViewCell.h"
#import "JHNewStoreHomeGoodsInfoTableViewCell.h"
/// cagetory
#import "UIViewController+JHDisplay.h"
#import "UIView+JHGradient.h"
/// business
#import "JHNewStoreHomeBusiness.h"
#import "JHNewUserRedPacketAlertView.h"
#import "JHNewStoreHomeViewModel.h"
#import "JHStoreDetailViewController.h"
#import "JHBaseOperationView.h"
#import "JHNewStoreSpecialDetailViewController.h"
#import "JHNewStoreHomeFirstGuide.h"
#import "JHMessageViewController.h"
#import "JHMarketFloatLowerLeftView.h"
#import "JHNewStoreHomeReport.h"
#import "JHNewStoreHomeSingelton.h"
#import "JHRecycleUploadTypeSeleteViewController.h"


#import "JHBusinessFansSettingViewController.h"
#import "JHC2CWriteOrderNumViewController.h"
#import "JHRushPurChaseViewController.h"
#import "JHSearchViewController_NEW.h"
#import "JHHotWordModel.h"
#import "JHNewstoreGoodsListViewController.h"

@interface JHNewStorerTableView : UITableView <UIGestureRecognizerDelegate>
@end

@implementation JHNewStorerTableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer {
    return YES;
}
@end


@interface JHNewStoreHomeViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIScrollViewDelegate,
JHNewStoreHomeGoodsInfoTableViewCellDelegate,
JXCategoryViewDelegate
>

@property (nonatomic, strong) JHNewStoreHomeNavView                *navView;
@property (nonatomic, strong) JHNewStorerTableView                 *homeStoreTableView;
@property (nonatomic, strong) JXCategoryTitleView                  *cagetoryTitleView;
@property (nonatomic, strong) JHNewStoreHomeGoodsInfoTableViewCell *lastCell;
/// 新人专区入口model
@property (nonatomic, strong) JHNewUserRedPacketAlertViewSubModel *anewPeopleBannerModel;

@property (nonatomic, strong) NSMutableArray                       *dataSourceArray;
@property (nonatomic, strong) NSMutableArray                       *upSourceArray; /// 上半区运营、活动数据
@property (nonatomic, strong) NSMutableArray                       *floorSourceArray; /// 下半区商品相关数据
@property (nonatomic, assign) BOOL                                  hasBoutique; /// 是否有专场
@property (nonatomic, assign) BOOL                                  hasGoodsInfo; /// 是否有商品
@property (nonatomic, assign) BOOL                                  isCheckPointScr; /// 是否锚点滚动
/// 浮层
@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;

@property (nonatomic, strong) JHNewStoreHomeCellStyle_MallModelViewModel *mallViewModel;
@end

@implementation JHNewStoreHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF5F5F8);
    self.hasBoutique = NO;
    [JHNewStoreHomeSingelton shared].hasBoutiqueValue = NO;
    self.isCheckPointScr = NO;
    self.hasGoodsInfo = NO;
    [self removeNavView];
    [self setupNav];
    [self setupViews];
    [self.homeStoreTableView.mj_header beginRefreshing];
//    [self loadData];
    [self addObserver];
    if ([CommHelp isFirstForName:@"isshowNewStoreFirstTip"]){
        [[JHNewStoreHomeFirstGuide signAppealpopWindow] show];
    }
    //右下角浮窗按钮
    [self.view addSubview:self.floatView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JHNewStoreHomeReport jhNewStoreHomeShowReport];
    @weakify(self);
    [self getAllUnreadMsgCount:^(id obj) {
        @strongify(self);
        [self.navView reloadMessageInfoCount:obj];
    }];
    [self.navView reloadHotKeys];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [JHHomeTabController changeStatusWithMainScrollView:self.homeStoreTableView index:2];
    [JHHomeTabController setSubScrollView:[self.lastCell getSubScrollViewFromSelf]];
    //收藏等数据刷新
    [self.floatView loadData];
    
}

- (void)setupNav {
    self.navView = [[JHNewStoreHomeNavView alloc] init];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(UI.statusBarHeight + 110.f - 9.f-7);
    }];
    @weakify(self);
    self.navView.searchScrollBlock = ^(NSInteger index) {
        @strongify(self);
        JHHotWordModel *wordModel = self.navView.hotKeysArray[index];
        /// 点击搜索框上报
        [JHNewStoreHomeReport jhNewStoreSearchViewClickReport];
        JHSearchViewController_NEW *searchVC = [[JHSearchViewController_NEW alloc] init];
        searchVC.fromSource = JHSearchFromStore;
        searchVC.placeholder = wordModel.title;
        [self.navigationController pushViewController:searchVC animated:NO];
    };
    self.navView.messageBtnClickBlock = ^{
        @strongify(self);
        if ([self isLgoin]) {
            JHMessageViewController *vc = [[JHMessageViewController alloc] init];
            vc.from = JHFromHomeSourceBuy;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
    };
}

- (BOOL)isLgoin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {}];
        return NO;
    }
    return YES;
}


- (void)setupViews {
    [self.view addSubview:self.homeStoreTableView];
    [self.homeStoreTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(0.f);
        make.right.equalTo(self.view.mas_right).offset(0.f);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    @weakify(self);
    self.homeStoreTableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self loadData];
//        [self.lastCell refresh];
        [self.lastCell releaseGoodListVC];
        self.lastCell = nil;
    }];
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (NSMutableArray *)upSourceArray {
    if (!_upSourceArray) {
        _upSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _upSourceArray;
}

- (NSMutableArray *)floorSourceArray {
    if (!_floorSourceArray) {
        _floorSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _floorSourceArray;
}

- (void)addObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCell:) name:@"NEWSTOREREMOVECELL" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsInfoSuccess:) name:@"JHNEWSTOREGOODSINFOSUCC" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSubScrollForToTop) name:@"GOODSINFOVIEWHASSUBSCRO" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(regreshKillActivityCell:) name:@"NEWSTOREREREFRESHKILLACTIVITYCELL" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appWillEnterForeground:(NSNotification *)no {
    [self.homeStoreTableView.mj_header beginRefreshing];
}

- (void)removeCell:(NSNotification *)no {
    NSIndexPath *indexPath = no.object;
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.floorSourceArray removeObjectAtIndex:indexPath.row];
    [self.homeStoreTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)goodsInfoSuccess:(NSNotification *)no {
    self.hasGoodsInfo = [no.object boolValue];
    if (![no.object boolValue]) {
        [self endRefresh];
    }
}

- (void)setSubScrollForToTop {
    [JHHomeTabController setSubScrollView:[self.lastCell getSubScrollViewFromSelf]];
    [self endRefresh];
}

- (void)regreshKillActivityCell:(NSNotification *)no {
    NSIndexPath *indexPath = no.object;
    [self getNewKillActivity:indexPath];
}

/// 秒杀专区
- (void)getNewKillActivity:(NSIndexPath *)indexPath {
    @weakify(self);
    [JHNewStoreHomeBusiness getKillActivity:^(NSError * _Nullable error, JHNewStoreHomeCellStyle_KillActivityViewModel * _Nullable viewModel) {
        @strongify(self);
        if (!error) {
            [self.upSourceArray replaceObjectAtIndex:indexPath.row withObject:viewModel];
            [self.homeStoreTableView reloadRow:indexPath.row inSection:0 withRowAnimation:UITableViewRowAnimationNone];
        } else {
            NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
            [self.upSourceArray removeObjectAtIndex:indexPath.row];
            [self.homeStoreTableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (JHNewStorerTableView *)homeStoreTableView {
    if (!_homeStoreTableView) {
        _homeStoreTableView                                = [[JHNewStorerTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _homeStoreTableView.dataSource                     = self;
        _homeStoreTableView.delegate                       = self;
        _homeStoreTableView.backgroundColor                = HEXCOLOR(0xF5F5F8);
        _homeStoreTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _homeStoreTableView.estimatedRowHeight             = 10.f;
        _homeStoreTableView.showsVerticalScrollIndicator   = NO;
        if (@available(iOS 11.0, *)) {
            _homeStoreTableView.estimatedSectionHeaderHeight   = 0.1f;
            _homeStoreTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        
        /// banner
        [_homeStoreTableView registerClass:[JHNewStoreHomeBannerTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewStoreHomeBannerTableViewCell class])];
        
        /// 一行五列运营位
        [_homeStoreTableView registerClass:[JHNewStoreCategoryTableCellTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewStoreCategoryTableCellTableViewCell class])];
        
        /// 秒杀专区
        [_homeStoreTableView registerClass:[JHNewStoreKillActivityTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewStoreKillActivityTableViewCell class])];
        
        /// 活动
        [_homeStoreTableView registerClass:[JHNewStoreMallOpreationTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewStoreMallOpreationTableViewCell class])];

        /// 新人专享
        [_homeStoreTableView registerClass:[JHStoreHomeNewPeopleGiftTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHStoreHomeNewPeopleGiftTableViewCell class])];
        
        /// 精品专场
        [_homeStoreTableView registerClass:[JHNewStoreBoutiqueTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewStoreBoutiqueTableViewCell class])];
        
        /// 商品标题
        [_homeStoreTableView registerClass:[JHNewStoreHomeGoosTitleTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoosTitleTableViewCell class])];
        
        /// 商品瀑布流
        [_homeStoreTableView registerClass:[JHNewStoreHomeGoodsInfoTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsInfoTableViewCell class])];

        if ([_homeStoreTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_homeStoreTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_homeStoreTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_homeStoreTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _homeStoreTableView;
}


- (JXCategoryTitleView *)cagetoryTitleView {
    if (_cagetoryTitleView == nil) {
        _cagetoryTitleView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 54.f)];
//        _cagetoryTitleView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _cagetoryTitleView.titleFont = [UIFont fontWithName:kFontNormal size:16];
        _cagetoryTitleView.titleSelectedFont = [UIFont fontWithName:kFontMedium size:16];
        _cagetoryTitleView.titleColor = HEXCOLOR(0x666666);
        _cagetoryTitleView.titleSelectedColor = HEXCOLOR(0x222222);
        _cagetoryTitleView.cellSpacing = 15;
        _cagetoryTitleView.titles = @[@"精品专场",@"精选商品"];
        _cagetoryTitleView.delegate = self;
        
        JXCategoryIndicatorImageView *indicatorImgView = [[JXCategoryIndicatorImageView alloc] init];
        indicatorImgView.indicatorImageView.image = [UIImage imageNamed:@"sq_category_Indicator_img_normal"];
        indicatorImgView.indicatorImageView.contentMode = UIViewContentModeScaleAspectFill;
        indicatorImgView.indicatorImageViewSize = CGSizeMake(28.f, 4.f);
        indicatorImgView.indicatorImageView.layer.cornerRadius = 2.f;
        indicatorImgView.indicatorImageView.layer.masksToBounds = YES;
        indicatorImgView.verticalMargin = 4;
        _cagetoryTitleView.indicators = @[indicatorImgView];
    }
    return _cagetoryTitleView;
}

- (JHMarketFloatLowerLeftView *)floatView{
    if (!_floatView) {
        _floatView = [[JHMarketFloatLowerLeftView alloc] initWithShowType:JHMarketFloatShowTypeNormal];
        _floatView.isHaveTabBar = YES;
        //收藏
        _floatView.collectGoodsBlock = ^{
            [JHNewStoreHomeReport jhNewStoreHomeCollectionBtnClick:@"" zc_id:@"" store_from:@"天天商城首页"];
        };
        
    }
    return _floatView;
}


- (void)endRefresh {
    [self.homeStoreTableView.mj_header endRefreshing];
}

#pragma mark - load Data
- (void)loadData {
    [self.upSourceArray removeAllObjects];
    [self.floorSourceArray removeAllObjects];
    [self.dataSourceArray removeAllObjects];
    self.hasBoutique = NO;
    [JHNewStoreHomeSingelton shared].hasBoutiqueValue = NO;
    [self getSearchHotWordsList];
    [self getOperationInfo];
}


/// 获取热搜热词列表
- (void)getSearchHotWordsList {
    @weakify(self);
    [JHNewStoreHomeBusiness getHotKeywords:^(NSArray *respObj, BOOL hasError) {
        @strongify(self);
        if (hasError) {
            [self endRefresh];
        }
        if (respObj) {
            self.navView.hotKeysArray = respObj;
            [self.navView reloadHotKeys];
        }
    }];
}

/// 获取运营位信息
- (void)getOperationInfo {
    [self.dataSourceArray removeAllObjects];
    [self.upSourceArray removeAllObjects];
    @weakify(self);
    [JHNewStoreHomeBusiness getNewStoreHomeOperationInfo:^(NSError * _Nullable error, JHNewStoreHomeCellStyle_MallModelViewModel * _Nullable viewModel) {
        @strongify(self);
        if (error) {
            [self endRefresh];
        }
        self.mallViewModel = viewModel;
        if (viewModel.bannerModel.slideShow.count > 0) {
            [self.upSourceArray addObject:viewModel.bannerModel];
        }
        if (viewModel.kingKongModel.operationSubjectList.count >0) {
            [self.upSourceArray addObject:viewModel.kingKongModel];
        }
        
        [self getKillActivity];
    }];
}

/// 秒杀专区
- (void)getKillActivity {
    @weakify(self);
    [JHNewStoreHomeBusiness getKillActivity:^(NSError * _Nullable error, JHNewStoreHomeCellStyle_KillActivityViewModel * _Nullable viewModel) {
        @strongify(self);
        if (!error) {
            [self.upSourceArray addObject:viewModel];
        }
        
        if (self.mallViewModel.bgAdVModel.operationPosition.count >0) {
            JHMallOperateModel *operateModel = [JHMallOperateModel cast:self.mallViewModel.bgAdVModel.operationPosition[0]];
            if (operateModel && operateModel.definiDetails.count >0) {
                [self.upSourceArray addObject:self.mallViewModel.bgAdVModel];
            }
        }
        if (self.upSourceArray.count >0) {
            [self.dataSourceArray addObjectsFromArray:self.upSourceArray];
        }
        
        [self.homeStoreTableView reloadData];
        
        [self getNewPeopleGiftInfo];
    }];
}

/// 获取新人福利信息
- (void)getNewPeopleGiftInfo {
    @weakify(self);
    [JHNewStoreHomeBusiness getNewStoreHomeNewPeopleGift:^(JHNewStoreHomeCellStyle_NewPeopleViewModel * _Nullable viewModel) {
        @strongify(self);
        if (viewModel.anewPeopleModel.banner) {
            self.anewPeopleBannerModel = viewModel.anewPeopleModel.banner;
            [self.upSourceArray addObject:viewModel];
//            [self.homeStoreTableView reloadData];
        }
        [self.homeStoreTableView reloadData];
        [self getBoutiqueInfo];
    }];
}

/// 获取专场
- (void)getBoutiqueInfo {
    @weakify(self);
    [JHNewStoreHomeBusiness getBoutiqueListCompletion:^(NSError * _Nullable error, NSArray<JHNewStoreHomeCellStyle_BoutiqueViewModel *> * _Nullable viewModels) {
        @strongify(self);
        [self endRefresh];
        if (viewModels.count >0) {
            [self.floorSourceArray addObjectsFromArray:viewModels];
            /// 增加商品分割线
            JHNewStoreHomeCellStyle_GoodsLineViewModel *lineViewModel = [[JHNewStoreHomeCellStyle_GoodsLineViewModel alloc] init];
            lineViewModel.cellStyle = JHNewStoreHomeCellStyle_GoodsLine;
            [self.dataSourceArray removeAllObjects];
            [self.dataSourceArray addObject:self.upSourceArray];
            
            [self.floorSourceArray addObject:lineViewModel];
            [self.dataSourceArray addObject:self.floorSourceArray];
        }
        [self getGoodsInfo];
    }];
}

/// 获取商品
- (void)getGoodsInfo {
    JHNewStoreHomeCellStyle_GoodsViewModel *viewModel = [[JHNewStoreHomeCellStyle_GoodsViewModel alloc] init];
    if (self.floorSourceArray.count == 0) {
        /// 表示没有专场，不显示专场
        self.hasBoutique = NO;
        [JHNewStoreHomeSingelton shared].hasBoutiqueValue = NO;
        [self.dataSourceArray removeAllObjects];
        [self.dataSourceArray addObjectsFromArray:self.upSourceArray];
        [self.dataSourceArray addObject:viewModel];
    } else {
        /// 表示有专场
        self.hasBoutique = YES;
        [JHNewStoreHomeSingelton shared].hasBoutiqueValue = YES;
//        [self.dataSourceArray removeAllObjects];
//        [self.dataSourceArray addObject:self.upSourceArray];
        [self.floorSourceArray addObject:viewModel];
    }
    [self.lastCell releaseGoodListVC];
    [self.homeStoreTableView reloadData];
}


#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.hasBoutique) {
        if (section == 0) {
            return 0;
        }
        return 45.f;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.hasBoutique) {
        if (section == 0) {
            return nil;
        }
        self.cagetoryTitleView.backgroundColor = HEXCOLOR(0xFFFFFF);
        return self.cagetoryTitleView;
    } else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.hasBoutique) {
        return self.dataSourceArray.count;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hasBoutique) {
        NSArray *viewModels = [NSArray cast:self.dataSourceArray[section]];
        if (viewModels && viewModels.count>0) {
            return viewModels.count;
        }
        return 0;
    } else {
        return self.dataSourceArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *viewModels;
    if (self.hasBoutique) {
        viewModels = self.dataSourceArray[indexPath.section];
        if (!viewModels || viewModels.count == 0) {
            return [[UITableViewCell alloc] init];
        }
    } else {
        viewModels = self.dataSourceArray;
    }
    id viewModel = viewModels[indexPath.row];
    
    /// banner
    if ([JHNewStoreHomeCellStyle_BannerViewModel has:viewModel]) {
        JHNewStoreHomeCellStyle_BannerViewModel *bannerViewModel = [JHNewStoreHomeCellStyle_BannerViewModel cast:viewModel];
        JHNewStoreHomeBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewStoreHomeBannerTableViewCell class])];
        if (!cell) {
            cell = [[JHNewStoreHomeBannerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewStoreHomeBannerTableViewCell class])];
        }
        [cell setViewModel:bannerViewModel.slideShow];
        return cell;
    }
    
    /// 一行五列运营位
    if ([JHNewStoreHomeCellStyle_KingKongViewModel has:viewModel]) {
        JHNewStoreHomeCellStyle_KingKongViewModel *kingKongViewModel = [JHNewStoreHomeCellStyle_KingKongViewModel cast:viewModel];
        JHNewStoreCategoryTableCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewStoreCategoryTableCellTableViewCell class])];
        if (!cell) {
            cell = [[JHNewStoreCategoryTableCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewStoreCategoryTableCellTableViewCell class])];
        }
        cell.categoryInfos = kingKongViewModel.operationSubjectList;
        return cell;
    }
    
    /// 秒杀位
    if ([JHNewStoreHomeCellStyle_KillActivityViewModel has:viewModel]) {
        JHNewStoreHomeCellStyle_KillActivityViewModel *killActivityViewModel = [JHNewStoreHomeCellStyle_KillActivityViewModel cast:viewModel];
        JHNewStoreKillActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewStoreKillActivityTableViewCell class])];
        if (!cell) {
            cell = [[JHNewStoreKillActivityTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewStoreKillActivityTableViewCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setViewModel:killActivityViewModel.killActivityModel];
        @weakify(self);
        cell.updateKillActivityCell = ^(NSInteger index, NSString * _Nonnull productId) {
            @strongify(self);
            NSString *from = @"";
            /// 0标题、1倒计时、2商品、3查看更多
            if (index == 0) {
                from = @"标题";
            } else if (index == 1) {
                from = @"倒计时";
            } else if (index == 2) {
                from = @"商品";
            } else if (index == 3) {
                from = @"查看更多";
            }
            JHRushPurChaseViewController *vc = [[JHRushPurChaseViewController alloc] init];
            vc.from = from;
            if (index == 2) {
                vc.productId = productId;
            }
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    
    /// 广告位
    if ([JHNewStoreHomeCellStyle_BgAdViewModel has:viewModel]) {
        JHNewStoreHomeCellStyle_BgAdViewModel *bgViewModel = [JHNewStoreHomeCellStyle_BgAdViewModel cast:viewModel];
        JHNewStoreMallOpreationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewStoreMallOpreationTableViewCell class])];
        if (!cell) {
            cell = [[JHNewStoreMallOpreationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewStoreMallOpreationTableViewCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.operateModel = bgViewModel.operationPosition[0];
        return cell;
    }
    
    /// 新人专享位
    if ([JHNewStoreHomeCellStyle_NewPeopleViewModel has:viewModel]) {
        JHNewStoreHomeCellStyle_NewPeopleViewModel *aNewPeopleViewModel = [JHNewStoreHomeCellStyle_NewPeopleViewModel cast:viewModel];
        
        JHStoreHomeNewPeopleModel *subModel = [[JHStoreHomeNewPeopleModel alloc] init];
        subModel.img = aNewPeopleViewModel.anewPeopleModel.banner.img;
        subModel.url = aNewPeopleViewModel.anewPeopleModel.banner.url;
        
        JHStoreHomeNewPeopleGiftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHStoreHomeNewPeopleGiftTableViewCell class])];
        if (!cell) {
            cell = [[JHStoreHomeNewPeopleGiftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHStoreHomeNewPeopleGiftTableViewCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.anewPeopleModel = subModel;
        cell.backgroundColor = HEXCOLOR(0xFFFFFF);
        return cell;
    }
    
    /// 精品专场
    if ([JHNewStoreHomeCellStyle_BoutiqueViewModel has:viewModel]) {
        JHNewStoreHomeCellStyle_BoutiqueViewModel *bouViewModel = [JHNewStoreHomeCellStyle_BoutiqueViewModel cast:viewModel];
        JHNewStoreBoutiqueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewStoreBoutiqueTableViewCell class])];
        if (!cell) {
            cell = [[JHNewStoreBoutiqueTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewStoreBoutiqueTableViewCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isFirstCell = bouViewModel.isFirstCell;
        [cell setViewModel:bouViewModel.boutiqueModel];
        if (bouViewModel.isFirstCell) {
            [cell.contentView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFFFFFF), HEXCOLOR(0xF5F5F8)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 0.5)];
        } else {
            [cell.contentView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xF5F5F8), HEXCOLOR(0xF5F5F8)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
            cell.contentView.backgroundColor = HEXCOLOR(0xF5F5F8);
        }
        cell.shareBlock = ^(JHNewStoreHomeShareInfoModel * _Nonnull model) {
            /// 分享
            JHShareInfo* info = [JHShareInfo new];
            info.title = model.title;
            info.desc  = model.desc;
            info.shareType = ShareObjectTypeCustomizeNormal;
            info.url = model.url;
            info.img = model.img;
            [JHBaseOperationView showShareView:info objectFlag:nil];
            [JHNewStoreHomeReport jhNewStoreHomeBoutiqueShareClickReport:bouViewModel.boutiqueModel.title zc_type:bouViewModel.boutiqueModel.showStatus zc_id:[NSString stringWithFormat:@"%ld",bouViewModel.boutiqueModel.showId]];
        };
        @weakify(cell);
        cell.bouClickBlock = ^{
            JHNewStoreSpecialDetailViewController *vc = [[JHNewStoreSpecialDetailViewController alloc] init];
            vc.showId = [NSString stringWithFormat:@"%ld",bouViewModel.boutiqueModel.showId];
            vc.fromPage = (bouViewModel.boutiqueModel.showStatus == 1) ? @"天天商城首页热卖专场":@"天天商城首页预告专场";
            vc.startRemindBtnBlock = ^(BOOL isSuccess) {
                @strongify(cell);
                bouViewModel.boutiqueModel.subscribeStatus = 1;
                [cell reloadBuyBtnMess:isSuccess];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        return cell;
    }
    
    /// 商品分割线
    if ([JHNewStoreHomeCellStyle_GoodsLineViewModel has:viewModel]) {
        JHNewStoreHomeGoosTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewStoreHomeGoosTitleTableViewCell class])];
        if (!cell) {
            cell = [[JHNewStoreHomeGoosTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewStoreHomeGoosTitleTableViewCell class])];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    /// 商品
    if ([JHNewStoreHomeCellStyle_GoodsViewModel has:viewModel]) {
//        JHNewStoreHomeCellStyle_GoodsViewModel *goodsViewModel = [JHNewStoreHomeCellStyle_GoodsViewModel cast:viewModel];
        self.lastCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewStoreHomeGoodsInfoTableViewCell class])];
        if (!self.lastCell) {
            self.lastCell = [[JHNewStoreHomeGoodsInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsInfoTableViewCell class])];
        }
        self.lastCell.hasBoutiqueValue = self.hasBoutique;
        self.lastCell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.lastCell.delegate = self;
        
        @weakify(self);
        self.lastCell.goodsClickBlock = ^(JHNewStoreHomeGoodsProductListModel * _Nonnull model, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            JHStoreDetailViewController *detailVC = [[JHStoreDetailViewController alloc] init];
            detailVC.fromPage = @"天天商城";
            detailVC.productId = [NSString stringWithFormat:@"%ld",model.productId];
            [self.navigationController pushViewController:detailVC animated:YES];
            
            [JHNewStoreHomeReport jhNewStoreHomeGoodsShowListClick:[NSString stringWithFormat:@"%ld",model.productId] commodity_label:NONNULL_STR([JHNewStoreHomeReport shared].tabName) commodity_name:model.productName andCurrentTitle:self.lastCell.goodListVc.currentCatTitle];
            
            //判断刷新当前商品订单 是否 解除
            [[RACObserve(detailVC, sellStatusDesc) skip:2] subscribeNext:^(id  _Nullable x) {
                //先改变model值
                model.productSellStatusDesc = x;
                //再更新指定cell
                [UIView performWithoutAnimation:^{
                    UICollectionView *collection = (UICollectionView *)[self.lastCell getSubScrollViewFromSelf];
                    [collection reloadItemsAtIndexPaths:@[indexPath]];
                }];
            }];
            
        };
        self.lastCell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
            @strongify(self);
            if (!isH5) {
                JHNewStoreSpecialDetailViewController * vc = [[JHNewStoreSpecialDetailViewController alloc] init];
                vc.fromPage = @"商品推荐列表";
                vc.showId = showId;
                [self.navigationController pushViewController:vc animated:YES];
//                [JHNewStoreHomeReport jhNewStoreHomeBoutiqueClickReport:boutiqueName zc_type:2 zc_id:showId store_from:@"商品推荐列表"];
            } else {
                [JHNewStoreHomeReport jhNewStoreHomeNewPeopleClickReport:@"商品推荐列表"];
            }
        };
        [JHHomeTabController setSubScrollView:[self.lastCell getSubScrollViewFromSelf]];
        return self.lastCell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *viewModels;
    if (self.hasBoutique) {
        viewModels = self.dataSourceArray[indexPath.section];
        if (!viewModels || viewModels.count == 0) {
            return;
        }
    } else {
        viewModels = self.dataSourceArray;
    }
    id viewModel = viewModels[indexPath.row];
    
    /// 秒杀专区
    if ([JHNewStoreHomeCellStyle_KillActivityViewModel has:viewModel]) {
        JHRushPurChaseViewController *vc = [[JHRushPurChaseViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

    /// 新人专享位
    if ([JHNewStoreHomeCellStyle_NewPeopleViewModel has:viewModel]) {
        JHNewStoreHomeCellStyle_NewPeopleViewModel *aNewPeopleViewModel = [JHNewStoreHomeCellStyle_NewPeopleViewModel cast:viewModel];
        if (aNewPeopleViewModel.anewPeopleModel.banner) {
            [JHRouterManager pushWebViewWithUrl:aNewPeopleViewModel.anewPeopleModel.banner.url title:@"" controller:self];
            [JHNewStoreHomeReport jhNewStoreHomeNewPeopleClickReport:@"天天商场首页"];
        }
    }
    
    /// 精品专场
    if ([JHNewStoreHomeCellStyle_BoutiqueViewModel has:viewModel]) {
        JHNewStoreHomeCellStyle_BoutiqueViewModel *bouViewModel = [JHNewStoreHomeCellStyle_BoutiqueViewModel cast:viewModel];
        JHNewStoreSpecialDetailViewController *vc = [[JHNewStoreSpecialDetailViewController alloc] init];
        vc.showId = [NSString stringWithFormat:@"%ld",bouViewModel.boutiqueModel.showId];
        vc.fromPage = (bouViewModel.boutiqueModel.showStatus == 1) ? @"天天商城首页热卖专场":@"天天商城首页预告专场";
        [self.navigationController pushViewController:vc animated:YES];
//        [JHNewStoreHomeReport jhNewStoreHomeBoutiqueClickReport:bouViewModel.boutiqueModel.title zc_type:(bouViewModel.boutiqueModel.showStatus + 1) zc_id:[NSString stringWithFormat:@"%ld",bouViewModel.boutiqueModel.showId] store_from:vc.fromPage];
    }
}

#pragma mark scrollViewDelegate
- (CGFloat)getNavHeight:(CGFloat)offset {
    CGFloat animationHeight = UI.statusBarHeight + 110.f - 9.f -7- offset;
    if (animationHeight <= (UI.statusBarHeight + 69.f - 9.f - 7.f-7)) {
        animationHeight = UI.statusBarHeight + 69.f - 9.f - 7.f-7;
    }
    return animationHeight;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    /// 导航条滚动效果
    if (contentOffsetY <= 0) {
        [self.navView reloadAnimation:0];
        [self.navView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(UI.statusBarHeight + 110.f - 9.f-7);
        }];
        [self.homeStoreTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navView.mas_bottom);
            make.left.equalTo(self.view.mas_left).offset(0.f);
            make.right.equalTo(self.view.mas_right).offset(0.f);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        return;
    }
    if (contentOffsetY > 0) {
        [self.navView reloadAnimation:contentOffsetY];
        CGFloat animationHeight = UI.statusBarHeight + 110.f - 9.f -7- contentOffsetY;
        if (animationHeight <= (UI.statusBarHeight + 69.f - 9.f - 7.f-7)) {
            animationHeight = UI.statusBarHeight + 69.f - 9.f - 7.f-7;
        }
        [self.navView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(animationHeight);
        }];
        [self.homeStoreTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navView.mas_bottom);
            make.left.equalTo(self.view.mas_left).offset(0.f);
            make.right.equalTo(self.view.mas_right).offset(0.f);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    }
    if (scrollView.contentOffset.y > 10) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
    }
    [JHHomeTabController changeStatusWithMainScrollView:self.homeStoreTableView index:2 hasSubScrollView:YES];

    /// 联动效果
    CGFloat bottomToolBarHeight = 48.f;
    CGFloat criticalPointOffsetY = 0.f;
    if (!self.hasBoutique) {
        criticalPointOffsetY = (scrollView.contentSize.height + [self getNavHeight:contentOffsetY] + bottomToolBarHeight) - ScreenH + 45.f - 44.f;
    } else {
        criticalPointOffsetY = (scrollView.contentSize.height + [self getNavHeight:contentOffsetY] + bottomToolBarHeight) - ScreenH;
    }
    NSString *str1 = [NSString stringWithFormat:@"%.2f",contentOffsetY];
    NSString *str2 = [NSString stringWithFormat:@"%.2f",criticalPointOffsetY];
    if ([str1 floatValue] >= [str2 floatValue]) {
        if (!self.isCheckPointScr) {
            [self.cagetoryTitleView selectItemAtIndex:1];
        }
        if (self.hasGoodsInfo) {
            self.cannotScroll = YES;
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
            [self.lastCell makeDeatilDescModuleScroll:YES];
        }
        [self.lastCell reloadCategoryViewBackgroundColor:YES];
        
    } else {
        [self.lastCell reloadCategoryViewBackgroundColor:NO];
        if (!self.isCheckPointScr) {
            [self.cagetoryTitleView selectItemAtIndex:0];
        }
        if (self.hasGoodsInfo && self.cannotScroll) {
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (!scrollView.decelerating) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}

- (void)scrollViewDidEndScroll {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [self.lastCell makeDeatilDescModuleScrollToTop];
    return YES;
}

#pragma mark - cellDelegate
- (void)JHNewStoreHomeGoodsInfoTableViewCellLeaveTopd {
    self.cannotScroll = NO;
}

- (void)pushToStoreDetail:(NSString *)productId {
    JHStoreDetailViewController *vc = [[JHStoreDetailViewController alloc] init];
    vc.fromPage = @"天天商城";
    vc.productId = productId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - JXDelegate
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    self.isCheckPointScr = YES;
    if (index == 0) { /// 专场
        [JHNewStoreHomeReport jhNewStoreHomeTabClickReport:@"精品专场"];
        self.cannotScroll = NO;
        [self.homeStoreTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        UIScrollView *subScrollView = [self.lastCell getSubScrollViewFromSelf];
        [subScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    } else { /// 商品
        NSInteger index = 0;
        for (NSObject *lineViewModel in self.floorSourceArray) {
            if ([JHNewStoreHomeCellStyle_GoodsLineViewModel has:lineViewModel]) {
                break;
            }
            index ++;
        }
        [JHNewStoreHomeReport jhNewStoreHomeTabClickReport:@"精选商品"];
        [self.homeStoreTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index+1 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    [JHDispatch after:1 execute:^{
        self.isCheckPointScr = NO;
    }];
}

#pragma mark -
#pragma mark - TabBar点击事件
- (void)subScrollViewDidScrollToTop {
    [[self.lastCell getSubScrollViewFromSelf] setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void)tableBarSelect:(NSInteger)currentIndex {
    if (currentIndex == 1) {  //特卖商城
        if ([self isRefreshing]) {
            return;
        }
        [_homeStoreTableView setContentOffset:CGPointMake(0, 0) animated:NO];
        [_homeStoreTableView.mj_header beginRefreshing];
    }
}

- (BOOL)isRefreshing {
    if([_homeStoreTableView.mj_header isRefreshing]) {
        return YES;
    }
    return NO;
}

@end
