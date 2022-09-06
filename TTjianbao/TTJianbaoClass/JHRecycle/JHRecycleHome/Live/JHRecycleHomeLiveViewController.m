//
//  JHRecycleHomeLiveViewController.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeLiveViewController.h"
#import "JHMallLittleCollectionViewCell.h"
#import "JHLiveRoomMode.h"
#import "NTESAudienceLiveViewController.h"
#import "JHEmptyCollectionCell.h"
#import "JHCustomizeGuideTipView.h"
#import "UIScrollView+JHEmpty.h"
#import "YDRefreshFooter.h"
#import <MBProgressHUD.h>

@interface JHRecycleHomeLiveViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>{
    NSInteger PageNum;
    NSInteger pagesize;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <JHLiveRoomMode *>*dataModes;

@end

@implementation JHRecycleHomeLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"直播回收";

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
    }];
    
    [self reloadNewData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"直播回收页"
    } type:JHStatisticsTypeSensors];
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
    NSString *url = FILE_BASE_STRING(@"/channel/recycle/sell/list");
    NSDictionary *dic = @{@"pageNo":@(PageNum),@"pageSize":@(pagesize)};
    [HttpRequestTool getWithURL:url Parameters:dic successBlock:^(RequestModel *respondObject) {
        [self.collectionView.mj_header endRefreshing];
        
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
        } else {
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        //当数据超过一屏后才显示“已经到底”文案
        if (arr.count > 6) {
            ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
        }
    }
    failureBlock:^(RequestModel *respondObject) {
        [self.collectionView jh_endRefreshing];
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
    //crash判空处理,目前逻辑,如果异常不进直播间
    if (model.channelLocalId.length> 0) {
        [self getDetail:model.channelLocalId];

        [JHAllStatistics jh_allStatisticsWithEventId:@"clickLiveRoom" params:@{
            @"channel_local_id":model.channelLocalId,
            @"live_type":@"recycle",
            @"page_position":@"recycleAggregationLive"
        } type:JHStatisticsTypeSensors];
    }


}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataModes.count == 0) {
        return self.collectionView.size;
    }
    CGFloat itemW = (ScreenW - 33.f) / 2. ;
    return CGSizeMake(itemW, itemW * 249. / 171.);
}

-(void)getDetail:(NSString *)selectLiveRoomId {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(selectLiveRoomId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];

       ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
       channel.first_channel = @"回收";
       if ([channel.status integerValue]==2)
       {
           NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
           vc.channel = channel;
           vc.coverUrl = channel.coverImg;
           vc.fromString = @"回收直播聚合页";
           [self.navigationController pushViewController:vc animated:YES];
           
       }else{
           NSString *string = nil;
           if (channel.status.integerValue == 1) {
               string = channel.lastVideoUrl;
           }
           NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
           vc.channel = channel;
           vc.coverUrl = channel.coverImg;
           vc.fromString = @"回收直播聚合页";
           [self.navigationController pushViewController:vc animated:YES];
        }
       
   } failureBlock:^(RequestModel *respondObject) {
       [MBProgressHUD hideHUDForView:self.view animated:YES];
       [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
       
   }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        if (scrollView.contentOffset.y>0) {
            [self scrollToListShow];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    NSLog(@"scrollViewDidEndDraggingy ===%f", scrollView.contentOffset.y);
    if (!decelerate) {
        if (scrollView.contentOffset.y>0) {
            [self scrollToListShow];
        }
      
    }

}



#pragma  mark -UI绘制
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 9;
        layout.minimumLineSpacing = 9;
        // 设置每个分区的 上左下右 的内边距
        layout.sectionInset = UIEdgeInsetsMake(12, 12 ,12, 12);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kColorF5F6FA;
        [_collectionView registerClass:[JHMallLittleCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHMallLittleCollectionViewCell class])];
        [_collectionView registerClass:[JHEmptyCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHEmptyCollectionCell class])];
        @weakify(self)
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self loadData];
        }];
        _collectionView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];

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
