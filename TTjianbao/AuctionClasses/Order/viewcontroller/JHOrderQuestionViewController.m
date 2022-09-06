//
//  JHOrderQuestionViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2019/9/16.
//  Copyright © 2019年 Netease. All rights reserved.
//
#import "JHOrderQuestionViewController.h"
#import "JHSellerOrderListTableViewCell.h"
#import "JHOrderDetailViewController.h"
#import "JHOrderPayViewController.h"
#import "JHQYChatManage.h"
#define pagesize 10
#define cellRate (float)  201/345
#import "JHOrderSegmentView.h"
#import "JHSendCommentViewController.h"
#import "OrderDateChooseView.h"
#import "JHOrderExportSuccessView.h"
#import "NaiveShareManager.h"
#import "JHSellerSendOrderViewController.h"
#import "JHOrderListSegmentView.h"
#import "CommAlertView.h"
#import "JHOrderReturnViewController.h"
#import "JHQRViewController.h"
#import "JHWebViewController.h"
#import "JHLiveRoomMode.h"
#import "BYTimer.h"
#import "TTjianbaoBussiness.h"

@interface JHOrderQuestionViewController ()<UITableViewDelegate,UITableViewDataSource,JHOrderSegmentViewViewDelegate,JHSellerOrderListTableViewCellDelegate>
{
    NSInteger PageNum;
    NSArray* rootArr;
    JHOrderListSegmentView *  headerView;
    JHLiveRoomMode * selectLiveRoom;
    BYTimer *timer;
    float titleViewHeight;
}
@property(nonatomic,strong) UITableView* homeTable;
@property(nonatomic,strong) NSMutableArray* orderModes;
@property(nonatomic,strong) NSMutableArray* bannerModes;
@property(nonatomic,strong)  NSString * searchStatus;
@property (nonatomic,strong)UIDocumentInteractionController * document;
@property (nonatomic,strong)UIButton * scanBtn;
@property (nonatomic,strong)   OrderMode * selectMode;
@end

@implementation JHOrderQuestionViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
           self.searchStatus=@"problem";
       // self.searchStatus=@"all";
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self  initToolsBar];
//    [self.navbar setTitle:@"问题单"];
    self.title = @"问题单";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.homeTable];
    __weak typeof(self) weakSelf = self;
    self.homeTable.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    self.homeTable.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
     self.homeTable.mj_footer.hidden=YES;
    [self.homeTable.mj_header beginRefreshing];
    
      [self updateCellTimeStatus];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}
-(void)loadNewData{
    
    PageNum=0;
    [self requestInfo];
}
-(void)loadMoreData{
    
    PageNum++;
    [self requestInfo];
}

-(void)requestInfo{
    
     User *user = [UserInfoRequestManager sharedInstance].user;
    NSString *url =[NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/sellerOrderList?searchStatus=%@&pageNo=%ld&pageSize=%ld&isAssistant=%@"),self.searchStatus,PageNum,pagesize,user.isAssistant?@"1":@"0"];

    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [self handleDataWithArr:respondObject.data];
        [self endRefresh];
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        
        [self endRefresh];
    }];
}

- (void)handleDataWithArr:(NSArray *)array {
    NSArray *arr = [OrderMode mj_objectArrayWithKeyValuesArray:array];
    if (PageNum == 0) {
        self.orderModes = [NSMutableArray arrayWithArray:arr];
    }else {
        [self.orderModes addObjectsFromArray:arr];
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
    if (self.orderModes.count) {
        [self hiddenDefaultImage];
    }else {
        [self showDefaultImageWithView:self.homeTable];
    }
}

-(UITableView*)homeTable{
    
    if (!_homeTable) {
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight)                                      style:UITableViewStyleGrouped];
        _homeTable.delegate=self;
        _homeTable.dataSource=self;
        _homeTable.alwaysBounceVertical=YES;
        _homeTable.scrollEnabled=YES;
        _homeTable.estimatedRowHeight = 255;
        _homeTable.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        [_homeTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _homeTable;
}

#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.orderModes.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    JHSellerOrderListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHSellerOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.delegate=self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
        [cell setOrderMode:self.orderModes[indexPath.section]];
        cell.isProblem=YES;
    
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // return 245;
    return  UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        return CGFLOAT_MIN;
    }
    return 10;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView =[[UIView alloc]init];
    headerView.backgroundColor=[CommHelp toUIColorByStr:@"#eeeeee"];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView  *view=[[UIView alloc]init];
    view.backgroundColor=[UIColor clearColor];
    return view;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHOrderDetailViewController * order=[[JHOrderDetailViewController alloc]init];
    order.orderId=[self.orderModes[indexPath.section]orderId];
    order.isSeller=YES;
    order.isProblem=YES;
    [self.navigationController pushViewController:order animated:YES];
    
}

-(void)buttonPress:(UIButton*)button withOrder:(OrderMode*)mode{
    
    self.selectMode=mode;
    switch (button.tag) {
        case JHOrderButtonTypeOrderDetail:
        {
            JHOrderDetailViewController * order=[[JHOrderDetailViewController alloc]init];
            order.orderId=mode.orderId;
            order.isSeller=YES;
            order.isProblem=YES;
            [self.navigationController pushViewController:order animated:YES];
        }
            break;
        case JHOrderButtonTypeQuestionDetail: {
            
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString = [H5_BASE_STRING(@"/jianhuo/app/problemDetails.html?orderId=") stringByAppendingString:OBJ_TO_STRING(mode.orderId)];
            [self.navigationController pushViewController:webVC animated:YES];
        }
            break;
        default:
            break;
            
    }
}
-(void)updateCellTimeStatus
{
    JH_WEAK(self)
    if (!timer) {
        timer=[[BYTimer alloc]init];
    }
    [timer startGCDTimerOnMainQueueWithInterval:1 Blcok:^{
        JH_STRONG(self)
        [self updateTime];
    }];
    
}
-(void)updateTime
{
    NSArray* cellArr = [_homeTable visibleCells];
    for(id obj in cellArr)
    {
        if([obj isKindOfClass:[JHSellerOrderListTableViewCell class]])
        {
            JHSellerOrderListTableViewCell *cell=(JHSellerOrderListTableViewCell *)obj;
            if ([cell.orderMode.orderStatus isEqualToString:@"waitpay"]||[cell.orderMode.orderStatus isEqualToString:@"waitack"]){
                NSString * status=[cell.orderMode.orderStatus isEqualToString:@"waitpay"]?@"待付款 ":@"待确认 ";
                if ([CommHelp dateRemaining:cell.orderMode.payExpireTime]>0) {
                    cell.orderRemainTime=[status stringByAppendingString:[CommHelp getHMSWithSecond:[CommHelp dateRemaining:cell.orderMode.payExpireTime]]];
                }
                else{
                    cell.orderRemainTime=@"订单已取消";
                }
            }
            
            else  if ([cell.orderMode.orderStatus isEqualToString:@"waitsellersend"]){
            }
        }
    }
}
-(void)orderOut:(UIButton*)button{
   
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end



