//
//
//  Created by jiangchao on 2017/5/23.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "JHLiveRoomMode.h"
#define pagesize 10
#define headViewRate (float) 241/375
#define cellRate (float)  201/345
#import "HomeTableViewHeader.h"
#import "NTESLivePlayerViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHAudienceApplyConnectView.h"
#import "NTESLiveManager.h"

#import "UIImage+GIF.h"
#import "MyLiveViewController.h"
#import "BindingPhoneViewController.h"
#import "JHConnetcMicDetailView.h"
#import "JHWebViewController.h"
#import "JHGemmologistViewController.h"
#import "AdressManagerViewController.h"
#import "JHOrderConfirmViewController.h"
#import "UMengManager.h"
#import "BannerMode.h"
#import "ChannelMode.h"
#import "JHCustomerInfoController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,HomeTableViewHeaderDelegate>
{
    NSInteger PageNum;
    NSArray* rootArr;
    HomeTableViewHeader *  headerView;
    JHLiveRoomMode * selectLiveRoom;
    
}
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) NSMutableArray* liveRoomModes;
@property(nonatomic,strong) NSMutableArray* bannerModes;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self  initToolsBar];
//    [self.navbar setTitle:@"天天鉴宝"];
    self.liveRoomModes=[NSMutableArray arrayWithCapacity:10];
    self.bannerModes=[NSMutableArray arrayWithCapacity:10];
    [self setNavImage];
    [self setHeaderView];
    [self.view addSubview:self.homeTable];
    
    __weak typeof(self) weakSelf = self;
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
     self.homeTable.mj_header = header;
      header.automaticallyChangeAlpha=YES;
    self.homeTable.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
     self.homeTable.mj_footer.hidden=YES;
     [self.homeTable.mj_header beginRefreshing];

}
-(void)setNavImage {
    
    UIImageView * titleIma=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_title"]];
    [self.jhNavView addSubview:titleIma];
    titleIma.contentMode=UIViewContentModeScaleAspectFit;
    
    CGFloat height = 20.0;
    if (@available(iOS 11.0, *))
    {
        CGFloat a =  [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
        if (a>0)
            height = 44;
    }
    [titleIma mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.jhNavView);
        make.top.equalTo(self.jhNavView).offset(height);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
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
    
    headerView=[[HomeTableViewHeader alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    headerView.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    headerView.delegate=self;
    [headerView layoutIfNeeded];
    headerView.frame=CGRectMake(0, 0, ScreenW,headerView.contentView.frame.size.height);
  
}
- (void)pressLiveVC:(UIGestureRecognizer *)gestureRecognizer {
    
    //我要直播
    MyLiveViewController *myliveVC=[MyLiveViewController new];
    [self.navigationController pushViewController:myliveVC animated:YES];
    
}

-(void)requestInfo{
   
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/all?pageNo=%ld&pageSize=%ld"),PageNum,pagesize];
    
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
         [self endRefresh];
        [self handleDataWithArr:respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self endRefresh];
        [UITipView showTipStr:respondObject.message];
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
    [self.homeTable.mj_header endRefreshing];
    [self.homeTable.mj_footer endRefreshing];
}
-(void)requestBanners{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/index/bannerData") Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        self.bannerModes=[NSMutableArray arrayWithCapacity:10];
        self.bannerModes = [BannerMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        [headerView setBanners:self.bannerModes];

    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
    
}

-(UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,0, ScreenW, ScreenH)                                      style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
         _homeTable.tableHeaderView = headerView;
        _homeTable.estimatedRowHeight = 0;
        _homeTable.estimatedSectionFooterHeight = 0;
         _homeTable.contentInset=UIEdgeInsetsMake(JHNavbarHeight, 0,49+JHSafeAreaBottomHeight, 0);
        _homeTable.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
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
    
    static NSString *CellIdentifier=@"cellIdentifier";
     HomeTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[HomeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        MJWeakSelf
        cell.clickAvatar = ^(JHLiveRoomMode *model) {
            JHGemmologistViewController *vc = [[JHGemmologistViewController alloc] init];
            vc.anchorId = model.anchorId;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
    }
       cell.liveRoomMode=[self.liveRoomModes objectAtIndex:indexPath.section];

    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  (ScreenW-30)*cellRate+65+10+10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        return 55;
    }
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
    
        UIView *headerView =[[UIView alloc]init];
        headerView.backgroundColor=[UIColor whiteColor];
        UILabel *  title=[[UILabel alloc]init];
        title.text=@"专业鉴定";
        //    title.font = [UIFont fontWithName:@"PingFang-SC-Bold" size:22.f];
        title.font = [UIFont boldSystemFontOfSize:22];
        title.textColor=[CommHelp toUIColorByStr:@"#000000"];
        title.numberOfLines = 1;
        title.textAlignment = UIControlContentHorizontalAlignmentCenter;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        [headerView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(15);
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
//        return 49+JHSafeAreaBottomHeight;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView  *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectLiveRoom=self.liveRoomModes[indexPath.section];
    
    if([selectLiveRoom.canCustomize isEqualToString:@"1"]){
        if(selectLiveRoom.status.intValue == 2){
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
        [self getLiveRoomDetail];
    }
}
-(void)getLiveRoomDetail{
    
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(selectLiveRoom.ID)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        
        if ([channel.status integerValue]==2)
        {
            
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:channel.httpPullUrl];
            vc.channel=channel;
            vc.coverUrl = selectLiveRoom.coverImg;
            vc.fromString = JHLiveFromhomeIdentify;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else  if ([channel.status integerValue]==1||[channel.status integerValue]==0||[channel.status integerValue]==3||[channel.status integerValue]==4){
            
            NSString *string = nil;
            if (channel.status.integerValue == 1) {
                string = channel.lastVideoUrl;
            }
            
            NTESAudienceLiveViewController *vc = [[NTESAudienceLiveViewController alloc] initWithChatroomId:channel.roomId streamUrl:string];
            vc.channel = channel;
            vc.coverUrl = selectLiveRoom.coverImg;
            vc.fromString = JHLiveFromhomeIdentify;

            [self.navigationController pushViewController:vc animated:YES];
        }

        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
       [SVProgressHUD show];
    
}
#pragma mark =============== HomeTableViewHeaderDelegate ===============
-(void)bannerTap:(BannerMode*)banner{
    
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = banner.picLink;
    [self.navigationController pushViewController:vc animated:YES];
    
//    JHOrderConfirmViewController * adress=[[JHOrderConfirmViewController alloc]init];
//    [self.navigationController pushViewController:adress animated:YES];

}
-(void)headerButtonPress:(UIButton*)btn{
    
    switch (btn.tag) {
        case HeaderButtonTypeFreeAppraisal:
        {
    
            NSLog(@"%@",[CommHelp deviceIDFA]);
            }
            break;
        case HeaderButtonTypeExpert:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

//- (void)netWorkReachable{
//
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//
//        switch (status) {
//            case AFNetworkReachabilityStatusNotReachable:
//            break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//            {
//                if (![[NSUserDefaults standardUserDefaults] boolForKey:HasNet]){
//                    [self loadNewData];
//                    [[UserInfoRequestManager sharedInstance] getLoginWay];
//
//                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:HasNet];
//                      [[NSUserDefaults standardUserDefaults]synchronize];
//                }
//            }
//                break;
//
//            default:
//                break;
//        }
//    }];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

