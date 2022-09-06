//
//  JHLiveSearchResultVC.m
//  TTjianbao
//
//  Created by lihang on 2020/11/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveSearchResultVC.h"
#import "JHMallLittleCollectionViewCell.h"
#import "NTESAudienceLiveViewController.h"
#import "JHLivePlayerManager.h"
#import "JHCustomerInfoController.h"


#define LittleCellRate (171./249.f)

@interface JHLiveSearchResultVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSInteger PageNum;
    NSInteger PageSize;
    
    BOOL isRefresh;
}
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *dataModes;
@property (nonatomic, strong) UICollectionViewFlowLayout *customLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@end



@implementation JHLiveSearchResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    PageSize = 10;
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self regCollectionViewCell];
    [self loadData];
    
    //搜索结果落地页埋点
    if(self.keyword){
        [JHGrowingIO trackEventId:JHSearch_click variables:@{@"type":@"0"}];
    }
}

-(void)regCollectionViewCell{
    
    [self.collectionView registerClass:[JHMallLittleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class])];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewIdentifer"];
}

- (void)reloadData {
    [self loadData];
}

-(void)loadData {
    PageNum=0;
    [self requestInfo];
}

-(void)loadMoreData{
    [self requestInfo];
}
-(void)requestInfo{
    if(!(self.keyword.length > 0)){
        return;
    }
    NSInteger num = PageNum;
    NSMutableDictionary *dic =[NSMutableDictionary dictionary];
    [dic setValue:@(PageNum) forKey:@"pageNo"];
    [dic setValue:@(PageSize) forKey:@"pageSize"];
    [dic setValue:self.keyword forKey:@"keyWord"];
    [dic setValue:@"sell" forKey:@"type"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/channel/getChannelSearch") Parameters:dic requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel * _Nullable respondObject) {
        [self endRefresh];
        if(num == PageNum) {
            [self handleDataWithArr:respondObject.data];
            PageNum++;
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self endRefresh];
        [UITipView showTipStr:respondObject.message];
        [self.view configBlankType:0 hasData:NO hasError:YES reloadBlock:nil];
        ///369神策埋点:发送搜索请求
        [self sendSearchRequest:NO];
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
    if (PageNum == 0 && self.dataModes.count >0) {
        if (self.collectionView) {
            NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
        }
    }
    
    if ([arr count]<PageSize) {
        
        self.collectionView.mj_footer.hidden = YES;
    }
    else{
        self.collectionView.mj_footer.hidden = NO;
    }
    
    BOOL hasData = self.dataModes.count == 0 ? NO :YES;
    [self.view configBlankType:0 hasData:hasData hasError:NO reloadBlock:nil];
    ///369神策埋点:发送搜索请求
    [self sendSearchRequest:hasData];
}

- (void)sendSearchRequest:(BOOL)hasResult {
    ///369神策埋点:发送搜索请求
    [JHTracking trackEvent:@"sendSearchRequest" property:@{@"has_result":@(hasResult), @"key_word":self.keyword, @"key_word_source":self.keywordSource}];
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
    JHMallLittleCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class]) forIndexPath:indexPath];
    cell.liveRoomMode = self.dataModes[indexPath.row];
    return cell;
}

#pragma mark - UICollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat w = (ScreenW - 33.f)/2.;
    return CGSizeMake(w, w/LittleCellRate);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(10, 12, 10, 12);
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    return [UICollectionReusableView new];
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
//    return CGSizeZero;
//}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHLiveRoomMode *selectLiveRoom = self.dataModes[indexPath.row];
    if([selectLiveRoom.canCustomize isEqualToString:@"1"]){
        if(selectLiveRoom.status.intValue == 2){
            [self shutdownPlayStream];
            [self getLiveRoomDetail:selectLiveRoom andListType:@"live_search_in"];
        }else{
            //定制直播间跳定制主页
            JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
            vc.roomId = selectLiveRoom.roomId;
            vc.anchorId = selectLiveRoom.anchorId;
            vc.channelLocalId = selectLiveRoom.channelLocalId;
            vc.fromSource = @"live_search_in";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self shutdownPlayStream];
        [self getLiveRoomDetail:selectLiveRoom andListType:@"live_search_in"];
    }
    
    ///369神策埋点:点击搜索结果
    [JHTracking trackEvent:@"searchResultClick" property:@{@"position_sort":@(indexPath.item),
                                                           @"resources_type":@"直播",
                                                           @"resources_id":selectLiveRoom.channelLocalId,
                                                           @"resources_name":selectLiveRoom.anchorName,
                                                           @"key_word":self.keyword
    }];
    
    //新埋点
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page_position"] = @"搜索页";
    params[@"model_type"] = @"搜索页";
    params[@"channel_status"] = selectLiveRoom.status.intValue == 2 ? @"是" : @"否";
    params[@"channel_name"] = NONNULL_STR(selectLiveRoom.title);
    params[@"channel_label"] = @"无";
    params[@"anchor_id"] = NONNULL_STR(selectLiveRoom.anchorId);
    params[@"anchor_nick_name"] = NONNULL_STR(selectLiveRoom.anchorName);
    params[@"channel_local_id"] = NONNULL_STR(selectLiveRoom.channelLocalId);
    [JHAllStatistics jh_allStatisticsWithEventId:@"channelClick" params:params type:JHStatisticsTypeSensors];
}

-(void)shutdownPlayStream{
    [[JHLivePlayerManager sharedInstance] shutdown];
}

-(void)getLiveRoomDetail:(JHLiveRoomMode*)selectLiveRoomModel andListType:(NSString *)listType{
    NSString *Id = selectLiveRoomModel.ID;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(Id)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        
        if ([channel.status integerValue]==2)
        {
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.channel=channel;
            vc.coverUrl = selectLiveRoomModel.coverImg;

        
//            //TODO 推荐传sectonid
//            else if (listType == JHGestureChangeLiveRoomFromMallGroupList) {
//                     vc.entrance = @"0";
//            }
           
            vc.PageNum=PageNum;
            vc.fromString = listType;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else  if ([channel.status integerValue]==1||[channel.status integerValue]==0||[channel.status integerValue]==3){
            
            NSString *string = nil;
            if (channel.status.integerValue == 1) {
                string = channel.lastVideoUrl;
            }
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
            vc.channel = channel;
            vc.coverUrl = selectLiveRoomModel.coverImg;
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.fromString = listType;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failureBlock:^(RequestModel *respondObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
   
    
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
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#F5F6FA"];
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

#pragma mark - JXCategoryListCollectionContentViewDelegate

- (UIView *)listView {
    return self.view;
}
@end
