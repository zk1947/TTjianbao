//
//  JHRecycleHomeViewController.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeViewController.h"
#import "JHRecycleHomeBaseTableViewCell.h"
#import "JHRecycleHomeUserProtectionCell.h"
#import "JHRecycleHomeKeyTypeCell.h"
#import "JHRecycleNodeGuideCell.h"
#import "JHRecycleHomeBannerCell.h"
#import "JHRecycleHomeLiveCell.h"
#import "JHRecycleHomeHotGoodsCell.h"
#import "JHRecycleHomeProblemCell.h"
#import "JHRecycleHomeGuideEntranceCell.h"
#import "JHRecycleOrderPageController.h"

#import "JHRecycleHomeViewModel.h"
#import "JHRecycleItemViewModel.h"
#import "UIView+JHGradient.h"
#import <UIImage+YYAdd.h>
#import <MJRefresh.h>
#import "JHRefreshGifHeader.h"
#import "JHAppAlertViewManger.h"


@interface JHRecycleHomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JHRecycleHomeViewModel *homeViewModel;
@property (nonatomic, strong) UIButton *orderButton;
@property (nonatomic, assign) NSInteger pageNo;
@end

@implementation JHRecycleHomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //超级红包
    [JHAppAlertViewManger showSuperRedPacketEnterWithSuperView:self.view];
    [JHAppAlertViewManger setShowSuperRedPacketEnterWithTop:ScreenH - 250 - UI.statusAndNavBarHeight];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{@"page_name":@"天天回收首页"} type:JHStatisticsTypeSensors];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [JHHomeTabController changeStatusWithMainScrollView:self.tableView index:3];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, UI.tabBarAndBottomSafeAreaHeight, 0));
    }];
    
    [self setupUIView];
        
    [self.tableView.mj_header beginRefreshing];
    
    [self configData];
}

#pragma mark - UI
- (void)setupUIView{
    //可拖拽的订单浮标
    [self.view addSubview:self.orderButton];
    [self.orderButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view).offset(-90-UI.tabBarAndBottomSafeAreaHeight);
        /// 会和活动重叠，所以坐标调整
        make.bottom.equalTo(self.view).offset(-210-UI.tabBarAndBottomSafeAreaHeight);
        make.right.equalTo(self.view).offset(-10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

#pragma mark - LoadData
- (void)loadData{
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"hotProductImageType"] = @"s";//s 缩略图，m 小图，b 大图，o 原图
    dicData[@"productImageType"] = @"s";//图片类型
    [self.homeViewModel.recycleHomeCommand execute:dicData];
  

}
#pragma mark - LoadProblemData
- (void)loadProblemData{
    
    NSMutableDictionary *params= [NSMutableDictionary dictionary];
    params[@"pageNo"] = @(_pageNo);
    [self.homeViewModel.recycleProblemCommand execute:params];

}
- (void)configData{
    @weakify(self)
    //楼层列表
    [[RACObserve(self.homeViewModel, dataSourceArray) skip:1] subscribeNext:^(id _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];

        [self.tableView reloadData];
        
    }];
    
    [self.homeViewModel.recycleHomeCompleteSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        _pageNo = 0;
        [self loadProblemData];
    }];

    //请求出错
    [self.homeViewModel.errorRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Action
///我的回收订单
- (void)clickOrderActionButton:(UIButton *)sender{
    //判断登录，未登录跳登录
    if (![JHRootController isLogin]) {
        @weakify(self);
        [JHRootController presentLoginVCWithTarget:[JHRootController currentViewController] complete:^(BOOL result) {
            @strongify(self);
            if (result) {
                [self.tableView.mj_header beginRefreshing];
            }
        }];
    }else{
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickRecyclOrder" params:@{
            @"page_position":@"recycleHome"
        } type:JHStatisticsTypeSensors];
        
        JHRecycleOrderPageController *orderVC = [[JHRecycleOrderPageController alloc] init];
        orderVC.selectIndex = 1;
        [self.navigationController pushViewController:orderVC animated:YES];
    }
    
}

#pragma mark - Delegate
/// 监听滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [JHHomeTabController changeStatusWithMainScrollView:self.tableView index:3];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}

#pragma mark - JXPagingViewListViewDelegate

- (UIScrollView *)listScrollView {
    return self.tableView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.homeViewModel.dataSourceArray.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JHRecycleItemViewModel *itemViewModel = self.homeViewModel.dataSourceArray[indexPath.section][indexPath.row];
    JHRecycleHomeBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:itemViewModel.cellIdentifier];
    if ([itemViewModel.cellIdentifier isEqualToString:@"JHRecycleHomeKeyTypeCell"]) {
        //刷新数据
        @weakify(self)
        [cell.loginSuccessSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.tableView.mj_header beginRefreshing];
        }];
    }
    
    if ([itemViewModel.cellIdentifier isEqualToString:@"JHRecycleHomeProblemCell"]) {
        //刷新数据
        @weakify(self)
    JHRecycleHomeProblemCell *problemCell = (JHRecycleHomeProblemCell*)cell;
    [problemCell.lookMoreSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        _pageNo ++;
        [self loadProblemData];
    }];
    }
    [cell bindViewModel:itemViewModel];

    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHRecycleItemViewModel *itemViewModel = self.homeViewModel.dataSourceArray[indexPath.section][indexPath.row];

    return itemViewModel.cellHeight;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = HEXCOLOR(0xF5F5F8);
    return view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = HEXCOLOR(0xF5F5F8);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    JHRecycleItemViewModel *itemViewModel = self.homeViewModel.dataSourceArray[section][0];
if ([itemViewModel.cellIdentifier isEqualToString:@"JHRecycleNodeGuideCell"]||
    [itemViewModel.cellIdentifier isEqualToString:@"JHRecycleHomeUserProtectionCell"]) {
        return CGFLOAT_MIN;
    }
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    if (indexPath.section == 0) {//用户保障
//        [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/app/recycle/security.html") title:@"" controller:JHRootController];
//        
//        [JHAllStatistics jh_allStatisticsWithEventId:@"clickUserGuarantee" params:@{
//            @"page_position":@"recycleHome"
//        } type:JHStatisticsTypeSensors];
//    }

}

#pragma mark - Lazy
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor =  HEXCOLOR(0xF5F5F8);
        [self registerCell:_tableView];
        //下拉刷新数据
        @weakify(self);
        _tableView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self loadData];
        }];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
            _tableView.contentInset = UIEdgeInsetsMake(0,0,0,0);
            _tableView.scrollIndicatorInsets =_tableView.contentInset;
            _tableView.estimatedSectionHeaderHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
        }

    }
    return  _tableView;
}
- (void)registerCell:(UITableView *)tableView{
    [tableView registerClass:[JHRecycleHomeBaseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleHomeBaseTableViewCell class])];
    [tableView registerClass:[JHRecycleHomeUserProtectionCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleHomeUserProtectionCell class])];
    [tableView registerClass:[JHRecycleHomeKeyTypeCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleHomeKeyTypeCell class])];
    [tableView registerClass:[JHRecycleNodeGuideCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleNodeGuideCell class])];
    [tableView registerClass:[JHRecycleHomeBannerCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleHomeBannerCell class])];
    [tableView registerClass:[JHRecycleHomeLiveCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleHomeLiveCell class])];
    [tableView registerClass:[JHRecycleHomeHotGoodsCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleHomeHotGoodsCell class])];
    [tableView registerClass:[JHRecycleHomeProblemCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleHomeProblemCell class])];
    [tableView registerClass:[JHRecycleHomeGuideEntranceCell class] forCellReuseIdentifier:NSStringFromClass([JHRecycleHomeGuideEntranceCell class])];

}

- (JHRecycleHomeViewModel *)homeViewModel{
    if (!_homeViewModel) {
        _homeViewModel = [[JHRecycleHomeViewModel alloc] init];
    }
    return _homeViewModel;
}

- (UIButton *)orderButton{
    if (!_orderButton) {
        _orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orderButton setBackgroundImage:JHImageNamed(@"recycle_home_order_icon") forState:UIControlStateNormal];
        [_orderButton addTarget:self action:@selector(clickOrderActionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderButton;
}

//设置图片的透明度
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
