//
//  JHPlateDetailController.m
//  TTjianbao
//
//  Created by lihui on 2020/9/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateDetailController.h"
#import <JXPagingView/JXPagerView.h>
#import <JXCategoryView.h>
#import "JHPlateDetailHeaderView.h"
#import "JHPlateDetailViewModel.h"
#import "JHPlateDetailListController.h"
#import "JHSQSearchViewController.h"
#import "JHGradientView.h"
#import "JHSQPublishSheetView.h"
#import "JHDetailSvgaLoadingView.h"
#import "JHPlateAboutViewController.h"
#import "JHBaseOperationModel.h"
#import "JHBaseOperationView.h"
#import "JHDetailHotNewSwtchView.h"

@interface JHPlateDetailController ()<JXPagerViewDelegate, JXCategoryViewDelegate,JXPagerMainTableViewGestureDelegate>

///记录导航栏的透明度
@property (nonatomic, assign) CGFloat alphaValue;

@property (nonatomic, strong) JXPagerView *pagingView;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) JHPlateDetailViewModel *viewModel;
@property (nonatomic, strong) JHPostData *postData;
@property (nonatomic, strong) JHPlateDetailHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray <JHPlateDetailListController *> *vcArray;

@property (nonatomic, strong) UISegmentedControl *segmentView;

/// 排序 1-最新，2-最热
@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, assign) BOOL popPan;

@property (nonatomic, weak) UIButton *searchButton;

@property (nonatomic, weak) JHDetailSvgaLoadingView *svgaPlayer;

//进入界面时间戳
@property (nonatomic, assign) NSTimeInterval enterTime;
///埋点时用到的公共参数
@property (nonatomic, strong) NSMutableDictionary *baseParams;


@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, copy) NSString *startPageTime;  //页面初始化时间点
@end

@implementation JHPlateDetailController

- (instancetype)init {
    self = [super init];
    if (self) {
        _alphaValue = 0;
        _sort = 2;
    }
    return self;
}

- (void)userStasticsForEnterPlateList {
    ///用户画像埋点：-- 进入社区tab板块分类列表页
    [JHUserStatistics noteEventType:kUPEventTypeCommunityPlateHomeEntrance params:self.baseParams];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ///340埋点 - 进入板块事件 跳转地方较多 统一这个地方埋点
    [self growingForEnterPlateDetail];
        
    [self configNav];
    
    [self.viewModel.requestCommand execute:@YES];
    
    JHDetailSvgaLoadingView *svgaPlayer = [[JHDetailSvgaLoadingView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH) placeholderImage:@"topic_detail_loading"];
    [self.view insertSubview:svgaPlayer belowSubview:self.jhNavView];
    [svgaPlayer showLoading];
    _svgaPlayer = svgaPlayer;
    self.startPageTime = [NSString getCurrentTime];
}

#pragma mark - Nav

- (void)configNav {
    [self.jhLeftButton setImage:JHImageNamed(@"navi_icon_back_white") forState:UIControlStateSelected];
    
    [self initRightButtonWithImageName:@"topic_nav_more0" action:@selector(rightActionButton:)];
    [self.jhRightButton setImage:JHImageNamed(@"topic_nav_more1") forState:UIControlStateSelected];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
    
    _searchButton = [UIButton jh_buttonWithImage:@"topic_nav_search0" target:self action:@selector(searchMethod) addToSuperView:self.jhNavView];
    [_searchButton setImage:JHImageNamed(@"topic_nav_search1") forState:UIControlStateSelected];
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.jhRightButton.mas_left);
        make.centerY.height.width.equalTo(self.jhRightButton);
    }];
    
    self.jhNavView.backgroundColor = UIColor.clearColor;
}

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    CGFloat height = [self.headerView headerViewHeight];
    return height;
}

- (NSUInteger)heightForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return 80;
}

- (UIView *)viewForPinSectionHeaderInPagerView:(JXPagerView *)pagerView {
    return self.categoryView;
}

- (NSInteger)numberOfListsInPagerView:(JXPagerView *)pagerView {
    return self.viewModel.detailModel.cate_tabs.count;
}

- (id<JXPagerViewListViewDelegate>)pagerView:(JXPagerView *)pagerView initListAtIndex:(NSInteger)index {
    if(index < self.vcArray.count)
    {
        JHPlateDetailListController *vc = self.vcArray[index];
        vc.viewModel.reqModel.sort = _sort;
        [vc refreshDataBlock:nil];
        vc.appear = YES;
        return vc;
    }
    
    JHPlateDetailListController *vc = [JHPlateDetailListController new];
    vc.viewModel.pageIndex = index;
    return vc;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat thresholdDistance = [JHPlateDetailHeaderView imageViewHeight] - UI.statusAndNavBarHeight;
    CGFloat offsetY = scrollView.contentOffset.y;
    _alphaValue = offsetY / thresholdDistance;
    _alphaValue = MAX(0, MIN(1, _alphaValue));
    [self changeNavStatusHidden:_alphaValue < 0.6];
    self.jhStatusBarStyle = (_alphaValue < 0.6 ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
    [UIView animateWithDuration:0.25 animations:^{
        self.jhNavView.backgroundColor = [UIColor colorWithWhite:1 alpha:_alphaValue];
    }];
    if(offsetY < 0)
    {
        [self.headerView updateImageHeight:fabsf(offsetY)];
    }
    
    if(offsetY < -35)
    {
        ///下拉刷新状态
        [self.headerView showLoading];
        self.headerView.isRequestLoading = YES;
    }
    if(offsetY == 0 && self.headerView.isRequestLoading)
    {
        NSInteger index = self.categoryView.selectedIndex;
        if(index < _vcArray.count)
        {
            @weakify(self);
            JHPlateDetailListController *vc = _vcArray[index];
            [vc refreshDataBlock:^{
                @strongify(self);
                [self.headerView dismissLoading];
//                [self.viewModel.requestCommand execute:@NO];
            }];
        }
    }
    
    if(_lineView)
    {
        _lineView.hidden = !(_headerView && offsetY > [self.headerView headerViewHeight] - UI.statusAndNavBarHeight - 10);
    }
    
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    ///340埋点 - 点击板块内容分类 滑动和点击事件同时统计
    JHTopicDetailCateModel *model = self.viewModel.detailModel.cate_tabs[index];
    [self.baseParams setValue:model.name forKey:@"category_name"];
    [JHGrowingIO trackEventId:JHTrackSQPlateClassifyClick variables:self.baseParams];
}

#pragma mark -------- method --------
-(void)changeNavStatusHidden:(BOOL)isHidden
{
    self.jhLeftButton.selected = isHidden;
    self.jhRightButton.selected = isHidden;
    self.searchButton.selected = isHidden;
    self.jhTitleLabel.textColor = isHidden ? UIColor.clearColor : UIColor.blackColor;
}

- (void)updateListViewController
{
    self.categoryView.listContainer = (id<JXCategoryViewListContainer>)self.pagingView.listContainerView;
    [self segmentView];
    [self showPublishButton];
}

- (void)sortMethod:(NSInteger)sender
{
    _sort = sender + 1;
    
    for (JHPlateDetailListController *vc in self.vcArray) {
        if(vc.appear)
        {
            vc.viewModel.reqModel.sort = _sort;
            [vc refreshDataBlock:nil];
        }
    }
    ///340埋点 - 点击版块排序开关
    NSString *key = (_sort == 1) ? JHTrackSQPlateSortReleaseClick : JHTrackSQPlateSortReplyClick;
    [JHGrowingIO trackEventId:key variables:self.baseParams];
}

- (void)searchMethod
{
    ///340埋点 - 点击版块搜索
    [JHGrowingIO trackEventId:JHTrackSQPlateSearchEnter variables:self.baseParams];
    ///369神策埋点:点击搜索栏
    [JHTracking trackEvent:@"searchBarClick" property:@{@"page_position":@"板块首页"}];
    
    JHSQSearchViewController * vc =  [[JHSQSearchViewController alloc]init];
    vc.section_id = self.plateId.integerValue;
    vc.placeholder = @"【搜索版块内容】";
    [self.navigationController pushViewController:vc animated:YES];
}

///操作弹框
- (void)rightActionButton:(UIButton *)sender{
    ///340埋点 - 点击版块操作弹窗
    [JHGrowingIO trackEventId:JHTrackSQPlateMoreClick variables:self.baseParams];
    
    self.postData = [[JHPostData alloc] init];
    self.postData.item_id = self.plateId;
    self.postData.share_info = self.viewModel.detailModel.share_info;
    self.postData.share_info.pageFrom = JHPageFromTypeSQPlateHomeList;
//    更多按钮
    @weakify(self);
     [JHBaseOperationView creatPlateOperationView:self.postData Block:^(JHOperationType operationType) {
         @strongify(self);
        [JHBaseOperationAction operationAction:operationType operationMode:self.postData bolck:^{
        }];
    }];
}

- (void)showPublishButton {
    JHPlateSelectData *m = [JHPlateSelectData new];
    m.channel_name = self.viewModel.detailModel.name;
    m.channel_id = self.plateId;
    [JHSQPublishSheetView showPublishSheetViewWithType:2 topic:nil plate:m addSuperView:self.view];
}

#pragma mark -------- get --------
- (JXCategoryTitleView *)categoryView
{
    if(!_categoryView)
    {
        NSMutableArray *array = [NSMutableArray new];
        for (JHTopicDetailCateModel *m in self.viewModel.detailModel.cate_tabs) {
            [array addObject:m.name];
        }
        NSLog(@"🍺%@",array);
        _categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
        _categoryView.titles = array;
        _categoryView.backgroundColor = [UIColor whiteColor];
        _categoryView.delegate = self;
        _categoryView.titleSelectedColor = RGB515151;
        _categoryView.titleColor = RGB(102, 102, 102);
        _categoryView.titleSelectedFont = JHBoldFont(15);
        _categoryView.titleFont = JHFont(15);
        _categoryView.titleColorGradientEnabled = NO;
        _categoryView.titleLabelZoomEnabled = NO;
        _categoryView.averageCellSpacingEnabled = NO;
        _categoryView.titleLabelVerticalOffset = -20;
        JXCategoryIndicatorImageView *indicatorImageView = [[JXCategoryIndicatorImageView alloc] init];
        indicatorImageView.indicatorImageView.image = [UIImage imageNamed:@"sq_category_Indicator_img_normal"];
        indicatorImageView.indicatorImageViewSize= CGSizeMake(15, 4);
        indicatorImageView.verticalMargin = 44;
        _categoryView.indicators = @[indicatorImageView];
        
        //搜索框
        UIView *switchView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:_categoryView];
        [switchView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_categoryView);
            make.height.mas_equalTo(40);
        }];
        
        UILabel *titleLable = [UILabel jh_labelWithFont:12 textColor:RGB(102,102,102) addToSuperView:switchView];
        titleLable.text = @"排序方式";
        [titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(switchView).offset(15);
            make.centerY.equalTo(switchView);
        }];

        @weakify(self);
        JHDetailHotNewSwtchView *segView = [JHDetailHotNewSwtchView new];
        [switchView addSubview:segView];
        [segView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(switchView).offset(-15);
            make.centerY.equalTo(switchView);
            make.size.mas_equalTo([JHDetailHotNewSwtchView viewSize]);
        }];
        segView.selectBlock = ^(NSInteger index) {
            @strongify(self);
            [self sortMethod:index];
        };
        
        _lineView = [UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:switchView];
        _lineView.hidden = YES;
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(switchView);
            make.height.mas_equalTo(1);
        }];
    }
    return _categoryView;
}

- (JXPagerView *)pagingView
{
    if(!_pagingView)
    {
        _pagingView = [[JXPagerView alloc] initWithDelegate:self];
        _pagingView.backgroundColor = kColorF5F6FA;
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

- (JHPlateDetailViewModel *)viewModel
{
    if(!_viewModel)
    {
        _viewModel = [JHPlateDetailViewModel new];
        _viewModel.reqModel.channel_id = self.plateId;
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if([x boolValue])
            {
                ///用户画像埋点
                self.plateName = self.viewModel.detailModel.name;
                self.plateId = self.viewModel.detailModel.ID;
                self.baseParams = [NSMutableDictionary dictionaryWithDictionary:@{@"plate_name":self.plateName,
                                                                                  @"plate_id":self.plateId}];
                [self userStasticsForEnterPlateList];
                
                self.title = self.viewModel.detailModel.name;
                self.headerView.model = self.viewModel.detailModel;
                [self updateListViewController];
                [self.pagingView reloadData];
                [self changeNavStatusHidden:YES];
            }
            else {
                self.headerView.focusButton.selected = self.viewModel.detailModel.is_follow;
            }
            
        }];
    }
    return _viewModel;
}

- (JHPlateDetailHeaderView *)headerView
{
    if(!_headerView)  {
        _headerView = [[JHPlateDetailHeaderView alloc] initWithFrame:CGRectZero];
        _headerView.pageFrom = self.pageFrom;
        _headerView.plateId = self.plateId;
        JH_WEAK(self);
        _headerView.briefBlock = ^(BOOL isPlateOwner) {
            JH_STRONG(self);
            NSLog(@"简介点击");
            [self growingBriefInfoTrack:isPlateOwner];
            
            JHPlateAboutViewController * VC = [[JHPlateAboutViewController alloc] initWithModel:self.viewModel.detailModel];
            [self.navigationController pushViewController:VC animated:YES];
        };
    }
    return _headerView;
}

- (NSMutableArray<JHPlateDetailListController *> *)vcArray
{
    if(!_vcArray)
    {
        _vcArray = [NSMutableArray arrayWithCapacity:3];
        for (JHTopicDetailCateModel *m in self.viewModel.detailModel.cate_tabs) {
            JHPlateDetailListController *listvc = [JHPlateDetailListController new];
            listvc.viewModel.reqModel.channel_id = self.plateId;
            listvc.viewModel.reqModel.cate_id = m.ID;
            [_vcArray addObject:listvc];
        }
    }
    return _vcArray;
}

#pragma mark -
#pragma mark - 板块列表停留时长埋点相关

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if(_pagingView) {
        _pagingView.mainTableView.scrollEnabled = YES;
    }
    _popPan = YES;
    ///用户画像埋点 - 社区板块首页停留时长：开始
    [self userStatisticForPlateHome:@{JHUPBrowseKey:JHUPBrowseBegin}];
    ///growing埋点：-- 社区板块停留时长 记录进入界面的时间
    _enterTime = [YDHelper get13TimeStamp].longLongValue;
    self.jhStatusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    ///用户画像埋点 - 社区板块首页停留时长：结束
    [self userStatisticForPlateHome:@{JHUPBrowseKey:JHUPBrowseEnd}];
    ///浏览时长埋点
    [self growingPlatePageBrowse];
    self.jhStatusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(_pagingView) {
        _pagingView.mainTableView.scrollEnabled = NO;
    }
    _popPan = NO;
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"社区版块首页",
        @"source_module":NONNULL_STR(self.plateName)
    } type:JHStatisticsTypeSensors];
}

//用户画像浏览时长:
- (void)userStatisticForPlateHome:(NSDictionary *)params {
    NSMutableDictionary * allParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [allParams setValue:self.plateName forKey:@"plate_name"];
    [allParams setValue:self.plateId forKey:@"plate_id"];
    [JHUserStatistics noteEventType:kUPEventTypeCommunityPlateHomeBrowse params:allParams];
}

//growingIO 埋点：浏览时长
- (void)growingPlatePageBrowse {
    NSTimeInterval outTime = [YDHelper get13TimeStamp].longLongValue;
    NSDate *enterDate = [NSDate dateWithTimeIntervalSince1970:_enterTime];
    NSDate *outDate = [NSDate dateWithTimeIntervalSince1970:outTime];
    NSTimeInterval duration = [outDate timeIntervalSinceDate:enterDate];
    ///340埋点 - 板块停留时长
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    [self.baseParams setValue:userId forKey:@"user_id"];
    [self.baseParams setValue:@(duration) forKey:@"duration"];
    [JHGrowingIO trackEventId:JHTrackSQPlateBrowseTime variables:self.baseParams];
}

///点击版主头像或者版主简介时的埋点~
- (void)growingBriefInfoTrack:(BOOL)isOwner {
    if (isOwner) { ///点击了版主
        ///340埋点 - 点击头部版主信息
        [JHGrowingIO trackEventId:JHTrackSQPlateAdminIconEnter variables:self.baseParams];
    }
    else {
        ///340埋点 - 点击头部版块简介
        [JHGrowingIO trackEventId:JHTrackSQPlateInfoClick variables:self.baseParams];
    }
}

///板块进入事件
- (void)growingForEnterPlateDetail {
    [JHGrowingIO trackEventId:JHTrackSQPlateDetailEnter variables:@{@"plate_id":self.plateId,
                                                                    @"page_from":self.pageFrom
    }];
}

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.popPan;
}

- (void)dealloc {
    NSString *currentShareTime = [NSString getCurrentTime];
    NSString *shareDurationTime = [NSString getTimeWithBeginTime:self.startPageTime endTime:currentShareTime];
    CGFloat eventTime = [shareDurationTime integerValue]/1000.0;
    [JHTracking trackEvent:@"sectionPageView" property:@{@"view_duration":@(eventTime),@"section_id":self.plateId,@"section_name":self.plateName,@"source_page":self.pageFrom}];
    NSLog(@"%@*************被释放",[self class])
}
@end
