//
//  JHOrderAgentPayViewController.h
//  TTjianbao
//
//  Created by jiang on 2019/11/4.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderAgentPayViewController.h"
#import "JHOrderAgentPayView.h"
#import "AdressMode.h"
#import "JHBaseOperationView.h"
#import "TTjianbaoBussiness.h"

@interface JHOrderAgentPayViewController ()
{
    JHOrderAgentPayView * orderView;
}
@property(strong,nonatomic) OrderMode* orderConfirmMode;
@property(strong,nonatomic) AdressMode * addressMode;
@property(assign,nonatomic) BOOL isStoneOrder;
@end

@implementation JHOrderAgentPayViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initToolsBar];
//    [self.navbar setTitle:@"找好友代付"];
    self.title = @"找好友代付";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self  initContentView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
-(void)initContentView{
    
    orderView=[[JHOrderAgentPayView alloc]init];
    orderView.money=self.money;
    orderView.orderMode=self.orderMode;
    [self.view addSubview:orderView];
    JH_WEAK(self)
    orderView.handle = ^{
        JH_STRONG(self)
        [self requestInfo];
    };
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        
    }];
}

-(void)requestInfo{
    
    [JHGrowingIO trackOrderEventId:JHTrackreplacePay_paybtn orderCode:self.orderMode.orderCode payWay:@"replacePay" suc:@""];

    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/findFriendsToPay") Parameters:@{@"payMoney":@(self.money),@"orderId":self.orderId,@"payId":@(self.payId),@"portalEnum":@"ios"} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        OrderAgentPayShareMode * mode=[OrderAgentPayShareMode  mj_objectWithKeyValues:respondObject.data];
        
//        [[UMengManager shareInstance] shareWebPageToPlatformType:UMSocialPlatformType_WechatSession title:mode.title text:mode.summary thumbUrl:mode.pic webURL:mode.targetUrl type:ShareObjectTypeAgentPay pageFrom:JHPageFromTypeUnKnown object:self.orderMode.orderCode];
        JHShareInfo* info = [JHShareInfo new];
        info.title = mode.title;
        info.desc = mode.summary;
        info.img = mode.pic;
        info.shareType = ShareObjectTypeAgentPay;
        info.pageFrom = JHPageFromTypeUnKnown;
        info.url = mode.targetUrl;
        [JHBaseOperationAction toShare:JHOperationTypeWechatSession operationShareInfo:info object_flag:self.orderMode.orderCode];//TODO:Umeng share
        
        [[NSNotificationCenter defaultCenter]postNotificationName:OrderPayInfoStatusChangeNotifaction object:nil];//
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    [SVProgressHUD show];
}

@end

