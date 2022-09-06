//
//  JHShopHomeController.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/19.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//


#import "JHShopHomeController.h"
#import "JHShopGoodsController.h"
#import "JHShopHomeNavigationBar.h"
#import "JHShopHeaderView.h"
#import "JHGoodsInfoMode.h"
#import "JHSellerInfo.h"
#import "TYPagerController.h"
#import "TYTabPagerBar.h"
#import "UMengManager.h"
#import <MJExtension/MJExtension.h>
#import "YDCountDownManager.h"
#import "JHBaseOperationView.h"
#import "UIView+JHShadow.h"
#import <YDCategoryKit/YDCategoryKit.h>
#import "UIView+CornerRadius.h"

#define shopNavHeight  (UI.statusBarHeight + 85)

NSString *const attentionSuccess = @"关注成功";
NSString *const attentionFailure = @"关注失败";
NSString *const cancelAttentionSuccess = @"取消关注成功";
NSString *const cancelAttentionFailure = @"取消关注失败";


@interface JHShopHomeController () <TYTabPagerBarDataSource,TYTabPagerBarDelegate,TYPagerControllerDataSource,TYPagerControllerDelegate,JHShopHomeNavigationBarDelegate>

@property (nonatomic, strong) JHShopHomeNavigationBar *customNavBar;
@property (nonatomic, strong)JHShopHeaderView *headerView;
@property (nonatomic, strong) TYTabPagerBar *tabBar;
@property (nonatomic, strong) TYPagerController *pagerController;

//@property (nonatomic, copy) NSArray *headerPages;
@property (nonatomic, strong) JHSellerInfo *sellerInfo;
@property (nonatomic, strong) JHShareInfo *shareInfo;
@property (assign) int sortType;
@property (nonatomic, copy) NSString *startPageTime;  //页面初始化时间点
@end

@implementation JHShopHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sortType = 1;  ///默认1 推荐 2 最新
//    _headerPages = @[@"特卖商品", @"询价商品"];

    self.startPageTime = [NSString getCurrentTime];
    [self initViews];
//    [self addTabPageBar];
//    [self addPagerController];
//    [self reloadData];
    
    ///加载店铺信息
    [self loadSellerInfo];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.customNavBar showOriginView];
    });
    
    ///用户画像埋点：--- 店铺首页停留时长- 开始
    [JHUserStatistics noteEventType:kUPEventTypeMallShopHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin}];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self growingSetParamDict:@{@"seller_id":@(self.sellerId)}];
    ///用户画像埋点：--- 店铺首页停留时长- 结束
    [JHUserStatistics noteEventType:kUPEventTypeMallShopHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd}];
    [super viewDidDisappear:animated];
}

- (void)initViews {
    JHShopHomeNavigationBar * naviBar = [[JHShopHomeNavigationBar alloc] init];
    naviBar = [[JHShopHomeNavigationBar alloc] init];
    naviBar.isFollow = NO;
    naviBar.delegate = self;
    _customNavBar = naviBar;
    
    JHShopHeaderView *shopHeader = [[JHShopHeaderView alloc] init];
    shopHeader.backgroundColor = [UIColor whiteColor];
    _headerView = shopHeader;
    
    [self.view addSubview:_customNavBar];
    [self.view addSubview:_headerView];
    
    [_customNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.width.equalTo(self.view);
        make.height.equalTo(@(shopNavHeight));
    }];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.customNavBar.mas_bottom).with.offset(-15);
        make.width.equalTo(@(ScreenW));
        make.height.equalTo(@44);
    }];

    [_headerView layoutIfNeeded];
    [_headerView yd_setCornerRadius:12.f corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    [_headerView yd_setShadowColor:kColorCCC opacity:1 radius:2 width:1 side:YDShadowSideBottom];
    //特价商品
    JHShopGoodsController *goodsVC = [[JHShopGoodsController alloc] init];
    goodsVC.sortType = 0;   ///1 特价商品  2 询价商品  暂时没用 暂时传0
    goodsVC.sellerId = self.sellerId;
    [self addChildViewController:goodsVC];
    [self.view addSubview:goodsVC.view];
    @weakify(self);
    goodsVC.offsetBlock = ^(CGFloat offsetY) {
        @strongify(self);
        [self changeLayouts:offsetY];
    };
    
    [goodsVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(2);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-UI.bottomSafeAreaHeight);
    }];
}

#pragma mark - load data
///获取店铺信息
- (void)loadSellerInfo {
    NSString *url = [NSString stringWithFormat: COMMUNITY_FILE_BASE_STRING(@"/v1/shop/bus_center?seller_id=%ld"), (long)self.sellerId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self resolveSellerInfo:respondObject.data];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [UITipView showTipStr:respondObject.message];
    }];
}

- (void)resolveSellerInfo:(id)data {
    self.sellerInfo = [JHSellerInfo mj_objectWithKeyValues:data[@"seller_info"]];
    self.shareInfo = [JHShareInfo mj_objectWithKeyValues:data[@"share_info"]];
    self.customNavBar.sellerInfo = self.sellerInfo;
    self.headerView.sellerInfo = self.sellerInfo;
    self.customNavBar.isFollow = [self.sellerInfo.follow_status boolValue];
}

///关注店铺/取消关注店铺
- (void)attentionShop:(BOOL)isFollow {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    [JHTracking trackEvent:@"storeOperate" property:@{@"operation_type":(isFollow ? @"取消关注" : @"关注")}];
    
    [SVProgressHUD show];
    ///isFollow == yes  关注状态为已关注 需要调用取消关注的接口
    ///isFollow == no  关注状态为未关注 需要调用关注的接口
    NSString *str = isFollow ? @"unfollow_bus" : @"follow_bus";
    NSString *url = [NSString stringWithFormat: COMMUNITY_FILE_BASE_STRING(@"/v1/shop/%@"), str];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(self.sellerId) forKey:@"seller_id"];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSString *message = isFollow ? cancelAttentionFailure : attentionFailure;
        self.customNavBar.isFollow = !self.customNavBar.isFollow;
        message = isFollow ? cancelAttentionSuccess : attentionSuccess;
        NSInteger fansNum = isFollow ? [self.sellerInfo.fans_num integerValue]-1 : [self.sellerInfo.fans_num integerValue]+1;
        self.sellerInfo.fans_num = [NSString stringWithFormat:@"%ld", (long)fansNum];
        self.sellerInfo.follow_status = @(!isFollow);
        [self.customNavBar setSellerInfo:self.sellerInfo];
        [UITipView showTipStr:message];
        /// 关注状态
        if(self.focusBlock)
        {
            self.focusBlock(!isFollow);
        }
        ///刷新店铺列表数据
        [JHNotificationCenter postNotificationName:ShopRefreshDataNotication object:self.sellerInfo];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [UITipView showTipStr:respondObject.message];
    }];
}

#pragma mark - action
///返回
- (void)leftButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 分享店铺
- (void)rightButtonAction {
    NSLog(@"分享");
    JHShareInfo *shareInfo = self.shareInfo;
    if (!shareInfo) {
        return;
    }

    [JHTracking trackEvent:@"storeOperate" property:@{@"operation_type":@"微信"}];
    NSString *objectStr = self.sellerInfo.seller_id.stringValue;
    JHShareInfo* info = self.shareInfo;
    info.shareType = ShareObjectTypeStoreShop;
//    [[UMengManager shareInstance] showCustomShareTitle:titleStr
//                                                     text:descStr
//                                                 thumbUrl:imgStr
//                                                   webURL:urlStr
//                                                     type:ShareObjectTypeStoreShop
//                                                   object:objectStr
//                                               isShowMore:NO
//                                                     isMe:NO];
    [JHBaseOperationView showShareView:info objectFlag:objectStr]; //TODO:Umeng share
}

#if 0
#pragma mark -
#pragma mark ---  Tabbar and PageViewController
- (void)addTabPageBar {
    TYTabPagerBar *tabBar = [[TYTabPagerBar alloc]init];
    tabBar.backgroundColor = [UIColor whiteColor];
    tabBar.delegate = self;
    tabBar.dataSource = self;
    tabBar.layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 5);
    tabBar.layout.barStyle = TYPagerBarStyleProgressElasticView;
    tabBar.layout.adjustContentCellsCenter = YES;
    tabBar.layout.progressHeight = 2;
    tabBar.layout.progressVerEdging = 6;
    tabBar.layout.progressColor = HEXCOLOR(0xFEE100);
    tabBar.layout.normalTextColor = HEXCOLOR(0x999999);
    tabBar.layout.selectedTextColor = HEXCOLOR(0x333333);
    tabBar.layout.normalTextFont = [UIFont fontWithName:kFontNormal size:15.0];
    tabBar.layout.selectedTextFont = [UIFont fontWithName:kFontMedium size:15.0];
    tabBar.layout.cellSpacing = 40;
    tabBar.layout.cellEdging = 0;
    [tabBar registerClass:[TYTabPagerBarCell class] forCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier]];
    _tabBar = tabBar;
    
    [self.view addSubview:_tabBar];
    
    _tabBar.sd_layout
    .topSpaceToView(self.headerView, 0)
    .leftEqualToView(self.view)
    .widthIs(self.view.width)
    .heightIs(44.0);
    
    [_tabBar updateLayout];
    [_tabBar yd_setShadowColor:kColorCCC opacity:1 radius:2 width:1 side:YDShadowSideBottom];
}

- (void)addPagerController {
    TYPagerController *pagerController = [[TYPagerController alloc]init];
    pagerController.layout.prefetchItemCount = 0;
    //pagerController.layout.autoMemoryCache = NO;
    // 只有当scroll滚动动画停止时才加载pagerview，用于优化滚动时性能
    pagerController.layout.addVisibleItemOnlyWhenScrollAnimatedEnd = YES;
    pagerController.dataSource = self;
    pagerController.delegate = self;
    [self addChildViewController:pagerController];
    [self.view addSubview:pagerController.view];
    _pagerController = pagerController;
    
    _pagerController.view.sd_layout
    .topSpaceToView(_tabBar, 2)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .bottomSpaceToView(self.view, UI.bottomSafeAreaHeight);
}

- (void)reloadData {
    [_tabBar reloadData];
    [_pagerController reloadData];
    [_pagerController scrollToControllerAtIndex:0 animate:NO];
}

- (NSInteger)numberOfItemsInPagerTabBar {
    return _headerPages.count;
}

- (UICollectionViewCell<TYTabPagerBarCellProtocol> *)pagerTabBar:(TYTabPagerBar *)pagerTabBar cellForItemAtIndex:(NSInteger)index {
    UICollectionViewCell<TYTabPagerBarCellProtocol> *cell = [pagerTabBar dequeueReusableCellWithReuseIdentifier:[TYTabPagerBarCell cellIdentifier] forIndex:index];
    cell.titleLabel.text = _headerPages[index];
    return cell;
}

#pragma mark - TYTabPagerBarDelegate
- (CGFloat)pagerTabBar:(TYTabPagerBar *)pagerTabBar widthForItemAtIndex:(NSInteger)index {
    NSString *title = _headerPages[index];
    return [pagerTabBar cellWidthForTitle:title];
}

- (void)pagerTabBar:(TYTabPagerBar *)pagerTabBar didSelectItemAtIndex:(NSInteger)index {
    [_pagerController scrollToControllerAtIndex:index animate:YES];
}

#pragma mark - TYPagerControllerDataSource
- (NSInteger)numberOfControllersInPagerController {
    return _headerPages.count;
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index prefetching:(BOOL)prefetching {
    JH_WEAK(self)
    if (index == 1) {
        JHShopHomeConsultViewController * consultVC = [[JHShopHomeConsultViewController alloc] init];
        consultVC.sellerId = self.sellerId;
        consultVC.offsetBlock = ^(CGFloat offsetY) {
            JH_STRONG(self)
            [self changeLayouts:offsetY];
        };
        return consultVC;
    }
    //特价商品
    JHShopGoodsController *goodsVC = [[JHShopGoodsController alloc] init];
    goodsVC.sortType = 0;   ///1 特价商品  2 询价商品  暂时没用 暂时传0
    goodsVC.sellerId = self.sellerId;
    goodsVC.offsetBlock = ^(CGFloat offsetY) {
        [weakSelf changeLayouts:offsetY];
    };
    return goodsVC;
}

#endif

///移动navigation的方法
- (void)changeLayouts:(CGFloat)offsetY {
   ///处理联动
    if (offsetY <= UI.statusBarHeight) {
        [self.view insertSubview:self.customNavBar belowSubview:self.headerView];
        CGFloat currentHeight = offsetY > 0 ? (shopNavHeight - offsetY) : shopNavHeight;
        [self.customNavBar changeBarHeight:currentHeight];
        [self.headerView changeHeaderViewTop:-15 depency:self.customNavBar];
        [self.customNavBar showOriginView];
    }
    else {
        [self.customNavBar changeBarHeight:UI.statusAndNavBarHeight];
        [self.headerView changeHeaderViewTop:0 depency:self.customNavBar];
        [self.view insertSubview:self.headerView belowSubview:self.customNavBar];
        [self.customNavBar showDragUpView];
    }
    if (offsetY > UI.statusBarHeight) {
        //上移header
        CGFloat offY = UI.statusAndNavBarHeight-offsetY;
        CGFloat maxH = UI.statusAndNavBarHeight + self.headerView.height;
        if (offY < 0) {
            CGFloat hh = offsetY < maxH ? offY : (-44);
            [self.headerView changeHeaderViewTop:hh depency:self.customNavBar];
        }
    }
}

#if 0
#pragma mark - TYPagerControllerDelegate
- (void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex animated:(BOOL)animated {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex animate:animated];
}

-(void)pagerController:(TYPagerController *)pagerController transitionFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [_tabBar scrollToItemFromIndex:fromIndex toIndex:toIndex progress:progress];
}

- (void)pagerControllerDidScroll:(TYPagerController *)pagerController {
    if (pagerController.scrollView.contentOffset.x < -100) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#endif

- (void)dealloc {
    NSString *currentShareTime = [NSString getCurrentTime];
    NSString *shareDurationTime = [NSString getTimeWithBeginTime:self.startPageTime endTime:currentShareTime];
    CGFloat eventTime = [shareDurationTime integerValue]/1000.0;
    [JHTracking trackEvent:@"storePageView" property:@{@"view_duration":@(eventTime),@"store_id":[NSString stringWithFormat:@"%ld",self.sellerId],@"store_name":self.sellerInfo.name}];
    NSLog(@"%@*************被释放",[self class])
}

@end
