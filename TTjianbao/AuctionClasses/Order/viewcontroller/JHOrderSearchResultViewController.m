//
//
//  Created by jiangchao on 2017/5/23.
//  Copyright © 2017年 jiangchao. All rights reserved.
//
#import "JHOrderSearchResultViewController.h"
#import "JHOrderListTableViewCell.h"
#import "JHSellerOrderListTableViewCell.h"
#import "JHOrderDetailViewController.h"
#import "JHOrderPayViewController.h"
#import "JHOrderConfirmViewController.h"
#import "JHExpressViewController.h"
#import "JHQYChatManage.h"
#import "JHSendOutViewController.h"
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
#import "AdressManagerViewController.h"
#import "JHWebViewController.h"
#import "JHOrderNoteView.h"
#import "JHOrderApplyReturnViewController.h"
#import "JHAppraiseOrderViewController.h"
#import "JHOrderSearchView.h"
#import "ExportOrderMode.h"
#import "JHOrderViewModel.h"
#import "JHLiveRoomMode.h"
#import "HttpDownLoadFileTool.h"
#import "TTjianbaoHeader.h"
#import "BYTimer.h"
#import "JHRecycleLogisticsViewController.h"
#import "JHRefunfOrderModel.h"

@interface JHOrderSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,JHOrderSegmentViewViewDelegate,JHOrderListTableViewCellDelegate,JHSellerOrderListTableViewCellDelegate,UIDocumentInteractionControllerDelegate>
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
@property (nonatomic,strong)UIButton * orderOutBtn;
@property (nonatomic,strong)   OrderMode * selectMode;
@end

@implementation JHOrderSearchResultViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.currentIndex=0;
        self.searchStatus=@"all";
    }
    return self;
}
  
- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [self  initToolsBar];
    self.isSeller=YES;
    if (self.isSeller) {
//        [self.navbar setTitle:@"搜索结果"];
        self.title = @"搜索结果";
    }
    else{
//        [self.navbar setTitle:@"我买到的"];
        self.title = @"我买到的";
        titleViewHeight=30;
        [self initTitleView];
    }
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.bannerModes=[NSMutableArray arrayWithCapacity:10];
   // [self setHeaderView];
    [self.view addSubview:self.homeTable];
    __weak typeof(self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:ORDERSTATUSCHANGENotifaction object:nil];
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
-(void)initTitleView{
    
    UIView * titleView=[[UIView alloc]init];
    titleView.backgroundColor=[CommHelp  toUIColorByStr:@"#fffbdc"];
    [self.view addSubview:titleView];
    
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.equalTo(self.view).offset(0);
        make.right.equalTo(self.view).offset(0);
        make.height.offset(titleViewHeight);
        make.width.offset(ScreenW);
    }];
    
    UIImageView *logo=[[UIImageView alloc]init];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    logo.image=[UIImage imageNamed:@"order_gift_tip_logo"];
    [titleView addSubview:logo];
    
    [logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleView).offset(20);
        make.centerY.equalTo(titleView);
        make.size.mas_equalTo(CGSizeMake(14, 13));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines =1;
    label.textAlignment = UIControlContentHorizontalAlignmentCenter;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.textColor=[CommHelp toUIColorByStr:@"#ff4200"];
    label.text = @"评价分享拿好礼，快来评价互动吧。";
    label.font=[UIFont systemFontOfSize:13];
    [titleView addSubview:label];
    
    [ label  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(logo.mas_right).offset(5);
        make.centerY.equalTo(logo);
    }];
    
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
-(void)showScanBtn{
    
    if (self.isSeller) {
        [self.view addSubview:self.scanBtn];
        [self.view addSubview:self.orderOutBtn];
        self.homeTable.height=ScreenH-UI.statusAndNavBarHeight-50-titleViewHeight-50;
    }
    else{
        self.homeTable.height=ScreenH-UI.statusAndNavBarHeight-50-titleViewHeight;
    }
}
- (void)setHeaderView
{
    headerView=[[JHOrderListSegmentView alloc]initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight+titleViewHeight, ScreenW, 50)];
    if (self.isSeller) {
        [headerView setTitles:@[@"全部",@"待付款",@"待发货",@"结算中",@"已结算",@"退款售后"]];
    }
    else{
        [headerView setTitles:@[@"全部",@"待付款",@"待发货",@"待验货",@"待收货",@"已完成",@"退款售后"]];
    }
    JH_WEAK(self)
    headerView.selectedItemHelper = ^(NSInteger index) {
        JH_STRONG(self)
        self.searchStatus=[self getSearchStatusByIndex:index];
        self.orderModes=[NSMutableArray array];
        [self.homeTable reloadData];
        [self.homeTable.mj_header beginRefreshing];
    };
    
    [self.view addSubview:headerView] ;
    [headerView changeItemToTargetIndex:self.currentIndex];
}
-(void)setCurrentIndex:(int)currentIndex{
    _currentIndex=currentIndex;
    self.searchStatus=[self getSearchStatusByIndex:_currentIndex];
}
#pragma mark ===============JHOrderListHeaderViewDelegate===============
- (void)segMentButtonPress:(UIButton *)button
{
    self.searchStatus=[self getSearchStatusByIndex:button.tag];
    if ([self.searchStatus isEqualToString:@"waitsellersend"]&&self.isSeller) {
        self.homeTable.height=ScreenH-UI.statusAndNavBarHeight-50-titleViewHeight-50;
        self.scanBtn.hidden=NO;
    }
    else{
        self.homeTable.height=ScreenH-UI.statusAndNavBarHeight-50-titleViewHeight;
        self.scanBtn.hidden=YES;
    }
    [self.homeTable.mj_header beginRefreshing];
}
-(NSString*)getSearchStatusByIndex:(NSInteger)index{
    
    NSString * status;
    if (self.isSeller) {
        switch (index) {
            case 0:
                status=@"all";
                break;
            case 1:
                status=@"waitpay";
                break;
            case 2:
                status=@"waitsellersend";
                break;
            case 3:
                status=@"portalsent";
                break;
            case 4:
                status=@"buyerreceived";
                break;
            case 5:
                status=@"refund";
                break;
            default:
                break;
        }
    }
    else{
        switch (index) {
            case 0:
                status=@"all";
                break;
            case 1:
                status=@"waitpay";
                break;
            case 2:
                status=@"waitsellersend";
                break;
            case 3:
                status=@"waitportalappraise";
                break;
            case 4:
                status=@"portalsent";
                break;
            case 5:
                status=@"buyerreceived";
                break;
            case 6:
                status=@"refund";
                break;
            default:
                break;
        }
    }
    return status;
    
}
-(void)requestInfo{
    
    NSString *url;
    if (self.isSeller) {
        User *user = [UserInfoRequestManager sharedInstance].user;
        url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/sellerOrderList?pageNo=%ld&pageSize=%ld&isAssistant=%@"),PageNum,pagesize,user.isAssistant?@"1":@"0"];
    }
    else{
        url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/buyerOrderList?pageNo=%ld&pageSize=%ld"),PageNum,pagesize];
    }
    [HttpRequestTool getWithURL:url Parameters:self.params successBlock:^(RequestModel *respondObject) {
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
        _homeTable=[[UITableView alloc]initWithFrame:CGRectMake(0,UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight) style:UITableViewStyleGrouped];
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
-(UIButton*)scanBtn{
    if (!_scanBtn) {
        _scanBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _scanBtn.frame=CGRectMake(0, ScreenH-50,ScreenW, 50);
        _scanBtn.titleLabel.font= [UIFont systemFontOfSize:18];
        [_scanBtn setTitle:@"扫码发货" forState:UIControlStateNormal];
        //        _scanBtn.layer.cornerRadius = 2.0;
        //        [_scanBtn setBackgroundColor:[UIColor whiteColor]];
        //        _scanBtn.layer.borderColor = [[CommHelp toUIColorByStr:@"#222222"] colorWithAlphaComponent:0.5].CGColor;
        //        _scanBtn.layer.borderWidth = 0.5f;
        _scanBtn.backgroundColor=[CommHelp toUIColorByStr:@"#fee100"];
        [_scanBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(Scan:) forControlEvents:UIControlEventTouchUpInside];
        _scanBtn.contentMode=UIViewContentModeScaleAspectFit;
        
    }
    return _scanBtn;
}
-(UIButton*)orderOutBtn{
    if (!_orderOutBtn) {
        _orderOutBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        _orderOutBtn.frame=CGRectMake(ScreenW-60, ScreenH/2+50, 50, 50);
        _orderOutBtn.titleLabel.font= [UIFont systemFontOfSize:13];
        [_orderOutBtn setTitle:@"订单\n导出" forState:UIControlStateNormal];
        _orderOutBtn.layer.cornerRadius = 25;
        _orderOutBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _orderOutBtn.backgroundColor=[CommHelp toUIColorByStr:@"#feda00"];
        [_orderOutBtn setTitleColor:[CommHelp toUIColorByStr:@"#333333"] forState:UIControlStateNormal];
        [_orderOutBtn addTarget:self action:@selector(orderOut:) forControlEvents:UIControlEventTouchUpInside];
        _orderOutBtn.contentMode=UIViewContentModeScaleAspectFit;
        
    }
    return _orderOutBtn;
}
#pragma mark tableviewDatesource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    //  return 1;
    return self.orderModes.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier=@"cellIdentifier";
    
    if (self.isSeller) {
        JHSellerOrderListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[JHSellerOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType=UITableViewCellAccessoryNone;
            cell.delegate=self;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [cell setOrderMode:self.orderModes[indexPath.section]];
        
        return  cell;
    }
    
    JHOrderListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[JHOrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryNone;
        cell.delegate=self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cell setOrderMode:self.orderModes[indexPath.section]];
    
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
    
    if ([[self.orderModes[indexPath.section]orderStatus]isEqualToString:@"waitack"]
        &&!self.isSeller) {
        JHOrderConfirmViewController * order=[[JHOrderConfirmViewController alloc]init];
        order.orderId=[self.orderModes[indexPath.section]orderId];
        [self.navigationController pushViewController:order animated:YES];
    }
    else{
        JHOrderDetailViewController * detail=[[JHOrderDetailViewController alloc]init];
        detail.orderId=[self.orderModes[indexPath.section]orderId];
        detail.isSeller=self.isSeller;
        [self.navigationController pushViewController:detail animated:YES];
        
    }
    //    JHAppraiseOrderViewController * vc=[[JHAppraiseOrderViewController alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    //
    
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
        if([obj isKindOfClass:[JHOrderListTableViewCell class]])
        {
            JHOrderListTableViewCell *cell=(JHOrderListTableViewCell *)obj;
            if ([cell.orderMode.orderStatus isEqualToString:@"waitpay"]||[cell.orderMode.orderStatus isEqualToString:@"waitack"]){
                NSString * status=[cell.orderMode.orderStatus isEqualToString:@"waitpay"]?@"待付款 ":@"待付款 ";
                if ([CommHelp dateRemaining:cell.orderMode.payExpireTime]>0) {
                    cell.orderRemainTime=[status stringByAppendingString:[CommHelp getHMSWithSecond:[CommHelp dateRemaining:cell.orderMode.payExpireTime]]];
                }
                else{
                    cell.orderRemainTime=@"订单已取消";
                }
            }
            else  if ([cell.orderMode.orderStatus isEqualToString:@"refunding"]&&cell.orderMode.refundButtonShow){
                NSString * status=cell.orderMode.workorderDesc ;
                if ([CommHelp dateRemaining:cell.orderMode.refundExpireTime]>0) {
                    cell.orderRemainTime=[NSString stringWithFormat:@"%@:%@",status,[CommHelp getHMSWithSecond:[CommHelp dateRemaining:cell.orderMode.refundExpireTime]]];
                }
                else{
                    cell.orderRemainTime=cell.orderMode.workorderDesc;
                }
            }
        }
        
        else if([obj isKindOfClass:[JHSellerOrderListTableViewCell class]])
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
                //                NSString * status=@"待发货";
                //                if ([CommHelp dateRemaining:cell.orderMode.sellerSentExpireTime]>0) {
                //                    cell.orderRemainTime=[status stringByAppendingString:[CommHelp getHMSWithSecond:[CommHelp dateRemaining:cell.orderMode.sellerSentExpireTime]]];
                //                }
                //                else{
                //                    cell.orderRemainTime=@"订单已取消";
                //                }
            }
        }
    }
}
-(void)buttonPress:(UIButton*)button withOrder:(OrderMode*)mode{
    
    self.selectMode=mode;
    switch (button.tag) {
        case JHOrderButtonTypeCommit:
        {
            JHOrderConfirmViewController * order=[[JHOrderConfirmViewController alloc]init];
            order.orderId=mode.orderId;
            [self.navigationController pushViewController:order animated:YES];
        }
            break;
        case JHOrderButtonTypePay:
        {
            JHOrderPayViewController * order =[[JHOrderPayViewController alloc]init];
            order.orderId=mode.orderId;
            order.directDelivery = order.directDelivery;
            [self.navigationController pushViewController:order animated:YES];
        }
            break;
        case JHOrderButtonTypeCancle:
            
            [self cancleOrder:mode];
            break;
        case JHOrderButtonTypeContact:
            if (self.isSeller) {
                [[JHQYChatManage shareInstance] showChatWithViewcontroller:self];
                
            }else {
                [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:self orderModel:mode];
            }
            
            break;
        case JHOrderButtonTypeLogistics: {
            if (mode.directDelivery) {
                JHRecycleLogisticsViewController *vc = [[JHRecycleLogisticsViewController alloc]init];
                vc.orderId = mode.orderId;
                if ([mode.orderStatus isEqualToString:@"refunding"]) { /// 退货
                    vc.type = 7;
                } else {
                    vc.type = 6;
                }
                vc.isBusinessZhiSend = YES;
                vc.isZhifaSeller     = self.isSeller;
                if ([mode.orderStatus isEqualToString:@"portalsent"] || [mode.orderStatus isEqualToString:@"待收货"]) {
                    vc.isZhifaOrderComplete = NO;
                } else {
                    vc.isZhifaOrderComplete = YES;
                }
                [[JHRootController currentViewController].navigationController pushViewController:vc animated:true];
            } else {
                JHExpressViewController * express=[[JHExpressViewController alloc]init];
                express.orderId = mode.orderId;
                [self.navigationController pushViewController:express animated:YES];
            }
        }
            
            break;
        case JHOrderButtonTypeReceive:
            
            [self sureOrder:mode];
            break;
            
        case JHOrderButtonTypeDetail: {
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/report.html?orderId=%@"), mode.orderId];
            [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
            
        }
            break;
        case JHOrderButtonTypeSend:
        {
            JHSendOutViewController *sendOut = [[JHSendOutViewController alloc]init];
            sendOut.orderId                  = mode.orderId;
            sendOut.directDelivery           = mode.directDelivery;
            JHOrderDetailMode *orderShowModel   = [[JHOrderDetailMode alloc] init];
            orderShowModel.shippingProvince     = mode.shippingProvince;
            orderShowModel.shippingCity         = mode.shippingCity;
            orderShowModel.shippingCounty       = mode.shippingCounty;
            orderShowModel.shippingDetail       = mode.shippingDetail;
            orderShowModel.shippingPhone        = mode.shippingPhone;
            orderShowModel.shippingReceiverName = mode.shippingReceiverName;
            orderShowModel.directDelivery       = mode.directDelivery;
            sendOut.orderShowModel              = orderShowModel;
            [self.navigationController pushViewController:sendOut animated:YES];
        }
            break;
            //评价
        case JHOrderButtonTypeComment:{
            JHSendCommentViewController *vc = [[JHSendCommentViewController alloc] init];
            MJWeakSelf
            vc.commentComplete = ^{
                mode.commentStatus = 1;
                [weakSelf.homeTable reloadData];
            };
            vc.imageUrl = mode.goodsUrl;
            vc.orderId = mode.orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            //已评价
        case JHOrderButtonTypeLookComment: {
            JHSendCommentViewController *vc = [[JHSendCommentViewController alloc] init];
            vc.orderId = mode.orderId;
            vc.imageUrl = mode.goodsImg;
            vc.isShow = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
            
            //绑卡
        case JHOrderButtonTypeBindCard: {
            [self toScanVcType:1 model:mode];
            
        }
            break;
            //退货
        case JHOrderButtonTypeReturnGood: {
            JHOrderReturnViewController *vc =[[JHOrderReturnViewController alloc]init];
            vc.refundExpireTime=self.selectMode.refundExpireTime;
            vc.orderId = self.selectMode.orderId;
            vc.directDelivery = self.selectMode.directDelivery;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHOrderButtonTypeAlterAddress: {
            
            AdressManagerViewController *vc = [[AdressManagerViewController alloc] init];
            vc.orderId=self.selectMode.orderId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHOrderButtonTypeReturnDetail: {
            
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString =ReturnDetailURL(mode.orderId, self.isSeller?1:0);
            [self.navigationController pushViewController:webVC animated:YES];
            
        }
            break;
        case JHOrderButtonTypeAppraiseIssue: {
            
            JHWebViewController *webVC = [JHWebViewController new];
            webVC.urlString =AppraiseIssueDetailURL(mode.orderId);
            [self.navigationController pushViewController:webVC animated:YES];
            
            
        }
            break;
        case JHOrderButtonTypeAddNote: {
            
            JHOrderNoteView * note=[[JHOrderNoteView alloc]init];
            note.orderMode=mode;
            [self.view addSubview:note];
            
        }
            break;
        case JHOrderButtonTypeApplyReturn: {
            [SVProgressHUD show];
            NSDictionary * dic = @{@"orderId":mode.orderId};
            @weakify(self);
            [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/getPartialWorkOrder") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
                @strongify(self);
                [SVProgressHUD dismiss];
                JHRefunfOrderModel *model = [JHRefunfOrderModel mj_objectWithKeyValues:respondObject.data];
                if (model.flag) {
                    JHTOAST(model.refundTag);
                }else{
                    JHOrderApplyReturnViewController * vc=[[JHOrderApplyReturnViewController alloc]init];
                    vc.orderMode=mode;
                    vc.orderId=mode.orderId;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } failureBlock:^(RequestModel *respondObject) {
                @strongify(self);
                [SVProgressHUD dismiss];
                JHOrderApplyReturnViewController * vc=[[JHOrderApplyReturnViewController alloc]init];
                vc.orderMode=mode;
                vc.orderId=mode.orderId;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            
        }
            break;
        default:
            break;
            
    }
}
-(void)showAlert{
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"退货方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    JH_WEAK(self)
    [alert addAction:[UIAlertAction actionWithTitle:@"已拒收快递" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JH_STRONG(self)
        CommAlertView*  returnAlert=[[CommAlertView alloc]initWithTitle:@"是否确认您已拒收快递?" andDesc:@"" cancleBtnTitle:@"取消" sureBtnTitle:@"确认"];
        [self.view addSubview:returnAlert];
        returnAlert.handle = ^{
            
            [self refuse:self.selectMode];
        };
    }] ];
    [alert addAction:[UIAlertAction actionWithTitle:@"已收货，发快递退回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        JH_STRONG(self)
        JHOrderReturnViewController *vc =[[JHOrderReturnViewController alloc]init];
        vc.refundExpireTime=self.selectMode.refundExpireTime;
        vc.orderId = self.selectMode.orderId;
        vc.directDelivery = self.selectMode.directDelivery;
        [self.navigationController pushViewController:vc animated:YES];
        
    }] ];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }] ];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
-(void)refuse:(OrderMode*)mode{
    [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/orderRefund/auth/express/reject?orderId=") stringByAppendingString:OBJ_TO_STRING(mode.orderId)] Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"已拒收" duration:1.0 position:CSToastPositionCenter];
        [self loadNewData];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
}
-(void)sureOrder:(OrderMode*)mode{
    
    [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/order/auth/receipt?orderId=") stringByAppendingString:OBJ_TO_STRING(mode.orderId)] Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"收货完成" duration:1.0 position:CSToastPositionCenter];
        [self loadNewData];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
}
-(void)cancleOrder:(OrderMode*)mode{
    
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSString * type;
    if (self.isSeller) {
        type=user.isAssistant?@"2":@"1";
    }
    else{
        type=@"0";
    }
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/cancel?orderId=%@&cancelReason=%@&userType=%@"),mode.orderId,@"",type];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"取消成功" duration:1.0 position:CSToastPositionCenter];
        [self loadNewData];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    [SVProgressHUD show];
}

-(void)orderOut:(UIButton*)button{
    JH_WEAK(self)
    OrderDateChooseView *view=[[OrderDateChooseView alloc]initWithFrame:self.view.frame];
    [view show];
    view.handle = ^(NSString * _Nonnull begin, NSString * _Nonnull end) {
        JH_STRONG(self)
        [self exportOrder:begin andEndTime:end];
    };
}
-(void)exportOrder:(NSString*)beginTime andEndTime:(NSString*)endTime{
    [JHOrderViewModel getOrderExportInfoByStartTime:beginTime endTime:endTime completion:^(RequestModel *respondObject, NSError *error) {
        [SVProgressHUD dismiss];
        if (!error) {
            ExportOrderMode * mode = [ExportOrderMode  mj_objectWithKeyValues: respondObject.data];
            NSString *fullPath =  [NSString stringWithFormat:@"%@/%@%@",[HttpDownLoadFileTool shareInstance ].orderDirectory,mode.orderTime,@".pdf"];
            //  NSString *fullPath = [[[HttpDownLoadFileTool shareInstance ].orderDirectory stringByAppendingPathComponent:mode.startDate] stringByAppendingString:@".pdf"] ;
            [[HttpDownLoadFileTool shareInstance ]downLoadFileByURL:mode.docUrl andFilePath:fullPath progress:^(NSProgress * _Nonnull downloadProgress) {
                [SVProgressHUD showProgress:1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount status:@"正在导出中" maskType:SVProgressHUDMaskTypeGradient];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath, NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
                if (!error) {
                    JHOrderExportSuccessView * success=[[JHOrderExportSuccessView alloc]init];
                    success.handle = ^{
                        [[NaiveShareManager shareInstance] nativeShare:filePath.path];
                    };
                }
                else{
                    [[UIApplication sharedApplication].keyWindow makeToast:@"导出失败,请重试" duration:1.0 position:CSToastPositionCenter];
                }
            }];
            [SVProgressHUD show];
        }
        else{
            [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
    [SVProgressHUD show];
}
-(void)Scan:(UIButton*)button{
    [self toScanVcType:0 model:nil];
    
}
-(void)orderSearch:(UIButton*)button{
    JHOrderSearchView * view=[[JHOrderSearchView alloc]init];
    [self.view addSubview:view];
    
}
/**
 @param type  0 扫码发货 1 绑定宝卡
 */
- (void)toScanVcType:(NSInteger)type model:(OrderMode *)model {
    
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    JH_WEAK(self)
    if (type == 0) {
        vc.titleString = @"扫描运单号";
        vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
            JH_STRONG(self)
            [obj.navigationController popViewControllerAnimated:YES];
            
            JHSellerSendOrderViewController *vc = [JHSellerSendOrderViewController new];
            vc.expressNumber = scanString;
            
            [self.navigationController pushViewController:vc animated:NO];
            
        };
    }else if (type == 1) {
        vc.titleString = @"扫描宝卡";
        
        vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
            JH_STRONG(self)
            [self relBarCode:scanString obj:obj model:model];
        };
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)relBarCode:(NSString *)cardId obj:(JHQRViewController *)vc model:(OrderMode *)model{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"isAssistant"] = @([UserInfoRequestManager sharedInstance].user.isAssistant?1:0);
    dic[@"barCode"] = cardId;
    dic[@"orderId"] = model.orderId;
    [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/order/auth/relBarCode") Parameters:dic requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        model.barCode = cardId;
        [self.homeTable reloadData];
        [vc.navigationController popViewControllerAnimated:YES];
        [self.view makeToast:@"绑定成功" duration:1 position:CSToastPositionCenter];
        
        
    } failureBlock:^(RequestModel *respondObject) {
        [vc.view makeToast:respondObject.message duration:1 position:CSToastPositionCenter];
        [vc performSelector:@selector(reStartDevice) withObject:nil afterDelay:2];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"orderListdealloc");
    [timer stopGCDTimer];
}
@end




