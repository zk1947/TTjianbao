//
//  JHMallListViewController.m
//  TTjianbao
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHMallListViewController.h"
#import "JHMallTableViewCell.h"
#import "JHMallSmallCollectionViewCell.h"
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
#define LittleCellRate (192./250.f)

@interface JHMallListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    NSInteger PageNum;
    NSArray* rootArr;
    JHLiveRoomMode * selectLiveRoom;
    JHMallTableViewCell  *lastCell;
    
}
@property (nonatomic, assign)BOOL isBig;
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *dataModes;
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *watchTrackModes;
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *followModes;
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *recommendModes;
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *liveRoomModes;
@property(nonatomic,strong) NSMutableArray <JHMallSectionModel *> *sectionModes;
@property(nonatomic,assign) NSInteger currentSelectIndex;
@property (nonatomic,assign)  BOOL viewDisAppear;
@property  (nonatomic, strong) UICollectionViewFlowLayout *customLayout;

@end

@implementation JHMallListViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewDisAppear=NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.viewDisAppear=YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isBig = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCellSize:) name:JHNotificationNameChangeMallCellSize object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToListShow) name:JHNotificationNameScrollMallTopEnd object:nil];    
    
}
- (void)getRecommandData
{
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/getChannelRecommend?pageNo=%ld&pageSize=%ld"),0,pagesize];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self makeDataWithArr:respondObject.data];
        [self endRefresh];
    }
                   failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        
    }];
}
- (void)makeDataWithArr:(NSArray *)array
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginPullSteam) object:nil];
    [self performSelector:@selector(beginPullSteam) withObject:nil afterDelay:0.5];
    NSArray *arr = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:array];
    self.dataModes = [NSMutableArray arrayWithArray:arr];
    self.recommendModes=[self.dataModes mutableCopy];
    JHMallSectionModel *mode = [JHMallSectionModel new];
    mode.sectionType = JHMallSectionTypeRecommend;
    [self getLiveRoomDetail:self.recommendModes andSectionType:mode];


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
                    mode2.listFromType=JHGestureChangeLiveRoomFromFollowList;
                    if (self.sectionModes.count==2) {
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
    
    if ([_groupId isEqualToString:@"50"]) {
        self.groupWatchTrack=YES;
    }
    
    self.sectionModes=[NSMutableArray arrayWithCapacity:10];
    if (self.groupWatchTrack) {
        JHMallSectionModel *mode3=[[JHMallSectionModel alloc]init];
        mode3.sectionType=JHMallSectionTypeRecommend;
        mode3.listFromType=JHGestureChangeLiveRoomFromRecommendList;
        [self.sectionModes addObject:mode3];
    }
    
    else{
        JHMallSectionModel *mode1=[[JHMallSectionModel alloc]init];
        mode1.sectionType=JHMallSectionTypeMallGroup;
        mode1.listFromType=JHGestureChangeLiveRoomFromMallGroupList;
        [self.sectionModes addObject:mode1];
    }
    
}
- (void)loadData {
    if (self.groupWatchTrack) {
        [self requestWatchTrack];
        [self requestMyFollow];
        if (self.recommendModes.count==0) {
            [self loadNewData];
        }
        else{
            [self beginPullSteam];
        }
    }
    else{
        if (!self.liveRoomModes || self.liveRoomModes.count == 0) {
            [self loadNewData];
        }
        else{
            [self beginPullSteam];
        }
    }
    
}
-(void)refreshData{
    
    if (self.groupWatchTrack) {
        [self requestWatchTrack];
        [self requestMyFollow];
    }
    [self loadNewData];
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
    if (mode.sectionType==JHMallSectionTypeMallGroup) {
        return self.liveRoomModes.count;
    }
    
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHMallSectionModel *mode=self.sectionModes[indexPath.section];
    
    if (mode.sectionType==JHMallSectionTypeWatchTrack) {
        JHMallWatchTrackTableViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallWatchTrackTableViewCell class]) forIndexPath:indexPath];
        cell.watchTrackModes =self.watchTrackModes;
        return cell;
    }
    
    NSArray * dataArr;
    if (mode.sectionType==JHMallSectionTypeFollow){
        dataArr=self.followModes;
    }
    else if (mode.sectionType==JHMallSectionTypeRecommend){
        dataArr=self.recommendModes;
    }
    else if (mode.sectionType==JHMallSectionTypeMallGroup){
        dataArr=self.liveRoomModes;
    }
    
    if (_isBig) {
        JHMallTableViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallTableViewCell class]) forIndexPath:indexPath];
        cell.liveRoomMode = dataArr[indexPath.row];
        return cell;
    }else {
        JHMallSmallCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallSmallCollectionViewCell class]) forIndexPath:indexPath];
        cell.liveRoomMode = dataArr[indexPath.row];
        
        return cell;
        
    }
    
}

#pragma mark - UICollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMallSectionModel *mode=self.sectionModes[indexPath.section];
    if (mode.sectionType==JHMallSectionTypeWatchTrack) {
        return CGSizeMake(ScreenW, [JHMallWatchTrackTableViewCell cellHeight]);
    }
    if (_isBig) {
        CGFloat w = (ScreenW - 10);
        return CGSizeMake(w, w/BigCellRate);
        
    }else {
        CGFloat w = (ScreenW - 25)/2.;
        
        return CGSizeMake(w, w/LittleCellRate);
    }
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
        return  UIEdgeInsetsMake(0, 10, 5, 10);
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
                [self.navigationController pushViewController:vc animated:YES];
            };
            return headerView;
            
            
        }
    }
    if (mode.sectionType==JHMallSectionTypeFollow){
        if([kind isEqual:UICollectionElementKindSectionHeader]){
            JHMallFollowHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([JHMallFollowHeader class]) forIndexPath:indexPath];
            //  headerView.backgroundColor=[UIColor redColor];
            return headerView;
        }
    }
    if (mode.sectionType==JHMallSectionTypeRecommend){
        if([kind isEqual:UICollectionElementKindSectionHeader]){
            JHRecommendHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([JHRecommendHeader class]) forIndexPath:indexPath];
            //  headerView.backgroundColor=[UIColor redColor];
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
#pragma mark - Getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 5;
        flowLayout.minimumLineSpacing =self.isBig?10:5;
        //   flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 5, 10);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        self.customLayout = flowLayout;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //解决categoryView在吸顶状态下，且collectionView的显示内容不满屏时，出现竖直方向滑动失效的问题
        _collectionView.alwaysBounceVertical = YES;
        //        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"#F5F6FA"];
        
        [_collectionView registerClass:[JHMallTableViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallTableViewCell class])];
        [_collectionView registerClass:[JHMallSmallCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallSmallCollectionViewCell class])];
        
        [_collectionView registerClass:[JHMallWatchTrackTableViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallWatchTrackTableViewCell class])];
        
        [_collectionView registerClass:[JHRecommendHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHRecommendHeader class])];
        [_collectionView registerClass:[JHWatchTrackHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHWatchTrackHeader class])];
        [_collectionView registerClass:[JHMallFollowHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHMallFollowHeader class])];
        
        JH_WEAK(self)
        _collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadMoreData];
        }];
        _collectionView.mj_footer.hidden=YES;
        
        
    }
    return _collectionView;
}
#pragma mark - 
-(void)loadNewData{
    
    PageNum=0;
    [self shutdownPlayStream];
    [self requestInfo];
    
}
-(void)loadMoreData{
    
    PageNum++;
    [self requestInfo];
}
-(void)requestInfo{
    if (self.groupWatchTrack) {
        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/getChannelRecommend?pageNo=%ld&pageSize=%ld"),PageNum,pagesize];
        [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
            [self handleDataWithArr:respondObject.data];
            [self endRefresh];
        }
                       failureBlock:^(RequestModel *respondObject) {
            [UITipView showTipStr:respondObject.message];
            
        }];
    }
    else{
        
        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/sellByGroup?pageNo=%ld&pageSize=%ld&groupId=%@"),PageNum,pagesize,self.groupId];
        [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
            [self handleDataWithArr:respondObject.data ];
            [self endRefresh];
        }
                       failureBlock:^(RequestModel *respondObject) {
            [UITipView showTipStr:respondObject.message];
            
        }];
    }
    
}

- (void)handleDataWithArr:(NSArray *)array {
    
    NSArray *arr = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.dataModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.dataModes addObjectsFromArray:arr];
    }
    if (self.groupWatchTrack) {
        self.recommendModes=[self.dataModes mutableCopy];
    }
    else{
        self.liveRoomModes=[self.dataModes mutableCopy];
    }
    
    [self.collectionView reloadData];
    
    if ([arr count]<pagesize) {
        
        self.collectionView.mj_footer.hidden=YES;
    }
    else{
        self.collectionView.mj_footer.hidden=NO;
    }
    
    if (PageNum==0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginPullSteam) object:nil];
        [self performSelector:@selector(beginPullSteam) withObject:nil afterDelay:0.5];
    }
    if (!self.groupWatchTrack){
        if (self.liveRoomModes.count) {
            [self hiddenDefaultImage];
        }else{
            [self showDefaultImageWithView:self.collectionView];
        }
    }
    
}
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshingWithCompletionBlock:^{
    }];
    [self.collectionView.mj_footer endRefreshing];
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHMallSectionModel *mode=self.sectionModes[indexPath.section];
    NSArray * dataArr;
    if (mode.sectionType==JHMallSectionTypeFollow){
        dataArr=self.followModes;
    }
    else if (mode.sectionType==JHMallSectionTypeRecommend){
        dataArr=self.recommendModes;
    }
    else if (mode.sectionType==JHMallSectionTypeMallGroup){
        dataArr=self.liveRoomModes;
    }
    selectLiveRoom=dataArr[indexPath.row];
    self.currentSelectIndex=indexPath.row;
    
    if([selectLiveRoom.canCustomize isEqualToString:@"1"]){
        if(selectLiveRoom.status.intValue == 2){
            [self shutdownPlayStream];
            [self getLiveRoomDetail:dataArr andSectionType:mode];
        }else{
            //定制直播间跳定制主页(直播购物)
            JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
            vc.roomId = selectLiveRoom.roomId;
            vc.anchorId = selectLiveRoom.anchorId;
            vc.channelLocalId = selectLiveRoom.channelLocalId;
            vc.fromSource = @"page_create";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self shutdownPlayStream];
        [self getLiveRoomDetail:dataArr andSectionType:mode];
    }
}
-(void)getLiveRoomDetail:(NSArray*)dataArr andSectionType:(JHMallSectionModel*)sectionMode{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(selectLiveRoom.ID)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        
        if ([channel.status integerValue]==2)
        {
            
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.channel=channel;
            vc.coverUrl = selectLiveRoom.coverImg;
            vc.fromString = JHLiveFromhomeMarket;
            
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
            vc.PageNum=PageNum;
            vc.groupId=self.groupId;
            vc.listFromType=sectionMode.listFromType;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
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
            vc.fromString = JHLiveFromhomeMarket;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
}
#pragma mark -
- (void)changeCellSize:(NSNotification *)noti {
    BOOL b = [noti.object boolValue];//yes 是小图 no 是大图
    self.isBig = !b;
    self.customLayout.minimumLineSpacing =self.isBig?10:5;
    [self.collectionView reloadData];
    if (self.isBig) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(beginPullSteam) object:nil];
        [self performSelector:@selector(beginPullSteam) withObject:nil afterDelay:0.1];
    }
    else{
        [self shutdownPlayStream];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [super scrollViewDidScroll: scrollView];
    [self isBeyondArea:scrollView];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        if (![self isRefreshing]) {
            [self  beginPullSteam];
            //            [self scrollToListShow];
            
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (![self isRefreshing]) {
        [self  beginPullSteam];
        [self scrollToListShow];
    }
}

-(void)isBeyondArea:(UIScrollView *)scrollView{
    if (![self isRefreshing]&&lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y<UI.statusAndNavBarHeight||rect.origin.y+rect.size.height>ScreenH-UI.bottomSafeAreaHeight-49) {
            [self shutdownPlayStream];
            lastCell=nil;
        }
    }
}
-(BOOL)isRefreshing{
    
    if ([self.collectionView.mj_header isRefreshing]||self.collectionView.mj_header.state== MJRefreshStatePulling||[self.collectionView.mj_footer isRefreshing]||self.collectionView.mj_footer.state== MJRefreshStatePulling) {
        
        return YES;
    }
    return NO;
}
-(NSArray *)sortbyArr:(NSArray *)array{
    
    NSArray *sorteArray = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        JHMallTableViewCell *cell1=(JHMallTableViewCell *)obj1;
        JHMallTableViewCell *cell2=(JHMallTableViewCell *)obj2;
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

-(NSArray *)sortbyCollectionArr:(NSArray *)array{
    
    NSArray *sorteArray = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        JHMallSmallCollectionViewCell *cell1=(JHMallSmallCollectionViewCell *)obj1;
        JHMallSmallCollectionViewCell *cell2=(JHMallSmallCollectionViewCell *)obj2;
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
    
    if ( !self.isBig) {
        return;
    }
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
    cellArr= [self sortbyArr:cellArr];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[JHMallTableViewCell class]])
        {
            JHMallTableViewCell *cell=(JHMallTableViewCell *)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            //  NSLog(@"坐标====%@  cell=%@",NSStringFromCGRect(rect),cell.liveRoomMode.watchTotal);
            if (rect.origin.y>=UI.statusAndNavBarHeight&&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49) {
                if (cell.liveRoomMode.ID!=lastCell.liveRoomMode.ID&&[cell.liveRoomMode.status integerValue]==2&&!self.viewDisAppear) {
                    //   JH_WEAK(self)
                    //    NSLog(@"拉流%@",cell.liveRoomMode.watchTotal);
                    [[JHLivePlayerManager sharedInstance] startPlay:cell.liveRoomMode.rtmpPullUrl inView:cell.content andTimeEndBlock:^{
                        [[JHLivePlayerManager sharedInstance] shutdown];
                        lastCell=nil;
                    }];
                    lastCell=cell;
                }
                
                break;
            }
        }
    }
}
-(void)shutdownPlayStream{
    [[JHLivePlayerManager sharedInstance] shutdown];
    lastCell=nil;
}
-(void)beginPullSteam{
    [self pullStream];
    //    [self scrollToListShow];
}
-(void)doDestroyLastCell{
    lastCell=nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 引导

- (void)scrollToListShow {
    if ([self isRefreshing]) {
        return;
    }
    
    if ([JHRootController tabBarSelectedIndex] != 1) {
        return;
    }
    
    if (!self.isBig) {
        if ([CommHelp isFirstForName:@"GuideMarketList"])
        {
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            BOOL isShow = NO;
            NSArray *array = [self.collectionView visibleCells];
            array= [self sortbyCollectionArr:array];
            for (int i = 0; i < array.count; i++) {
                UIView *cell = array[i];
                //                    CGRect rect = [self.collectionView convertRect:cell.frame toView:JHKeyWindow];
                
                //                    CGRect rect1 = [self.view convertRect:self.collectionView.frame toView:JHKeyWindow];
                //                    CGRect rect2 = rect1;
                //                    rect2.size.height = ScreenH-(rect1.origin.y+UI.tabBarHeight);
                //                    if (CGRectContainsRect(rect2, rect))
                CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
                if (rect.origin.y>=UI.statusAndNavBarHeight&&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49)
                {
                    CGRect cellFrame = cell.frame;
                    cellFrame.origin.x = 10;
                    [JHNewGuideTipsView showGuideWithType:JHTipsGuideTypeSellMarket transparencyRect:[self.collectionView convertRect:cellFrame toView:JHKeyWindow] superView:JHRootController.homeTabController.view];
                    isShow = YES;
                    break;
                    
                }
            }
            
            if (!isShow) {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"GuideMarketList"];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
            
            //            });
            
        }
    }
    
}

@end
