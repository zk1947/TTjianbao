//
//  JHStoneResaleViewController.m
//  TTjianbao
//
//  Created by jiang on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//
#import "JHStoneResaleViewController.h"
#import "JHStoneResaleListViewController.h"
#import "MallAttentionTableViewCell.h"
#import "HGPersonalCenterExtend.h"
#import "JHMallSegmentView.h"
#import "JHStoneResaleHeaderView.h"
#import "SourceMallApiManager.h"
#import "UIImage+GIF.h"
#import "UIAlertView+NTESBlock.h"
#import "BannerMode.h"
#import "HGAlignmentAdjustButton.h"
#import "VideoCateMode.h"
#import "JHStoneSearchConditionView.h"
#define circlerate (float)150/394
#define headerrate (float)195/375
@interface JHStoneResaleViewController () <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, HGSegmentedPageViewControllerDelegate, HGPageViewControllerDelegate>
{
}
@property (nonatomic, strong) HGAlignmentAdjustButton *messageButton;
@property (nonatomic, strong) HGCenterBaseTableView *tableView;
@property (nonatomic, strong) JHStoneResaleHeaderView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic) BOOL cannotScroll;
@property (nonatomic, assign) NSInteger lastIndex;
@property (nonatomic, strong) JHMallSegmentView *segmentV;
@property(nonatomic,strong) UIImageView* headerBackImage;

//
@property(nonatomic,strong) NSMutableArray<BannerMode *>* bannerModes;
@property(nonatomic,strong) NSMutableArray<VideoCateMode *> * cateModes;
@property(nonatomic,strong) NSMutableArray<JHLiveRoomMode *> * attentionModes;

@property (nonatomic, strong) UIButton *selectButton;
@end

@implementation JHStoneResaleViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[JHLivePlayerManager sharedInstance] shutdown];
    [[self currentVC] doDestroyLastCell];
    [JHGrowingIO trackEventId:@"yshx_return_click"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [JHGrowingIO trackEventId:@"yshx_dzservice_in"];
    UIImageView * imagev = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 174)];
    imagev.image = [UIImage imageNamed:@"stoneResaleHeaderView_bgImage"];
    imagev.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imagev];
    [self.view bringSubviewToFront:self.jhNavView];
    self.jhNavView.backgroundColor = [UIColor clearColor];
    self.title = @"原石回血";
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
    [self requestHeaderInfo];
    // [self requestMallMyAttenton];
    [self showBackTopImage];
    self.backTopImage.hidden = YES;
}
- (void)loadNewData {
    JHStoneResaleListViewController *vc = (JHStoneResaleListViewController *)_segmentedPageViewController.currentPageViewController;
    [vc loadNewData];
    [self requestHeaderInfo];
}
- (void)requestHeaderInfo{
    [JHMainViewStoneHeaderInfoModel  requestHeaderInfoCompletion:^(RequestModel *respondObject, NSError *error) {
        [_tableView.mj_header endRefreshing];
        if (!error) {
            JHMainViewStoneHeaderInfoModel *mode = [JHMainViewStoneHeaderInfoModel mj_objectWithKeyValues:respondObject.data];
            [_headerView setMode:mode];
            [_tableView reloadData];
        }
        else{
            [self.view makeToast:error.localizedDescription];
        }
    }];
}
- (void)loadMallCateList{
    NSArray  *arr=@[@{@"name":@"回血直播间",@"id":@"",@"type":@"1"},
                    @{@"name":@"寄售原石",@"id":@"",@"type":@"2"},
                    @{@"name":@"个人转售",@"id":@"",@"type":@"4"},
                    @{@"name":@"已售原石",@"id":@"",@"type":@"3"}];
    self.cateModes=[NSMutableArray arrayWithCapacity:10];
    self.cateModes = [VideoCateMode mj_objectArrayWithKeyValuesArray:arr];
    [self addSegmentedPageViewController];
}
-(void)addSegmentedPageViewController{
    
    if (self.cateModes.count>0) {
        NSMutableArray *titles = [NSMutableArray array];
        NSMutableArray *controllers = [NSMutableArray array];
        for (int i=0 ;i<[self.cateModes count];i++ ) {
            VideoCateMode * mode=self.cateModes[i];
            DDLogInfo(@"segmentedPageViewController name==%@",mode.name);
            [titles addObject:mode.name];
            JHStoneResaleListViewController *controller = [[JHStoneResaleListViewController alloc] init];
            controller.groupId = mode.ID;
            controller.type=mode.type;
            if (i == 0) {
                [controller loadData];
            }
            controller.delegate = self;
            [controllers addObject:controller];
        }
        [self addChildViewController:self.segmentedPageViewController];
        _segmentedPageViewController.pageViewControllers = controllers;
        _segmentedPageViewController.categoryButtonClolor = [UIColor whiteColor];
        _segmentedPageViewController.segmentWidth=ScreenW-70;
        _segmentedPageViewController.categoryView.originalIndex = 0;
        _segmentedPageViewController.categoryView.titles = self.cateModes;
        _segmentedPageViewController.categoryView.backgroundColor = [CommHelp toUIColorByStr:@"f7f7f7"];
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
        self.selectButton.hidden=YES;
        
    }
}

-(UIButton *)selectButton
{
    if(!_selectButton)
    {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.backgroundColor=[UIColor clearColor];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"stone_main_filtrate_hui"] forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"stone_main_filtrate_white"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectMethod) forControlEvents:UIControlEventTouchUpInside];
        //        _lineView = [UIView jh_viewWithColor:RGB(222, 222, 222) addToSuperview:temView];
        //        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.size.mas_equalTo(CGSizeMake(0.5, 20));
        //            make.centerY.left.equalTo(self.selectButton);
        //        }];
    }
    return _selectButton;
}

-(void)selectMethod
{
    JHStoneSearchConditionView *selectView = [[JHStoneSearchConditionView alloc]initWithFrame:self.view.window.bounds];
    selectView.selectDic = [self currentVC].paramDic;
    @weakify(self);
    selectView.selectedBlock = ^(NSDictionary * _Nonnull paramDic) {
        @strongify(self);
        [self currentVC].paramDic = paramDic;
        [[self currentVC] loadNewData];
        NSLog(@"%@",paramDic);
    };
    [self.view.window addSubview:selectView];
}
- (void)requestMallMyAttenton{
    [SourceMallApiManager getMallMyAttentonCompletion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            self.attentionModes=[NSMutableArray arrayWithCapacity:10];
            self.attentionModes = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:respondObject.data];
            [self.tableView  reloadData];
        }
    }];
}

- (void)setupSubViews {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    if (self.attentionModes.count) {
    //        return 1;
    //    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier=@"cellIdentifier";
    MallAttentionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[MallAttentionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.attentionModes=self.attentionModes;
    
    return  cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont boldSystemFontOfSize:22];
    label.text = @"我的关注";
    label.textColor =  [CommHelp  toUIColorByStr:@"#222222"];
    [headerView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(5, 10,5, 10));
    }];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [CommHelp  toUIColorByStr:@"#F5F6FA"];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.attentionModes.count) {
        return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
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
- (JHStoneResaleHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[JHStoneResaleHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW,round((ScreenW -10)*StoneHeaderImageRate))];
    }
    return _headerView;
}

- (UIView *)footerView {
    if (!_footerView) {
        //如果当前控制器存在TabBar/ToolBar, 还需要减去TabBarHeight/ToolBarHeight和SAFE_AREA_INSERTS_BOTTOM
        CGFloat navHeight = 44;
        if (@available(iOS 11.0, *)) {
            navHeight += [UIApplication sharedApplication].keyWindow.safeAreaInsets.top;
        } else {
            navHeight += [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - navHeight)];
    }
    return _footerView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[HGCenterBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.footerView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        //  _tableView.contentInset=UIEdgeInsetsMake(0, 0,UI.bottomSafeAreaHeight+49, 0);
        _tableView.contentInset=UIEdgeInsetsMake(0, 0,0,0);
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
    //第一部分：更改导航栏颜色
    //第二部分：处理scrollView滑动冲突
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //吸顶临界点(此时的临界点不是视觉感官上导航栏的底部，而是当前屏幕的顶部相对scrollViewContentView的位置)
    //如果底部存在TabBar/ToolBar, 还需要减去TabBarHeight/ToolBarHeight和SAFE_AREA_INSERTS_BOTTOM
    
    //  CGFloat criticalPointOffsetY = scrollView.contentSize.height - ScreenH+49+UI.bottomSafeAreaHeight;
    CGFloat criticalPointOffsetY = scrollView.contentSize.height - ScreenH+UI.statusAndNavBarHeight;
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
-(void)segmentedPageViewControllerDidEndDeceleratingWithPageIndex:(NSInteger)index{
    NSLog(@"pageIndex=%ld",(long)index);
    [self changeNewPage:index];
    
}
-(void)changeNewPage:(NSInteger)index{
    
    if (self.lastIndex!=index) {
        if (self.lastIndex<_segmentedPageViewController.pageViewControllers.count) {
            JHStoneResaleListViewController *lastvc = (JHStoneResaleListViewController *)_segmentedPageViewController.pageViewControllers[self.lastIndex];
            [lastvc.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
            [[JHLivePlayerManager sharedInstance] shutdown];
            [lastvc doDestroyLastCell];
        }
    }
    
    [[self currentVC] loadData];
    self.lastIndex = index;
    
    if ([self currentVC].type == JHStoneMainListTypeStoneSale||
        [self currentVC].type == JHStoneMainListTypeStoneResell) {
        self.selectButton.hidden = NO;
    }
    else{
        self.selectButton.hidden = YES;
    }
}
- (void)changeCellSizeAction:(UIButton *)btn{
    btn.selected = !btn.selected;
    [[NSNotificationCenter defaultCenter] postNotificationName:JHNotificationNameChangeStoneCellSize object:@(btn.selected)];//yes是小图 no是大图
    
}
- (void)backTop:(UIGestureRecognizer *)gestureRecognizer {
    
    [[self currentVC].collectionView setContentOffset:CGPointMake(0,0) animated:NO];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}
-(void)scrollPageIndex:(NSUInteger)index{
    
    [self.segmentedPageViewController setPageIndex:index];
}
- (JHStoneResaleListViewController *)currentVC {
    JHStoneResaleListViewController *vc = (JHStoneResaleListViewController *)_segmentedPageViewController.currentPageViewController;
    return vc;
}
-(void)tableBarSelect:(NSInteger)currentIndex{
    
    if ([self isRefreshing]){
        return;
    }
    if (currentIndex == 2) {
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

@end
