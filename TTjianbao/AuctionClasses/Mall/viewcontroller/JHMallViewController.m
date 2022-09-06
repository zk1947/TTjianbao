//
//
//  Created by jiangchao on 2017/5/23.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "JHMallViewController.h"
#import "JHMallTableViewCell.h"
#import "CoponPackageMode.h"
#define pagesize 20
#define headViewRate (float) 241/375
#define cellRate (float)  250/345
#import "JHMallHeaderView.h"
#import "NTESLivePlayerViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHAudienceApplyConnectView.h"
#import "NTESLiveManager.h"
#import "UIImage+GIF.h"
#import "MyLiveViewController.h"
#import "JHWebViewController.h"
#import "JHGemmologistViewController.h"
#import "JHPaySuccessViewController.h"
#import "ReceiveCoponView.h"
#import "JHMyCouponViewController.h"
#import "JHRefreshGifHeader.h"
#import "JHGoodAppraisalCommentView.h"
#import "JHAudienceCommentView.h"
#import "JHAppraisalAlertView.h"
#import "JHAudienceOrderListView.h"
#import "NTESLogManager.h"
#import "BannerMode.h"
#import "ChannelMode.h"
#import "TTjianbaoUtil.h"
#import "JHCustomerInfoController.h"

#define cellHeight (float) (ScreenW-20)*cellRate+20

@interface JHMallViewController ()<UITableViewDelegate,UITableViewDataSource,JHMallHeaderViewDelegate>
{
    
    NSInteger PageNum;
    NSArray* rootArr;
    JHMallHeaderView *  headerView;
    JHLiveRoomMode * selectLiveRoom;
    CoponPackageMode  * coponMode;
    NSString * cellId;
    BOOL loadCashDataCmplete;
    JHMallTableViewCell  *lastCell;
    ReceiveCoponView  *coponView;
    
}
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) NSMutableArray <JHLiveRoomMode *> *liveRoomModes;
@property(nonatomic,strong) NSMutableArray* bannerModes;
@property(nonatomic,assign) NSInteger currentSelectIndex;

@end

@implementation JHMallViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.liveRoomModes=[NSMutableArray arrayWithCapacity:10];
    self.bannerModes=[NSMutableArray arrayWithCapacity:10];
    [self setHeaderView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstNet) name:FirstNetNotifaction object:nil];
  
    [self.view addSubview:self.homeTable];
//    [self  initToolsBar];
//   // [self.navbar setTitle:@"尖货商城"];
//     self.navbar.ImageView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
//    [self.navbar addNavImage:[UIImage imageNamed:@"home_title_image"]];
    //此类未用到
     [self setLiveButton];
    
     [self loadCacheData];
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:FirstNet]){
//        [self getNewCopon];
//    }
    
    [self createAddMsgBtn];


}

-(void)firstNet{
    
    [self loadNewData];
  //  [self getNewCopon];
}
-(void)loadCacheData{
    
    PageNum=0;
    self.bannerModes=[NSMutableArray arrayWithCapacity:10];
   __block  NSArray  *arr;
    __block  NSArray  *bannners;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData * data=[FileUtils readDataFromFile:MallBannerData];
        if (data) {
           bannners = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
          }
           NSData  *listData=[FileUtils readDataFromFile:MallLivesData];
        if (listData) {
             arr= [NSJSONSerialization JSONObjectWithData:listData options:NSJSONReadingMutableContainers error:nil];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
              self.bannerModes = [BannerCustomerModel mj_objectArrayWithKeyValuesArray:bannners];
              [headerView setBanners:self.bannerModes];
              [self handleDataWithArr:arr];
              [self.homeTable.mj_header beginRefreshing];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableBarSelect:) name:TableBarSelectNotifaction object:nil];
        });
    });
}
-(void)setLiveButton{
    
    [self showBackTopImage];
    [self.backTopImage setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self pullStream];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [self shutdown];
    lastCell=nil;
}
-(void)loadNewData{
    
     PageNum=0;
    [self requestInfo];
    [self requestBanners];
    
}
-(void)loadMoreData{
    
    PageNum++;
    [self requestInfo];
}

- (void)setHeaderView
{
    headerView=[[JHMallHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    headerView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    headerView.delegate=self;
    [headerView layoutIfNeeded];
    headerView.frame=CGRectMake(0, 0, ScreenW,headerView.contentView.frame.size.height);
    
}
- (void)pressLiveVC:(UIGestureRecognizer *)gestureRecognizer {
    MyLiveViewController *myliveVC=[MyLiveViewController new];
    [self.navigationController pushViewController:myliveVC animated:YES];
}
-(void)requestInfo{
   //
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/sell/authoptional?pageNo=%ld&pageSize=%ld"),PageNum,pagesize];
    
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self handleDataWithArr:respondObject.data];
         [self endRefresh];
        if (PageNum==0) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                if ( [FileUtils writeDataToFile:MallLivesData data:[NSJSONSerialization dataWithJSONObject:respondObject.data options:NSJSONWritingPrettyPrinted error:nil]]) {
                    NSLog(@"Info写入成功");
                }
            });
        }
       
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        
        [self endRefresh];
    }];
}
- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [JHLiveRoomMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.liveRoomModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.liveRoomModes addObjectsFromArray:arr];
    }
    [self.homeTable reloadData];
    
    if ([arr count]<pagesize) {
        
        self.homeTable.mj_footer.hidden=YES;
    }
    else{
        self.homeTable.mj_footer.hidden=NO;
    }
}
- (void)endRefresh {

    [self.homeTable.mj_header endRefreshingWithCompletionBlock:^{
          [self  pullStream];
    }];
    [self.homeTable.mj_footer endRefreshing];
}

- (void)requestBanners{
   
    [HttpRequestTool getWithURL:  COMMUNITY_FILE_BASE_STRING(@"/ad/2") Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        self.bannerModes=[NSMutableArray arrayWithCapacity:10];
        self.bannerModes = [BannerCustomerModel mj_objectArrayWithKeyValuesArray:respondObject.data];
          [headerView setBanners:self.bannerModes];
        
        if (![respondObject.data isKindOfClass:[NSArray class]]) {
            return ;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            if ([FileUtils writeDataToFile:MallBannerData data:[NSJSONSerialization dataWithJSONObject:respondObject.data options:NSJSONWritingPrettyPrinted error:nil]]) {
                NSLog(@"Banner写入成功");
            }
        });
       
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        
    }];
    
    [[UMengManager shareInstance] requestShareDomain];

}

-(UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenW, ScreenH-UI.bottomSafeAreaHeight-49)                                             style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.tableHeaderView = headerView;
        _homeTable.estimatedRowHeight = 0;
        _homeTable.estimatedSectionFooterHeight = 0;
        _homeTable.contentInset=UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0,0, 0);
        _homeTable.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
       
        JHRefreshGifHeader *header = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        //  header.automaticallyChangeAlpha=YES;
         _homeTable.mj_header = header;
        
         JH_WEAK(self)
        
        _homeTable.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadMoreData];
        }];
        self.homeTable.mj_footer.hidden=YES;
        
    }
    return _homeTable;
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.liveRoomModes.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    static NSString *CellIdentifier=@"cellIdentifier";
//    JHMallTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if(cell == nil)
//    {
//        cell = [[JHMallTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.accessoryType=UITableViewCellAccessoryNone;
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
////        MJWeakSelf
//        cell.clickAvatar = ^(JHLiveRoomMode *model) {
////            JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
////            vc.anchorId = model.anchorId;
////            [weakSelf.navigationController pushViewController:vc animated:YES];
//        };
//
//    }
//
//    cell.liveRoomMode=[self.liveRoomModes objectAtIndex:indexPath.section];
//
//    return  cell;
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  cellHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        return 55;
    }
    return CGFLOAT_MIN;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        
        UIView *headerView =[[UIView alloc]init];
        headerView.backgroundColor=[UIColor whiteColor];
        UILabel *  title=[[UILabel alloc]init];
        title.text=@"直播卖场";
        //    title.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:22.f];
        title.font = [UIFont boldSystemFontOfSize:22];
        title.textColor=[CommHelp toUIColorByStr:@"#000000"];
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [headerView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(10);
            make.bottom.equalTo(headerView).offset(0);
        }];
        return headerView;
    }
    
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
    //        return 49+UI.bottomSafeAreaHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView  *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
      selectLiveRoom=self.liveRoomModes[indexPath.section];
     self.currentSelectIndex=indexPath.section;
    //做判断是否是定制师
    if([selectLiveRoom.canCustomize isEqualToString:@"1"]){
        if(selectLiveRoom.status.intValue == 2){
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (self.player) {

                [self shutdown:^{
                    [self getLiveRoomDetail];
                }];
            }
            else{
                [self getLiveRoomDetail];
            }
        }else{
            //定制直播间跳定制主页(未用到)
            JHCustomerInfoController *vc = [[JHCustomerInfoController alloc] init];
            vc.roomId = selectLiveRoom.roomId;
            vc.anchorId = selectLiveRoom.anchorId;
            vc.channelLocalId = selectLiveRoom.channelLocalId;
            vc.fromSource = JHLiveFromLiveRoom;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (self.player) {

            [self shutdown:^{
                [self getLiveRoomDetail];
            }];
        }
        else{
            [self getLiveRoomDetail];
        }
        
    }
}
-(void)getLiveRoomDetail{
    
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
            NSMutableArray * channelArr=[self.liveRoomModes mutableCopy];
            for (JHLiveRoomMode * mode in self.liveRoomModes) {
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

#pragma mark =============== HomeTableViewHeaderDelegate ===============
-(void)bannerTap:(BannerMode*)banner{
    
    
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString =[[banner.picLink stringByAppendingString:@"?customerId="] stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId?:@""];
    [self.navigationController pushViewController:vc animated:YES];
    [JHGrowingIO trackEventId:JHEventBusinesslivebanner];
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    if (![self isRefreshing]&&lastCell) {
        
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:self.view];
        if (rect.origin.y<UI.statusAndNavBarHeight||rect.origin.y+rect.size.height>ScreenH-UI.bottomSafeAreaHeight-49) {
            [self shutdown];
            lastCell=nil;
        }
    }
    
    if (scrollView.contentOffset.y>=ScreenH-UI.statusAndNavBarHeight) {
        
         [self.backTopImage setHidden:NO];
    }
    else{
        [self.backTopImage setHidden:YES];
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if(!decelerate){
        if (![self isRefreshing]) {
            [self  pullStream];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (![self isRefreshing]) {
          [self  pullStream];
    }
}
-(BOOL)isRefreshing{
    
    if ([self.homeTable.mj_header isRefreshing]||self.homeTable.mj_header.state== MJRefreshStatePulling||[self.homeTable.mj_footer isRefreshing]||self.homeTable.mj_footer.state== MJRefreshStatePulling) {
        
        return YES;
    }
    return NO;
}
-(void)pullStream{
    
    if (lastCell) {
        CGRect rect = [lastCell convertRect:lastCell.bounds toView:self.view];
        if (rect.origin.y>=UI.statusAndNavBarHeight&&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49) {
            return ;
        }
    }
    
    if ( ![AFNetworkReachabilityManager sharedManager].isReachableViaWiFi) {
        return;
    }
   
    NSArray* cellArr = [_homeTable visibleCells];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[JHMallTableViewCell class]])
        {
            JHMallTableViewCell *cell=(JHMallTableViewCell *)obj;
             CGRect rect = [cell convertRect:cell.bounds toView:self.view];
        
            if (rect.origin.y>=UI.statusAndNavBarHeight&&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49) {
                
                if (cell.liveRoomMode.ID!=lastCell.liveRoomMode.ID&&[cell.liveRoomMode.status integerValue]==2&&!self.viewDisAppear) {
                    JH_WEAK(self)
                    [self startPlay:cell.liveRoomMode.rtmpPullUrl inView:cell.content andTimeEndBlock:^{
                        JH_STRONG(self)
                        [self shutdown];
                        lastCell=nil;
     
                    }];
                    
                    lastCell=cell;
                }
               
                break;
            }
        }
    }
}

-(void)getNewCopon{
    
    NSString * date=[CommHelp getCurrentDate];
    NSLog(@"date==%@",date);
    if (![CommHelp checkTheDate:[[NSUserDefaults standardUserDefaults ] objectForKey:[LASTDATE stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId?:@""]]]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
  
            [self requestCoupon];;
        });
    }
}
-(void)requestCoupon{
    
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/coupon/package/authoptional?code=%@"),@"P001"];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        coponMode = [CoponPackageMode mj_objectWithKeyValues:respondObject.data];
        if (coponMode.code==1710) {
            return ;
        }
        JH_WEAK(self)
        
        if (coponView) {
            [coponView removeFromSuperview];
        }
    
         coponView=[[ReceiveCoponView alloc]initWithFrame:CGRectMake(0,0, ScreenW, ScreenH)];
         [coponView setMode:coponMode];
         [self.view addSubview:coponView];
        
        coponView.buttonClick = ^(id sender) {
            JH_STRONG(self)
            if (![JHRootController isLogin]) {
                [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
                    if (result) {
                        [self receiveCoupon];
                    }
                }];
            }
            else{
                [self receiveCoupon];
            }
        };
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}
-(void)receiveCoupon{
    
    [coponView dismiss];
    NSDictionary *parameters=@{@"id":coponMode.Id,@"type":@"couponPackage",};
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/coupon/receive/auth") Parameters:parameters requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        
        [[UIApplication sharedApplication].keyWindow makeToast:@"领取成功" duration:1.0 position:CSToastPositionCenter];
        JHMyCouponViewController *vc=[[JHMyCouponViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        [SVProgressHUD dismiss];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
}

-(void)tableBarSelect:(NSNotification*)note{
    
    BaseTabBarController * tablebar=(BaseTabBarController*)note.object;
    if ([self isRefreshing]){
        return;
    }
    if (tablebar.selectedIndex==1) {
           [self.homeTable setContentOffset:CGPointMake(0,-UI.statusAndNavBarHeight) animated:NO];
           [self.homeTable.mj_header beginRefreshing];
    }
    else{
         [self.homeTable setContentOffset:CGPointMake(0,-UI.statusAndNavBarHeight) animated:NO];
    }
    
}
- (void)backTop:(UIGestureRecognizer *)gestureRecognizer {
    
      [self.homeTable setContentOffset:CGPointMake(0,-UI.statusAndNavBarHeight) animated:YES];
}

- (BOOL)prefersStatusBarHidden {
    
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end


