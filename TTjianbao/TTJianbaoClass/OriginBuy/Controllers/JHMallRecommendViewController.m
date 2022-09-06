//
//  JHMallRecommendViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallRecommendViewController.h"
#import "JHMallLittleCollectionViewCell.h"
#import "ChannelMode.h"
#import "SourceMallApiManager.h"
#import "JHNewGuideTipsView.h"
#import "NTESAudienceLiveViewController.h"
#import "JHLivePlayerManager.h"
#import "JHMallIntroduceCell.h"
#import "JHMallRecommendHeader.h"
#import "JHMallSpecialAreaCell.h"
#import "JHMallOperationModel.h"
#import "MBProgressHUD.h"
#import "JHCustomerInfoController.h"
#import "JHQiYuVIPCustomerServiceManager.h"

#define pagesize 10
#define LittleCellRate (192./250.f)

#define kCycleViewH (ScreenW*210/375 + 34)

@interface JHMallRecommendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    NSInteger PageNum;
    JHLiveRoomMode * selectLiveRoom;
    JHMallLittleCollectionViewCell *lastCell;
    BOOL needSetData;
}
///推荐页面的头部
@property (nonatomic, strong) JHMallRecommendHeader *cycleHeader;
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *dataModes;
@property(nonatomic,assign) NSInteger currentSelectIndex;
@property  (nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@property(nonatomic,strong) JHMallOperationModel *mallOperationModel;
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)NSString *orderCount;
@property(nonatomic,strong) UIView *lastCycleView;
@property(nonatomic,assign) NSInteger cycleViewH;

@end

@implementation JHMallRecommendViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    /// 七鱼VIP客服相关
//    [self loadQiYuInfo];
    //用户画像埋点
    [JHUserStatistics noteEventType:kUPEventTypeLiveShopGroupBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin, @"group1_id" : self.groupId ? : @""}];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    /// 用户画像埋点
    [JHUserStatistics noteEventType:kUPEventTypeLiveShopGroupBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd, @"group1_id" : self.groupId ? : @""}];
}

- (void)loadQiYuInfo {
    [[JHQiYuVIPCustomerServiceManager shared] loadQiYuInfo:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    _cycleViewH = kCycleViewH;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
     [self.view bringSubviewToFront:self.backTopImage];
    [self regCollectionViewCell];
   // [self.view bringSubviewToFront:self.backTopImage];
   //  self.groupId = @"0";
     self.isAutoScroll = YES;
     [self loadData];
}

-(void)regCollectionViewCell{
    
    [self.collectionView addSubview:self.cycleHeader];
    [self.collectionView registerClass:[JHMallLittleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class])];
    [self.collectionView registerClass:[JHMallIntroduceCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallIntroduceCell class])];
    [self.collectionView registerClass:[JHMallSpecialAreaCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallSpecialAreaCell class])];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewIdentifer"];
}

#pragma mark -

-(void)refreshData:(NSInteger)currentIndex {
    [self srollToTop];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.mj_header beginRefreshing];
    });
   
}
-(void)loadData{
    
       [self shutdownPlayStream];
       [self requestSpecianAreaInfo];
       [self requestOrderCount];
       [self loadNewData];
    
    //用户画像埋点
    [JHUserStatistics noteEventType:kUPEventTypeLiveHomeTabEntrance params:nil];
}
-(void)loadNewData{
    
     PageNum=0;
    [self requestInfo];
    
}
-(void)loadMoreData {
    [self requestInfo];
}
-(void)requestInfo{
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/sellByGroup?pageNo=%ld&pageSize=%ld&groupId=%@"),PageNum,pagesize,self.groupId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self.collectionView.mj_footer endRefreshing];
         [self handleDataWithArr:respondObject.data ];
        PageNum++;
    }
        failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        [self.collectionView.mj_footer endRefreshing];
    }];
}

-(void)requestSpecianAreaInfo {
    [SourceMallApiManager getMallCustomSpecialAreaCompletion:^(RequestModel *respondObject, NSError *error) {
        [self.collectionView.mj_header endRefreshing ];
        if (!error) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                needSetData = YES;
                self.mallOperationModel = [JHMallOperationModel mj_objectWithKeyValues:respondObject.data];
                self.cycleHeader.liveRoomData = self.mallOperationModel.slideShow;
                self.cycleHeader.hidden = !(self.cycleHeader.liveRoomData.count>1);
                self.cycleViewH = self.cycleHeader.liveRoomData.count > 1 ? kCycleViewH : 0;
                [self.collectionView reloadData];
            });
        }
        else {
            needSetData = YES;
            self.cycleHeader.hidden = YES;
            self.cycleViewH = 0;
            [self.collectionView reloadData];
        }
    }];
}
/// 获取为宝友把关数量
- (void)requestOrderCount {
    [SourceMallApiManager requestOrderCountBlock:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            self.orderCount =respondObject.data;
            [self.collectionView reloadData];
        }
    }];
}
- (void)handleDataWithArr:(NSArray *)array {
    
    NSArray *arr = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.dataModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.dataModes addObjectsFromArray:arr];
    }
    [self.collectionView reloadData];
    
    if ([arr count]<pagesize) {
        
        self.collectionView.mj_footer.hidden=YES;
    }
    else{
        self.collectionView.mj_footer.hidden=NO;
    }
    
}
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 3;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==0) {
        return [self.orderCount isNotBlank] ? 1 : 0;
    }
    if (section==1) {
        return self.mallOperationModel.operationPosition.count > 0 ? 1 : 0;
    }
    return self.dataModes.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0) {
        JHMallIntroduceCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallIntroduceCell class]) forIndexPath:indexPath];
        if (needSetData) {
            [cell setOrderCount:self.orderCount];
        }
        return cell;
    }
    if (indexPath.section==1) {
        JHMallSpecialAreaCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallSpecialAreaCell class]) forIndexPath:indexPath];
        if (self.mallOperationModel.operationPosition.count>0) {
            if (needSetData) {
            [cell setSpecialAreaModes:[self.mallOperationModel.operationPosition mutableCopy]];
             needSetData = NO;
            }
        }
       
        return cell;
      }
    if (indexPath.section==2) {
        NSArray *  dataArr=self.dataModes;
        JHMallLittleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class]) forIndexPath:indexPath];
        cell.liveRoomMode = dataArr[indexPath.row];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - UICollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return [JHMallIntroduceCell viewSize];
    }
    if (indexPath.section == 1) {
        NSInteger count = self.mallOperationModel.operationPosition.count;
        if (count == 0) {
              return CGSizeMake(ScreenW, 1);
        }
        return CGSizeMake(ScreenW, self.mallOperationModel.height);
       // return CGSizeMake(ScreenW, count*100+10*(count-1));
    }
      
    CGFloat w = (ScreenW - 25)/2.;
    return CGSizeMake(w, w/LittleCellRate);
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return  UIEdgeInsetsMake(0, 10, 0, 10);
    }
    if (section == 1) {
        return UIEdgeInsetsMake(10, 10, 0, 10);
    }
    return  UIEdgeInsetsMake(10, 10, 10, 10);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&
        [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewIdentifer" forIndexPath:indexPath];
        return header;
    }
    
    return [UICollectionReusableView new];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if([UserInfoRequestManager sharedInstance].hiddenHomeSaleTips)
        {
            return CGSizeMake(ScreenW, self.cycleViewH - 10); //V342暂时隐藏
        }
        else
        {
            return CGSizeMake(ScreenW, self.cycleViewH);
        }
    }
    return CGSizeZero;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectLiveRoom = self.dataModes[indexPath.row];
    self.currentSelectIndex = indexPath.row;
    
    if([selectLiveRoom.canCustomize isEqualToString:@"1"]){
        if(selectLiveRoom.status.intValue == 2){
            [self shutdownPlayStream];
            [self getLiveRoomDetail:selectLiveRoom.ID andListType:JHGestureChangeLiveRoomFromMallGroupList];
        }else{
            //定制直播间跳定制主页(本类没用到)
            JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
            vc.roomId = selectLiveRoom.roomId;
            vc.anchorId = selectLiveRoom.anchorId;
            vc.channelLocalId = selectLiveRoom.channelLocalId;
            vc.fromSource = @"";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self shutdownPlayStream];
        [self getLiveRoomDetail:selectLiveRoom.ID andListType:JHGestureChangeLiveRoomFromMallGroupList];
    }
    [JHGrowingIO trackEventId:JHMarketListItemClick variables: @{@"channelLocalId":selectLiveRoom.ID,@"index":@(indexPath.row),@"second_tabname":self.groupName}];
}







-(void)getLiveRoomDetail:(NSString*)Id andListType:(JHGestureChangeLiveRoomFromType)listType{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(Id)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        
        if ([channel.status integerValue]==2)
        {
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.channel=channel;
            vc.coverUrl = selectLiveRoom.coverImg;
            self.currentSelectIndex=0;
            
            if (listType == JHGestureChangeLiveRoomFromMallRecommendCycle) {
                NSMutableArray * channelArr=self.mallOperationModel.slideShow.mutableCopy;
                for (JHLiveRoomMode * mode in self.mallOperationModel.slideShow) {
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
            
            //TODO 推荐传sectonid
            else if (listType == JHGestureChangeLiveRoomFromMallGroupList) {
                     vc.entrance = @"0";
            }
           
            vc.PageNum=PageNum;
            vc.listFromType=listType;
            [self setLiveRoomParamsForVC:vc];
            [self.navigationController pushViewController:vc animated:YES];
            
            if (listType == JHGestureChangeLiveRoomFromMallRecommendCycle) {
                @weakify(self);
                vc.closeBlock = ^{
                    @strongify(self);
                    [self.collectionView setContentOffset:CGPointMake(0,kCycleViewH+[JHMallIntroduceCell viewSize].height+self.mallOperationModel.height+10) animated:YES];
                };
            }
        
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
            
            [self.navigationController pushViewController:vc animated:YES];
            @weakify(self);
            if (listType == JHGestureChangeLiveRoomFromMallRecommendCycle) {
                vc.closeBlock = ^{
                    @strongify(self);
                    [self scrollViewToListTop];
                };
            }
        }
       
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}

- (void)scrollViewToListTop
{
    [self.collectionView setContentOffset:CGPointMake(0,kCycleViewH+[JHMallIntroduceCell viewSize].height+self.mallOperationModel.height+10) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self isBeyondArea:scrollView];
    if (scrollView.contentOffset.y>=ScreenH-UI.statusAndNavBarHeight) {
              [self.backTopImage setHidden:NO];
          }
          else{
              [self.backTopImage setHidden:YES];
          }    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
         DDLogInfo(@"******newPage*******a");
        if (![self isRefreshing]) {
            [self  pullStream];
            [self scrollToListShow];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
       DDLogInfo(@"******newPage*******b");
    if (![self isRefreshing]) {
       
        [self  pullStream];
       // [self scrollToListShow];
    }

    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}

- (void)scrollViewDidEndScroll {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
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
    
  //轮播图在屏幕内
    if ([self cycleInScreen]) {
        if (!self.lastCycleView) {
             [self.cycleHeader scrollToNextPage];
        }
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
                    self.lastCycleView = nil;
                     break;
                }
                
               
            }
        }
    }
}
-(BOOL)cycleInScreen{
    CGRect rect = [self.cycleHeader convertRect:self.cycleHeader.bounds toView:[UIApplication sharedApplication].keyWindow];
    
     NSLog(@"cycleHeader坐标=%@",NSStringFromCGRect(rect));
    if(rect.origin.y+rect.size.height>=UI.statusAndNavBarHeight) {
        return YES;
    }
    return NO;
    
}
-(void)shutdownPlayStream{
    [[JHLivePlayerManager sharedInstance] shutdown];
    lastCell=nil;
    self.lastCycleView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLiveRoomParamsForVC:(NTESAudienceLiveViewController*)vc
{
    if(vc.listFromType == JHGestureChangeLiveRoomFromMallRecommendCycle)
        vc.fromString = JHLiveFromhomeMarketTopRecommend; //上部推荐：top_recommend
    else //JHGestureChangeLiveRoomFromMallGroupList
        vc.fromString = JHLiveFromhomeMarketCommonRecommend; //卖场首页-普通list(下部)推荐
    vc.groupId = self.groupId;
}

#pragma mark - 引导

- (void)scrollToListShow {
    if ([self isRefreshing]) {
        return;
    }
    
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

- (JHMallRecommendHeader *)cycleHeader {
    if (!_cycleHeader) {
        CGRect rect = CGRectMake(0, 0, ScreenWidth, kCycleViewH);
        _cycleHeader = [[JHMallRecommendHeader alloc] initWithFrame:rect];
        _cycleHeader.backgroundColor = kColorF5F6FA;
    }
    return _cycleHeader;
}

-(void)srollToTop{
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];
}
-(void) backTop:(UIGestureRecognizer *)gestureRecognizer{
    
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:YES];
}
#pragma mark -
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

@end
