//
//  JHStoneResaleListViewController.m
//  TTjianbao
//
//  Created by jiang on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//
#import "JHStoneResaleListViewController.h"
#import "JHStoneResaleBigCollectionViewCell.h"
#import "JHStoneResaleSmallCollectionViewCell.h"
#import "JHStoneSoldBigCollectionViewCell.h"
#import "JHStoneSoldSmallCollectionViewCell.h"
#import "JHStoneResaleLiveCollectionViewCell.h"
#import "NTESAudienceLiveViewController.h"
#import "ChannelMode.h"
#import "JHMainViewStoneResaleModel.h"
#import "MBProgressHUD.h"
#import "FJWaterfallFlowLayout.h"
#import "JHOfferPriceViewController.h"
#import "JHCustomerInfoController.h"

#define pagesize 20

@interface JHStoneResaleListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,FJWaterfallFlowLayoutDelegate> {
    
    NSInteger PageNum;
    NSArray* rootArr;
    JHLiveRoomMode * selectLiveRoom;
    JHStoneResaleLiveCollectionViewCell  *lastCell;
    NSString *url;
}
@property (nonatomic, assign)BOOL isBig;
@property(nonatomic,strong) NSMutableArray *listModes;
@property(nonatomic,assign) NSInteger currentSelectIndex;
@property (nonatomic,assign)  BOOL viewDisAppear;
@property  (nonatomic, weak) FJWaterfallFlowLayout *customLayout;

@end

@implementation JHStoneResaleListViewController

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
-(void)setType:(JHStoneMainListType)type{
    
    _type=type;
    if (type==JHStoneMainListTypeStoneLive) {
        url=@"/anon/stone-restore/list-index-channel";
    }
    if (type==JHStoneMainListTypeStoneSale) {
        url=@"/anon/stone-restore/list-index-sale";
    }
    if (type==JHStoneMainListTypeStoneSold) {
        url=@"/anon/stone-restore/list-index-sold";
    }
    if (type==JHStoneMainListTypeStoneResell) {
        url=@"/anon/stone/resale/list-resale";
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeNavView]; //无基类navbar
    self.isBig = NO;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    // [self showDefaultImageWithView:self.collectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCellSize:) name:JHNotificationNameChangeStoneCellSize object:nil];
}

#pragma mark - Getters
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        FJWaterfallFlowLayout *fjWaterfallFlowLayout = [[FJWaterfallFlowLayout alloc] init];
        fjWaterfallFlowLayout.itemSpacing = 5;
        fjWaterfallFlowLayout.lineSpacing = 5;
        fjWaterfallFlowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 5, 10);
        if (self.type==JHStoneMainListTypeStoneLive||self.isBig) {
            fjWaterfallFlowLayout.colCount = 1;
            fjWaterfallFlowLayout.lineSpacing = 10;
        }
        else{
            fjWaterfallFlowLayout.colCount = 2;
            fjWaterfallFlowLayout.lineSpacing = 5;
        }
        self.customLayout = fjWaterfallFlowLayout;
        self.customLayout.delegate = self;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fjWaterfallFlowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        //解决categoryView在吸顶状态下，且collectionView的显示内容不满屏时，出现竖直方向滑动失效的问题
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [CommHelp toUIColorByStr:@"F5F6FA"];
        if (self.type==JHStoneMainListTypeStoneLive) {
            _collectionView.backgroundColor = [UIColor whiteColor];
        }
        [_collectionView registerClass:[JHStoneResaleBigCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHStoneResaleBigCollectionViewCell class])];
        [_collectionView registerClass:[JHStoneResaleSmallCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHStoneResaleSmallCollectionViewCell class])];
        [_collectionView registerClass:[JHStoneSoldBigCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHStoneSoldBigCollectionViewCell class])];
        [_collectionView registerClass:[JHStoneSoldSmallCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHStoneSoldSmallCollectionViewCell class])];
        [_collectionView registerClass:[JHStoneResaleLiveCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHStoneResaleLiveCollectionViewCell class])];
        JH_WEAK(self)
        
        _collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadMoreData];
        }];
        _collectionView.mj_footer.hidden=YES;
        
    }
    return _collectionView;
}
#pragma FJWaterfallFlowLayoutDelegate
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(FJWaterfallFlowLayout*)collectionViewLayout heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath*)indexPath{
    
    if (self.type==JHStoneMainListTypeStoneLive) {
        return kResaleRoomTableCellHeight;
    }
    JHMainViewStoneResaleModel *model = self.listModes[indexPath.item];
    if (self.type==JHStoneMainListTypeStoneSale
        ||self.type==JHStoneMainListTypeStoneResell) {
        if (self.isBig) {
            return model.reSaleBigCellheight;
        }
        return model.height;;
    }
    if (self.type==JHStoneMainListTypeStoneSold) {
        if (self.isBig) {
            return model.soldBigCellheight;
        }
        return model.height;;
    }
    return 0;
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listModes.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type==JHStoneMainListTypeStoneLive) {
        JHStoneResaleLiveCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHStoneResaleLiveCollectionViewCell class]) forIndexPath:indexPath];
        cell.liveRoomMode = self.listModes[indexPath.row];
        return cell;
    }
    
    if (self.type==JHStoneMainListTypeStoneSale||
        self.type==JHStoneMainListTypeStoneResell) {
        if (_isBig) {
            JHStoneResaleBigCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHStoneResaleBigCollectionViewCell class]) forIndexPath:indexPath];
            cell.resaleFlag=self.type==JHStoneMainListTypeStoneResell?YES:NO;
            cell.mode = self.listModes[indexPath.row];
            return cell;
        }else {
            JHStoneResaleSmallCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHStoneResaleSmallCollectionViewCell class]) forIndexPath:indexPath];
            cell.resaleFlag=self.type==JHStoneMainListTypeStoneResell?YES:NO;
            cell.mode = self.listModes[indexPath.row];
            
            return cell;
            
        }
    }
    if (self.type==JHStoneMainListTypeStoneSold) {
        if (_isBig) {
            JHStoneSoldBigCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHStoneSoldBigCollectionViewCell class]) forIndexPath:indexPath];
            cell.mode = self.listModes[indexPath.row];
            return cell;
        }else {
            JHStoneSoldSmallCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHStoneSoldSmallCollectionViewCell class]) forIndexPath:indexPath];
            cell.mode = self.listModes[indexPath.row];
            
            return cell;
            
        }
    }
    
    return nil;
}
#pragma mark - UICollectionViewLayoutDelegate

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (_isBig) {
//        CGFloat w = (ScreenW - 20);
//        return CGSizeMake(w, w/BigCellRate);
//
//    }else {
//        CGFloat w = (ScreenW - 30)/2.;
//
//        return CGSizeMake(w, w/LittleCellRate);
//    }
//}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type==JHStoneMainListTypeStoneLive) {
        selectLiveRoom=self.listModes[indexPath.row];
        self.currentSelectIndex=indexPath.row;
        
        if([selectLiveRoom.canCustomize isEqualToString:@"1"]){
            if(selectLiveRoom.status.intValue == 2){
                [self shutdownPlayStream];
                [self EnterLiveRoom];
            }else{
                //定制直播间跳定制主页(未统计)
                JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
                vc.roomId = selectLiveRoom.roomId;
                vc.anchorId = selectLiveRoom.anchorId;
                vc.channelLocalId = selectLiveRoom.channelLocalId;
                vc.fromSource = @"";
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [self shutdownPlayStream];
            [self EnterLiveRoom];
        }
    }
   else if (self.type==JHStoneMainListTypeStoneResell) {
    JHMainViewStoneResaleModel * mode=self.listModes[indexPath.row];
     [JHRouterManager pushPersonReSellDetailWithStoneResaleId:mode.stoneRestoreId];
    }
       
    else{
        
        //        JHOfferPriceViewController * vc = [[JHOfferPriceViewController alloc]init];
        JHMainViewStoneResaleModel * mode=self.listModes[indexPath.row];
        //        vc.stoneRestoreId=mode.stoneRestoreId;
        //        [self.navigationController pushViewController:vc animated:YES];
        [JHRouterManager pushStoneDetailWithStoneId:mode.stoneRestoreId channelCategory:JHRoomTypeNameRestoreStone complete:nil];
    }
}
#pragma mark -
-(void)loadNewData{
    
    PageNum=0;
    [self shutdownPlayStream];
    [self requestInfo];
    [JHUserStatistics noteEventType:kUPEventTypePaybackHomeEntrance params:@{}];
}
-(void)loadMoreData{
    
    PageNum++;
    [self requestInfo];
}
-(void)requestInfo{
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    
    if(_paramDic)
    {
        dic = [NSMutableDictionary dictionaryWithDictionary:self.paramDic];
    }
    [dic setValue:@(PageNum) forKey:@"pageIndex"];
    [dic setValue:@(pagesize) forKey:@"pageSize"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(url) Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        [self handleDataWithArr:respondObject.data];
        [self endRefresh];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self endRefresh];
    }];
}

- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr;
    if (self.type==JHStoneMainListTypeStoneLive) {
        arr = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:array];
    }
    else{
        arr = [JHMainViewStoneResaleModel mj_objectArrayWithKeyValuesArray:array];
    }
    if (PageNum == 0) {
        self.listModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.listModes addObjectsFromArray:arr];
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
    if (self.listModes.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.collectionView];
    }
}
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshingWithCompletionBlock:^{
    }];
    [self.collectionView.mj_footer endRefreshing];
}
- (void)loadData {
    if (!self.listModes || self.listModes.count == 0) {
        [self loadNewData];
    }
    else{
        [self beginPullSteam];
    }
}
#pragma mark -
- (void)changeCellSize:(NSNotification *)noti {
    BOOL b = [noti.object boolValue];//yes 是小图 no 是大图
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];
    if (self.type==JHStoneMainListTypeStoneLive) {
        self.customLayout.colCount = 1;
    }
    else{
        self.isBig = !b;
        if (self.isBig) {
            self.customLayout.colCount = 1;
        }
        else{
            self.customLayout.colCount = 2;
        }
        
    }
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
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (![self isRefreshing]) {
        [self  beginPullSteam];
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
        JHStoneResaleBigCollectionViewCell *cell1=(JHStoneResaleBigCollectionViewCell *)obj1;
        JHStoneResaleBigCollectionViewCell *cell2=(JHStoneResaleBigCollectionViewCell *)obj2;
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
    if (self.type!=JHStoneMainListTypeStoneLive) {
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
        if([obj isKindOfClass:[JHStoneResaleLiveCollectionViewCell class]])
        {
            JHStoneResaleLiveCollectionViewCell *cell=(JHStoneResaleLiveCollectionViewCell *)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            //  NSLog(@"坐标====%@  cell=%@",NSStringFromCGRect(rect),cell.liveRoomMode.watchTotal);
            if (rect.origin.y>=UI.statusAndNavBarHeight&&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49) {
                if (cell.liveRoomMode.ID!=lastCell.liveRoomMode.ID&&[cell.liveRoomMode.status integerValue]==2&&!self.viewDisAppear) {
                       JH_WEAK(self)
                    //    NSLog(@"拉流%@",cell.liveRoomMode.watchTotal);
                    [[JHLivePlayerManager sharedInstance] startPlay:cell.liveRoomMode.rtmpPullUrl inView:cell.content andTimeEndBlock:^{
                        JH_STRONG(self)
                        [[JHLivePlayerManager sharedInstance] shutdown];
                        self->lastCell=nil;
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
}
-(void)doDestroyLastCell{
    lastCell=nil;
}
-(void)EnterLiveRoom{
    BOOL inLiveRoom=NO;
    for ( UIViewController *vc in JHRootController.homeTabController.navigationController.viewControllers) {
        if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
            inLiveRoom=YES;
            NTESAudienceLiveViewController * liveVC=(NTESAudienceLiveViewController*)vc;
            JH_WEAK(self)
            liveVC.closeBlock = ^{
                JH_STRONG(self)
                [self getLiveRoomDetail:YES];
            };
            liveVC.isExitVc = YES;
            [liveVC onCloseRoom];
            
            break;
        }
    }
    if (!inLiveRoom) {
        [self getLiveRoomDetail:NO];
    }
}
-(void)getLiveRoomDetail:(BOOL)inLiveRoom{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *url = [NSString stringWithFormat:@"/channel/detail/authoptional?&clientType=commonlink&channelId=%@",selectLiveRoom.ID];
    [HttpRequestTool getWithURL:FILE_BASE_STRING(url) Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        
        if ([channel.status integerValue]==2)
        {
            
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.channel=channel;
            vc.coverUrl = selectLiveRoom.coverImg;
            vc.fromString = JHLiveFromhomeMarket;
             vc.entrance = @"2";
            vc.listFromType=JHGestureChangeLiveRoomFromStoneResaleList;
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
        if (inLiveRoom) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSMutableArray *arr=[JHRootController.homeTabController.navigationController.viewControllers mutableCopy];
                for ( UIViewController *vc in arr) {
                    if ([vc isKindOfClass:[NTESAudienceLiveViewController class]]) {
                        [arr removeObject:vc];
                        JHRootController.homeTabController.navigationController.viewControllers=arr;
                        break;
                    }
                }
            });
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
