//
//  JHLivingShoppingView.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import "JHLivingShoppingView.h"
#import "JHMallRecommendViewController.h"
#import "JHMallLittleCollectionViewCell.h"
#import "JHMallRecommendAdCell.h"
#import "JHMallIntroduceCell.h"
#import "JHMallSpecialAreaCell.h"
#import "JHLiveRoomMode.h"
#import "JHMallCateModel.h"
#import "JHRefreshGifHeader.h"
#import "BannerMode.h"
#import <MBProgressHUD.h>
#import "UIView+Blank.h"
#import "JHLivePlayerManager.h"
#import "NTESAudienceLiveViewController.h"
#import "JHNewGuideTipsView.h"

#import "TTJianBaoColor.h"

#define LittleCellRate (171./249.f)

@interface JHLivingShoppingView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate>
{
    JHLiveRoomMode *selectLiveRoom;
    JHMallLittleCollectionViewCell *lastCell;
}
@property (nonatomic, copy) void (^scrollCallback)(UIScrollView *scrollView);
@property  (nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray <JHLiveRoomMode *>*dataModes;


@end

@implementation JHLivingShoppingView

- (void)dealloc {
    NSLog(@"%s被释放了----", __func__);
}

- (NSMutableArray<JHLiveRoomMode *> *)dataModes {
    if (!_dataModes) {
        _dataModes = [NSMutableArray array];
    }
    return _dataModes;
}

- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:array];
    if (self.page == 0) {
        self.dataModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.dataModes addObjectsFromArray:arr];
    }
    [self.collectionView reloadData];
    
    if ([arr count] < self.pageSize) {
        self.collectionView.mj_footer.hidden = YES;
    }
    else{
        self.collectionView.mj_footer.hidden = NO;
    }
    ///如果是页数为1 拉流
    if (self.page == 0) {
        [self beginPullSteam];
    }
    
    [self showBlankView:self.dataModes.count];
}

- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

- (void)setGroupId:(NSString *)groupId {
    _pageSize = 20;
    _groupId = groupId;
    
    self.dataModes = [NSMutableArray new];
    
    [self performSelector:@selector(requestInfo) withObject:nil afterDelay:0.2];
    
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _page = 0;
        _pageSize = 20;
        [self initViews];
        
        self.backgroundColor = BACKGROUND_COLOR;
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark -
#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return _collectionView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self isBeyondArea:scrollView];
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
}

- (void)scrollViewDidEndScroll {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
}

- (void)isBeyondArea:(UIScrollView *)scrollView {
    if (![self isRefreshing] && lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y<UI.statusAndNavBarHeight || rect.origin.y + rect.size.height > ScreenH-UI.bottomSafeAreaHeight-49) {
            [self shutdownPlayStream];
            lastCell = nil;
        }
    }
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listViewLoadDataIfNeeded {
    //NSLog(@"curChannelId = %ld", (long)_curChannelData.channel_id);
//    if (_curModel.isFirstReq || _curModel.list.count == 0) {
//        [self getGoodsList];
//    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataModes.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    JHLiveRoomMode *m = self.dataModes[indexPath.row];
    JHMallLittleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class]) forIndexPath:indexPath];
    cell.liveRoomMode = m;
    
    return cell;
}

#pragma mark - UICollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (ScreenW - 33.f)/2.;
    return CGSizeMake(w, w/LittleCellRate);
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(10, 12, 10, 12);
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self shutdownPlayStream];
    ///选择别的cell时停止拉流
    JHLiveRoomMode *m = self.dataModes[indexPath.row];
    if(m.type == 1) {
        [JHRootController toNativeVC:m.target.vc withParam:m.target.params from:JHFromHomeSourceBuy];
    }
    else {
        [self getLiveRoomDetail:m selectIndex:indexPath.item];
    }
//    page_position
//    model_type
//    channel_status
//    channel_name
//    channel_label
//    anchor_id
//    anchor_nick_name
//    channel_local_id
    
    NSDictionary *dic = @{
        @"page_position":NONNULL_STR(self.channelName),
        @"model_type":@"分类列表页",
        @"channel_status":[m.status intValue]==2?@"是":@"否",
        @"channel_name":NONNULL_STR(m.anchorName),
        @"channel_label":NONNULL_STR(self.text),
        @"anchor_id":NONNULL_STR(m.anchorId),
        @"channel_local_id":NONNULL_STR(m.channelLocalId),
        @"anchor_nick_name":NONNULL_STR(m.anchorName)
    };
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"channelClick" params:dic type:JHStatisticsTypeSensors];
    
    NSLog(@"channelClick埋点参数%@",dic);
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate){
        if (![self isRefreshing]) {
            [self pullStream];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![self isRefreshing]) {
        [self  pullStream];
    }
}

- (void)getLiveRoomDetail:(JHLiveRoomMode *)liveInfo selectIndex:(NSInteger)selectIndex {
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(liveInfo.ID)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        channel.first_channel = self.channelName;
        channel.second_channel = self.text;
        ///369神策埋点:直播间点击
//        [JHTracking sa_clickLiveRoomList:channel pagePosition:@"直播购物金刚位分类页" currentIndex:@(selectIndex).stringValue];
        
        if ([channel.status integerValue] == 2)
        {
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.channel = channel;
            vc.coverUrl = liveInfo.coverImg;
            vc.groupId = self.groupId;
            vc.entrance = @"0";
            vc.PageNum = self.page;
            vc.listFromType = JHGestureChangeLiveRoomFromMallGroupList;
            [self setLiveRoomParamsForVC:vc];
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }
        else  if ([channel.status integerValue] == 1 || [channel.status integerValue] == 0 || [channel.status integerValue] == 3){
            NSString *string = nil;
            if (channel.status.integerValue == 1) {
                string = channel.lastVideoUrl;
            }
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
            vc.channel = channel;
            vc.coverUrl = liveInfo.coverImg;
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            [self setLiveRoomParamsForVC:vc];
            [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        }
        
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failureBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        [UITipView showTipStr:respondObject.message?:@"网络请求失败"];
    }];
}
- (void)setLiveRoomParamsForVC:(NTESAudienceLiveViewController*)vc
{
//    vc.fromString = JHLiveFromhomeMarketTabSecondLabel; //标签、活动、【二级标签】：tab_secend_label
//    vc.third_tab_from = self.thiredTabModel.name ? : @"";
//    vc.groupId = self.groupId;
}

- (void)loadMoreData {
    [self shutdownPlayStream];
    self.page ++;
    [self requestInfo];
}

- (void)requestInfo {
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/sellByGroup?pageNo=%ld&pageSize=%ld&groupId=%@"),self.page,self.pageSize,self.groupId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self endRefresh];
         [self handleDataWithArr:respondObject.data];
       
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        [self endRefresh];
        [self showBlankView:self.dataModes.count];
    }];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 9;
        flowLayout.minimumLineSpacing = 9;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
         self.customLayout = flowLayout;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = BACKGROUND_COLOR;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[JHMallLittleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class])];
        @weakify(self);
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self);
            [self refreshData];
        }];
        _collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            @strongify(self);
            [self loadMoreData];
        }];
        _collectionView.mj_footer.hidden = YES;
    }
    return _collectionView;
}

- (void)showBlankView:(NSInteger)count {
    if (count == 0) {
        [self showDefaultImageWithView:self];
    }
}

- (void)pullStream {
    if (lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y >= UI.statusAndNavBarHeight && rect.origin.y + rect.size.height <= ScreenH-UI.bottomSafeAreaHeight-49) {
            return ;
        }
    }
    //    if ( ![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
    //        return;
    //    }
    NSArray* cellArr = [self.collectionView visibleCells];
    cellArr = [self sortbyCollectionArr:cellArr];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[JHMallLittleCollectionViewCell class]])
        {
            JHMallLittleCollectionViewCell *cell = (JHMallLittleCollectionViewCell *)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            //  NSLog(@"坐标====%@  cell=%@",NSStringFromCGRect(rect),cell.liveRoomMode.watchTotal);
            if (rect.origin.y >= UI.statusAndNavBarHeight && rect.origin.y+rect.size.height <= ScreenH-UI.bottomSafeAreaHeight-49) {
                
                NSLog(@"status====%@",cell.liveRoomMode.status);
                if (cell.liveRoomMode.ID != lastCell.liveRoomMode.ID &&
                    [cell.liveRoomMode.status integerValue] == 2) {
                    [[JHLivePlayerManager sharedInstance] startPlay:cell.liveRoomMode.rtmpPullUrl inView:cell.content andTimeEndBlock:^{} isAnimal:YES isLikeImageView:YES];
                    lastCell = cell;
                    break;
                }
            }
        }
    }
}

- (void)shutdownPlayStream {
    [[JHLivePlayerManager sharedInstance] shutdown];
    lastCell = nil;
}
- (void)beginPullSteam {
     [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pullStream) object:nil];
     [self performSelector:@selector(pullStream) withObject:nil afterDelay:0.5];
}

- (NSArray *)sortbyCollectionArr:(NSArray *)array {
    
    NSArray *sorteArray = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        JHMallLittleCollectionViewCell *cell1 = (JHMallLittleCollectionViewCell *)obj1;
        JHMallLittleCollectionViewCell *cell2 = (JHMallLittleCollectionViewCell *)obj2;
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

-(BOOL)isRefreshing {
    if ([self.collectionView.mj_header isRefreshing]||self.collectionView.mj_header.state== MJRefreshStatePulling||[self.collectionView.mj_footer isRefreshing]||self.collectionView.mj_footer.state== MJRefreshStatePulling) {
        
        return YES;
    }
    return NO;
}

- (UIView *)listView {
    return self.collectionView;
}

@end
