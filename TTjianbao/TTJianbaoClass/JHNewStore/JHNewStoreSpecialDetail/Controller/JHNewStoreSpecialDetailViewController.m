//
//  JHNewStoreSpecialDetailViewController.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  专题详情

#import "JHNewStoreSpecialDetailViewController.h"
#import "JHNewStoreSpecialHeaderView.h"
#import <JXPagingView/JXPagerView.h>
#import <JXCategoryView.h>
#import "JHBaseOperationView.h"
#import "JHNewShopSortMenuView.h"
#import "JXCategoryTitleBackgroundView.h"
#import "JHNewStoreSpecialBussinew.h"
#import "JHNewStoreSpecialModel.h"
#import "JHNewStoreSpecialShowUser.h"
#import "NSString+UISize.h"
#import "JHNewStoreSpecialListViewController.h"
#import "JHMarketFloatLowerLeftView.h"

#import "JHNewStoreCountDownTimeView.h"
#import "YDCountDown.h"
#import "JHLabelHeight.h"
#define categoryViewHeight  45.0
#define categoryBackViewHeight 85.0

@interface JHNewStoreSpecialDetailViewController ()<JXPagerViewDelegate, JXCategoryViewDelegate, JXPagerMainTableViewGestureDelegate, JHNewShopSortMenuViewDelegate,JHNewStoreSpecialHeaderViewDelegate>
@property (nonatomic, strong) JHNewStoreSpecialHeaderView *headerView;
@property (nonatomic, strong) JXPagerView *pagingView;
@property (nonatomic, strong) JXCategoryTitleBackgroundView *categoryView;
@property (nonatomic, strong) NSMutableArray <JHNewStoreSpecialListViewController *> *vcArray;
@property (nonatomic, strong) UIView * categoryBackView;
@property (nonatomic, strong) UIButton * startRemindBtn;
///记录导航栏的透明度
@property (nonatomic, assign) CGFloat alphaValue;
//排序选择
@property (nonatomic, strong) JHNewShopSortMenuView *sortMenuView;

@property (nonatomic, strong) JHMarketFloatLowerLeftView *floatView;//收藏返回顶部view
@property (nonatomic, assign) NSInteger tabIndex;

@property (nonatomic, strong) JHNewStoreSpecialModel *specialModel;

@property (nonatomic, assign) CGFloat headerViewHeight;

@property (nonatomic,strong) dispatch_source_t timer;

@property (nonatomic, assign)JHNewShopSortType sortType;

@property (nonatomic, strong) JHNewStoreCountDownTimeView *countDownView;
@property (nonatomic, strong) YDCountDown *countDown;

@property (nonatomic, assign) BOOL isRequestUpdate;
@property (nonatomic, assign) BOOL isRequesting;
@end

@implementation JHNewStoreSpecialDetailViewController

- (void)dealloc{
    //取消计时器
    dispatch_source_cancel(_timer);
    [_countDown destoryTimer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.jhStatusBarStyle = UIStatusBarStyleLightContent;
    //收藏等数据刷新
    [self.floatView loadData];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.jhStatusBarStyle = UIStatusBarStyleDefault;
}



- (void)viewDidLoad {
    [super viewDidLoad];
//    self.showId = @"1";
    if (!_countDown) {
        _countDown = [[YDCountDown alloc] init];
    }
    self.headerViewHeight = UI.topSafeAreaHeight + 297;
    self.tabIndex = 0;
    [self creatTimer];
    [self setupNavBarView];
    [self changeNavStatusHidden:YES];
    //右下角浮窗按钮
    [self.view addSubview:self.floatView];
    
    [self requestData:YES];
}

#pragma mark - UI
- (void)setupNavBarView{
    [self.jhLeftButton setImage:JHImageNamed(@"navi_icon_back_white") forState:UIControlStateSelected];
    
    [self initRightButtonWithImageName:@"newStore_share_black_icon" action:@selector(clickShareActionButton:)];
    [self.jhRightButton setImage:JHImageNamed(@"newStore_share_white_icon") forState:UIControlStateSelected];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.jhNavView).offset(UI.statusBarHeight/2);
        make.right.equalTo(self.jhNavView).offset(-15);
    }];
    
    self.jhNavView.backgroundColor = UIColor.clearColor;
    JHNewStoreCountDownConfig *config = [[JHNewStoreCountDownConfig alloc] init];
    config.titleColor = [UIColor whiteColor];
    config.ddColor = [UIColor whiteColor];
    config.spColor = [UIColor whiteColor];
    _countDownView = [JHNewStoreCountDownTimeView newcountDownWithConfig:config endBlock:^{
    }];
    [self.jhTitleLabel addSubview:_countDownView];
    [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _countDownView.hidden = YES;
}

#pragma mark - Action

- (void)clickShareActionButton:(UIButton *)sender{
    JHShareInfo* info = self.specialModel.shareInfoBean;
    info.shareType = ShareObjectTypeStoreGoodsDetail;
    [JHBaseOperationView showShareView:info objectFlag:nil];
    [JHAllStatistics jh_allStatisticsWithEventId:@"shareClick" params:@{@"store_from":[self specialStatusName],@"zc_id":self.showId,@"zc_name":self.specialModel.title} type:JHStatisticsTypeSensors];
}

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return self.headerViewHeight;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {

    return categoryBackViewHeight;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryBackView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.specialModel.showTabs.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    
    
    if(index < self.vcArray.count)
    {
        JHNewStoreSpecialListViewController *vc = self.vcArray[index];
//        [vc refreshDataBlock:nil];
        return vc;
    }
    
    JHNewStoreSpecialListViewController * vc = [JHNewStoreSpecialListViewController new];
    vc.showId = self.showId;
    return vc;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat thresholdDistance = self.headerViewHeight - UI.statusAndNavBarHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    _alphaValue = offsetY / thresholdDistance;
    _alphaValue = MAX(0, MIN(1, _alphaValue));
    [self changeNavStatusHidden:_alphaValue < 0.6];
    self.jhStatusBarStyle = (_alphaValue < 0.6 ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
    [UIView animateWithDuration:0.25 animations:^{
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:_alphaValue];
    }];
    if(offsetY < 0){
        [self.headerView updateImageHeight:fabs(offsetY)];
    }
 
    //下拉刷新
    if(offsetY < -50){
        self.isRequestUpdate = YES;
    }
    if(offsetY == 0 && self.isRequestUpdate && !self.isRequesting){
        self.isRequestUpdate = NO;
        [self refreshData];
    }
    
    BOOL goTopHidden = offsetY <= 100;
    self.floatView.topButton.hidden = goTopHidden;

}

//防止手势冲突
- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"UICollectionView")]) {
        UICollectionView *collectionView = (UICollectionView*)otherGestureRecognizer.delegate;
        if([collectionView.dataSource isKindOfClass:NSClassFromString(@"JHNewStoreSpecialListViewController")]){
            return YES;
        }
    }
    return NO;
    
}
#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.tabIndex = index;
    JHNewStoreSpecialListViewController *vc = SAFE_OBJECTATINDEX(self.vcArray, self.tabIndex);
    [vc loadFirstData:(int)self.sortType];
    if (self.specialModel) {
        JHNewStoreSpecialShowTabModel *tem = self.specialModel.showTabs[index];
        [JHAllStatistics jh_allStatisticsWithEventId:@"sxbqClick" params:@{@"store_from":[self specialStatusName],@"zc_name":self.specialModel.title,@"zc_id":self.showId,@"tab_name":tem.title} type:JHStatisticsTypeSensors];
    }
    
}

#pragma mark - method
///处理navBar上按钮图标随着互动显示的颜色
-(void)changeNavStatusHidden:(BOOL)isHidden{
    self.jhLeftButton.selected = isHidden;
    self.jhRightButton.selected = isHidden;
    self.jhTitleLabel.textColor = isHidden ? UIColor.clearColor : UIColor.blackColor;
    
    if (isHidden) {
        [_countDownView setTitleColor:UIColor.whiteColor andTimeColor:UIColor.whiteColor andBgColor:HEXCOLOR(0xF23730)];
        
    }else{
        [_countDownView setTitleColor:HEXCOLOR(0x222222) andTimeColor:UIColor.whiteColor andBgColor:HEXCOLOR(0x222222)];
    }
}
#pragma mark - Lazy

- (JHNewStoreSpecialHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[JHNewStoreSpecialHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, self.headerViewHeight)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIView *)categoryBackView{
    if (!_categoryBackView) {
        _categoryBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, categoryBackViewHeight)];
        JHNewShopMenuMode *recMode = [[JHNewShopMenuMode alloc] init];
        recMode.title = @"综合排序";
        recMode.isShowImg = NO;
        JHNewShopMenuMode *priceMode = [[JHNewShopMenuMode alloc] init];
        priceMode.title = @"价格排序";
        priceMode.isShowImg = YES;
        NSArray *menuArray = @[recMode, priceMode];
        _sortMenuView = [[JHNewShopSortMenuView alloc] initWithFrame:CGRectZero menuArray:menuArray titleFont:14.0];
        _sortMenuView.delegate = self;
        _sortMenuView.selectIndex = 0;
        [_categoryBackView addSubview:_sortMenuView];
        [_sortMenuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(5);
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(_categoryBackView.mas_right);
            make.height.mas_offset(35);
        }];
        
        [_categoryBackView addSubview:self.categoryView];
    }
    return _categoryBackView;
}
#pragma mark - JHNewShopSortMenuViewDelegate
- (void)menuViewDidSelect:(JHNewShopSortType)sortType {
    self.sortType = sortType;
//    0 综合排序，1 价格升序，2 价格降序
    JHNewStoreSpecialListViewController *vc = SAFE_OBJECTATINDEX(self.vcArray, self.tabIndex);
    [vc loadFirstData:(int)sortType];
}
- (JXCategoryTitleBackgroundView *)categoryView{
    if (!_categoryView) {
        _categoryView = [[JXCategoryTitleBackgroundView alloc] initWithFrame:CGRectMake(0, 35, [UIScreen mainScreen].bounds.size.width, categoryViewHeight)];
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.titleFont = [UIFont fontWithName:kFontNormal size:12];
        _categoryView.cellSpacing = 10;
        _categoryView.cellWidthIncrement = 24;
        _categoryView.titleColor = kColor222;
        _categoryView.titleSelectedFont = [UIFont fontWithName:kFontNormal size:12];
        _categoryView.titleSelectedColor = kColor222;
        _categoryView.contentEdgeInsetLeft = 12;
        _categoryView.contentEdgeInsetRight = 12;
        _categoryView.backgroundCornerRadius = 14;
        _categoryView.backgroundHeight = 28;
        _categoryView.averageCellSpacingEnabled = NO;
        
    }
    _categoryView.delegate = self;
    
    return _categoryView;
}

- (JXPagerView *)pagingView
{
    if(!_pagingView)
    {
        _pagingView = [[JXPagerView alloc] initWithDelegate:self];
        _pagingView.backgroundColor = UIColor.whiteColor;
        _pagingView.mainTableView.backgroundColor = UIColor.whiteColor;
        _pagingView.pinSectionHeaderVerticalOffset = UI.statusAndNavBarHeight;
        _pagingView.mainTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_pagingView];
        _pagingView.listContainerView.categoryNestPagingEnabled = YES;
        _pagingView.mainTableView.gestureDelegate = self;
        _pagingView.frame = self.view.bounds;
        [self jhBringSubviewToFront];
    }
    return _pagingView;
}
- (NSMutableArray<JHNewStoreSpecialListViewController *> *)vcArray
{
    if(!_vcArray)
    {
        _vcArray = [NSMutableArray arrayWithCapacity:3];
        for (JHNewStoreSpecialShowTabModel *m in self.specialModel.showTabs) {
            JHNewStoreSpecialListViewController *listvc = [JHNewStoreSpecialListViewController new];
            listvc.showId = self.showId;
            listvc.showName = self.specialModel.title;
            listvc.store_from = [self specialStatusName];
            listvc.specialTabId = m.specialTabId;
            listvc.specialTabName = m.title;
            [_vcArray addObject:listvc];
        }
    }
    return _vcArray;
}
- (JHMarketFloatLowerLeftView *)floatView{
    if (!_floatView) {
        _floatView = [[JHMarketFloatLowerLeftView alloc] initWithShowType:JHMarketFloatShowTypeBackTop];
        _floatView.isHaveTabBar = NO;
        @weakify(self)
        //收藏
        _floatView.collectGoodsBlock = ^{
            @strongify(self)
            [JHAllStatistics jh_allStatisticsWithEventId:@"scClick" params:@{@"store_from":[self specialStatusName],@"zc_name":self.specialModel.title,@"zc_id":self.showId} type:JHStatisticsTypeSensors];
        };
        //返回顶部
        _floatView.backTopViewBlock = ^{
            @strongify(self)
            JHNewStoreSpecialListViewController *vc = self.vcArray[self.tabIndex];
            [vc.collectionView setContentOffset:CGPointMake(0, 0)];
            [self.pagingView.mainTableView setContentOffset:CGPointMake(0, 0)];
            [JHAllStatistics jh_allStatisticsWithEventId:@"backTopClick" params:@{@"store_from":[self specialStatusName]} type:JHStatisticsTypeSensors];

        };
    }
    return _floatView;
}

- (UIButton *)startRemindBtn{
    if (!_startRemindBtn) {
        _startRemindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _startRemindBtn.layer.cornerRadius = 4;
        _startRemindBtn.titleLabel.font = JHMediumFont(16);
        [_startRemindBtn setImage:[UIImage imageNamed:@"startRemindBtnIcon_Normal"] forState:UIControlStateNormal];
        [_startRemindBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [_startRemindBtn addTarget:self action:@selector(startRemindBtnClickAction) forControlEvents:UIControlEventTouchUpInside];
        [_startRemindBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
    }
    return _startRemindBtn;
}
- (void)creatTimer{
    /** 获取一个全局的线程来运行计时器*/
    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    /** 创建一个计时器*/
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue2);
    /** 设置计时器, 这里是每5秒执行一次*/
    dispatch_source_set_timer(_timer, dispatch_walltime(nil, 0), 5*1000*NSEC_PER_MSEC, 0);
    /** 设置计时器的里操作事件*/
    @weakify(self);
    dispatch_source_set_event_handler(_timer, ^{
        @strongify(self);
        [self requestPvUserData];
    });
    dispatch_resume(_timer);
}

- (void)startRemindBtnClickAction{
    if (![JHRootController isLogin]) {
        @weakify(self);
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
            @strongify(self);
            [self requestData:NO];
        }];
        
    }else {
        if (self.specialModel.subscribeStatus == 1){
            return;
        }
        long showid = [self.showId longValue];
        NSInteger customerId = [[UserInfoRequestManager sharedInstance].user.customerId integerValue];
        NSDictionary * params = @{@"showId":@(showid),@"userId":@(customerId)};
        @weakify(self);
        [JHNewStoreSpecialBussinew requestSalesReminderWithParams:params successBlock:^(RequestModel * _Nullable respondObject) {
            @strongify(self);
            if (self.startRemindBtnBlock) {
                self.startRemindBtnBlock(YES);
            }
            [self.startRemindBtn setTitle:@"已设置提醒" forState:UIControlStateNormal];
            [self.startRemindBtn setImage:[UIImage imageNamed:@"startRemindBtnIcon_Select"] forState:UIControlStateNormal];
            [_startRemindBtn setTitleColor:HEXCOLOR(0x7A7353) forState:UIControlStateNormal];
            [self.startRemindBtn setBackgroundColor:HEXCOLOR(0xFFEF9F)];
            if (self.specialModel.showType == 2) {
                [self.view makeToast:@"开拍提醒设置成功~" duration:1.0 position:CSToastPositionCenter];
            }else{
                [self.view makeToast:@"设置提醒成功" duration:1.0 position:CSToastPositionCenter];
            }
            
            self.specialModel.subscribeStatus = 1;
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }];
        
    
        NSDictionary *par = @{
            @"zc_id" : self.showId,
            @"zc_name" : self.specialModel.title,
            @"tx_type" : @"预告专场",
            @"store_from" : @"专场",
            @"commodity_id":@""
        };
        [JHAllStatistics jh_allStatisticsWithEventId:@"kstxClick"
                                              params:par
                                                type:JHStatisticsTypeSensors];
    }
    
}
- (void)requestPvUserData{
    @weakify(self);
    [JHNewStoreSpecialBussinew requestSpecialUserList:self.showId successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        JHNewStoreSpecialShowUser *userModel = [JHNewStoreSpecialShowUser mj_objectWithKeyValues:respondObject.data];
        [self.headerView resetHeaderViewWithUserModel:userModel];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
#pragma make JHNewStoreSpecialHeaderViewDelegate
- (void)descExpandOrPackUp:(CGFloat)maxHeight{
    [self resetheaderViewHeight:maxHeight];
}

//设置header高度
- (void)resetheaderViewHeight:(CGFloat)maxHeight{
    self.headerViewHeight =  UI.topSafeAreaHeight + 297;
    if (self.specialModel.showDesc.length == 0) {
        return;
    }
    self.headerViewHeight = self.headerViewHeight + maxHeight + 5;
    [self.pagingView resizeTableHeaderViewHeightWithAnimatable:NO duration:0 curve:UIViewAnimationCurveLinear];
}
- (void)refreshData{
    NSLog(@"---------------");
    self.tabIndex = 0;
    [self.sortMenuView setSelectIndex:0];
    [self.categoryView selectItemAtIndex:0];
    [self.headerView resetSpecialDescLabelNumLine];
    [self.vcArray removeAllObjects];
    self.vcArray = nil;
    [self requestData:NO];
}
- (void)requestData:(BOOL)isFirst{
    self.isRequesting = YES;
    @weakify(self);
    [JHNewStoreSpecialBussinew getStoreSpecialInfoWithSpecialId:self.showId successBlock:^(RequestModel * _Nullable respondObject) {
        @strongify(self);
        self.isRequesting = NO;
        NSDictionary *dic = respondObject.data;
        if (dic == nil) { return; }
        self.specialModel = [JHNewStoreSpecialModel mj_objectWithKeyValues:dic];
        
        if (self.specialModel && self.specialModel.showTabs) {
            JHNewStoreSpecialShowTabModel *temp = [[JHNewStoreSpecialShowTabModel alloc] init];
            temp.title = @"全部";
            temp.specialTabId = -1;
            [self.specialModel.showTabs insertObject:temp atIndex:0];
        }
        if (isFirst) {
            [self sa_enterDisplayStatistics];
        }
        [self resetViewWithModel];
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            self.isRequesting = NO;
//            [self resetViewWithModel];
    }];
}

- (void)resetViewWithModel{
    
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    NSMutableArray * tabarray = [[NSMutableArray alloc] init];
    for (JHNewStoreSpecialShowTabModel * tab in self.specialModel.showTabs) {
        [tabarray addObject:tab.title];
    }
    _categoryView.titles = tabarray;
    [self.pagingView reloadData];
    [self.categoryView reloadData];
    
    [self.headerView resetHeaderViewWithModel:self.specialModel];
    
    JHLabelHeight * label = [JHLabelHeight new];
    [label setTextToLabel:self.specialModel.showDesc];
//    CGSize size = [NSString getSpaceLabelHeight:self.specialModel.showDesc font:JHFont(13) maxSize:CGSizeMake(kScreenWidth - 24, 67) withlineSpacing:6];
//    [self resetheaderViewHeight:size.height+4];
    [self resetheaderViewHeight:[label getLabelHeight]];
    if(self.specialModel.showStatus == 1){
        self.countDownView.hidden = NO;
        _startRemindBtn.hidden = YES;
        self.title = @"";
        @weakify(self);
        [_countDown startWithbeginTimeStamp:(self.specialModel.saleEndTime/1000 - self.specialModel.remainTime/1000)
                            finishTimeStamp:(self.specialModel.saleEndTime+1000)/1000
                              completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second)
        {
            @strongify(self);
            [self.countDownView setDD:day hh:hour mm:minute ss:second];
            if (day == 0 && hour==0 && minute == 0 && second == 0) {
//                [self.countDownView showEndStyle];
                [self refreshData];
                ///停止定时器
                [self.countDown destoryTimer];
                
            }
        }];
    }else if(self.specialModel.showStatus == 0){
        self.countDownView.hidden = YES;
        [self.view addSubview:self.startRemindBtn];
        [self.startRemindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(self.view.mas_bottom).offset(-(UI.bottomSafeAreaHeight+30));
            make.size.mas_equalTo(CGSizeMake(202, 40));
        }];
        if (self.specialModel.subscribeStatus == 1) {
            [self.startRemindBtn setTitle:@"已设置提醒" forState:UIControlStateNormal];
            [self.startRemindBtn setImage:[UIImage imageNamed:@"startRemindBtnIcon_Select"] forState:UIControlStateNormal];
            [_startRemindBtn setTitleColor:HEXCOLOR(0x7A7353) forState:UIControlStateNormal];
            [self.startRemindBtn setBackgroundColor:HEXCOLOR(0xFFEF9F)];
        }else{
            [self.startRemindBtn setTitle:@"开售提醒" forState:UIControlStateNormal];
            [self.startRemindBtn setImage:[UIImage imageNamed:@"startRemindBtnIcon_Normal"] forState:UIControlStateNormal];
            [_startRemindBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
            [self.startRemindBtn setBackgroundColor:HEXCOLOR(0xFFD70F)];
        }
        self.title = self.specialModel.title;
    }
    else{
        self.countDownView.hidden = YES;
        _startRemindBtn.hidden = YES;
        self.title = self.specialModel.title;
    }
    
    [self.view bringSubviewToFront:self.floatView];

    
}

- (NSString *)specialStatusName{
    //0 预告、1 热卖、2 结束、-1 未知
    if (self.specialModel.showStatus == 0){
        return @"预告专场";
    }else if(self.specialModel.showStatus == 1){
        return @"热卖专场";
    }else if(self.specialModel.showStatus == 2){
        return @"结束专场";
    }else{
        return @"未知专场";
    }
}
- (NSString *)specialStatus{
    //0 预告、1 热卖、2 结束、-1 未知
    if (self.specialModel.showStatus == 0){
        return @"预告";
    }else if(self.specialModel.showStatus == 1){
        return @"热卖";
    }else if(self.specialModel.showStatus == 2){
        return @"已结束";
    }else{
        return @"未知";
    }
}
- (void)sa_enterDisplayStatistics{
    NSString *strStr = [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%ld",self.specialModel.saleStartTime]];
    NSString *strEnd = [self timeWithTimeIntervalString:[NSString stringWithFormat:@"%ld",self.specialModel.saleEndTime]];
    NSString *str = [NSString stringWithFormat:@"%@_%@",strStr, strEnd];
    [JHNewStoreSpecialBussinew sa_enterSpecialDetailWithName:self.specialModel.title zc_type:[self specialStatus] zc_id:self.showId store_from:self.fromPage zc_time:str show_type:[NSString stringWithFormat:@"%ld",(long)self.specialModel.showType]];
}

- (NSString *)timeWithTimeIntervalString:(NSString *)timeString {
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end
