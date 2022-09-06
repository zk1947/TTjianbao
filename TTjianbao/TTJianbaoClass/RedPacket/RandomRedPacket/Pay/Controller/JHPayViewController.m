//
//  JHPayViewController.m
//  TTjianbao
//
//  Created by jiang on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPayViewController.h"
#import "JHPayView.h"
#import "JHPaySuccessViewController.h"
#import "WXApi.h"
#import "WXPayDataMode.h"
#import "JHOrderViewModel.h"
#import "TTjianbaoUtil.h"
#import "NTESAudienceLiveViewController.h"
#import "JHNormalLiveController.h"
#import "NTESAnchorLiveViewController.h"
#import "PanNavigationController.h"

//查询结果尝试次数
static NSInteger allTryCount=2;
@interface JHPayViewController ()<JHPayViewDelegate>
{
    JHPayView * payView;
    WXPayDataMode * wxPayMode;
    ALiPayDataMode * aLiPayMode;
    BOOL isPaying;
    NSInteger tryQueryCount;
    
}
@property(strong,nonatomic) NSArray<PayWayMode*> *payWayList;
@property(strong,nonatomic) PayWayMode* payWayMode;

@property(strong,nonatomic) NSString* payWay;
@property(strong,nonatomic) NSString* payWayString;
@end

@implementation JHPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initToolsBar];
//    [self.navbar setTitle:@"支付"];
    self.title = @"支付";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(WillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [self initContentView];
    
}
-(void)setRedPacketMode:(JHMakeRedpacketModel *)redPacketMode{
    _redPacketMode=redPacketMode;
     self.payWayList=_redPacketMode.payWayList;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    if ([nav isKindOfClass:[PanNavigationController class]]) {
    nav.isForbidDragBack = YES;
        
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
            if ([nav isKindOfClass:[PanNavigationController class]]) {
                nav.isForbidDragBack = NO;
                
            }
}
-(void)initContentView{
    
    payView=[[JHPayView alloc]init];
    payView.delegate=self;
    [self.view addSubview:payView];
    [payView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
    }];
    
    [payView setPayWayArray:[PayMode sortbyPay:self.payWayList]];
    [payView setPrice:self.redPacketMode.payMoney];
    
}

-(void)WillEnterForeground:(NSNotificationCenter*)note{
    if (isPaying) {
        isPaying=NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [self requestPayStatus];
    }
}

-(void)Complete:(PayWayMode *)mode andPayMoney:(double)money{
    
    tryQueryCount=0;
    self.payWayMode=mode;
    switch (mode.Id) {
        case JHPayTypeWxPay:
            break;
        case JHPayTypeAliPay:
            break;
            
        default:
            break;
    }
    JHRedPacketPrepayReqModel * reqMode=[[JHRedPacketPrepayReqModel alloc]init];
    reqMode.payWay=[NSString stringWithFormat:@"%d",self.payWayMode.Id];
    reqMode.remainUsed=0;
    reqMode.redPacketId=self.redPacketMode.redPacketId;
    JH_WEAK(self)
    [PayMode redPacketPrepay:reqMode completion:^(RequestModel *respondObject, NSError *error) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        if (!error) {
            JHRedPacketPrepayRespModel * mode=[JHRedPacketPrepayRespModel mj_objectWithKeyValues: respondObject.data];
            if (self.payWayMode.Id==JHPayTypeWxPay) {
                if (JH_UNION_ENABLE) {
                    wxPayMode=[WXPayDataMode mj_objectWithKeyValues:[mode.token mj_JSONObject]];
                    [self WXPay:wxPayMode];
                }
                else{
                    wxPayMode=[WXPayDataMode mj_objectWithKeyValues: [mode.token mj_JSONObject]];
                    [self WXPay:wxPayMode];
                    
                }

                isPaying=YES;
            }
            else  if (self.payWayMode.Id==JHPayTypeAliPay) {
                if (JH_UNION_ENABLE) {
                    aLiPayMode=[ALiPayDataMode mj_objectWithKeyValues: [mode.token mj_JSONObject]];
                    [self AliPay:aLiPayMode.appPayRequest];
                }
                else{
                    aLiPayMode=[ALiPayDataMode mj_objectWithKeyValues: [mode mj_keyValues]];
                    [self AliPay:aLiPayMode.token];
                    
                }

                isPaying=YES;
            }
            
        }
        else{
            [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }
    }];
    
    [SVProgressHUD show];
}
-(void)WXPay:(WXPayDataMode*)pay{
    
    [PayMode WXPay:pay];
}
-(void)AliPay:(NSString*)orderString{
    
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayScheme callback:^(NSDictionary *resultDic) {
//        NSLog(@"reslut = %@",resultDic);
    //        if (isPaying) {
    //               isPaying=NO;
    //               [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    //               [self requestPayStatus];
    //           }
//    }];
    JH_WEAK(self)
     [PayMode AliPay:orderString callback:^(id obj) {
         JH_STRONG(self)
        NSLog(@"reslut = %@",(NSDictionary*)obj);
        if (isPaying) {
            isPaying=NO;
            [MBProgressHUD showHUDAddedTo:self.view animated:NO];
            [self requestPayStatus];
        }
    } ];
}
-(void)requestPayStatus{
    
      tryQueryCount++;
      NSString *outTradeNo;
    if (wxPayMode&&self.payWayMode.Id==JHPayTypeWxPay) {
        if (JH_UNION_ENABLE) {
            outTradeNo=wxPayMode.outTradeNo;
        }
        else{
            outTradeNo=wxPayMode.out_trade_no;
            
        }
        self.payWay=@"weixin";
        self.payWayString=@"微信";
    }
    else  if (aLiPayMode&&self.payWayMode.Id==JHPayTypeAliPay) {
        outTradeNo=aLiPayMode.outTradeNo;
        self.payWay=@"zhifubao";
        self.payWayString=@"支付宝";
    }
    [PayMode requestPacketPayStatus:outTradeNo completion:^(RequestModel *respondObject, NSError *error) {
        if (!error) {
        PayResultMode  * resultMode=[PayResultMode mj_objectWithKeyValues: respondObject.data];
            [self handlePaySuccessStatus:resultMode];
        }
        else{
            [self handlePayFailureStatus];
        }
    }];
    
}
-(void)handlePaySuccessStatus:(PayResultMode*)resultMode{
    
    if ([resultMode.return_code isEqualToString:@"SUCCESS"]) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if(self.complete) {
            self.complete();
        }
        [self disMiss];
        
    }
    else if ([resultMode.return_code isEqualToString:@"FAIL"]) {
        
    }
    else if ([resultMode.return_code isEqualToString:@"NOTPAY"]) {

    }
    else if ([resultMode.return_code isEqualToString:@"PAYING"]) {
        
    }
    if (![resultMode.return_code isEqualToString:@"SUCCESS"]){
        [self handlePayFailureStatus];
    }
}
-(void)handlePayFailureStatus{
    if (tryQueryCount<allTryCount) {
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [self requestPayStatus];
           });
       }
       else{
           [MBProgressHUD hideHUDForView:self.view animated:NO];
           [self showFailAlert];
       }
    
}
-(void)showFailAlert{
    CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"支付提醒" andDesc:[NSString stringWithFormat:@"由于%@支付的原因\n未获得支付结果",self.payWayString] cancleBtnTitle:@"未支付" sureBtnTitle:@"已支付"];
    alert.titleImage.image=[UIImage imageNamed:@"pay_result_tip-icon"];
    [[UIApplication sharedApplication].keyWindow addSubview:alert];
    alert.handle = ^{
    };
    
}
-(void)disMiss{
    BOOL  isPop=NO;
    for (UIViewController* vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass: [NTESAudienceLiveViewController  class]]) {
            isPop=YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        if ([vc isKindOfClass: [JHNormalLiveController class]]) {
            isPop=YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        
        if ([vc isKindOfClass: [NTESAnchorLiveViewController class]]) {
            isPop=YES;
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
    if (!isPop) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)dealloc
{
    NSLog(@"pay---dealloc");
}

@end

