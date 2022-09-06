//
//  JHMallGroupViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallGroupViewController.h"
#import "JHMallLittleCollectionViewCell.h"
#import "ChannelMode.h"
#import "SourceMallApiManager.h"
#import "JHNewGuideTipsView.h"
#import "NTESAudienceLiveViewController.h"
#import "JHLivePlayerManager.h"
#import "JHMallIntroduceCell.h"
#import "JHMallOperationModel.h"
#import "JHMallSpecialAreaCollectionViewCell.h"
#import "JHMallGroupCategoryTitleView.h"
#import "JHMallCateModel.h"
#import "JHMallCateViewModel.h"
#import "MBProgressHUD.h"
#import "JHSQApiManager.h"
#import "JHMallGroupHeaderView.h"
#import "JHCustomerInfoController.h"

#define pagesize 10
#define LittleCellRate (192./250.f)
#define ktitleTagHeight 46.f

#define kDefiniSerialBase  5

@interface JHMallGroupViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    
    NSInteger PageNum;
    JHLiveRoomMode *selectLiveRoom;
    JHMallLittleCollectionViewCell *lastCell;
}
@property (nonatomic, strong) NSMutableArray *dataModes;
@property (nonatomic, assign) NSInteger currentSelectIndex;
@property (nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@property (nonatomic, strong) JHOperationDetailModel *advertModel;//
@property (nonatomic, strong) JHMallGroupCategoryTitleView *categoryTitleView;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, strong) JHMallCateViewModel *thiredTabModel;
@property (nonatomic, copy) NSArray <JHMallCateModel *>*channelArray;
///轮播图运营位
@property (nonatomic, strong) NSMutableArray <JHOperationImageModel *>*bannerList;

@end

@implementation JHMallGroupViewController

- (NSMutableArray<JHOperationImageModel *> *)bannerList {
    if (!_bannerList) {
        _bannerList = [NSMutableArray array];
    }
    return _bannerList;
}

//获取广告数据
- (void)getBannerList {
    @weakify(self);
    NSInteger definiSerial = kDefiniSerialBase + self.currentIndex;
    [SourceMallApiManager getMallGroupBannerList:@(definiSerial).stringValue Completion:^(JHOperationDetailModel *detailModel, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            NSMutableArray *arr = [NSMutableArray array];
            for (JHOperationImageModel *model in detailModel.definiDetails) {
                if ([model.imageUrl isNotBlank]) {
                    [arr addObject:model];
                }
            }
            self.bannerList = arr;
            [self.collectionView reloadData];
        }
    }];
}

///将获取的数据转
- (NSArray *)getHeaderBannerData {
    NSMutableArray *banners = [NSMutableArray array];
    for (JHOperationImageModel *model in self.bannerList) {
        BannerCustomerModel *banner = [[BannerCustomerModel alloc] init];
        banner.image = model.imageUrl;
        [banners addObject:banner];
    }
    return banners;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //用户画像埋点
    [JHUserStatistics noteEventType:kUPEventTypeLiveShopGroupBrowse params:@{JHUPBrowseKey:JHUPBrowseBegin, @"group1_id" : self.prentId ? : @""}];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //用户画像埋点
    [JHUserStatistics noteEventType:kUPEventTypeLiveShopGroupBrowse params:@{JHUPBrowseKey:JHUPBrowseEnd, @"group1_id" : self.prentId ? : @""}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self loadData];
}
-(void)createViews
{
    [self regCollectionViewCell];
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.backTopImage];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.collectionView addSubview:self.categoryTitleView];
    [self.categoryTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.collectionView);
        make.right.equalTo(self.collectionView);
        make.top.equalTo(self.collectionView);
        make.width.offset(ScreenW);
        make.height.equalTo(@0);
    }];
    @weakify(self);
    [self.categoryTitleView setClickItemBlock:^(JHMallCateViewModel * _Nonnull vm, NSInteger currentIndex) {
        @strongify(self);
        ///刷新数据前停止拉流
        [self shutdownPlayStream];
        self.groupId = vm.Id;
        self.thiredTabModel = vm;
        ///获取顶部轮播运营位数据
        [self.bannerList removeAllObjects];
        [self loadNewData];
        //埋点
        [self trackEvent];
    }];
}

- (void)trackEvent
{
    [JHGrowingIO trackEventId:JHMarketThirdTabSwitch variables: @{@"second_tabname":self.parentName ? : @"",@"third_tabname":self.thiredTabModel.name ? : @""}];
    //用户画像埋点
    [JHUserStatistics noteEventType:kUPEventTypeLiveLabelTab2Click params:@{@"group1_id" : self.prentId ? : @"", @"group2_id" : self.groupId ? : @""}];
}

-(void)regCollectionViewCell{
    [self.collectionView registerClass:[JHMallLittleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class])];
    [self.collectionView registerClass:[JHMallSpecialAreaCollectionViewCell class] forCellWithReuseIdentifier:kCellId_JHMallSpecialAreaId];
    [self.collectionView registerClass:[JHMallGroupHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kJHMallGroupHeaderViewIdentifer];
}
-(JHMallGroupCategoryTitleView *)categoryTitleView
{
    if(!_categoryTitleView)
    {
        _categoryTitleView = [JHMallGroupCategoryTitleView new];
       
    }
    return _categoryTitleView;
}
#pragma mark -
-(void)refreshData:(NSInteger)currentIndex {
    [self.collectionView.mj_header beginRefreshing];
}

-(void)loadData{
    self.groupId = self.prentId;
    [self shutdownPlayStream];
    [self loadCategoryData];
    [self getBannerList];
    [self loadNewData];
    //用户画像埋点
    [JHUserStatistics noteEventType:kUPEventTypeLiveHomeTabEntrance params:nil];
}
-(void)loadNewData{
    PageNum=0;
    [self requestInfo];
  
}
-(void)loadMoreData{
    [self requestInfo];
}
-(void)requestInfo{
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/sellByGroup?pageNo=%ld&pageSize=%ld&groupId=%@"),PageNum,pagesize,self.groupId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self handleDataWithArr:respondObject.data];
        [self endRefresh];
        PageNum++;
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
         [self endRefresh];
        
    }];
}
-(void)requestListAdvertInfo{
    [SourceMallApiManager getMallListAdvertCompletion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
            self.advertModel = [JHOperationDetailModel  mj_objectWithKeyValues:respondObject.data];
            if (self.dataModes.count>=6) {
                [self.dataModes insertObject:self.advertModel atIndex:6];
            }
            [self.collectionView reloadData];
        }
    }];
}
- (void)loadCategoryData {
    [SourceMallApiManager getSourceMallCate:self.prentId Completion:^(NSArray *channels, BOOL hasError) {
        if (!hasError) {
            self.channelArray = channels;
            if (self.channelArray.count>0) {
                [self.categoryTitleView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.equalTo(@(ktitleTagHeight));
                }];
                [self.categoryTitleView setData:channels];
                [self.collectionView reloadData];
            }
        }
    }];
}
- (void)handleDataWithArr:(NSArray *)array {
    
    NSArray *arr = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.dataModes = [NSMutableArray arrayWithArray:arr];
        [self requestListAdvertInfo];
    }else {
        [self.dataModes addObjectsFromArray:arr];
    }
    [self.collectionView reloadData];
    
    if ([arr count]<pagesize) {
        
        self.collectionView.mj_footer.hidden = YES;
    }
    else{
        self.collectionView.mj_footer.hidden = NO;
    }
    if (PageNum==0) {
         [self beginPullSteam];
    }
}
- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
   
    return self.dataModes.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataModes[indexPath.row] isKindOfClass:[JHOperationDetailModel class]]) {
        JHMallSpecialAreaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId_JHMallSpecialAreaId forIndexPath:indexPath];
        cell.specialAreaMode = self.advertModel.definiDetails[0];
           return cell;
    }
    
    JHMallLittleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class]) forIndexPath:indexPath];
    cell.liveRoomMode = self.dataModes[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataModes[indexPath.row] isKindOfClass:[JHOperationDetailModel class]]) {
        if (self.advertModel.definiDetails.count > 0) {
            return CGSizeMake((ScreenW - 20), (ScreenW - 20)*80/355.);
        }
        return CGSizeZero;
    }
    CGFloat w = (ScreenW - 25)/2.;
    return CGSizeMake(w, w/LittleCellRate);
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(0, 10, 5, 10);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&
        [kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JHMallGroupHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kJHMallGroupHeaderViewIdentifer forIndexPath:indexPath];
        header.bannerList = self.bannerList;
        header.clickBlock = ^(JHOperationImageModel * _Nonnull bannerModel, NSInteger selectIndex) {
            NSLog(@"点击banner");
            JHOperationImageModel *model = self.bannerList[selectIndex];
            [JHRootController handleMessageModel:model.target from:@""];
        };
        return header;
    }
    
    return [UICollectionReusableView new];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        CGFloat headerHeight = [self collectionHeaderHeight];
        return CGSizeMake(ScreenW, headerHeight);
    }
    return CGSizeZero;
}

///根据返回的数据确定顶部二级标签和轮播图的高度
- (CGFloat)collectionHeaderHeight {
    CGFloat bannerHeight = [JHMallGroupHeaderView bannerHeight];
    if (self.channelArray.count > 0 && self.bannerList.count > 0) {
        return bannerHeight + ktitleTagHeight + 10;
    }
    if (self.channelArray.count > 0 && self.bannerList.count == 0) {
        return ktitleTagHeight;
    }
    if (self.channelArray.count == 0 && self.bannerList.count > 0) {
        return bannerHeight + 20;
    }
    return CGFLOAT_MIN;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.dataModes[indexPath.row] isKindOfClass:[JHOperationDetailModel class]]) {
        JHOperationDetailModel * mode = self.dataModes[indexPath.row];
        [JHRootController handleMessageModel:mode.definiDetails[0].target from:@""];
        [JHGrowingIO trackEventId:JHMarketBottomBannerClick variables: @{@"id":mode.definiDetails[0].detailsId}];
        return;
    }
    selectLiveRoom = self.dataModes[indexPath.row];
    self.currentSelectIndex = indexPath.row;
    if([selectLiveRoom.canCustomize isEqualToString:@"1"]){
        if(selectLiveRoom.status.intValue == 2){
            [self shutdownPlayStream];
            [self getLiveRoomDetail];
        }else{
            //定制直播间跳定制主页(没用到)
            JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
            vc.roomId = selectLiveRoom.roomId;
            vc.anchorId = selectLiveRoom.anchorId;
            vc.channelLocalId = selectLiveRoom.channelLocalId;
            vc.fromSource = @"";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self shutdownPlayStream];
        [self getLiveRoomDetail];
    }
    [JHGrowingIO trackEventId:JHMarketListItemClick variables: @{@"channelLocalId":selectLiveRoom.ID,@"index":@(indexPath.row),@"second_tabname":self.parentName,@"third_tabname":self.thiredTabModel.name ? : @""}];
}
- (void)getLiveRoomDetail {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(selectLiveRoom.ID)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        
        if ([channel.status integerValue] == 2)
        {
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.channel = channel;
            vc.coverUrl = selectLiveRoom.coverImg;
//            self.currentSelectIndex = 0;
//
//            NSMutableArray * channelArr = [self.dataModes mutableCopy];
//            for (JHLiveRoomMode * mode in self.dataModes) {
//                if (![mode isKindOfClass:[JHLiveRoomMode class]]) {
//                    [channelArr removeObject:mode];
//                }
//                else if ([mode.status integerValue] != 2) {
//                    [channelArr removeObject:mode];
//                }
//            }
//            [channelArr enumerateObjectsUsingBlock:^(JHLiveRoomMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if([obj.ID isEqual:channel.channelLocalId]) {
//                    self.currentSelectIndex = idx;
//                    *stop = YES;
//                }
//            }];
            
//            vc.currentSelectIndex = self.currentSelectIndex;
//            vc.channeArr = channelArr;
            
            vc.entrance = @"0";
            vc.PageNum = PageNum;
            vc.listFromType = JHGestureChangeLiveRoomFromMallGroupList;
            [self setLiveRoomParamsForVC:vc];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else  if ([channel.status integerValue] == 1 || [channel.status integerValue] == 0 || [channel.status integerValue] == 3){
            
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
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self isBeyondArea:scrollView];
    if (scrollView.contentOffset.y >= ScreenH - UI.statusAndNavBarHeight) {
           [self.backTopImage setHidden:NO];
       }
       else{
           [self.backTopImage setHidden:YES];
       }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate){
        if (![self isRefreshing]) {
            [self pullStream];
            [self scrollToListShow];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![self isRefreshing]) {
        [self  pullStream];
    }
    
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}

- (void)scrollViewDidEndScroll {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
}

- (void)isBeyondArea:(UIScrollView *)scrollView {
    if (![self isRefreshing]&&lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:[UIApplication sharedApplication].keyWindow];
        if (rect.origin.y<UI.statusAndNavBarHeight || rect.origin.y + rect.size.height > ScreenH-UI.bottomSafeAreaHeight-49) {
            [self shutdownPlayStream];
            lastCell = nil;
        }
    }
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
   
    //    [self scrollToListShow];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setLiveRoomParamsForVC:(NTESAudienceLiveViewController*)vc
{
    vc.fromString = JHLiveFromhomeMarketTabSecondLabel; //标签、活动、【二级标签】：tab_secend_label
    vc.third_tab_from = self.thiredTabModel.name ? : @"";
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

- (void)srollToTop {
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:NO];
}
- (void) backTop:(UIGestureRecognizer *)gestureRecognizer {
    [self.collectionView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark -
#pragma mark - JXCategoryListContentViewDelegate

- (UIView *)listView {
    return self.view;
}

@end
