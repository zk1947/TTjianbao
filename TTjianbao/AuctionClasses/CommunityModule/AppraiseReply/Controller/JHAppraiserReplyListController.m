//
//  JHAppraiserReplyListController.m
//  TTjianbao
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAppraiserReplyListController.h"
#import "HJCollectionViewWaterfallLayout.h"
#import "JHDiscoverHomeFlowCollectionCell.h"
#import "JHDiscoverChannelCateModel.h"

#import "JHDiscoverChannelViewModel.h"
#import "JHAppraiseReplyViewModel.h"
#import "JHDiscoverStatisticsModel.h"
#import "JHBuryPointOperator.h"
#import "NSString+LNExtension.h"
#import "JHAppraiseVideoViewController.h"
#import "TTjianbaoBussiness.h"
#import "UIView+Blank.h"
#import "JHSQManager.h"
#import "JHDefaultCollectionViewCell.h"

#define kStatiscGapTime 1000

@interface JHAppraiserReplyListController ()<UICollectionViewDelegate, UICollectionViewDataSource, HJCollectionViewWaterfallLayoutDelegate>{
    RequestModel *resObject;
}
@property(nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL showDefaultImage;
@property (nonatomic, assign) NSInteger page;//collectionView的页数
@property(nonatomic,strong) NSMutableArray<JHDiscoverChannelCateModel *> * dataArray;//collectionview的数据源
@property(nonatomic, strong) NSMutableArray *pubuZaningArr;

@property(nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *originArr;//原始数组，随时插入
@property(nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *waitUploadArr;//等待上传的数据
@property(nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *canUploadArr;//所有满足条件的数据

@property(nonatomic, strong) NSTimer *timer;

@end

@implementation JHAppraiserReplyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeNavView]; //无基类navbar
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, UI.bottomSafeAreaHeight, 0));
    }];
    
    [self setupScrollView:self.collectionView target:self refreshData:@selector(loadNewData) loadMoreData:@selector(loadMoreData)];
    [self loadNewData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //防治webpt动图不播放
    [self.collectionView reloadData];
}


#pragma mark -
#pragma mark - 网络请求

//只有“喜欢”栏目会需要走这个方法
- (void)loadNewData{
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, UI.bottomSafeAreaHeight, 0);
    [self refreshStatics:NO];
    self.page = 1;
    self.collectionView.mj_footer.hidden = NO;
    [self requestInfo:^{
        [self endRefresh];
        [self handleDataWithArr:resObject.data];
    }];
}

#pragma mark - 加载更多相关推荐
- (void)loadMoreData {
    NSLog(@"加载更多相关推荐");
    [self refreshStatics:NO];
    self.page++;
    [self requestInfo:^{
        [self endRefresh];
        [self handleDataWithArr:resObject.data];
    }];
}

-(void)requestInfo:(JHFinishBlock)complete{
    
    //self.channelId  self.labelStr
    [JHAppraiseReplyViewModel getAppraiseContentList:[self.applyType integerValue] page:self.page channelId:[self.channelId integerValue] success:^(RequestModel * _Nonnull request) {
        NSLog(@"request.data = %@", request.data);//request.data[@"content_list"]
        resObject = request;
        complete();
    } failure:^(RequestModel * _Nonnull request) {
        [UITipView showTipStr:request.message];
        //        complete();
        //失败的时候只停止刷新显示失败原因，不刷新collectionview
        [self endRefresh];
    }];
}

//用于第一次请求的完整数据
- (void)handleDataWithArr:(NSArray *)dataArr {
    NSArray *arr = [JHDiscoverChannelCateModel mj_objectArrayWithKeyValuesArray:dataArr];
    
    if (self.page == 1) {
        self.dataArray = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.dataArray addObjectsFromArray:arr];
    }
    
    if (self.dataArray.count==0) {
        self.showDefaultImage=YES;
    }
    else{
        self.showDefaultImage=NO;
    }
    
    if ((self.page > 1 && [arr count] == 0) || self.dataArray.count==0) {
        
        self.collectionView.mj_footer.hidden=YES;
    }
    else{
        
        self.collectionView.mj_footer.hidden=NO;
    }
    [self.collectionView reloadData];
}

- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark -
#pragma mark   ==============UICollectionViewDataSource==============
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.showDefaultImage) {
        return  1;
    }
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHDiscoverHomeFlowCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHDiscoverHomeFlowCollectionCell" forIndexPath:indexPath];
    if (self.showDefaultImage) {
        JHDefaultCollectionViewCell *defaultcell = [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultcell" forIndexPath:indexPath];
        return defaultcell;
    }
    cell.recordMode = self.dataArray[indexPath.item];
    cell.cellIndex=indexPath.row;
    JH_WEAK(self)
    cell.cellClick = ^(BOOL isLaud, NSInteger index) {
        JH_STRONG(self)
        [self clickIndex:index isLaud:isLaud];
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    JHDiscoverChannelCateModel *model = self.dataArray[indexPath.item];
    
    if (model.item_type == JHSQItemTypeArticle) {//鉴定剪辑
        JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
        vc.cateId = model.cate_id;
        vc.appraiseId = model.item_id;
        vc.likeChangedBlock = ^(NSString * _Nonnull likeNum) {
            model.like_num_int = [likeNum integerValue];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
        vc.from = JHFromUndefined;

        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
    } else if (model.item_type == JHPostItemTypeDynamic || model.item_type == JHPostItemTypePost || model.item_type == JHPostItemTypeVideo){
        [JHRouterManager pushPostDetailWithItemType:(JHPostItemType)model.item_type itemId:model.item_id pageFrom:JHFromHomeIdentity scrollComment:0];
    }
}

/**
 可选实现，列表显示的时候调用
 */
- (void)listDidAppear {
    NSLog(@"listDidAppear .....");
    [self addTimer];
}

/**
 可选实现，列表消失的时候调用
 */
- (void)listDidDisappear {
    NSLog(@"listDidDisappear......");
    [self refreshStatics:YES];
}


#pragma mark - CHTCollectionViewDelegateWaterfallLayout
/**
 item size
 */
- (CGSize)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.showDefaultImage) {
        return CGSizeMake(ScreenW, ScreenH - UI.statusAndNavBarHeight - 44);
    }
    JHDiscoverChannelCateModel *model = self.dataArray[indexPath.item];
    return CGSizeMake((ScreenW-25)/2, model.height);
}

/**
 每组单行的排布个数
 */
- (NSInteger)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout columCountAtSection:(NSInteger)section{
    if (self.showDefaultImage) {
        return 1;
    }
    return 2;
}


/**
 每组头部视图的高度
 */
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForHeaderAtSection:(NSInteger)section{
    return 0;
}
/**
 每组尾部视图的高度
 */
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForFooterAtSection:(NSInteger)section{
    return 0;
}

/**
 每组的UIEdgeInsets
 */
- (UIEdgeInsets)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSection:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

/**
 每组的minimumLineSpacing 行与行之间的距离
 */
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSection:(NSInteger)section{
    return 5;
}

/**
 每组的minimumInteritemSpacing 同一行item之间的距离
 */
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSection:(NSInteger)section{
    return 5;
}

- (void)clickIndex:(NSInteger)index isLaud:(BOOL)laud{
    
    if ([self isLgoin]) {
        JHDiscoverChannelCateModel * model =[self.dataArray objectAtIndex:index];
        if ([self.pubuZaningArr containsObject:model.item_id]) {
            return;
        }
        [self.pubuZaningArr addObject:model.item_id];
        if (laud) {
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
        }else {
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
    }
}

-(BOOL)isLgoin{
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                
            }
        }];
        
        return  NO;
    }
    
    return  YES;
}

-(UICollectionView*)collectionView
{
    if (!_collectionView) {
        HJCollectionViewWaterfallLayout *waterfallLayout = [[HJCollectionViewWaterfallLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:waterfallLayout];
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"#f7f7f7"];
        [_collectionView registerClass:[JHDiscoverHomeFlowCollectionCell class] forCellWithReuseIdentifier:@"JHDiscoverHomeFlowCollectionCell"];
        [_collectionView registerClass:[JHDefaultCollectionViewCell class] forCellWithReuseIdentifier:@"defaultcell"];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        waterfallLayout.delegate = self;
        
    }
    return _collectionView;
}

- (NSMutableArray *)pubuZaningArr {
    if (!_pubuZaningArr) {
        _pubuZaningArr = [NSMutableArray array];
    }
    return _pubuZaningArr;
}

- (void)addTimer{
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(uploadStatics) userInfo:nil repeats:YES];
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
    //    NSLog(@"endTimeSp = %f", timeSp);
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
    pointModel.entry_type = 3;
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
    NSLog(@"row =下拉刷新上报埋点鉴定帖回复appstr = %@", appStr);
    pointModel.item_ids = appStr;
    
    //还要取消定时器，开启新定时器
    if (!isDisAppear) {
        [self addTimer];
    }else {
        [self destoryTimer];
    }
}

- (void)uploadStatics {
    //    NSLog(@"定时器响应");
    
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
    pointModel.entry_type = 3;
    pointModel.entry_id = @"0";
    pointModel.time = [NSString stringWithFormat:@"%lld", timeSp];
    
    NSString *appStr = @"";
    //NSLog(@"row = waitUploadArrCount = %ld", self.waitUploadArr.count);
    for (int i = 0; i < self.waitUploadArr.count; i++) {
        JHDiscoverStatisticsModel *staticModel = self.waitUploadArr[i];
        if (i == 0) {
            appStr = staticModel.item_uniq_id;
        }else {
            appStr = [appStr stringByAppendingString:[NSString stringWithFormat:@",%@", staticModel.item_uniq_id]];
        }
    }
    //NSLog(@"appstr = %@", appStr);
    pointModel.item_ids = appStr;
    
    if (![NSString empty:appStr]) {
        NSLog(@"row =定时器上报埋点appstr = %@", appStr);
        [self.waitUploadArr removeAllObjects];
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    
    JHDiscoverChannelCateModel *cateModel = self.dataArray[indexPath.item];
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    //NSLog(@"startTimeSp = %f", timeSp);
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
    
    JHDiscoverStatisticsModel *model = [JHDiscoverStatisticsModel new];
    model.item_uniq_id = cateModel.item_uniq_id;
    model.startTime = timeSp;
    [self.originArr addObject:model];
    //    NSLog(@"willDisplayCell row = %ld, str = %@, origCount = %ld", indexPath.item, model.item_id, self.originArr.count);
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    //比较该cell是否出现超过限制
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    //NSLog(@"endTimeSp = %f", timeSp);
    //NSLog(@"didEndDisplayingCell row = item = %ld,dataArrCount= %ld", indexPath.item, self.dataArray.count);
    
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


#pragma mark -
#pragma mark - JXCategoryListCollectionContentViewDelegate

- (UIView *)listView {
    return self.view;
}

- (void)dealloc {
    NSLog(@"JHAppraiserReplyListController dealloc......");
}

@end
