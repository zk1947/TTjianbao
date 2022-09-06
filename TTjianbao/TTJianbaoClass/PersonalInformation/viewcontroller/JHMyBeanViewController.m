//
//  JHMyBeanViewController.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHMyBeanViewController.h"
#import "JHMyBeanView.h"
#import "JHWebViewController.h"
#import "JHCoinRecordViewController.h"
#import "JHBeanMoneyMode.h"
#import "WXApi.h"
#import "STRIAPManager.h"
#import "StorePayOrderMode.h"
#import "MBProgressHUD.h"

#import "UserInfoRequestManager.h"

@interface JHMyBeanViewController ()<JHMyBeanViewDelegate>
{
    JHMyBeanView * myBeanView;
   
}
@property(nonatomic,strong) NSMutableArray* beanMoneyModes;
@property(nonatomic,strong)  StorePayOrderMode * currentPayMode;
@end

@implementation JHMyBeanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self  initToolsBar];
//    [self.navbar setTitle:@"鉴豆"];
    self.title = @"鉴豆"; //背景颜色不一致
//    self.view.backgroundColor=[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:[UIImage imageNamed:@"Custom Preset.png"] withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.navbar addrightBtn:@"送出的礼物" withImage:nil withHImage:nil withFrame:CGRectMake(ScreenW-90,0,90,44)];
//    [self.navbar.rightBtn addTarget :self action:@selector(sendRecord) forControlEvents:UIControlEventTouchUpInside];
    
    [self initRightButtonWithName:@"送出的礼物" action:@selector(sendRecord)];
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(90);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
    [self initContentView];
    [self requestInfo];
    [self HandleTransaction];
}

-(void)requestInfo{
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/coin/list?portal=ios") Parameters:nil successBlock:^(RequestModel *respondObject) {
        self.beanMoneyModes=[NSMutableArray arrayWithCapacity:10];
        self.beanMoneyModes = [JHBeanMoneyMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        [myBeanView setBeanMoneyModes:self.beanMoneyModes];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
}
-(void)HandleTransaction{
    [ [STRIAPManager shareSIAPManager] veryfyTransaction :^{
       [[UserInfoRequestManager sharedInstance] getUserInfoSuccess:^(RequestModel *respondObject) {
        [myBeanView reloadBeanCount];
        }];
    }];
}
- (void)sendRecord {
    JHCoinRecordViewController *vc = [[JHCoinRecordViewController alloc]init];
    vc.type = 1;
    [self .navigationController pushViewController:vc animated:YES];
    
}

-(void)beanRecord{
    //
    JHCoinRecordViewController *vc = [[JHCoinRecordViewController alloc]init];
    vc.type = 0;
    [self .navigationController pushViewController:vc animated:YES];
}
-(void)initContentView{
    
    myBeanView=[[JHMyBeanView alloc]init];
    myBeanView.delegate=self;
    [self.view addSubview:myBeanView];
    [myBeanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(-UI.bottomSafeAreaHeight);
        make.left.right.equalTo(self.view);
        
    }];
}

#pragma mark =============== JHMyBeanViewDelegate ===============
- (void)didBeanRecod {
    [self beanRecord];
}
-(void)agreeMent{
    
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.titleString = @"用户充值协议";
    vc.urlString =  H5_BASE_STRING(@"/jianhuo/czxieyi.html");
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)Complete:(JHBeanMoneyMode*)beanMoneyMode{
    JH_WEAK(self)
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/apple/prepay") Parameters:@{@"coinId":beanMoneyMode.Id}   isEncryption:YES  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
      
        [[STRIAPManager shareSIAPManager] startPurchWithID:beanMoneyMode.applePayId  andOrderId:respondObject.data completeHandle:^(SIAPPurchType type,NSString * description) {
            JH_STRONG(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
            });
          
            if (type==SIAPPurchSuccess){
                [[UserInfoRequestManager sharedInstance] getUserInfoSuccess:^(RequestModel *respondObject) {
                    [self->myBeanView reloadBeanCount];
                }];
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.view makeToast:description duration:2.0 position:CSToastPositionCenter];
                });
            }
        }];

    } failureBlock:^(RequestModel *respondObject) {
        JH_STRONG(self)
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
      [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
}
//-(void)authStorePay:(StorePayOrderMode*)mode{
//
//    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/apple/receipt") Parameters:@{@"receiptData":mode.receiptString,@"outTradeNo":mode.orderId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
//
//        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
//          NSMutableArray  *transactionArr=[NSMutableArray arrayWithArray:[self readFile]];
//          [transactionArr enumerateObjectsUsingBlock:^(StorePayOrderMode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj.orderId isEqualToString:mode.orderId]) {
//                [transactionArr removeObject:obj];
//            }
//        }];
//
//        [[UserInfoRequestManager sharedInstance] getUserInfoSuccess:^(RequestModel *respondObject) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRechargeSuccess object:nil];
//        [myBeanView reloadBeanCount];
//        }];
//        [self writeFile:transactionArr];
//        }
//            failureBlock:^(RequestModel *respondObject) {
//
//            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:NO];
//            [self.view makeToast:@"网络连接失败"];
//            }];
//
//}
//
//-(NSArray*)readFile{
//
//    NSDictionary * dic=[CommHelp readFile:[UserInfoRequestManager sharedInstance].user.customerId];
//    NSMutableArray *arr = [StorePayOrderMode mj_objectArrayWithKeyValuesArray:[dic objectForKey:@"transaction"]];
//    return arr;
//}
//-(void)writeFile:(NSArray*)transactions{
//
//    NSDictionary * dic=@{@"transaction":[StorePayOrderMode mj_keyValuesArrayWithObjectArray:transactions]};
//    [CommHelp writeFile:dic withName:[UserInfoRequestManager sharedInstance].user.customerId];
//}

- (void)dealloc{
    NSLog(@"%@*************被释放",[self class])
}
@end
