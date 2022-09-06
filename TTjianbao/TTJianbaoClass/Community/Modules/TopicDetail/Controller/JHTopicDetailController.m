//
//  JHTopicDetailController.m
//  TTjianbao
//
//  Created by wangjianios on 2020/8/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDetailHotNewSwtchView.h"
#import "JHTopicDetailController.h"
#import <JXPagingView/JXPagerView.h>
#import <JXCategoryView.h>
#import "JHTopicDetailHeaderView.h"
#import "JHTopicDetailViewModel.h"
#import "JHTopicDetailListController.h"
#import "JHSQSearchViewController.h"
#import "JHSQPublishSheetView.h"
#import "JHDetailSvgaLoadingView.h"
#import "JHBaseOperationModel.h"
#import "JHBaseOperationView.h"
#import "JHOnlineVideoDetailController.h"

#define kJoinBtnOffetY  (50 + 56)

@interface JHTopicDetailController ()<JXPagerViewDelegate, JXCategoryViewDelegate,JXPagerMainTableViewGestureDelegate>

///记录导航栏的透明度
@property (nonatomic, assign) CGFloat alphaValue;

@property (nonatomic, strong) JXPagerView *pagingView;

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) JHTopicDetailViewModel *viewModel;
@property (nonatomic, strong) JHPostData *postData;
@property (nonatomic, strong) JHTopicDetailHeaderView *headerView;

@property (nonatomic, strong) NSMutableArray <JHTopicDetailListController *> *vcArray;

@property (nonatomic, strong) UISegmentedControl *segmentView;

/// 排序 1-最新，2-最热
@property (nonatomic, assign) NSInteger sort;

@property (nonatomic, weak) UIButton *searchButton;

@property (nonatomic, weak) JHDetailSvgaLoadingView *svgaPlayer;

//进入界面时间戳
@property (nonatomic, assign) NSTimeInterval enterTime;

@property (nonatomic, weak) UIView *lineView;

/// 返回时能上线滑动
@property (nonatomic, assign) BOOL popPan;

@end

@implementation JHTopicDetailController

- (instancetype)init {
    self = [super init];
    if (self) {
        _alphaValue = 0;
        _sort = 2;
        _supportEnterVideo = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self.viewModel.requestCommand execute:@YES];
    
    JHDetailSvgaLoadingView *svgaPlayer = [[JHDetailSvgaLoadingView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH)];
    [self.view insertSubview:svgaPlayer belowSubview:self.jhNavView];
    [svgaPlayer showLoading];
    _svgaPlayer = svgaPlayer;
}

#pragma mark - JXPagingViewDelegate

- (UIView *)tableHeaderViewInPagerView:(JXPagerView *)pagerView {
    return self.headerView;
}

- (NSUInteger)tableHeaderViewHeightInPagerView:(JXPagerView *)pagerView {
    return [JHTopicDetailHeaderView viewHeight];
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
        JHTopicDetailListController *vc = self.vcArray[index];
        vc.viewModel.reqModel.sort = _sort;
        vc.supportEnterVideo = YES;  ///进入支持上下滑动的详情页
        [vc refreshDataBlock:nil];
        vc.appear = YES;
        return vc;
    }
    
    JHTopicDetailListController *vc = [JHTopicDetailListController new];
    vc.viewModel.pageIndex = index;
    vc.supportEnterVideo = YES;  ///进入支持上下滑动的详情页
    return vc;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    CGFloat thresholdDistance = [JHTopicDetailHeaderView viewHeight] - UI.statusAndNavBarHeight;
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
            JHTopicDetailListController *vc = _vcArray[index];
            [vc refreshDataBlock:^{
                @strongify(self);
                [self.headerView dismissLoading];
            }];
        }
    }
    
    if(_lineView)
    {
        _lineView.hidden = !(_headerView && offsetY > [JHTopicDetailHeaderView viewHeight] - UI.statusAndNavBarHeight - 10);
    }
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    ///340埋点 - 点击板块内容分类 滑动和点击事件同时统计
    JHTopicDetailCateModel *model = self.viewModel.detailModel.cate_tabs[index];
    [JHGrowingIO trackEventId:JHTrackSQTopicClassifyClick variables:@{@"topic_id":model.ID,
                                                                  @"page_from":self.pageFrom
    }];
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
    [self gotoPublishMethod];
}

- (void)sortMethod:(NSInteger)sender
{
    _sort = sender + 1;
    for (JHTopicDetailListController *vc in self.vcArray) {
        if(vc.appear)
        {
            vc.viewModel.reqModel.sort = _sort;
            [vc refreshDataBlock:nil];
        }
    }
    
    ///340埋点 - 点击话题排序开关
    NSString *key = (_sort == 1) ? JHTrackSQTopicSortReleaseClick : JHTrackSQTopicSortReplyClick;
    [JHGrowingIO trackEventId:key variables:@{@"topic_id":self.topicId,
                                              @"page_from":self.pageFrom
    }];
}

- (void)searchMethod
{
    /// 340埋点 - 点击话题搜索
    [JHGrowingIO trackEventId:JHTrackSQTopicSearchEnter variables:@{@"topic_id":self.topicId,
                                                                    @"page_from":self.pageFrom
    }];
    ///369神策埋点:点击搜索栏
    [JHTracking trackEvent:@"searchBarClick" property:@{@"page_position":@"话题首页"}];
    
    JHSQSearchViewController * vc =  [[JHSQSearchViewController alloc]init];
    vc.topic_id = self.topicId.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}

///操作弹框
- (void)rightActionButton:(UIButton *)sender{
    /// 340埋点 - 点击话题右上角更多。。。
    [JHGrowingIO trackEventId:JHTrackSQTopicMoreClick variables:@{@"topic_id":self.topicId,
                                                                    @"page_from":self.pageFrom
    }];

    self.postData = [[JHPostData alloc] init];
    self.postData.item_id = self.topicId;
    self.postData.share_info = self.viewModel.detailModel.topic.share_info;
    self.postData.share_info.pageFrom = JHPageFromTypeSQTopicHomeList;
//    更多按钮
    @weakify(self);
     [JHBaseOperationView creatPlateOperationView:self.postData Block:^(JHOperationType operationType) {
         @strongify(self);
        [JHBaseOperationAction operationAction:operationType operationMode:self.postData bolck:^{
        }];
    }];
}

///发帖子
-(void)gotoPublishMethod
{
    JHPublishTopicDetailModel *topic = [JHPublishTopicDetailModel new];
    topic.title = self.viewModel.detailModel.topic.title;
    topic.itemId = self.topicId;
    [JHSQPublishSheetView showPublishSheetViewWithType:1 topic:topic plate:nil addSuperView:self.view];
}


#pragma mark -------- get --------
- (JXCategoryTitleView *)categoryView
{
    if(!_categoryView)
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:3];
        for (JHTopicDetailCateModel *m in self.viewModel.detailModel.cate_tabs) {
            [array addObject:m.name];
        }
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
            make.left.bottom.right.equalTo(self.categoryView);
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

- (JHTopicDetailViewModel *)viewModel
{
    if(!_viewModel)
    {
        _viewModel = [JHTopicDetailViewModel new];
        _viewModel.reqModel.topic_id = self.topicId;
        @weakify(self);
        [_viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            JHTopicDetailInfoModel *m = self.viewModel.detailModel.topic;
            if(m)
            {
                self.title = m.title;
                [self.headerView setImage:m.bg_image title:m.title comment_num:m.comment_num content_num:m.content_num scan_num:m.scan_num];
                [self changeNavStatusHidden:YES];
                [self updateListViewController];
            }
        }];
    }
    return _viewModel;
}

- (JHTopicDetailHeaderView *)headerView
{
    if(!_headerView)
    {
        _headerView = [[JHTopicDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, [JHTopicDetailHeaderView viewHeight])];
    }
    return _headerView;
}

- (NSMutableArray<JHTopicDetailListController *> *)vcArray
{
    if(!_vcArray)
    {
        _vcArray = [NSMutableArray arrayWithCapacity:3];
        for (JHTopicDetailCateModel *m in self.viewModel.detailModel.cate_tabs) {
            JHTopicDetailListController *listvc = [JHTopicDetailListController new];
            listvc.viewModel.reqModel.topic_id = self.topicId;
            listvc.viewModel.reqModel.cate_id = m.ID;
            [_vcArray addObject:listvc];
        }
    }
    return _vcArray;
}

#pragma mark -
#pragma mark - 话题列表停留时长埋点相关

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ///growing埋点：-- 社区话题停留时长 记录进入界面的时间
    _enterTime = [YDHelper get13TimeStamp].longLongValue;
    self.jhStatusBarStyle = UIStatusBarStyleLightContent;
    if(_pagingView) {
        _pagingView.mainTableView.scrollEnabled = YES;
    }
    _popPan = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    ///浏览时长埋点
    [self growingTopicPageBrowse];
    self.jhStatusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_pagingView) {
        _pagingView.mainTableView.scrollEnabled = NO;
    }
    _popPan = NO;
}
//growingIO 埋点：浏览时长
- (void)growingTopicPageBrowse {
    NSTimeInterval outTime = [YDHelper get13TimeStamp].longLongValue;
    NSDate *enterDate = [NSDate dateWithTimeIntervalSince1970:_enterTime];
    NSDate *outDate = [NSDate dateWithTimeIntervalSince1970:outTime];
    NSTimeInterval duration = [outDate timeIntervalSinceDate:enterDate];
    
    ///340埋点 - 板块停留时长
    NSString *userId = [UserInfoRequestManager sharedInstance].user.customerId;
    [JHGrowingIO trackEventId:JHTrackSQTopicBrowseTime variables:@{@"page_from":JHFromSQTopicDetail,
                                                                   @"user_id":userId, @"duration":@(duration)
    }];
}

- (BOOL)mainTableViewGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return self.popPan;
}

@end
