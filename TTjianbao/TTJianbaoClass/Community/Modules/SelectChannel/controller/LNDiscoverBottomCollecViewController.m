//
//  LNDiscoverBottomCollecViewController.m
//  TTjianbao
//
//  Created by jingxin on 2019/5/12.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "LNDiscoverBottomCollecViewController.h"
#import "JHAnchorHomepageTopView.h"
#import "JHAppraiseVideoViewController.h"
#import "RequestModel.h"
#import "JHDiscoverVideoDetailViewController.h"

#import "JHAppraiseVideoViewController.h"
#import "JHDiscoverChannelViewModel.h"
#import "JHDiscoverChannelCateModel.h"
#import "JHDiscoverHomeFlowCollectionCell.h"
#import "FJWaterfallFlowLayout.h"
#import "ONMessageHeaderView.h"
#import "JHRecommentFocusViewController.h"
#import "JHUserFocusModel.h"
#import "JHDiscoverDetailsVC.h"
#import "LoginViewController.h"
#import "JHDiscoverStatisticsModel.h"
#import "JHBuryPointOperator.h"
#import "NSString+LNExtension.h"
#import "BaseNavViewController.h"
#import "JHTopicDetailController.h"
#import "TTjianbaoUtil.h"
#import "GrowingManager.h"
#import "JHRecommendTopicReusableView.h"
#import "JHDiscoverCateCollectionReusableView.h"
#import "JHDiscoverHeaderCollectionReusableView.h"
#import "CTopicModel.h"
#import "JHLivePlayerManager.h"
#import "JHProxy.h"


//#define kDiscoverHeaderH 310 - 90 - 30
#define kDiscoverHeaderH 187

///推荐 热门话题header的高度
#define kDiscoverTopicHeaderH  148

#define kStatiscGapTime 1000

@interface LNDiscoverBottomCollecViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, FJWaterfallFlowLayoutDelegate>
{
    RequestModel *resObject;
    JHDiscoverHomeFlowCollectionCell *lastCell;
    JHProxy *mProxy; //中转弱化
}
@property (nonatomic, strong) NSMutableArray<JHDiscoverChannelModel *> *channelArray; //频道数据
@property (nonatomic, strong) ONMessageHeaderView *headerUserV;
@property  (nonatomic, strong) UICollectionView *collectionView;
@property  (nonatomic, strong) NSMutableArray<JHDiscoverChannelCateModel *> *dataArray;
@property(nonatomic, strong) NSMutableArray *headerArray;
@property (nonatomic, assign) BOOL viewWillDisappear;
@property (nonatomic, assign) NSInteger page;

@property  (nonatomic, weak) FJWaterfallFlowLayout *customLayout;

@property (nonatomic, assign) BOOL showDefaultImage;

@property(nonatomic, strong) NSString *direction;//拉去方向,0下,1上

@property (nonatomic, assign) BOOL isRequesting;//正在请求数据
@property(nonatomic, strong) NSMutableArray *requestedPage;//记录请求过的页数
@property(nonatomic, strong) NSMutableArray *pubuZaningArr;

@property(nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *originArr;//原始数组，随时插入
@property(nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *waitUploadArr;//等待上传的数据
@property(nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *canUploadArr;//所有满足条件的数据

@property(nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *topicList;

@property (assign) CGFloat topicHeaderHeight;

@end

@implementation LNDiscoverBottomCollecViewController

static NSString *const cellId = @"cellId";

- (void)dealloc {
    [self destoryTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"LNDiscoverBottomCollecViewController dealloc......");
}

#pragma mark - TabBar点击事件
- (void)tabBarSelected {
    if ([self isRefreshing]) {
        return;
    }
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.collectionView.mj_header performSelector:@selector(beginRefreshing) afterDelay:0.3];
}
- (BOOL)isRefreshing {
    if([self.collectionView.mj_header isRefreshing] ||
       [self.collectionView.mj_footer isRefreshing]) {
        return YES;
    }
    return NO;
}

- (instancetype)initWithChannelType:(JHDiscoverChannelType)type{
    if(self = [super init])
    {
        mProxy = [JHProxy alloc];
        mProxy.target = self;
        self.channelModel = [JHDiscoverChannelModel new];
        //注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDeleteAllRecommentUser) name:kRefreshFocucCateNoticeName object:nil];
        
        //重新登录或者注册啥的进入首页
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveDestoryTime) name:kDiscoverHomeRefreshChannelNoticeName object:nil];
        //获取用户频道
        if(type == JHDiscoverChannelTypeRecommend)
        {
            self.channelModel.channel_id = -2;
            self.channelModel.channel_name = @"推荐"; //没什么意义,不显示
            [self requestChannelArray];
        }
    }
    return self;
}

- (instancetype)init{
    
    return [self initWithChannelType:JHDiscoverChannelTypeNone];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    if(self.channelModel.channelType != JHDiscoverChannelTypeRecommend)
    {
        [self setupToolBarWithTitle:self.channelModel.channel_name];
    }
    
    self.direction = @"0";
    self.isRequesting = NO;
    self.topicHeaderHeight = 0;
    
    [self.view addSubview:self.collectionView];
    

//    if(self.channelModel.channelType == JHDiscoverChannelTypeRecommend)
//    {//tab：关注+发现=45？？
////        _collectionView.frame = CGRectMake(0, 0, self.view.width, self.view.height - (StatusBarAddNavigationBarH /*+ 45*/ + JHSafeAreaBottomHeight + 49));
//            self.collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0 /*+ 45*/ + 0, 0, 0, 0));
//    }
//    else
//    {
////        _collectionView.frame = CGRectMake(0, StatusBarAddNavigationBarH, self.view.width, self.view.height - StatusBarAddNavigationBarH);
//            self.collectionView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(44+20 /*+ 45*/ + (iPhoneX_moreThan ? 14.0 : 0), 0, 0, 0));
//    }
    
    [self showBackTopImage];
    [self.backTopImage setHidden:YES];
    [self loadNewData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //防治webpt动图不播放
    [self.collectionView reloadData];
    [self loadCacheDataIfNeeded];
    
    if (self.channelModel.channel_id == -1) {
        //关注列表
        if ([[NSUserDefaults standardUserDefaults] boolForKey:kAppearRedHotKey] == YES) {
            [self.requestedPage removeAllObjects];
            [self loadNewData];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _viewWillDisappear = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _viewWillDisappear = YES;
    [self shutdownPlayStream];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

- (NSMutableArray *)topicList {
    if (!_topicList) {
        _topicList = [NSMutableArray array];
    }
    return _topicList;
}

- (void)receiveDestoryTime {
    [self refreshStatics:YES];
}

- (void)backTop:(UIGestureRecognizer *)gestureRecognizer {
//    CGFloat headerH = 0.0f;
//    JHDiscoverChannelType type = self.channelModel.channelType;
//    if(type == JHDiscoverChannelTypeFocus && self.headerArray.count != 0) {
//        headerH = kDiscoverHeaderH;
//    }
//    if(type == JHDiscoverChannelTypeRecommend && self.topicList.count != 0) {
//        ///推荐
//        headerH = self.topicHeaderHeight;
//    }
    
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat headerH = 0.0f;
    JHDiscoverChannelType type = self.channelModel.channelType;
    if(type == JHDiscoverChannelTypeFocus && self.headerArray.count != 0) {
        headerH = kDiscoverHeaderH;
    }
    else if(self.topicList.count != 0) {
        ///推荐（有分类标签）或分类（无分类标签）
        headerH = self.topicHeaderHeight;
    }
    else if(type == JHDiscoverChannelTypeRecommend){
        headerH = self.topicHeaderHeight; //推荐（无分类标签）
    }
    
    if(scrollView.contentOffset.y>=ScreenH-(StatusBarAddNavigationBarH + 45 + JHSafeAreaBottomHeight + 49 + headerH)) {
        [self.backTopImage setHidden:NO];
    } else {
        [self.backTopImage setHidden:YES];
    }
    
    [self isBeyondArea:scrollView];
}

//删除所有的关注分类里推荐的用户
- (void)receiveDeleteAllRecommentUser {
    [self.headerArray removeAllObjects];
    [self.collectionView reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        
        FJWaterfallFlowLayout *fjWaterfallFlowLayout = [[FJWaterfallFlowLayout alloc] init];
        fjWaterfallFlowLayout.itemSpacing = 5;
        fjWaterfallFlowLayout.lineSpacing = 5;
        fjWaterfallFlowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
        fjWaterfallFlowLayout.colCount = 2;
        self.customLayout = fjWaterfallFlowLayout;
        self.customLayout.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fjWaterfallFlowLayout];
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"#f7f7f7"];
        [_collectionView registerClass:[JHDiscoverHomeFlowCollectionCell class] forCellWithReuseIdentifier:cellId];
        [_collectionView registerClass:[JHDefaultCollectionViewCell class] forCellWithReuseIdentifier:@"defaultcell"];
        
        [_collectionView registerClass:[ONMessageHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"ONMessageHeaderView"];
        
        [_collectionView registerClass:[JHDiscoverHeaderCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHDiscoverHeaderCollectionReusableView class])];
        
        [_collectionView registerClass:[JHRecommendTopicReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHRecommendTopicReusableView class])];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"defaultHeader"];
        
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"defaultFooter"];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.alwaysBounceVertical = YES;
        [self setupScrollView:_collectionView target:self refreshData:@selector(loadNewData) loadMoreData:@selector(loadMoreData)];
        //_collectionView.contentOffset = CGPointZero;
        //_collectionView.mj_header.ignoredScrollViewContentInsetTop = self.collectionView.contentInset.top;
        [self resetCollectionBounds];
    }
    return _collectionView;
    
}

- (void)resetCollectionBounds
{
    if(self.channelModel.channelType == JHDiscoverChannelTypeRecommend)
    {//tab：关注+发现=45？？
        _collectionView.frame = CGRectMake(0, 0, self.view.width, ScreenH - (StatusBarAddNavigationBarH /*+ 45*/ + JHSafeAreaBottomHeight + 40 + 49));
    }
    else
    {
        _collectionView.frame = CGRectMake(0, StatusBarAddNavigationBarH, self.view.width, self.view.height - StatusBarAddNavigationBarH);
    }
}

#pragma mark - request
- (void)loadNewData {
    if (self.isRequesting) {
        return;
    }
    self.direction = @"0";//向下
    [self.requestedPage removeAllObjects];
    [self refreshStatics:NO];
    self.page = 1;
    
    [self requestInfo:^{
        [self endRefresh];
        [self handleDataWithArr:resObject.data[@"content_list"]];
    }];
}

- (void)loadMoreData {
    if (self.isRequesting) {
        return;
    }
    self.direction = @"1";//向上
    self.page++;
    
    [self requestInfo:^{
        [self endRefresh];
        [self handleDataWithArr:resObject.data[@"content_list"]];
    }];
}

- (void)requestInfo:(JHFinishBlock)complete {
    self.isRequesting = YES;
    
    JHDiscoverChannelCateModel *cateModel = _dataArray.lastObject;
    NSLog(@"uniq_id = %@", cateModel.uniq_id);
    
    @weakify(self);
    [JHDiscoverChannelViewModel getChannelCateListWithChannel_id:self.channelModel.channel_id direction:self.direction last_id:(self.page == 1 ? @"0" : self.dataArray.lastObject.uniq_id) page:self.page success:^(RequestModel * _Nonnull request) {
        @strongify(self);
        resObject = request;
        self.isRequesting = NO;
        if (self.channelModel.channelType == JHDiscoverChannelTypeFocus) {
            if (self.page == 1 && resObject.data[@"follow_user_list"]) {
                [self.headerArray removeAllObjects];
                self.headerArray = [NSArray modelArrayWithClass:[JHUserFocusModel class] json:resObject.data[@"follow_user_list"]].mutableCopy;
            }
        }
        else {///推荐
            NSArray *tempArray = [CTopicData mj_objectArrayWithKeyValuesArray:resObject.data[@"topics"]].copy;
            if (tempArray.count != 0)
            {
                self.topicList = tempArray.mutableCopy;
            }
        }
        complete();
        
        [self.requestedPage addObject:@(self.page)];
        
        long lastStampTime = [[[NSUserDefaults standardUserDefaults] objectForKey:kAttentionStampTime] longValue];
        if (self.channelModel.channel_id != -1) {
            if ([request.data[@"attention_flag"] longValue] > lastStampTime) {
                //“关注”显示小红点
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kAppearRedHotKey];
                [[NSNotificationCenter defaultCenter] postNotificationName:kAppearRedHotNoticeName object:nil];
            }
        }else {
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kAppearRedHotKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAppearRedHotNoticeName object:nil];
        }
        
        if ([request.data[@"attention_flag"] longValue] != 0) {
            [[NSUserDefaults standardUserDefaults] setObject:request.data[@"attention_flag"] forKey:kAttentionStampTime];
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            if (self.page == 1) {
                if ([FileUtils writeDataToFile:[NSString stringWithFormat:@"ChannelCateList_%ld", (long)self.channelModel.channel_id] data:[NSJSONSerialization dataWithJSONObject:request.data options:NSJSONWritingPrettyPrinted error:nil]]) {
                    NSLog(@"写入成功");
                }
            }
        });
        
    } failure:^(RequestModel * _Nonnull request) {
        [self endRefresh];
        self.isRequesting = NO;
        [UITipView showTipStr:request.message];
    }];
    
    //埋点
    [Growing track:@"verticalrefresh" withVariable:@{@"value":self.channelModel.channel_name}];
}

- (void)loadCacheDataIfNeeded {
    if (self.dataArray && self.dataArray.count > 0) {
        return;
    }
    
    //开始取缓存数据
    __block  NSDictionary  *dic;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSData *listData = [FileUtils readDataFromFile:[NSString stringWithFormat:@"ChannelCateList_%ld", (long)self.channelModel.channel_id]];
        if (listData) {
            dic = [NSJSONSerialization JSONObjectWithData:listData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"listData dic = %@", dic);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!self.dataArray || self.dataArray.count == 0) {
                self.page = 1;
                [self.headerArray removeAllObjects];
                [self.dataArray removeAllObjects];
                
                if (dic[@"follow_user_list"]) {
                    if ([dic[@"follow_user_list"] isKindOfClass:[NSArray class]]) {
                        self.headerArray = [NSArray modelArrayWithClass:[JHUserFocusModel class] json:dic[@"follow_user_list"]].mutableCopy;
                    }
                }
                
                if ([dic[@"content_list"] isKindOfClass:[NSArray class]]) {
                    NSArray *arr = [NSArray modelArrayWithClass:[JHDiscoverChannelCateModel class] json:dic[@"content_list"]];
                    if (arr.count > 0) {
                        [self handleDataWithArr:dic[@"content_list"]];
                    }
                }
            }
        });
    });
}

- (void)handleDataWithArr:(NSArray *)array {
    NSArray *modelArray = [JHDiscoverChannelCateModel mj_objectArrayWithKeyValuesArray:array];
    
    if (self.page == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:modelArray];
        //开始拉流
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginPullStream) object:nil];
        [self performSelector:@selector(beginPullStream) withObject:nil afterDelay:0.5];
    }else {
        [self.dataArray addObjectsFromArray:modelArray];
    }
    
    self.showDefaultImage = (self.dataArray.count == 0);
    _customLayout.isShowDefaultImage = self.showDefaultImage;
    
    self.collectionView.mj_footer.hidden = [modelArray count] == 0 ? YES : NO;
    
    [self.collectionView reloadData];
}

//获取用户频道
- (void)requestChannelArray {
    @weakify(self);
//    if ([JHRootController isLogin])
    {
        [JHDiscoverChannelViewModel getChannelListWithSuccess:^(RequestModel * _Nonnull request) {
            @strongify(self);
            NSArray *dataArray = [NSArray modelArrayWithClass:[JHDiscoverChannelModel class] json:request.data];
            self.channelArray = [NSMutableArray arrayWithArray:dataArray];
            [self resetCollectionBounds];
            [self.collectionView reloadData];
            
        } failure:^(RequestModel * _Nonnull request) {
            [UITipView showTipStr:request.message];
        }];
        
    }
//    else {
//        //未登录
////        NSMutableArray *deviceChannelList = [self getLocalChannelData:ChannelDeviceFileData];
////        if (deviceChannelList.count > 0) {
////            [self updateChannelList:deviceChannelList];
////        }
//    }
}

#pragma mark - scroll
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.showDefaultImage == NO) {
        NSArray *collecCells = [self.collectionView visibleCells];//JHDiscoverHomeFlowCollectionCell
        [collecCells enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            JHDiscoverHomeFlowCollectionCell *cell = obj;
            cell.disInterestV.hidden = YES;
        }];
    }
}

- (void)addTimer{
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:mProxy selector:@selector(uploadStatics) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
}

- (void)destoryTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//下拉刷新
- (void)refreshStatics:(BOOL)isDisAppear {
    //比较该cell是否出现超过限制
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    
    for (JHDiscoverStatisticsModel *staticModel in self.originArr) {
        //找到相应的item,加入waitUploadArr,canUploadArr,并且从originArr移除
        if (timeSp - staticModel.startTime >= kStatiscGapTime) {
            [self.waitUploadArr addObject:staticModel];
            [self.canUploadArr addObject:staticModel];
        }
    }
    if (!isDisAppear) {
        [self.originArr removeAllObjects];
    }
    
    
    JHBuryPointCommunityArticleModel *pointModel = [JHBuryPointCommunityArticleModel new];
    pointModel.entry_type = 1;
    pointModel.entry_id = @"0";
    pointModel.time = [NSString stringWithFormat:@"%lld", timeSp];
    
    NSString *appStr = @"";
    for (int i = 0; i < self.waitUploadArr.count; i++) {
        JHDiscoverStatisticsModel *staticModel = self.waitUploadArr[i];
        if (i == 0) {
            appStr = staticModel.item_uniq_id;
        }else {
            [appStr stringByAppendingString:[NSString stringWithFormat:@",%@", staticModel.item_uniq_id]];
        }
    }
    NSLog(@"row =下拉刷新上报埋点首页appstr = %@", appStr);
    pointModel.item_ids = appStr;
    
    if (![NSString empty:appStr]) {
        [[JHBuryPointOperator shareInstance] scanCommunityArticleWithModel:pointModel];
        [self.waitUploadArr removeAllObjects];
    }
    //还要取消定时器，开启新定时器
    if (!isDisAppear) {
        [self addTimer];
    }else {
        [self destoryTimer];
    }
}

- (void)uploadStatics {
    //NSLog(@"定时器响应home");
    
    //比较该cell是否出现超过限制
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    //NSLog(@"endTimeSp = %f", timeSp);
    
    NSMutableArray *removeOrignalArr = [NSMutableArray array];
    for (JHDiscoverStatisticsModel *staticModel in self.originArr) {
        //找到相应的item,加入waitUploadArr,canUploadArr,并且从originArr移除
        if (timeSp - staticModel.startTime >= kStatiscGapTime) {
            [self.waitUploadArr addObject:staticModel];
            [self.canUploadArr addObject:staticModel];
            [removeOrignalArr addObject:staticModel];
        }
    }
    [self.originArr removeObjectsInArray:removeOrignalArr];
    
    JHBuryPointCommunityArticleModel *pointModel = [JHBuryPointCommunityArticleModel new];
    pointModel.entry_type = 1;
    pointModel.entry_id = @"0";
    pointModel.time = [NSString stringWithFormat:@"%lld", timeSp];
    
    NSString *appStr = @"";
    //    NSLog(@"row = waitUploadArrCount = %ld", self.waitUploadArr.count);
    for (int i = 0; i < self.waitUploadArr.count; i++) {
        JHDiscoverStatisticsModel *staticModel = self.waitUploadArr[i];
        if (i == 0) {
            appStr = staticModel.item_uniq_id;
        }else {
            appStr = [appStr stringByAppendingString:[NSString stringWithFormat:@",%@", staticModel.item_uniq_id]];
        }
    }
    //    NSLog(@"appstr = %@", appStr);
    pointModel.item_ids = appStr;
    
    if (![NSString empty:appStr]) {
        NSLog(@"row =定时器上报埋点appstr = %@", appStr);
        [[JHBuryPointOperator shareInstance] scanCommunityArticleWithModel:pointModel];
        [self.waitUploadArr removeAllObjects];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    
    JHDiscoverChannelCateModel *cateModel = self.dataArray[indexPath.item];
    NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    //    NSLog(@"startTimeSp = %f", timeSp);
    //判断originArr或者canUploadArr是否存在,存在则不进行任何操作
    for (JHDiscoverStatisticsModel *model in self.canUploadArr) {
        if ([model.item_uniq_id isEqualToString:cateModel.item_uniq_id]) {
            return;
        }
    }
    
    for (JHDiscoverStatisticsModel *model in self.originArr) {
        if ([model.item_uniq_id isEqualToString:cateModel.item_uniq_id]) {
            return;
        }
    }
    
    //记录浏览历史上报API，用于推荐
    if (cateModel.item_type != JHSQItemTypeAD) {
        JHDiscoverStatisticsModel *model = [JHDiscoverStatisticsModel new];
        model.item_uniq_id = cateModel.item_uniq_id;
        model.startTime = timeSp;
        [self.originArr addObject:model];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    //比较该cell是否出现超过限制
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    
    NSMutableArray *removeOrignalArr = [NSMutableArray array];
    if (indexPath.item < self.dataArray.count) {
        JHDiscoverChannelCateModel *cateModel = self.dataArray[indexPath.item];
        
        for (JHDiscoverStatisticsModel *staticModel in self.originArr) {
            if ([staticModel.item_uniq_id isEqualToString:cateModel.item_uniq_id]) {
                //找到相应的item,加入waitUploadArr,canUploadArr,并且从originArr移除
                if (timeSp - staticModel.startTime >= kStatiscGapTime) {
                    [self.waitUploadArr addObject:staticModel];
                    [self.canUploadArr addObject:staticModel];
                }
                [removeOrignalArr addObject:staticModel];
                //                NSLog(@"didEndDisplayingCell row = %ld, str = %@", indexPath.item, staticModel.item_id);
            }
        }
    }
    [self.originArr removeObjectsInArray:removeOrignalArr];
    //    NSLog(@"didEndDisplayingCell row = %ld, cout = %ld", indexPath.item, self.originArr.count);
}

//MARK:UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //    NSLog(@"1111111numberOfItemsInSection......");
    if (self.showDefaultImage) {
        return  1;
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.showDefaultImage) {
        JHDefaultCollectionViewCell *defaultcell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"defaultcell" forIndexPath:indexPath];
        return defaultcell;
    }
    
    JHDiscoverHomeFlowCollectionCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    
    JHDiscoverChannelCateModel *cateModel = self.dataArray[indexPath.item];
    [cell setRecordMode:cateModel];
    cell.cellIndex=indexPath.row;
    if (cateModel.item_type == JHSQItemTypeAD) {
        cell.canDisInterest = NO;
    } else {
        cell.canDisInterest = YES;
    }
    JH_WEAK(self)
    cell.disInterestBlock = ^(JHDiscoverChannelCateModel * _Nonnull recordMode) {
        JH_STRONG(self)
        NSLog(@"点击不感兴趣");
        [JHDiscoverChannelViewModel deleteRecommentUserWithItem_type:recordMode.item_type item_id:recordMode.item_id entry_type:1 entry_id:[NSString stringWithFormat:@"%ld", (long)self.channelModel.channel_id] success:^(RequestModel * _Nonnull request) {
            [self.dataArray removeObject:recordMode];
            [collectionView reloadData];
        } failure:^(RequestModel * _Nonnull request) {
            [SVProgressHUD showErrorWithStatus:@"删除失败"];
        }];
    };
    //点赞按钮的选择
    cell.cellClick = ^(BOOL isLaud, NSInteger index) {
        JH_STRONG(self)
        [self clickIndex:index isLaud:isLaud];
    };
    
    return cell;
}

// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    
    JHDiscoverChannelCateModel *model = self.dataArray[indexPath.item];
    if (model.layout == JHSQLayoutTypeImageText) {
        //图片
        NSLog(@"跳转图文详情。。。。");
        JHDiscoverDetailsVC *vc = [JHDiscoverDetailsVC new];
        vc.cateModel = model;
        vc.item_id = model.item_id;
        vc.item_type = [NSString stringWithFormat:@"%ld", (long)model.item_type];
        vc.entry_type = JHEntryType_SQ_Home;
        vc.entry_id = [NSString stringWithFormat:@"%ld", (long)self.channelModel.channel_id];
        vc.zanBlock = ^(JHDiscoverChannelCateModel * _Nonnull cateModel) {
            //更新当前collectionviewCell
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }else if (model.layout == JHSQLayoutTypeVideo) {
        //视频
        NSLog(@"跳转视频详情。。。。");
        JHDiscoverVideoDetailViewController *vc = [JHDiscoverVideoDetailViewController new];
        vc.cateModel = model;
        vc.item_type = [NSString stringWithFormat:@"%ld", (long)model.item_type];
        vc.item_id = model.item_id;
        vc.entry_type = JHEntryType_SQ_Home;
        vc.entry_id = [NSString stringWithFormat:@"%ld", (long)self.channelModel.channel_id];
        vc.zanStatus = ^(JHDiscoverChannelCateModel * _Nonnull cateModel) {
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
        
        NSLog(@"currentVC.navigationController = %@, jsd_getCurrentViewC = %@", [CommonTool findNearsetViewController:self.view].navigationController, [JHRootController currentViewController]);
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    } else if (model.layout == JHSQLayoutTypeAppraisalVideo ) {
        //鉴定剪辑视频
        JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
        vc.cateId = model.cate_id;
        vc.appraiseId = model.item_id;
        vc.from = JHFromHomeCommunity;
        vc.likeChangedBlock = ^(NSString * _Nonnull likeNum) {
            model.like_num_int = [likeNum integerValue];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    } else if (model.layout == JHSQLayoutTypeAD || model.layout == JHSQLayoutTypeLiveStore) {
        //广告和直播间
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:model.target[@"params"]];
        [params setObject:JHFromHomeCommunity forKey:@"from"];
        [JHRootController toNativeVC:model.target[@"componentName"] withParam:model.target[@"params"] from:JHFromHomeCommunity];
        
    } else if (model.layout == JHSQLayoutTypeTopic) {
        //话题详情
        ///340埋点 - 话题进入事件
        [JHGrowingIO trackEventId:JHTrackSQTopicDetailEnter];

        JHTopicDetailController *vc = [JHTopicDetailController new];
        vc.topicId = model.item_id;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
        //埋点 - 进入话题详情埋点
        [self buryPointWithTopicId:model.item_id];
    }
    
    //埋点
    [Growing track:@"showdetail" withVariable:@{@"value":@([model.sale_tag integerValue])}];
    
    if (model.layout == JHSQLayoutTypeAD && model.item_type == JHSQItemTypeAD) {
        //埋点：社区-文章item-点击普通广告
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:[self growingParamsWithModel:model]];
        [params removeObjectForKey:@"is_can_buy"];
        [params removeObjectForKey:@"is_need_appraise"];
        [params removeObjectForKey:@"publisher_id"];
        [GrowingManager homeArticleItemAdClicked:params];
    }
}

//新增进入话题页埋点
- (void)buryPointWithTopicId:(NSString *)topicId {
    JHBuryPointEnterTopicDetailModel *pointModel = [JHBuryPointEnterTopicDetailModel new];
    pointModel.entry_type = 1;
    pointModel.entry_id = [NSString stringWithFormat:@"%ld", (long)self.channelModel.channel_id];
    pointModel.topic_id = topicId;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    pointModel.time = timeSp;
    [[JHBuryPointOperator shareInstance] enterTopicDetailWithModel:pointModel];
}

#pragma mark - pull stream
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        if (![self isRefreshing]) {
            [self  beginPullStream];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (![self isRefreshing]) {
        [self  beginPullStream];
    }
}

- (void)isBeyondArea:(UIScrollView *)scrollView{
    if (![self isRefreshing]&&lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y<JHNavbarHeight||rect.origin.y+rect.size.height>ScreenH-JHSafeAreaBottomHeight-49) {
            [self shutdownPlayStream];
            lastCell=nil;
        }
    }
}

- (void)shutdownPlayStream{
    [[JHLivePlayerManager sharedInstance ] shutdown];
    lastCell=nil;
}

- (void)doDestroyLastCell{
    lastCell=nil;
}

- (void)beginPullStream{
    if (lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y>=JHNavbarHeight&&rect.origin.y+rect.size.height<=ScreenH-JHSafeAreaBottomHeight-49) {
            return ;
        }
    }
//    if ( ![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
//        return;
//    }
    NSArray* cellArr = [self.collectionView visibleCells];
    cellArr= [self sortbyArr:cellArr];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[JHDiscoverHomeFlowCollectionCell class]])
        {
            JHDiscoverHomeFlowCollectionCell *cell = (JHDiscoverHomeFlowCollectionCell*)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            
            if (!_viewWillDisappear && rect.origin.y >= JHNavbarHeight &&
                rect.origin.y + rect.size.height <= ScreenH - JHSafeAreaBottomHeight-49)
            {
                JHDiscoverChannelCateModel *model = cell.recordMode;
                if([model.rtmp_pull_url length] > 0)
                {
                    [[JHLivePlayerManager sharedInstance ] startPlay:model.rtmp_pull_url inView:cell.coverImage andTimeEndBlock:^{
//                        [[JHLivePlayerManager sharedInstance ] shutdown];
//                        lastCell=nil;
                    }];
                    lastCell=cell;
                    break;
                }
//                break;
            }
        }
    }
}

- (NSArray *)sortbyArr:(NSArray *)array{
    
    NSArray *sorteArray = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        JHDiscoverHomeFlowCollectionCell *cell1 = (JHDiscoverHomeFlowCollectionCell *)obj1;
        JHDiscoverHomeFlowCollectionCell *cell2 = (JHDiscoverHomeFlowCollectionCell *)obj2;
        CGRect rect1 = [cell1 convertRect:cell1.bounds toView:[UIApplication sharedApplication].keyWindow];
        CGRect rect2 = [cell2 convertRect:cell2.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect1.origin.y > rect2.origin.y) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (rect1.origin.y < rect2.origin.y){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
        
    }];
    return sorteArray;
}

#pragma mark -
#pragma mark - FJWaterfallFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath {
    if (self.showDefaultImage) {
        return ScreenH - StatusBarAddNavigationBarH - 45 - (JHSafeAreaBottomHeight + 49);
    }else {
        JHDiscoverChannelCateModel *model = self.dataArray[indexPath.item];
        //广告不展示title、名字和点赞数
        if (model.layout == JHSQLayoutTypeAD ||
            model.layout == JHSQLayoutTypeTopic) {
            return model.picHeight;
        } else {
            return model.height;
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    JHDiscoverChannelType type = self.channelModel.channelType;
    if (type == JHDiscoverChannelTypeFocus && self.headerArray.count != 0) {
        return CGSizeMake(ScreenW, kDiscoverHeaderH);
    }
    if(self.topicList.count != 0)
    {
        NSInteger lineNumber = (self.topicList.count + self.topicList.count % 2)/2;
        if (type == JHDiscoverChannelTypeRecommend) {
            ///50+15+28+10(num*(cellHeight+space)+15(top+bottom)+28(热门话题高度)
            CGFloat headerHeight = JHRecommendTopicHeight(lineNumber) + kDiscoverCateCollectionViewHeight;
            self.topicHeaderHeight = headerHeight;
            return CGSizeMake(ScreenW, headerHeight);
        }
        else //普通分类和求鉴定
        {
            CGFloat headerHeight = JHRecommendTopicHeight(lineNumber) - 28; //隐藏热门话题
            self.topicHeaderHeight = headerHeight;
            return CGSizeMake(ScreenW, headerHeight);
        }
    }
    else if (type == JHDiscoverChannelTypeRecommend)
    {
        CGFloat headerHeight = kDiscoverCateCollectionViewHeight + 5;
        self.topicHeaderHeight = headerHeight;
        return CGSizeMake(ScreenW, headerHeight);
    }

    return CGSizeMake(ScreenW, 5);//CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JHDiscoverChannelType channelType = self.channelModel.channelType;
        if (channelType == JHDiscoverChannelTypeFocus && self.headerArray.count != 0) {
            //关注
            static NSString *identifer = @"ONMessageHeaderView";
            ONMessageHeaderView *heardV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifer forIndexPath:indexPath];
            heardV.visitorRecordArray = self.headerArray;
            heardV.cateModel = self.channelModel;
            self.headerUserV = heardV;
            heardV.jumpBlock = ^{
                [[JHRootController currentViewController].navigationController pushViewController:[JHRecommentFocusViewController new] animated:YES];
            };
            return heardV;
        }
        if(self.topicList.count != 0)
        {
            if (channelType == JHDiscoverChannelTypeRecommend) {
                ///推荐
                JHDiscoverHeaderCollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHDiscoverHeaderCollectionReusableView class]) forIndexPath:indexPath];
                [cell updateCateData:self.channelArray topicData:self.topicList.copy];

                return cell;
            }
            else  //普通分类和求鉴定
            {
                JHRecommendTopicReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHRecommendTopicReusableView class]) forIndexPath:indexPath];
                [cell updateTopicList:self.topicList.copy hideHotTitle:YES];
                return cell;
            }
        }
        else if (channelType == JHDiscoverChannelTypeRecommend){
            ///推荐
            JHDiscoverHeaderCollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHDiscoverHeaderCollectionReusableView class]) forIndexPath:indexPath];
            [cell updateCateData:self.channelArray topicData:self.topicList.copy];

            return cell;
        }

        ///默认header
        UICollectionReusableView *heardV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"defaultHeader" forIndexPath:indexPath];
        return heardV;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"defaultFooter" forIndexPath:indexPath];
        return footer;
    }
    
    return nil;
}

- (BOOL)isLgoin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) { }];
        return  NO;
    }
    return  YES;
}

//点击喜欢图标 isLaud:是否已点赞，1-yes
- (void)clickIndex:(NSInteger)index isLaud:(NSInteger)laud{
    
    JHDiscoverChannelCateModel *model =[self.dataArray objectAtIndex:index];
    
    if (![JHRootController isLogin]) {
        LoginViewController * loginVc = [[LoginViewController alloc]init];
        BaseNavViewController *loginNav = [[BaseNavViewController alloc]initWithRootViewController:loginVc];
        [loginNav setNavigationBarHidden:YES];
        [[JHRootController currentViewController].navigationController presentViewController:loginNav animated:YES completion:nil];
    } else {
        if (laud == 1) {
            [self cancleLikeItem:model andLaud:laud index:index];
            //埋点：社区首页 - 文章item - 取消点赞
            [GrowingManager homeArticleItemUnLike:[self growingParamsWithModel:model]];
            
        }else {
            [self likeItem:model andLaud:laud index:index];
            //埋点：社区首页 - 文章item - 点赞
            [GrowingManager homeArticleItemLike:[self growingParamsWithModel:model]];
        }
    }
}

- (void)likeItem:(JHDiscoverChannelCateModel *)model andLaud:(NSInteger)laud  index:(NSInteger)index {
    if ([self.pubuZaningArr containsObject:model.item_id]) {
        return;
    }
    [self.pubuZaningArr addObject:model.item_id];
    //瀑布流点赞
    [JHDiscoverChannelViewModel likeItemWithItemid:model.item_id item_type:model.item_type itemLikeCount:model.like_num_int success:^(RequestModel * _Nonnull request) {
        [self.pubuZaningArr removeObject:model.item_id];
        model.like_num = [NSString stringWithFormat:@"%@", request.data[@"like_num"]];
        model.like_num_int = [request.data[@"like_num_int"] integerValue];
        model.is_like = 1;
        
        JHDiscoverHomeFlowCollectionCell *cell =(JHDiscoverHomeFlowCollectionCell*) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell beginAnimation:model];
        
    } failure:^(RequestModel * _Nonnull request) {
        [self.pubuZaningArr removeObject:model.item_id];
        [UITipView showTipStr:request.message];
    }];
}

- (void)cancleLikeItem:(JHDiscoverChannelCateModel *)model andLaud:(NSInteger)laud index:(NSInteger)index{
    if ([self.pubuZaningArr containsObject:model.item_id]) {
        return;
    }
    [self.pubuZaningArr addObject:model.item_id];
    //瀑布流点赞
    [JHDiscoverChannelViewModel cancleLikeItemWithItemid:model.item_id item_type:model.item_type itemLikeCount:model.like_num_int success:^(RequestModel * _Nonnull request) {
        [self.pubuZaningArr removeObject:model.item_id];
        
        model.like_num = [NSString stringWithFormat:@"%@", request.data[@"like_num"]];
        model.like_num_int = [request.data[@"like_num_int"] integerValue];
        model.is_like = 0;
        
        JHDiscoverHomeFlowCollectionCell *cell =(JHDiscoverHomeFlowCollectionCell*) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [cell beginAnimation:model];
        
    } failure:^(RequestModel * _Nonnull request) {
        [self.pubuZaningArr removeObject:model.item_id];
        [UITipView showTipStr:request.message];
    }];
}

- (NSMutableArray *)headerArray {
    if (!_headerArray) {
        _headerArray = [NSMutableArray array];
    }
    return _headerArray;
}

- (NSMutableArray *)requestedPage {
    if (!_requestedPage) {
        _requestedPage = [NSMutableArray array];
    }
    return _requestedPage;
}

- (NSMutableArray *)pubuZaningArr {
    if (!_pubuZaningArr) {
        _pubuZaningArr = [NSMutableArray array];
    }
    return _pubuZaningArr;
}

- (NSMutableArray *)originArr {
    if (!_originArr) {
        _originArr = [NSMutableArray array];
    }
    return _originArr;
}

- (NSMutableArray *)waitUploadArr {
    if (!_waitUploadArr) {
        _waitUploadArr = [NSMutableArray array];
    }
    return _waitUploadArr;
}

- (NSMutableArray *)canUploadArr {
    if (!_canUploadArr) {
        _canUploadArr = [NSMutableArray array];
    }
    return _canUploadArr;
}

//广告的判断条件： item_type=6 & layout=4

- (NSDictionary *)growingParamsWithModel:(JHDiscoverChannelCateModel *)model {
    NSString *titleStr = model.title;
    if (![titleStr isNotBlank]) {
        titleStr = model.content;
    }
    if (titleStr.length > 10) {
        titleStr = [titleStr substringToIndex:9];
    }
    
    NSDictionary *params = @{@"userId" : [NSString stringWithFormat:@"%ld", (long)model.publisher.user_id],
                             @"time" : @([[YDHelper get13TimeStamp] longLongValue]),
                             @"channel_id" : @(_channelModel.channel_id),
                             @"channel_name" : _channelModel.channel_name,
                             @"item_id" : model.item_id,
                             @"item_type" : @(model.item_type),
                             @"resource_type" : @(model.layout),
                             @"title" : titleStr,
                             @"is_can_buy" : @(model.is_can_buy),
                             @"is_need_appraise" : @(model.is_need_appraise),
                             @"publisher_id" : @(model.publisher.user_id)
    };
    return params;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
