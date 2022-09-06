//
//  JHMallTrackView.m
//  TTjianbao
//
//  Created by lihui on 2020/12/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallTrackView.h"
#import "JHMallTrackViewController.h"
#import "JHMallCateModel.h"
#import "JHMallListViewController.h"
#import "JHMallTableViewCell.h"
#import "JHMallLittleCollectionViewCell.h"
#import "NTESAudienceLiveViewController.h"
#import "ChannelMode.h"
#import "MBProgressHUD.h"
#import "JHMallSectionModel.h"
#import "JHMallWatchTrackTableViewCell.h"
#import "JHRecommendHeader.h"
#import "JHWatchTrackHeader.h"
#import "JHMallFollowHeader.h"
#import "SourceMallApiManager.h"
#import "JHMallGroupConditionController.h"
#import "JHNewGuideTipsView.h"
#import "JHCustomerInfoController.h"

#define pagesize 10
#define BigCellRate (394./250.f)
#define LittleCellRate (171./249.f)

@interface JHMallTrackView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    NSInteger PageNum;
    NSArray* rootArr;
    JHLiveRoomMode * selectLiveRoom;
    JHMallLittleCollectionViewCell  *lastCell;
    
}
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *dataModes;
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *watchTrackModes;
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *followModes;
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *recommendModes;
//@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *liveRoomModes;
@property(nonatomic,strong) NSMutableArray <JHMallSectionModel *> *sectionModes;
@property(nonatomic,assign) NSInteger currentSelectIndex;
@property  (nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@property (nonatomic, copy)NSString *groupId;
@property (nonatomic, copy)NSString *groupName;
@property (nonatomic, copy) void (^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) NSMutableArray * uploadData;
@end

@implementation JHMallTrackView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithChannelInfo:(JHMallCateModel *)model {
    self = [super init];
    if (self) {
        self.channelModel = model;
        self.groupId = self.channelModel.Id;
        self.groupName = self.channelModel.name;
        [self creatUI];
    }
    return self;
}


- (void)creatUI {
   
    self.backgroundColor = [CommHelp toUIColorByStr:@"#F5F6FA"];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self regCollectionViewCell];
    [self loadData];
}

- (void)refreshData {
    [self loadData];
}
- (void)requestWatchTrack{
    [SourceMallApiManager getMallMyWatchTrackCompletion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            self.watchTrackModes=[NSMutableArray arrayWithCapacity:10];
            self.watchTrackModes = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:respondObject.data];
            
            __block BOOL isContain=NO;
            __block  NSUInteger index=-1;
            [self.sectionModes enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                JHMallSectionModel *mode=(JHMallSectionModel*)obj;
                if (mode.sectionType == JHMallSectionTypeWatchTrack) {
                    isContain=YES;
                    index=idx;
                    *stop = YES;
                }
            }];
            if (self.watchTrackModes.count>0) {
                if (!isContain) {
                    JHMallSectionModel *mode2=[[JHMallSectionModel alloc]init];
                    mode2.sectionType=JHMallSectionTypeWatchTrack;
                    mode2.listFromType=JHGestureChangeLiveRoomFromWatchTrackList;
                    [self.sectionModes insertObject:mode2 atIndex:0];
                }
            }
            else{
                if (isContain){
                    [self.sectionModes removeObjectAtIndex:index];
                }
            }
            
            [self.collectionView  reloadData];
        }
    }];
}
- (void)requestMyFollow{
    [SourceMallApiManager getMallMyAttentonCompletion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            self.followModes=[NSMutableArray arrayWithCapacity:10];
            self.followModes = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:respondObject.data];
            __block BOOL isContain=NO;
            __block  NSUInteger index=-1;
            [self.sectionModes enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                JHMallSectionModel *mode=(JHMallSectionModel*)obj;
                if (mode.sectionType == JHMallSectionTypeFollow) {
                    isContain=YES;
                    index=idx;
                    *stop = YES;
                }
            }];
            if (self.followModes.count>0) {
                if (!isContain) {
                    JHMallSectionModel *mode2=[[JHMallSectionModel alloc]init];
                    mode2.sectionType=JHMallSectionTypeFollow;
                    mode2.listFromType=JHGestureChangeLiveRoomFromFollowList;                 if (self.sectionModes.count==2) {
                        [self.sectionModes insertObject:mode2 atIndex:1];
                    }
                    else{
                        [self.sectionModes insertObject:mode2 atIndex:0];
                    }
                }
            }
            else{
                if (isContain){
                    [self.sectionModes removeObjectAtIndex:index];
                }
            }
            
            [self.collectionView  reloadData];
        }
    }];
}

-(void)setGroupId:(NSString *)groupId{
    
    _groupId=groupId;
    
    self.sectionModes=[NSMutableArray arrayWithCapacity:10];
    JHMallSectionModel *mode3=[[JHMallSectionModel alloc]init];
    mode3.sectionType=JHMallSectionTypeRecommend;
    mode3.listFromType=JHGestureChangeLiveRoomFromRecommendList;
    [self.sectionModes addObject:mode3];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return self.sectionModes.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JHMallSectionModel *mode=self.sectionModes[section];
    if (mode.sectionType==JHMallSectionTypeWatchTrack) {
        return 1;
    }
    if (mode.sectionType==JHMallSectionTypeFollow) {
        
        return self.followModes.count;
    }
    if (mode.sectionType==JHMallSectionTypeRecommend) {
        
        return self.recommendModes.count;
    }
    
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHMallSectionModel *mode=self.sectionModes[indexPath.section];
    
    if (mode.sectionType==JHMallSectionTypeWatchTrack) {
        JHMallWatchTrackTableViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallWatchTrackTableViewCell class]) forIndexPath:indexPath];
        
        /* hutao修改 */
        NSArray *sWatchTracks = [NSArray new];
        int NUM = 20;
        if (self.watchTrackModes.count > NUM)
        {
            sWatchTracks = [self.watchTrackModes subarrayWithRange:NSMakeRange(0, NUM)];
        }
        else
        {
            sWatchTracks = [[NSArray alloc] initWithArray:self.watchTrackModes];
        }
        
        NSMutableArray *array = [NSMutableArray  new];
        [array addObjectsFromArray:sWatchTracks];
        cell.watchTrackModes = array;
        
        //cell.watchTrackModes =self.watchTrackModes;
        
        return cell;
    }
    
    NSArray * dataArr;
    if (mode.sectionType==JHMallSectionTypeFollow){
        dataArr=self.followModes;
    }
    else if (mode.sectionType==JHMallSectionTypeRecommend){
        dataArr=self.recommendModes;
    }
    
    JHMallLittleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class]) forIndexPath:indexPath];
    cell.liveRoomMode = dataArr[indexPath.row];
    
    return cell;
        
}

#pragma mark - UICollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMallSectionModel *mode=self.sectionModes[indexPath.section];
    if (mode.sectionType==JHMallSectionTypeWatchTrack) {
        return CGSizeMake(ScreenW, [JHMallWatchTrackTableViewCell cellHeight]);
    }
     CGFloat w = (ScreenW - 33)/2.;
    return CGSizeMake(w, w/LittleCellRate);
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    JHMallSectionModel *mode=self.sectionModes[section];
    if (mode.sectionType==JHMallSectionTypeWatchTrack) {
        return  UIEdgeInsetsMake(0, 0, 0, 0);
    }
    else{
        return  UIEdgeInsetsMake(0, 12, 5, 12);
    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    JHMallSectionModel *mode=self.sectionModes[indexPath.section];
    if (mode.sectionType==JHMallSectionTypeWatchTrack){
        if([kind isEqual:UICollectionElementKindSectionHeader]){
            JHWatchTrackHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([JHWatchTrackHeader class]) forIndexPath:indexPath];
            JH_WEAK(self)
            headerView.buttonClick = ^{
                JH_STRONG(self)
                JHMallGroupConditionController * vc=[[JHMallGroupConditionController alloc]init];
                vc.type=1;
                vc.dataArray=self.watchTrackModes;
                [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            };
            return headerView;
            
            
        }
    }
    if (mode.sectionType==JHMallSectionTypeFollow){
        if([kind isEqual:UICollectionElementKindSectionHeader]){
            JHMallFollowHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([JHMallFollowHeader class]) forIndexPath:indexPath];
            return headerView;
        }
    }
    if (mode.sectionType == JHMallSectionTypeRecommend){
        if([kind isEqual:UICollectionElementKindSectionHeader]){
            JHRecommendHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([JHRecommendHeader class]) forIndexPath:indexPath];
            headerView.title=@"大家都在关注";
            return headerView;
        }
    }
    
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    JHMallSectionModel *mode=self.sectionModes[section];
    if (mode.sectionType==JHMallSectionTypeMallGroup){
        return CGSizeMake(0, 0);
    }
    return CGSizeMake(ScreenW, 46);
}
- (void )regCollectionViewCell {

        [self.collectionView registerClass:[JHMallLittleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class])];
        
        [self.collectionView registerClass:[JHMallWatchTrackTableViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallWatchTrackTableViewCell class])];
        
        [self.collectionView registerClass:[JHRecommendHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHRecommendHeader class])];
        [self.collectionView registerClass:[JHWatchTrackHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHWatchTrackHeader class])];
        [self.collectionView registerClass:[JHMallFollowHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHMallFollowHeader class])];
}
#pragma mark -
- (void)refreshData:(NSInteger)currentIndex {
    [self loadData];
//    [self srollToTop];
//       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//           [self.collectionView.mj_header beginRefreshing];
//       });
//    [self srollToTop];
//    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadData {
    [self shutdownPlayStream];
    [self requestWatchTrack];
    [self requestMyFollow];
    [self loadNewData];
    
    //用户画像埋点
    [JHUserStatistics noteEventType:kUPEventTypeLiveHomeTabEntrance params:nil];
}
-(void)loadNewData {
    PageNum = 0;
    [self requestInfo];
}
- (void)loadMoreData {
    [self requestInfo];
}
- (void)requestInfo {
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/getChannelRecommend?pageNo=%ld&pageSize=%ld"),PageNum,pagesize];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self handleDataWithArr:respondObject.data];
        [self endRefresh];
        PageNum++;
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        
    }];
    
}

- (void)handleDataWithArr:(NSArray *)array {
    
    NSArray *arr = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.dataModes = [NSMutableArray arrayWithArray:arr];
    }else {
        JHLiveRoomMode *m1 = arr.lastObject;
        JHLiveRoomMode *m2 = self.dataModes.lastObject;
        if(m1.title && m2.title && ![m1.title isEqualToString:m2.title])
        [self.dataModes addObjectsFromArray:arr];
    }
    
    self.recommendModes=[self.dataModes mutableCopy];
    
    [self.collectionView reloadData];
    
    if ([arr count]<pagesize) {
        
        self.collectionView.mj_footer.hidden=YES;
    }
    else{
        self.collectionView.mj_footer.hidden=NO;
    }
    
    if (PageNum==0) {
        [self beginPullSteam];
    }
    
}
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshingWithCompletionBlock:^{
    }];
    [self.collectionView.mj_footer endRefreshing];
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(8.0)){
    NSLog(@"-----------==========");
    JHLiveRoomMode *model = self.dataModes[indexPath.item];
    NSString * strtemp = [NSString stringWithFormat:@"%@",model.channelLocalId];
    if (![self.uploadData containsObject:strtemp]) {
        [self.uploadData addObject:strtemp];
        if (self.uploadData.count>=10) {
            NSMutableArray * temp = [self.uploadData mutableCopy];
            [self sa_uploadData:temp];
            [self.uploadData removeAllObjects];
        }
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMallSectionModel *mode=self.sectionModes[indexPath.section];
    NSArray * dataArr;
    if (mode.sectionType==JHMallSectionTypeFollow){
        dataArr=self.followModes;
    }
    else if (mode.sectionType==JHMallSectionTypeRecommend){
        dataArr=self.recommendModes;
    }
    selectLiveRoom=dataArr[indexPath.row];
    self.currentSelectIndex=indexPath.row;
    if ([selectLiveRoom.canCustomize isEqualToString:@"1"]){
//        //定制直播间跳定制主页(属于直播购物)
//        JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
//        vc.roomId = selectLiveRoom.roomId;
//        vc.anchorId = selectLiveRoom.anchorId;
//        vc.channelLocalId = selectLiveRoom.channelLocalId;
//        vc.fromSource = JHLiveFromLiveRoom;
//        [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
        ///369神策埋点:直播间点击
        [self sa_trackCustomizerClick:indexPath.item];
        
        [JHRootController EnterLiveRoom:selectLiveRoom.channelLocalId fromString:JHLiveFromLiveRoom isStoneDetail:NO isApplyConnectMic:NO];
    }else{
        [self shutdownPlayStream];
        [self getLiveRoomDetail:dataArr andSectionType:mode selectIndex:indexPath.item];
    }
}

- (void)sa_trackCustomizerClick:(NSInteger)index {
    JHTrackLiveRoomModel *model = [[JHTrackLiveRoomModel alloc] init];
    model.page_position = @"直播购物";
    model.channel_id = NONNULL_STR(selectLiveRoom.roomId);
    model.channel_name = NONNULL_STR(selectLiveRoom.title);
    model.anchor_id = NONNULL_STR(selectLiveRoom.anchorId);
    model.anchor_nick_name = NONNULL_STR(selectLiveRoom.anchorName);
    model.channel_local_id = NONNULL_STR(selectLiveRoom.channelLocalId);
    model.first_channel = @[@"关注"];
    model.position_sort = @(index);
    [JHTracking trackClickLiveRoom:model];
}

-(void)getLiveRoomDetail:(NSArray*)dataArr andSectionType:(JHMallSectionModel*)sectionMode selectIndex:(NSInteger)selectIndex {
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(selectLiveRoom.ID)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        channel.first_channel = @"关注";
        [JHTracking sa_clickLiveRoomList:channel pagePosition:@"直播购物" currentIndex:@(selectIndex).stringValue];
        
        if ([channel.status integerValue]==2)
        {
            
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.channel=channel;
            vc.coverUrl = selectLiveRoom.coverImg;
            vc.groupId = self.channelModel.Id;
            vc.entrance = @"0";
            //我的关注
            if (sectionMode.sectionType == JHMallSectionTypeFollow) {
                self.currentSelectIndex=0;
                NSMutableArray * channelArr=[dataArr mutableCopy];
                for (JHLiveRoomMode * mode in dataArr) {
                    if ([mode.status integerValue]!=2) {
                        [channelArr removeObject:mode];
                    }
                }
                [channelArr enumerateObjectsUsingBlock:^(JHLiveRoomMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj.ID isEqual:channel.channelLocalId]) {
                        self.currentSelectIndex=idx;
                        * stop=YES;
                    }
                }];
                vc.currentSelectIndex=self.currentSelectIndex;
                vc.channeArr=channelArr;
            }
            //TODO 大家关注 传类型
           else if (sectionMode.sectionType == JHMallSectionTypeRecommend) {
                 vc.entrance = @"1";
            }
           
            vc.PageNum=PageNum;
            vc.listFromType=sectionMode.listFromType;
            [self setLiveRoomParamsForVC:vc];
//            [self.navigationController pushViewController:vc animated:YES];
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
            
            
        }
        else  if ([channel.status integerValue]==1||[channel.status integerValue]==0||[channel.status integerValue]==3){
            
            NSString *string = nil;
            if (channel.status.integerValue == 1) {
                string = channel.lastVideoUrl;
            }
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
            vc.channel = channel;
            vc.coverUrl = selectLiveRoom.coverImg;
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            [self setLiveRoomParamsForVC:vc];
            
            [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
//            [self.navigationController pushViewController:vc animated:YES];
        }
        
        [MBProgressHUD hideHUDForView:self animated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    [self isBeyondArea:scrollView];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        
        [self  pullStream];
        [self scrollToListShow];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self  pullStream];
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}

- (void)scrollViewDidEndScroll {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
}

-(void)isBeyondArea:(UIScrollView *)scrollView{
    if (lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y<UI.statusAndNavBarHeight||rect.origin.y+rect.size.height>ScreenH-UI.bottomSafeAreaHeight-49) {
            [self shutdownPlayStream];
            lastCell=nil;
        }
    }
}

-(NSArray *)sortbyCollectionArr:(NSArray *)array{
    
    NSArray *sorteArray = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        JHMallLittleCollectionViewCell *cell1=(JHMallLittleCollectionViewCell *)obj1;
        JHMallLittleCollectionViewCell *cell2=(JHMallLittleCollectionViewCell *)obj2;
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

-(void)pullStream{
    
    if (lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y>=UI.statusAndNavBarHeight&&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49) {
            return ;
        }
    }
    //    if ( ![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
    //        return;
    //    }
    NSArray* cellArr = [self.collectionView visibleCells];
    cellArr= [self sortbyCollectionArr:cellArr];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[JHMallLittleCollectionViewCell class]])
        {
            JHMallLittleCollectionViewCell *cell=(JHMallLittleCollectionViewCell *)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            //  NSLog(@"坐标====%@  cell=%@",NSStringFromCGRect(rect),cell.liveRoomMode.watchTotal);
            if (rect.origin.y>=UI.statusAndNavBarHeight&&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49) {
                if (cell.liveRoomMode.ID!=lastCell.liveRoomMode.ID&&[cell.liveRoomMode.status integerValue]==2) {
                    [[JHLivePlayerManager sharedInstance] startPlay:cell.liveRoomMode.rtmpPullUrl inView:cell.content andTimeEndBlock:^{
                    } isAnimal:YES isLikeImageView:YES];
                    lastCell=cell;
                    break;
                }
                
              
            }
        }
    }
}
-(void)shutdownPlayStream{
    [[JHLivePlayerManager sharedInstance] shutdown];
    lastCell=nil;
}
-(void)beginPullSteam{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pullStream) object:nil];
    [self performSelector:@selector(pullStream) withObject:nil afterDelay:0.5];
//    [self scrollToListShow];
}

- (void)setLiveRoomParamsForVC:(NTESAudienceLiveViewController*)vc
{
    vc.fromString = JHLiveFromhomeMarketEverybodyAttention;  //大家关注：everybody_attention
    vc.groupId = self.groupId;
}

#pragma mark - 引导

- (void)scrollToListShow {
   
    if ([JHRootController tabBarSelectedIndex] != 1) {
        return;
    }
    
    if ([CommHelp isFirstForName:@"GuideMarketList"])
    {
        NSArray *array = [self.collectionView visibleCells];
        array= [self sortbyCollectionArr:array];
        for (int i = 0; i < array.count; i++) {
            UIView *cell = array[i];
            if ( [cell isKindOfClass:[JHMallLittleCollectionViewCell class]]) {
                
                CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
                if (rect.origin.y>=UI.statusAndNavBarHeight+40&&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49)
                {
                    CGRect cellFrame = cell.frame;
                    cellFrame.origin.x = 10;
                    [JHNewGuideTipsView showGuideWithType:JHTipsGuideTypeSellMarket transparencyRect:[self.collectionView convertRect:cellFrame toView:JHKeyWindow] superView:JHRootController.homeTabController.view];
                    break;
                    
                }
                
            }
        }
        
    }
    
}
-(void)srollToTop{
    
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];
    
}
-(void) backTop:(UIGestureRecognizer *)gestureRecognizer{
    
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark -
#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listViewLoadDataIfNeeded {
    
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
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"#F5F6FA"];
        JH_WEAK(self)
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            JH_STRONG(self)
           [self loadData];
        }];
        _collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadMoreData];
        }];
        _collectionView.mj_footer.hidden = YES;
        
    }
    return _collectionView;
}

- (NSMutableArray *)uploadData{
    if (!_uploadData) {
        _uploadData = [NSMutableArray array];
    }
    return _uploadData;
}
- (void)sa_uploadData:(NSMutableArray *)array{
    [JHTracking trackEvent:@"ep" property:@{@"page_position":@"源头直购首页",@"model_name":@"卖场直播间标签列表",@"res_type":@"直播间feeds",@"tab_name":self.groupName,@"item_list":array}];
}
- (void)changeCategaryUpLoad{
    if (self.uploadData.count > 0) {
        
        NSMutableArray * temp = [self.uploadData mutableCopy];
        [self sa_uploadData:temp];
        [self.uploadData removeAllObjects];
    }
}
@end

