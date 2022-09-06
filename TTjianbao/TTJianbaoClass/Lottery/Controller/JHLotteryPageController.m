//
//  JHLotteryPageController.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryPageController.h"
#import "JHLotteryCategoryView.h"
#import "JHLotteryListController.h"
#import "JHLotteryDataManager.h"
#import "JHLotteryRecordViewController.h"
#import "JHLotterAddAddressAlert.h"
#import "AdressManagerViewController.h"
#import "GrowingManager+Lottery.h"

@interface JHLotteryPageController ()

@property (nonatomic, strong) JHLotteryModel *curModel;
@property (nonatomic, strong) JHLotteryCategoryView *myCategoryView;

//为了下拉刷新
@property (nonatomic, strong) JHLotteryListController *curListVC;

//缓存页面-为了调用各标签页的分享成功请求
@property (nonatomic, strong) NSMutableDictionary <NSString *, id<JXCategoryListContentViewDelegate>> *listCache;

@end

@implementation JHLotteryPageController

- (void)dealloc {
    NSLog(@"JHLotteryPageController::dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    
    _curModel = [[JHLotteryModel alloc] init];
    _curModel.lotteryType = JHLotteryTypeCurrent;
    
    _listCache = [NSMutableDictionary dictionary];
    
    [self configNaviBar];
    
    [self configCategoryView];
    
    [self.view beginLoading];
    [self sendRequest];
    
    [self addObserver];
}

- (void)rightBtnClicked {
    NSLog(@"进入往期页面");
    JHLotteryRecordViewController *vc = [[JHLotteryRecordViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
    //埋点-进入往期记录
    [GrowingManager lotteryEnterPageName:NSStringFromClass([JHLotteryRecordViewController class]) from:JHFromLotteryHome];
}

- (void)addObserver {
    @weakify(self);
    //登录成功
    [[[JHNotificationCenter rac_addObserverForName:kAllLoginSuccessNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notification) {
        @strongify(self);
        [self sendRequest];
    }];

    //退出登录
    [[[JHNotificationCenter rac_addObserverForName:LOGOUTSUSSNotifaction object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notification) {
        @strongify(self);
        [self sendRequest];
    }];

    //分享成功
    [[[JHNotificationCenter rac_addObserverForName:kShareSuccessNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification * _Nullable notification) {
        @strongify(self);
        [self sendShareCompleteRequest];
    }];
}

- (void)sendShareCompleteRequest {
    JHLotteryActivityData *data = self.curModel.list[_myCategoryView.selectedIndex].activityList.firstObject;
    JHLotteryListController *curListVC = (JHLotteryListController *)self.listCache[data.activityCode];
    if (curListVC) {
        [curListVC sendShareCompleteRequest];
    }
}

#pragma mark -
#pragma mark - UI Methods

- (void)configNaviBar {
    [self showNaviBar];
    self.naviBar.backgroundColor = [UIColor whiteColor];
    self.naviBar.title = @"0元抽奖";
    self.naviBar.rightTitle = @"往期";
    self.naviBar.bottomLine.hidden = NO;
}

#pragma mark - TitleBar

- (void)configCategoryView {
    _myCategoryView = (JHLotteryCategoryView *)self.categoryView;
    _myCategoryView.backgroundColor = [UIColor whiteColor];
    _myCategoryView.averageCellSpacingEnabled = NO; //是否按屏幕宽度居中显示每个cell
    _myCategoryView.cellSpacing = 15;
    _myCategoryView.sd_resetLayout
    .topSpaceToView(self.view, UI.statusAndNavBarHeight)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs([self preferredCategoryViewHeight]);
}
- (CGFloat)preferredCategoryViewHeight {
    return [JHLotteryCategoryCell cellSize].height + 20;
}
- (JHLotteryCategoryView *)preferredCategoryView {
    return [[JHLotteryCategoryView alloc] init];
}

#pragma mark -
#pragma mark - 网络请求
- (void)sendRequest {
    if (_curModel.isLoading) {
        return;
    }
    @weakify(self);
    [JHLotteryDataManager getLotteryList:_curModel block:^(JHLotteryModel *  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self.view endLoading];
        if(self.curModel.list)
        {
            [self.curModel.list removeAllObjects];
        }
        //为了下拉刷新
        if (self.curListVC) {
            [self.curListVC endRefresh];
        }
        if(self.curModel.list)
        {
            [self.curModel.list removeAllObjects];
        }
        if (respObj) {
            [self.curModel configModel:respObj];
            
            self.myCategoryView.dataList = self.curModel.list;
            self.myCategoryView.defaultSelectedIndex = 0;
            
            if (self.curListVC) {
                //为了下拉刷新
                [self.myCategoryView performSelector:@selector(reloadData) afterDelay:0.25];
            } else {
                [self.myCategoryView reloadData];
            }
            
            [self showAddressDialog];
            
            //埋点-tab切换
            [GrowingManager lotterySwitchTab:[self gioBasicParams]];
        }
        
        self.myCategoryView.backgroundColor = (self.curModel.list.count == 0 || hasError) ? kColorF5F6FA : [UIColor whiteColor];
        
        [self.view configBlankType:YDBlankTypeNone hasData:_curModel.list.count > 0 hasError:hasError offsetY:0 reloadBlock:^(id sender) {
        }];
    }];
}

- (void)showAddressDialog {
    JHLotteryDialog *dialog = _curModel.dialog;
    if (!dialog) {
        return;
    }
    @weakify(self);
    [JHLotterAddAddressAlert showLotterAddAddressAlertWithImageUrl:dialog.img
                                                             title:dialog.title
                                                          btnTitle:dialog.buttonTxt
                                                             price:dialog.prizePrice
                                                         prizeName:dialog.prizeName
                                                   blockClickBlock:^{
        @strongify(self);
        JHLotteryListController *vc = [JHLotteryListController new];
        vc.codeStr = dialog.activityCode;
        vc.isHistory = YES;
        vc.needAddAddress = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
        //埋点-进入0元抽详情页
        [GrowingManager lotteryEnterPageName:NSStringFromClass([JHLotteryListController class]) from:JHFromLotteryHistory];
    }];
}

#pragma mark -
#pragma mark - JXCategoryViewDelegate

//点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    //埋点-tab切换
    [GrowingManager lotterySwitchTab:[self gioBasicParams]];
}

//点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    //self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
}

#pragma mark - JXCategoryListContainerViewDelegate

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return _curModel.list.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    
    JHLotteryActivityData *data = _curModel.list[index].activityList.firstObject;
    JHLotteryListController *cacheVC = (JHLotteryListController *)self.listCache[data.activityCode];
    
    if (cacheVC != nil) { //使用缓存页面
        cacheVC.curData = _curModel.list[index];
        [cacheVC updateListData]; //已经存在缓存的页面需要手动刷新一下
        return cacheVC;
        
    } else {
        JHLotteryListController *vc = [[JHLotteryListController alloc] init];
        vc.curData = _curModel.list[index];
        @weakify(self);
        vc.refreshBlock = ^(JHLotteryListController * _Nonnull controller) {
            @strongify(self);
            self.curListVC = controller;
            [self sendRequest];
        };
        
        //缓存页面
        JHLotteryActivityData *data = _curModel.list[index].activityList.firstObject;
        self.listCache[data.activityCode] = vc;
        
        return vc;
    }
}

#pragma mark -
#pragma mark - GrowingIO埋点
//基础参数
- (NSMutableDictionary *)gioBasicParams {
    JHLotteryActivityData *data = _curModel.list[_myCategoryView.selectedIndex].activityList.firstObject;
    return @{@"activityDate" : data.activityDate}.mutableCopy;
}

@end
