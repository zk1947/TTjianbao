//
//  JHOriginalMallViewController.m
#import "JHSourceMallViewController.h"
#import "JHCelebrateHeaderView.h"
#import "MallAttentionTableViewCell.h"
#import "HGPersonalCenterExtend.h"
#import "JHMallSegmentView.h"
#import "JHMallHeaderView.h"
#import "SourceMallApiManager.h"
#import "JHMallListViewController.h"
#import "MyLiveViewController.h"
#import "UIImage+GIF.h"
#import "UIAlertView+NTESBlock.h"
#import "BannerMode.h"
#import "HGAlignmentAdjustButton.h"
#import "VideoCateMode.h"
#import "FileUtils.h"
#import "JHMallGroupConditionModel.h"
#import "JHMallSpecialTopicTableViewCell.h"
#import "JHMallSpecialAreaTableViewCell.h"
#import "JHCateUnfoldView.h"
#import "JHMallSpecialAreaModel.h"
#import "JHMallSpecialTopicModel.h"
#import "JHNewGuideTipsView.h"
#define circlerate (float)115/355
#define headerrate (float)195/375
@interface JHSourceMallViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, HGSegmentedPageViewControllerDelegate, HGPageViewControllerDelegate, JHCelebrateHeaderViewDelegate>
{
    NSArray* celebrateDetailArray;
    BOOL celebrateStarting;
}
@property (nonatomic, strong) HGAlignmentAdjustButton *messageButton;
@property (nonatomic, strong) HGCenterBaseTableView *tableView;
@property (nonatomic, strong) JHMallHeaderView *mallHeaderView;
@property (nonatomic, strong) JHCelebrateHeaderView *celebrateHeaderView;
@property (nonatomic, strong) UIView *footerView;
@property(nonatomic,strong) UIButton *changeCellImage;
@property (nonatomic) BOOL cannotScroll;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, strong) JHMallSegmentView *segmentV;
@property(nonatomic,strong) UIImageView* headerBackImage;
@property(nonatomic,strong) UIButton *selectButton;

@property(nonatomic,strong) NSMutableArray<BannerCustomerModel *>* bannerModes;
@property(nonatomic,strong) NSMutableArray<VideoCateMode *> * cateModes;
@property(nonatomic,strong) NSMutableArray<JHLiveRoomMode *> * attentionModes;
@property(nonatomic,copy) NSArray<JHMallGroupConditionModel *> * groupConditionArray;

@property(nonatomic,strong) NSMutableArray<JHMallSpecialTopicModel *> * specialTopicModes;
@property(nonatomic,copy) NSMutableArray<JHMallSpecialAreaModel *> * specialAreaModes;
@end

@implementation JHSourceMallViewController

- (instancetype)init {
    if (self = [super init]) {
       // [self getCelebrateMallDetailData:nil];//优先获取周年庆落地页跳转数据
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshPageView];
    // [self requestMallMyAttenton];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[JHLivePlayerManager sharedInstance] shutdown];
    [[self currentVC] doDestroyLastCell];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self removeNavView]; //无基类navbar
    self.view.backgroundColor = [CommHelp toUIColorByStr:@"#F5F6FA"];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //解决pop手势中断后tableView偏移问题
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    [self setupSubViews];
    [self loadMallCateList];
    [self requestBanners];
    [self requestMallMyAttenton];
    [self requestMallSpecialArea];
    [self showBackTopImage];
    // [self requestGroupCondition];
    self.backTopImage.hidden = YES;
    [self showChangCellImage];
    [self requestOrderCount];
    //用户画像浏览时长:begin
    [JHUserStatistics noteEventType:kUPEventTypeLiveShopHomeBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin} resumeBrowse:YES];
}

- (void)loadNewData {
    JHMallListViewController *vc = (JHMallListViewController *)_segmentedPageViewController.currentPageViewController;
    [vc refreshData];
    //  [self requestMallMyAttenton];
    [self requestMallSpecialArea];
    [self requestBanners];
    // [self requestGroupCondition];
//    JH_WEAK(self)
//    [self getCelebrateMallDetailData:^(id obj) {
//        JH_STRONG(self)
//        if(self.refreshBlock)
//            self.refreshBlock([JHRespModel nullMessage], [JHRespModel nullMessage]);
//    }]; //刷新
    
    [self requestOrderCount];
    
}
-(void)requestGroupCondition
{
    @weakify(self);
    [SourceMallApiManager requestGroupConditionArrayBlock:^(NSArray *modelArray) {
        @strongify(self);
        self.groupConditionArray = modelArray;
        [self.tableView reloadData];
    }];
}
- (void)requestBanners{
    
    [SourceMallApiManager getMallBannerCompletion:^(RequestModel *respondObject, NSError *error) {
        [_tableView.mj_header endRefreshing];
        if (!error) {
            self.bannerModes=[NSMutableArray arrayWithCapacity:10];
            self.bannerModes = [BannerCustomerModel mj_objectArrayWithKeyValuesArray:respondObject.data];
            [_mallHeaderView setBanners:[NSArray arrayWithArray:self.bannerModes]];
            
        }
    }];
}
- (void)loadMallCateList{
    __block  NSArray  *arr;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData * data=[FileUtils readDataFromFile:MallCateData];
        if (data) {
            arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([arr isKindOfClass:[NSArray class]]) {
                if (arr.count>0) {
                    self.cateModes=[NSMutableArray arrayWithCapacity:10];
                    self.cateModes = [VideoCateMode mj_objectArrayWithKeyValuesArray:arr];
                    [self addSegmentedPageViewController];
                }
            }
            else{
                JH_WEAK(self)
                [SourceMallApiManager getMallCateCompletion:^(RequestModel *respondObject, NSError *error) {
                    JH_STRONG(self)
                    if (!error) {
                        self.cateModes=[NSMutableArray arrayWithCapacity:10];
                        self.cateModes = [VideoCateMode mj_objectArrayWithKeyValuesArray:respondObject.data];
                        [self addSegmentedPageViewController];
                    }
                }];
            }
        });
    });
}

//- (void)getCelebrateMallDetailData:(JHActionBlock)response
//{
//    JH_WEAK(self)
//    [SourceMallApiManager getCelebrateMallDetailUrl:^(NSMutableArray* respData, NSString *errorMsg) {
//        JH_STRONG(self)
//        if(!errorMsg && [respData count] > 0)
//        {
//            self->celebrateDetailArray = respData;
//            self->celebrateStarting = YES;
//            if(self.refreshBlock)
//                self.refreshBlock(respData, [JHRespModel nullMessage]);
//            if(response)
//                response(respData);
//            [[NSNotificationCenter defaultCenter] postNotificationName:kCelebrateRunningOrNotNotification object:@(1)];
//        }
//        else
//        {
//            self->celebrateStarting = NO;
//            if(response)
//                response(nil);
//            [[NSNotificationCenter defaultCenter] postNotificationName:kCelebrateRunningOrNotNotification object:@(0)];
//        }
//    }];
//}


/// 获取为宝友把关数量
- (void)requestOrderCount {
    [SourceMallApiManager requestOrderCountBlock:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            self.mallHeaderView.orderCount = respondObject.data;
        }
    }];
}

- (BOOL)celebrateRunning
{
    return celebrateStarting;
}

-(void)addSegmentedPageViewController{
    
    if (self.cateModes.count>0) {
        NSMutableArray *titles = [NSMutableArray array];
        NSMutableArray *controllers = [NSMutableArray array];
        
        NSInteger selectIndex=0;
        for (int i=0 ;i<[self.cateModes count];i++ ) {
            VideoCateMode * mode=self.cateModes[i];
            //  DDLogInfo(@"segmentedPageViewController name==%@",mode.name);
            [titles addObject:mode.name];
            JHMallListViewController *controller = [[JHMallListViewController alloc] init];
            controller.groupId = mode.ID;
            if (mode.isDefault) {
                selectIndex=i;
                [controller loadData];
            }
            controller.delegate = self;
            [controllers addObject:controller];
        }
        [self addChildViewController:self.segmentedPageViewController];
        _segmentedPageViewController.pageViewControllers = controllers;
        _segmentedPageViewController.segmentWidth=ScreenW-70;
        _segmentedPageViewController.categoryView.originalIndex = selectIndex;
        _segmentedPageViewController.categoryView.titles = self.cateModes;
        [self.footerView addSubview:self.segmentedPageViewController.view];
        [self.segmentedPageViewController didMoveToParentViewController:self];
        [self.segmentedPageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.footerView);
        }];
        [_segmentedPageViewController.categoryView addSubview:self.selectButton];
        [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_segmentedPageViewController.categoryView).offset(-10);
            make.centerY.equalTo(_segmentedPageViewController.categoryView);
            make.size.mas_equalTo(CGSizeMake(70, 52));
        }];
    }
}
- (void)requestMallMyAttenton{
    [SourceMallApiManager getMallMyAttentonCompletion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            //            self.attentionModes=[NSMutableArray arrayWithCapacity:10];
            //            self.attentionModes = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:respondObject.data];
            //            [self.tableView  reloadData];
            NSArray * arr=[JHLiveRoomMode mj_objectArrayWithKeyValuesArray:respondObject.data];
            if (arr.count>0) {
                [self.segmentedPageViewController.categoryView showRedDot];
            }
        }
    }];
}

- (void)requestMallSpecialArea{
    [SourceMallApiManager getMallSpecialAreaCompletion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            self.specialTopicModes=[NSMutableArray arrayWithCapacity:10];
            self.specialTopicModes=[JHMallSpecialTopicModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"operationSubjectList"]];
            
            self.specialAreaModes=[NSMutableArray arrayWithCapacity:10];
            self.specialAreaModes=[JHMallSpecialAreaModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"operationAreaList"]];
            
            [self.tableView  reloadData];
        }
    }];
}
- (void)setupSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)refreshPageView
{
    
    if ([self currentVC].groupWatchTrack) {
        [[self currentVC]refreshData ];
    }
    
    if([self celebrateRunning])
    {
        self.view.backgroundColor = [CommHelp toUIColorByStr:@"#C60036"];
        self.tableView.tableHeaderView = self.celebrateHeaderView;
    }
    else
    {
        self.view.backgroundColor = [CommHelp toUIColorByStr:@"#F5F6FA"];
        self.tableView.tableHeaderView = self.mallHeaderView;
    }
}

- (void)showChangCellImage{
    [self.view addSubview:self.changeCellImage];
    [self.changeCellImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-30);
        make.right.equalTo(self.view).offset(-15);
        make.size.mas_equalTo(CGSizeMake(39,39));
    }];
}

- (UIButton *)changeCellImage{
    
    if (!_changeCellImage) {
        _changeCellImage = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_changeCellImage setImage:[UIImage imageNamed:@"icon_mall_change_small"] forState:UIControlStateNormal];
        [_changeCellImage setImage:[UIImage imageNamed:@"icon_mall_change_big"] forState:UIControlStateSelected];
        [_changeCellImage addTarget:self action:@selector(changeCellSizeAction:) forControlEvents:UIControlEventTouchUpInside];
        _changeCellImage.selected = YES;
        
    }
    return _changeCellImage;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if((section == 0 && self.specialTopicModes.count) || (section == 1 && self.specialAreaModes.count))
    {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier=@"cellIdentifier";
        JHMallSpecialTopicTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[JHMallSpecialTopicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType=UITableViewCellAccessoryNone;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        cell.specialTopicModes=self.specialTopicModes;
        
        return  cell;
    }
    else
    {
        static NSString *CellIdentifier=@"SpecialAreaCellIdentifier";
        JHMallSpecialAreaTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[JHMallSpecialAreaTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType=UITableViewCellAccessoryNone;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        cell.specialAreaModes=self.specialAreaModes;
        return  cell;
    }
    
    
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [CommHelp  toUIColorByStr:@"#F5F6FA"];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 180 : [JHMallSpecialAreaTableViewCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    // return CGFLOAT_MIN;
    
    if (self.specialTopicModes.count && section == 0) {
        return 5;
    }
    if (self.specialAreaModes.count && section == 1) {
        return 15;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    //    if (section == 0) {
    //        if ((self.attentionModes.count&&self.groupConditionArray.count)) {
    //            return 10;
    //        }
    //    }
    return CGFLOAT_MIN;
}

#pragma mark - HGSegmentedPageViewControllerDelegate
- (void)segmentedPageViewControllerWillBeginDragging {
    self.tableView.scrollEnabled = NO;
}

- (void)segmentedPageViewControllerDidEndDragging {
    self.tableView.scrollEnabled = YES;
}

#pragma mark - HGPageViewControllerDelegate
- (void)pageViewControllerLeaveTop {
    self.cannotScroll = NO;
}
-(UIImageView*)headerBackImage{
    if (!_headerBackImage) {
        _headerBackImage=[[UIImageView alloc]init];
        _headerBackImage.contentMode=UIViewContentModeScaleToFill;
        _headerBackImage.image=[UIImage imageNamed:@"shuang11_mall_header"];
    }
    return _headerBackImage;
}

- (JHCelebrateHeaderView *)celebrateHeaderView
{
    if(!_celebrateHeaderView)
    {
        _celebrateHeaderView = [JHCelebrateHeaderView new];
        _celebrateHeaderView.delegate = self;
    }
    return _celebrateHeaderView;
}

- (JHMallHeaderView *)mallHeaderView {
    if (!_mallHeaderView) {
        _mallHeaderView = [[JHMallHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW,10+round(circlerate*(ScreenW-20))+10+TipsHeight)];
        _mallHeaderView.orderCount = @"0";
    }
    return _mallHeaderView;
}
-(UIButton *)selectButton
{
    if(!_selectButton)
    {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.backgroundColor=[UIColor clearColor];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"mall_selectbtn_icon_xia"] forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"mall_selectbtn_icon_xia-white"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectButton;
}
- (UIView *)footerView {
    if (!_footerView) {
        //如果当前控制器存在TabBar/ToolBar, 还需要减去TabBarHeight/ToolBarHeight和SAFE_AREA_INSERTS_BOTTOM

        CGFloat navHeight = (UI.isIPad ? 50 : 44);
        if (@available(iOS 11.0, *)) {
            navHeight += [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
        } else {
            navHeight += [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - navHeight-49-UI.bottomSafeAreaHeight)];
    }
    return _footerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[HGCenterBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        if([self celebrateRunning])
            _tableView.tableHeaderView = self.celebrateHeaderView;
        else
            _tableView.tableHeaderView = self.mallHeaderView;
        _tableView.tableFooterView = self.footerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.contentInset=UIEdgeInsetsMake(0, 0,0, 0);
        [_tableView scrollToTop];
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _tableView.mj_header = header;
        
    }
    return _tableView;
}

- (HGSegmentedPageViewController *)segmentedPageViewController {
    if (!_segmentedPageViewController) {
        _segmentedPageViewController = [[HGSegmentedPageViewController alloc] init];
        _segmentedPageViewController.delegate = self;
    }
    return _segmentedPageViewController;
}

- (void)pressLiveVC:(UIGestureRecognizer *)gestureRecognizer {
    MyLiveViewController *myliveVC=[MyLiveViewController new];
    [self.navigationController pushViewController:myliveVC animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    [_segmentedPageViewController.currentPageViewController makePageViewControllerScrollToTop];
    return YES;
}
/**
 * 处理联动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.backTopImage setHidden:NO];
    if(self.refreshBlock)
        self.refreshBlock([JHRespModel nullMessage], scrollView);
    //第一部分：更改导航栏颜色
    //第二部分：处理scrollView滑动冲突
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //吸顶临界点(此时的临界点不是视觉感官上导航栏的底部，而是当前屏幕的顶部相对scrollViewContentView的位置)
    //如果底部存在TabBar/ToolBar, 还需要减去TabBarHeight/ToolBarHeight和SAFE_AREA_INSERTS_BOTTOM
    
    //  CGFloat criticalPointOffsetY = scrollView.contentSize.height - ScreenH+49+UI.bottomSafeAreaHeight;
    CGFloat criticalPointOffsetY = scrollView.contentSize.height - ScreenH+49+UI.bottomSafeAreaHeight+UI.statusAndNavBarHeight;
    
    //利用contentOffset处理内外层scrollView的滑动冲突问题
    if (contentOffsetY >= criticalPointOffsetY) {
        /*
         * 到达临界点：
         * 1.未吸顶状态 -> 吸顶状态
         * 2.维持吸顶状态 (pageViewController.scrollView.contentOffsetY > 0)
         */
        //“进入吸顶状态”以及“维持吸顶状态”
        //  self.navbar.ImageView.backgroundColor =[CommHelp toUIColorByStr:@"#ff7c00"];
        [self.backTopImage setHidden:NO];
        self.cannotScroll = YES;
        self.segmentedPageViewController.categoryView.backColor=[UIColor colorWithHexString:@"FFFFFF"];
        [self.selectButton setSelected:YES];
        scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        [_segmentedPageViewController.currentPageViewController makePageViewControllerScroll:YES];
    } else {
        self.segmentedPageViewController.categoryView.backColor=[UIColor colorWithHexString:@"F5F6FA"];
        [self.selectButton setSelected:NO];
        /*
         * 未达到临界点：
         * 1.维持吸顶状态 (pageViewController.scrollView.contentOffsetY > 0)
         * 2.吸顶状态 -> 不吸顶状态
         */
        //        self.navbar.ImageView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0];
        [self.backTopImage setHidden:YES];
        
        if (self.cannotScroll) {
            //“维持吸顶状态”
            self.segmentedPageViewController.categoryView.backColor=[UIColor colorWithHexString:@"FFFFFF"];
            [self.selectButton setSelected:YES];
            scrollView.contentOffset = CGPointMake(0, criticalPointOffsetY);
        } else {
            /* 吸顶状态 -> 不吸顶状态
             * categoryView的子控制器的tableView或collectionView在竖直方向上的contentOffsetY小于等于0时，会通过代理的方式改变当前控制器self.canScroll的值；
             */
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    ///这块为啥要通知出现引导呢 ？？？、 ---- TODO LIHUI
    [[NSNotificationCenter defaultCenter] postNotificationName:JHNotificationNameScrollMallTopEnd object:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate){
        [[NSNotificationCenter defaultCenter] postNotificationName:JHNotificationNameScrollMallTopEnd object:nil];
    }
}

- (void)segmentedPageViewControllerDidEndDeceleratingWithPageIndex:(NSInteger)index{
    NSLog(@"pageIndex=%ld",(long)index);
    [self changeNewPage:index];
}
-(void)changeNewPage:(NSInteger)index{
    
    for (JHMallListViewController *vc in self.segmentedPageViewController.pageViewControllers) {
               [vc.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
           }
    if (self.lastIndex!=index) {
       
        if (self.lastIndex<_segmentedPageViewController.pageViewControllers.count) {
            JHMallListViewController *lastvc = (JHMallListViewController *)_segmentedPageViewController.pageViewControllers[self.lastIndex];
            [lastvc.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
            [[JHLivePlayerManager sharedInstance] shutdown];
            [lastvc doDestroyLastCell];
        }
    }
    
    [[self currentVC] loadData];
    self.lastIndex = index;
    
}
- (void)changeCellSizeAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:JHNotificationNameChangeMallCellSize object:@(btn.selected)];//yes是小图 no是大图
}
- (void)backTop:(UIGestureRecognizer *)gestureRecognizer {
    
    [[self currentVC].collectionView setContentOffset:CGPointMake(0,0) animated:NO];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)selectBtnAction:(UIButton*)button{
    
    CGFloat criticalPointOffsetY = ScreenH+49+UI.bottomSafeAreaHeight+UI.statusAndNavBarHeight;
    self.tableView.contentOffset = CGPointMake(0, criticalPointOffsetY);
    
    JHCateUnfoldView * view=[[JHCateUnfoldView alloc]init];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(0);
        make.bottom.equalTo(self.view).offset(0);
    }];
    view.titles=self.cateModes;
    view.selectIndex=self.lastIndex;
    
    JH_WEAK(self)
    view.buttonClick = ^(id obj) {
        JH_STRONG(self)
        NSNumber *number=(NSNumber*)obj;
        [self.segmentedPageViewController setPageIndex:[number integerValue]];
    };
    
}
- (JHMallListViewController *)currentVC {
    JHMallListViewController *vc = (JHMallListViewController *)_segmentedPageViewController.currentPageViewController;
    return vc;
}

-(void)tableBarSelect:(NSInteger)currentIndex{
    if ([self isRefreshing]){
        return;
    }
    if (currentIndex == 0) {
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
        [[self currentVC].collectionView setContentOffset:CGPointMake(0,0) animated:NO];
        [[JHLivePlayerManager sharedInstance] shutdown];
        [[self currentVC] doDestroyLastCell];
        [self.tableView.mj_header beginRefreshing];
        self.cannotScroll=NO;
    }
    else{
        [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
        [[self currentVC].collectionView setContentOffset:CGPointMake(0,0) animated:NO];
    }
    
}
-(BOOL)isRefreshing{
    
    if ([self.tableView.mj_header isRefreshing]||self.tableView.mj_header.state== MJRefreshStatePulling||[self.tableView.mj_footer isRefreshing]||self.tableView.mj_footer.state== MJRefreshStatePulling) {
        
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    DDLogInfo(@"didReceiveMemoryWarning ");
}

#pragma mark - 根据类型页面跳转
- (void)clickButtonResponse:(NSInteger)buttonTag
{
//    JH_WEAK(self)
//    [SVProgressHUD show];
//    [self getCelebrateMallDetailData:^(id obj) {
//        JH_STRONG(self)
//        if(obj && buttonTag < [self->celebrateDetailArray count])
//        {
//            [SVProgressHUD dismiss];
//            [JHRouters gotoPageByModel:self->celebrateDetailArray[buttonTag]];
//
//        }
//        else
//        {
//            if(self.refreshBlock)
//                self.refreshBlock([JHRespModel nullMessage], [JHRespModel nullMessage]);
//            [SVProgressHUD showErrorWithStatus:@"活动已下线，请刷新重试"];
//        }
//    }];
}

#pragma mark -
#pragma mark - JXCategoryListCollectionContentViewDelegate
- (UIView *)listView {
    return self.view;
}

-(NSArray<JHMallGroupConditionModel *> *)groupConditionArray
{
    if(!_groupConditionArray)
    {
        _groupConditionArray = @[];
    }
    return _groupConditionArray;
}


@end




