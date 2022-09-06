//
//  YDBaseViewController.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/10.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "YDBaseViewController.h"

#import "GrowingManager.h"


@interface YDBaseViewController ()

//进入界面时间戳
@property (nonatomic, assign) NSTimeInterval enterTime;
@property (nonatomic, strong) NSMutableDictionary *growingInfoDict;

@end

@implementation YDBaseViewController

#pragma mark -
#pragma mark - Life Cycle
- (void)dealloc {
    NSLog(@">>>> dealloc class:[%@]", NSStringFromClass([self class]));
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        ///页面被创建埋点>>与基类重复>>去掉
//        NSString * vcName = NSStringFromClass([self class]);
//        [GrowingManager appViewControllerCreate:@{@"page_name":vcName, @"page_full_name":@""}];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeNavView]; //无基类navbar
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ///进入界面的时间
    _enterTime = [YDHelper get13TimeStamp].longLongValue;
    ///页面被展示埋点
    NSString * vcName = NSStringFromClass([self class]);
    [GrowingManager appViewWillAppear:@{@"page_name":vcName, @"page_full_name":@""}];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    ///页面被关闭埋点
    NSString * vcName = NSStringFromClass([self class]);
    [GrowingManager appViewControllerClose:@{@"page_name":vcName, @"page_full_name":@""}];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    ///浏览时长埋点
//    [self growingArticleBrowse];
}

//埋点：浏览时长
- (void)growingArticleBrowse {
    NSLog(@"baseviewcontroller:-------,%@", NSStringFromClass([self class]));

    [self growingArticleBrowseWithStartTime:_enterTime];
}

- (void)growingArticleBrowseWithStartTime:(NSTimeInterval)startTime
{
    NSTimeInterval outTime = [YDHelper get13TimeStamp].longLongValue;
    NSDate *enterDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDate *outDate = [NSDate dateWithTimeIntervalSince1970:outTime];
    NSTimeInterval duration = [outDate timeIntervalSinceDate:enterDate];
    [self.growingInfoDict addEntriesFromDictionary:@{@"duration":@(duration)}];
    [JHNotificationCenter postNotificationName:JHGrowingNotify_AllPageBrowseDuration object:nil userInfo:self.growingInfoDict];
}

//埋点：扩展浏览时长参数
- (void)growingSetParamDict:(NSDictionary*)paramDict
{
    if(paramDict)
    {
        [self.growingInfoDict addEntriesFromDictionary:paramDict];
    }
    else
    {
        _growingInfoDict = nil;
    }
}

- (NSMutableDictionary *)growingInfoDict
{
    if(!_growingInfoDict)
    {
        _growingInfoDict = [NSMutableDictionary dictionary];
    }
    return _growingInfoDict;
}

#pragma mark -
#pragma mark - UI

- (void)showNaviBar {
    if (!_naviBar) {
        _naviBar = [[YDBaseNavigationBar alloc] init];
        //_naviBar.leftImage = kNavBackBlackImg;
        //_naviBar.rightImage = [UIImage imageNamed:@""];
        [_naviBar.leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_naviBar.rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        
        if ([NSStringFromClass([self class]) rangeOfString:@"JHSQHomePage"].location != NSNotFound ||
            [NSStringFromClass([self class]) rangeOfString:@"JHStoreHome"].location != NSNotFound) {
            [self.naviBar hideBackButton];
        } else {
            [self.naviBar showBackButton];
        }
        
        [self.view addSubview:_naviBar];
        [self.view bringSubviewToFront:_naviBar];
    }
    _naviBar.hidden = NO;
}

- (void)hideNaviBar {
    [_naviBar removeFromSuperview];
    _naviBar = nil;
}

- (YDBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[YDBaseTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        if (iOS(11)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0.1;
            _tableView.estimatedSectionFooterHeight = 0.1;
        }
        
        //适配iOS11
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
        [self.view addSubview:_tableView];
        _tableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    }
    return _tableView;
}

#pragma mark -
#pragma mark - TableView Refresh M

- (JHRefreshGifHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _refreshHeader.automaticallyChangeAlpha = NO;
    }
    return _refreshHeader;
}

- (YDRefreshFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
        _refreshFooter.autoTriggerTimes = YES; //每次拖拽只发送一次请求
    }
    return _refreshFooter;
}

- (void)endRefresh {
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (BOOL)isRefreshing {
    if([self.tableView.mj_header isRefreshing] ||
       [self.tableView.mj_footer isRefreshing]) {
        return YES;
    }
    return NO;
}


#pragma mark -
#pragma mark - 子类可重写方法
- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightBtnClicked {}
- (void)refresh {}
- (void)refreshMore {}


#pragma mark -
#pragma mark - tabBar、titleCategory点击操作
- (void)scrollToTop {
    if (!_tableView) return;
    [self.tableView setContentOffset:CGPointZero animated:YES];
}
- (void)handleTabBarClick {
    if (!_tableView) return;
    if ([self isRefreshing]) return;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -
#pragma mark - UITableViewDataSource & UITableViewDelegate M

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

/** 适配iOS11：这两个方法必须实现，且返回高度必须大于0，不然不起作用！！！ */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}

//防止滑动tableView时产生的BUG
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    UIMenuController * menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) {
        [menu setMenuVisible:NO animated:YES];
    }
}


#pragma mark -
#pragma mark - 控制屏幕旋转

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)forceChangeToOrientation:(UIInterfaceOrientation)interfaceOrientation {
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:interfaceOrientation] forKey:@"orientation"];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
