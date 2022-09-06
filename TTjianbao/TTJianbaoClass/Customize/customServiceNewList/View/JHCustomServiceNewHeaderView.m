//
//  JHCustomServiceNewHeaderView.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomServiceNewHeaderView.h"
#import "JHMallRecommendHeader.h"
#import "JHFreeCustomServiceView.h"
#import "JHOrderStateview.h"
#import "JHAdsCycleView.h"
#import "JHLivePlayerManager.h"
#import "JHMallLittleCollectionViewCell.h"

/** 临时数据*/
#import "SourceMallApiManager.h"
#import "JHMallOperationModel.h"
#import "JHLastOrderModel.h"
#import "NTESAudienceLiveViewController.h"
#import "MBProgressHUD.h"
#import "JHCustomerInfoController.h"
#import "JHGrowingIO.h"


#define kCycleViewH (ScreenW * 210 / 375.f + 34)
#define kFreeViewH 141
#define kOrderViewH 104
#define kAdsViewH (70 / 375.f * ScreenW + 16)

@interface JHCustomServiceNewHeaderView()
/** 推荐位轮播*/
@property (nonatomic, strong) JHMallRecommendHeader *cycleHeader;
/** 免费申请定制模块*/
@property (nonatomic, strong) JHFreeCustomServiceView *freeCustomView;
/** 订单状态模块*/
@property (nonatomic, strong) JHOrderStateview *orderStatusView;
/** 广告轮播模块*/
@property (nonatomic, strong) JHAdsCycleView *adsCycleView;
/** 记录最后播放的视图*/
@property(nonatomic,strong) UIView *lastCycleView;

/** 最后一条订单*/
@property (nonatomic, strong) JHLastOrderModel *orderModel;
/** 推荐位数据*/
@property (nonatomic, strong) JHMallOperationModel *mallOperationModel;
@property(nonatomic,assign) NSInteger currentSelectIndex;
/** 关闭拉流*/
@property(nonatomic,assign) BOOL isAutoScroll;
/** 是否当前页面*/
@property(nonatomic,assign) BOOL isCurrentHeader;

@property (nonatomic, assign) NSInteger cycleSelectIndex;

@end
@implementation JHCustomServiceNewHeaderView
#pragma mark - 进入前后台Observer
- (void)addObserver {
    @weakify(self);
    //进入前台
    //takeUntil会接收一个signal,当signal触发后会把之前的信号释放掉
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationWillEnterForegroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        if (self.isCurrentHeader) {
            self.isAutoScroll = YES;
            [self pullStream];
        }
    }];
    
    //进入后台
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
        @strongify(self);
        if (self.isCurrentHeader) {
            self.isAutoScroll = NO;
            [self shutdownPlayStream];
        }
    }];
    
}
- (void)removeObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDismiss{
    self.isAutoScroll = NO;
    self.isCurrentHeader = NO;
    [self shutdownPlayStream];
}
- (void)viewAppear{
    self.isAutoScroll = YES;
    self.isCurrentHeader = YES;
    [self pullStream];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self configUI];
//        [self reloadData];
//        [self shutdownPlayStream];
//        [self loadRecommendData];
        self.isAutoScroll = YES;
        self.isCurrentHeader = YES;
        [self addObserver];
    }
    return self;
}

- (void)configUI{
    self.backgroundColor = HEXCOLOR(0xf5f6fa);
    [self addSubview:self.cycleHeader];
    [self addSubview:self.freeCustomView];
    [self addSubview:self.orderStatusView];
    [self addSubview:self.adsCycleView];
    self.height = self.adsCycleView.bottom;
}
#pragma  mark -重新刷新UI布局
- (void)reBuildUI{
    if (self.cycleHeader.liveRoomData.count > 1) {
        self.cycleHeader.frame = CGRectMake(0, 0, ScreenWidth, kCycleViewH);
        self.freeCustomView.frame = CGRectMake(0, self.cycleHeader.bottom + 8, ScreenWidth, kFreeViewH);

    }else{
        self.cycleHeader.frame = CGRectMake(0, 0, ScreenWidth, 0);
        self.freeCustomView.frame = CGRectMake(0, self.cycleHeader.bottom, ScreenWidth, kFreeViewH);

    }
    if (self.orderModel.isShow.integerValue == 1) {
        self.orderStatusView.frame = CGRectMake(0, self.freeCustomView.bottom, ScreenWidth, kOrderViewH);
    }else{
        self.orderStatusView.frame = CGRectMake(0, self.freeCustomView.bottom, ScreenWidth, 0);
    }

    if (self.adsCycleView.adsArray.count > 0) {
        self.adsCycleView.frame = CGRectMake(0, self.orderStatusView.bottom, ScreenWidth, kAdsViewH);
    }else{
        self.adsCycleView.frame = CGRectMake(0, self.orderStatusView.bottom, ScreenWidth, 0);
    }

    self.height = self.adsCycleView.bottom;
    if (self.changeHeightBlock) {
        self.changeHeightBlock(self.height);
    }
}
#pragma mark -请求数据
- (void)reloadData{
    [self shutdownPlayStream];
    [self loadRecommendData];
    [self getLastOrderData];
}

- (void)reloadLastOrderData{
    [self getLastOrderData];
}

- (void)loadRecommendData{
    NSString *url = FILE_BASE_STRING(@"/anon/operation/customize-list-defini");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        JHMallOperationModel *mallOperationModel = [JHMallOperationModel mj_objectWithKeyValues:respondObject.data];
        self.mallOperationModel = mallOperationModel;
        self.cycleHeader.liveRoomData = mallOperationModel.slideShow;
        self.adsCycleView.adsArray = mallOperationModel.operationPosition;
        [self reBuildUI];
        if (self.completeBlock) {
            self.completeBlock();
        }
    }failureBlock:^(RequestModel *respondObject) {
        [self reBuildUI];
        if (self.completeBlock) {
            self.completeBlock();
        }
    }];
}
/** 请求最后一条订单*/
- (void)getLastOrderData{
    NSString *url = FILE_BASE_STRING(@"/orderCustomize/auth/getHomeNewOrder");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.data) {
            self.orderModel = [JHLastOrderModel mj_objectWithKeyValues:respondObject.data];
            self.orderStatusView.model = self.orderModel;
            [self reBuildUI];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        //调取失败,隐藏订单视图
        self.orderModel.isShow = @"0";
        [self reBuildUI];
    }];
}
/** 接收推荐位数据*/
- (void)reciveRecommendData{
    [self reBuildUI];
}
/** 接收订单数据*/
- (void)reciveOrderData{
    [self reBuildUI];
}
/** 判断拉流轮播图是否在可视范围内部*/
-(BOOL)cycleInScreen{
    CGRect rect = [self.cycleHeader convertRect:self.cycleHeader.bounds toView:[UIApplication sharedApplication].keyWindow];
    
     NSLog(@"cycleHeader坐标=%@",NSStringFromCGRect(rect));
    if(rect.origin.y+rect.size.height>=UI.statusAndNavBarHeight) {
        return YES;
    }
    return NO;
    
}
/** 关闭拉流*/
-(void)shutdownPlayStream{
    /** 划出屏幕,刷新数据,点击跳转,都要关闭拉流*/
    [[JHLivePlayerManager sharedInstance ] shutdown];
    self.lastCycleView = nil;
}

-(void)pullStream{
  //轮播图在屏幕
    [NSObject cancelPreviousPerformRequestsWithTarget:self.cycleHeader selector:@selector(scrollToNextPage) object:nil];
    [self.cycleHeader performSelector:@selector(scrollToNextPage) withObject:nil afterDelay:0.5];
   // [self.cycleHeader scrollToNextPage];
}

#pragma mark -拉流处理
-(void)pullsteam:(UIView*)steamView andliveRoomSource:(JHLiveRoomMode*)mode
{
    NSString *pullUrl = mode.rtmpPullUrl;
    @weakify(self);
    [[JHLivePlayerManager sharedInstance] startPlay:pullUrl inView:steamView playFailBlock:^{
        @strongify(self);
         [[JHLivePlayerManager sharedInstance ] shutdown];
        //切换到下个轮播图
        if (self.isAutoScroll) {
              NSLog(@"轮播拉流中******************");
                [self.cycleHeader scrollToNextPage];
               }
       // [self.cycleHeader scrollToNextPage];
    } playOutTimeBlock:^{
        @strongify(self);
        [[JHLivePlayerManager sharedInstance ] shutdown];
        //切换到下个轮播图
        if (self.isAutoScroll) {
            NSLog(@"轮播拉流中******************");
             [self.cycleHeader scrollToNextPage];
        }
    } timeInterval:3 isAnimal:NO isLikeImageView:YES];
}
#pragma  mark -UI绘制
- (JHMallRecommendHeader *)cycleHeader {
    if (!_cycleHeader) {
        _cycleHeader = [[JHMallRecommendHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
        _cycleHeader.backgroundColor = [UIColor whiteColor];
        _cycleHeader.clipsToBounds = YES;
        @weakify(self);
        _cycleHeader.scrolledBlock = ^(UIView * _Nonnull steamView, JHLiveRoomMode * _Nonnull liveRoomSource) {
            @strongify(self);
            [self pullsteam:steamView andliveRoomSource:liveRoomSource];
            self.lastCycleView = steamView;
        };
        
        _cycleHeader.willDraggBlock = ^{
            ///停止拉流
            @strongify(self);
            [[JHLivePlayerManager sharedInstance] shutdown];
            self.lastCycleView = nil;
        };
        _cycleHeader.didSelectBLock = ^(NSInteger index) {
            @strongify(self);
            self.cycleSelectIndex = index;
            JHLiveRoomMode *model = self.mallOperationModel.slideShow[index];
            NSString *vcName = @"NTESAudienceLiveViewController";
            if([model.canCustomize isEqualToString:@"1"]){
                if(model.status.intValue == 2){
                    [self getLiveRoomDetail:model.ID andListType:JHGestureChangeLiveRoomFromMallRecommendCycle];
                }else{
                    //定制直播间跳定制主页
                    JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
                    vc.roomId = model.roomId;
                    vc.anchorId = model.anchorId;
                    vc.channelLocalId = model.channelLocalId;
                    vc.fromSource = @"dz_tv_banner_in";
                    [self.viewController.navigationController pushViewController:vc animated:YES];
                    vcName = @"JHCustomerInfoController";
                }
            }else{
                [self getLiveRoomDetail:model.ID andListType:JHGestureChangeLiveRoomFromMallRecommendCycle];
            }
            [JHGrowingIO trackEventId:JHTrackCustomizelive_tv_banner_click variables:@{@"position":@(index+1),@"channelLocalId":model.channelLocalId}];
            //新埋点
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            params[@"page_position"] = @"天天定制主页";
            params[@"model_type"] = @"天天定制主页顶部轮播图";
            params[@"channel_status"] = model.status.intValue == 2 ? @"是" : @"否";
            params[@"channel_name"] = NONNULL_STR(model.title);
            params[@"channel_label"] = @"无";
            params[@"anchor_id"] = NONNULL_STR(model.anchorId);
            params[@"anchor_nick_name"] = NONNULL_STR(model.anchorName);
            params[@"channel_local_id"] = NONNULL_STR(model.channelLocalId);
            params[@"position_sort"] = [NSString stringWithFormat:@"%@", @(index)];
            params[@"content_url"] = vcName;
            [JHAllStatistics jh_allStatisticsWithEventId:@"channelClick" params:params type:JHStatisticsTypeSensors];
        };
     }
    return _cycleHeader;
}
-(void)getLiveRoomDetail:(NSString*)Id andListType:(JHGestureChangeLiveRoomFromType)listType{
    
    [MBProgressHUD showHUDAddedTo:self.viewController.view animated:YES];
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(Id)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        channel.first_channel = @"天天定制轮播直播间";
        ///369神策埋点:直播间点击
        [JHTracking sa_clickLiveRoomList:channel pagePosition:@"天天定制" currentIndex:@(self.cycleSelectIndex).stringValue];
        
        if ([channel.status integerValue]==2)
        {
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
            vc.channel=channel;
//            vc.coverUrl = selectLiveRoom.coverImg;
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
           
//            vc.PageNum=PageNum;
            vc.listFromType=listType;
//            [self setLiveRoomParamsForVC:vc];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
        else  if ([channel.status integerValue]==1||[channel.status integerValue]==0||[channel.status integerValue]==3){
            
            NSString *string = nil;
            if (channel.status.integerValue == 1) {
                string = channel.lastVideoUrl;
            }
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
            vc.channel = channel;
//            vc.coverUrl = selectLiveRoom.coverImg;
            vc.audienceUserRoleType = JHAudienceUserRoleTypeSale;
//            [self setLiveRoomParamsForVC:vc];
            [self.viewController.navigationController pushViewController:vc animated:YES];
        }
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        [MBProgressHUD hideHUDForView:self.viewController.view animated:YES];
        [self.viewController.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
}
- (JHFreeCustomServiceView *)freeCustomView{
    if (_freeCustomView == nil) {
        _freeCustomView = [[JHFreeCustomServiceView alloc] initWithFrame:CGRectMake(0, self.cycleHeader.bottom, ScreenWidth, kFreeViewH)];
    }
    return _freeCustomView;
}

- (JHOrderStateview *)orderStatusView{
    if (_orderStatusView == nil) {
        _orderStatusView = [[JHOrderStateview alloc] initWithFrame:CGRectMake(0, self.freeCustomView.bottom, ScreenWidth, 0)];
        _orderStatusView.clipsToBounds = YES;
    }
    return _orderStatusView;
}

- (JHAdsCycleView *)adsCycleView{
    if (_adsCycleView == nil) {
        _adsCycleView = [[JHAdsCycleView alloc] initWithFrame:CGRectMake(0, self.orderStatusView.bottom, ScreenWidth, 0)];
        _adsCycleView.clipsToBounds = YES;
    }
    return _adsCycleView;
}


@end
