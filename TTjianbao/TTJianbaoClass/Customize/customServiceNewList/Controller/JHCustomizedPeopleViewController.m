//
//  JHCustomizedPeopleViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizedPeopleViewController.h"
#import "JHMallLittleCollectionViewCell.h"
#import "JHLiveRoomMode.h"
#import "NTESAudienceLiveViewController.h"
#import "JHCustomerInfoController.h"
#import "JHEmptyCollectionCell.h"
#import "JHCustomizeGuideTipView.h"
#import "UIScrollView+JHEmpty.h"

@interface JHCustomizedPeopleViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger PageNum;
    NSInteger pagesize;
}
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

/** 数据源*/
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *dataModes;
@end

@implementation JHCustomizedPeopleViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    pagesize = 20;
    PageNum = 0;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)reloadNewData {
    pagesize = 20;
    PageNum = 0;
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [JHHomeTabController setSubScrollView:self.collectionView];
}

/**加载数据*/
-(void)loadData{
    NSString *url = FILE_BASE_STRING(@"/channel/customized/sell/list");
    NSDictionary *dic = @{@"pageNo":@(PageNum),@"pageSize":@(pagesize)};
    [HttpRequestTool getWithURL:url Parameters:dic successBlock:^(RequestModel *respondObject) {
        NSArray *arr = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:respondObject.data];
         if (PageNum == 0) {
             self.dataModes = [NSMutableArray arrayWithArray:arr];
         }else {
             [self.dataModes addObjectsFromArray:arr];
         }
        [self.collectionView reloadData];
        if (arr.count >= 20) {
            PageNum += 1;
            [self.collectionView.mj_footer resetNoMoreData];
            [self.collectionView.mj_footer endRefreshing];
            self.collectionView.mj_footer.hidden = NO;
        } else {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            self.collectionView.mj_footer.hidden = YES;
        }
    }
    failureBlock:^(RequestModel *respondObject) {
        [self.collectionView jh_endRefreshing];
//        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
//        self.collectionView.mj_footer.hidden = YES;
    }];
}

#pragma mark -collectionview 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataModes.count > 0 ? self.dataModes.count: 1;  //每个section的Item数;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataModes.count == 0) {
        JHEmptyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHEmptyCollectionCell class]) forIndexPath:indexPath];
        return cell;
    }
    JHMallLittleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class]) forIndexPath:indexPath];
    cell.liveRoomMode = self.dataModes[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];//取消选中
   //do something ...
    if (self.dataModes.count == 0) {
        return;
    }
    JHLiveRoomMode *model = self.dataModes[indexPath.item];
    
    if([model.canCustomize isEqualToString:@"1"]){
        if(model.status.intValue == 2){
            [self getDetail:model.channelLocalId isAppraisal:NO];
            if (model.channelLocalId.length>0) {
                [JHGrowingIO trackEventId:JHTrackCustomizeListdz_item_click variables:@{@"channelLocalId":model.channelLocalId,@"index":@(indexPath.item)}];
            }
        }else{
            //定制直播间跳定制主页
            JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
            vc.roomId = model.roomId;
            vc.anchorId = model.anchorId;
            vc.channelLocalId = model.channelLocalId;
            vc.fromSource = @"dz_click";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        [self getDetail:model.channelLocalId isAppraisal:NO];
        if (model.channelLocalId.length>0) {
            [JHGrowingIO trackEventId:JHTrackCustomizeListdz_item_click variables:@{@"channelLocalId":model.channelLocalId,@"index":@(indexPath.item)}];
        }
    }
    
    //新埋点
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"page_position"] = @"天天定制主页";
    params[@"model_type"] = @"天天定制主页推荐位";
    params[@"channel_status"] = model.status.intValue == 2 ? @"是" : @"否";
    params[@"channel_name"] = NONNULL_STR(model.title);
    params[@"channel_label"] = @"无";
    params[@"anchor_id"] = NONNULL_STR(model.anchorId);
    params[@"anchor_nick_name"] = NONNULL_STR(model.anchorName);
    params[@"channel_local_id"] = NONNULL_STR(model.channelLocalId);
    [JHAllStatistics jh_allStatisticsWithEventId:@"channelClick" params:params type:JHStatisticsTypeSensors];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataModes.count == 0) {
        return self.collectionView.size;
    }
    CGFloat itemW = (ScreenW - 33.f) / 2. ;
    return CGSizeMake(itemW, itemW * 249. / 171.);
}

-(void)getDetail:(NSString *)selectLiveRoomId isAppraisal:(BOOL)isAppraisal {
   
   //crash判空处理,目前逻辑,如果异常可以return
   if(selectLiveRoomId.length == 0)
       return;
   [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(selectLiveRoomId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
       [SVProgressHUD dismiss];
       ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
       channel.first_channel = @"定制师";
       ///369神策埋点:直播间点击
       [JHTracking sa_clickLiveRoomList:channel pagePosition:@"天天定制"];
       
       if ([channel.status integerValue]==2)
       {
           NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
           vc.channel=channel;
           vc.applyApprassal=isAppraisal;
           vc.coverUrl = channel.coverImg;
           vc.fromString = JHLiveFromhomeIdentify;
           vc.entrance = @"4";
           [self.navigationController pushViewController:vc animated:YES];
           
       }else{
           JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
           vc.roomId = channel.roomId;
           vc.anchorId = channel.anchorId;
           vc.channelLocalId = channel.channelLocalId;
           vc.fromSource = JHLiveFromLiveRoom;
           [self.navigationController pushViewController:vc animated:YES];
       }
       
   } failureBlock:^(RequestModel *respondObject) {
       [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
       
   }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
        if (scrollView.contentOffset.y>0) {
            [self scrollToListShow];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    NSLog(@"scrollViewDidEndDraggingy ===%f", scrollView.contentOffset.y);
    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
        if (scrollView.contentOffset.y>0) {
            [self scrollToListShow];
        }
       
      
    }

}
- (void)scrollViewDidEndScroll {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}

#pragma  mark -UI绘制
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 9;
        layout.minimumLineSpacing = 9;// 设置item的大小

        // 设置每个分区的 上左下右 的内边距
        layout.sectionInset = UIEdgeInsetsMake(10, 12 ,10, 12);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kColorF5F6FA;
        [_collectionView registerClass:[JHMallLittleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class])];
        [_collectionView registerClass:[JHEmptyCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHEmptyCollectionCell class])];
        MJWeakSelf;
        _collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadData];
        }];
    }
    return _collectionView;

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
#pragma mark - 引导
- (void)scrollToListShow {
   
    if ([JHRootController tabBarSelectedIndex] != 1) {
        return;
    }
    if ([CommHelp isFirstForName:@"showTTCustomizeCelltip"])
    {
        NSArray *array = [self.collectionView visibleCells];
        array= [self sortbyCollectionArr:array];
        for (int i = 0; i < array.count; i++) {
            UIView *cell = array[i];
            if ( [cell isKindOfClass:[JHMallLittleCollectionViewCell class]]) {
                
                CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
                if (rect.origin.y>=UI.statusAndNavBarHeight+50&&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49)
                {
                    if (rect.origin.x<20) {
                        CGRect cellFrame = cell.frame;
                      //  cellFrame.origin.x = 10;
                        JHCustomizeGuideTipView *view = [JHCustomizeGuideTipView new];
                        [[JHRootController currentViewController].view addSubview:view];
                        
                        [view showGuideWithType:JHTipsGuideTypeSellMarket transparencyRect:[self.collectionView convertRect:cellFrame toView:JHKeyWindow]];
                        break;
                    }
                    
                    
                }
                
            }
        }
    }    
}
@end
