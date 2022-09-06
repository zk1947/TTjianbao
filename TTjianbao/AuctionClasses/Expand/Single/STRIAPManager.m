//
//  STRIAPManager.m
//  TaodangpuDetection
//
//  Created by jiangchao on 2019/1/5.
//  Copyright © 2019 jiangchao. All rights reserved.
//

#import "STRIAPManager.h"
#import <StoreKit/StoreKit.h>
#import "StorePayOrderMode.h"
#import "UserInfoRequestManager.h"

  static STRIAPManager *IAPManager = nil;
@interface STRIAPManager()<SKPaymentTransactionObserver,SKProductsRequestDelegate>{
    NSString           *_purchID;
     NSString           *_orderID;
    IAPCompletionHandle _handle;
}
@property(strong,nonatomic)NSMutableArray <SKPaymentTransaction *> * transactions;

@end
@implementation STRIAPManager

+ (instancetype)shareSIAPManager{
    
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        IAPManager = [[STRIAPManager alloc] init];
    });
    return IAPManager;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        // 购买监听写在程序入口,程序挂起时移除监听,这样如果有未完成的订单将会自动执行并回调 paymentQueue:updatedTransactions:方法
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}
#pragma mark - public
- (void)startPurchWithID:(NSString *)purchID  andOrderId:(NSString*)orderId  completeHandle:(IAPCompletionHandle)handle{
    if (purchID) {
        if ([SKPaymentQueue canMakePayments]) {
            // 开始购买服务
              _purchID = purchID;
               _orderID = orderId;
               _handle = handle;
            NSSet *nsset = [NSSet setWithArray:@[purchID]];
            SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:nsset];
            request.delegate = self;
            [request start];
        }else{
            [self handleActionWithType:SIAPPurchNotArrow data:nil];
        }
    }
}
#pragma mark - private
- (void)handleActionWithType:(SIAPPurchType)type data:(NSData *)data{
    
    NSString * string;
    switch (type) {
        case SIAPPurchSuccess:
            NSLog(@"购买成功");
             string=@"购买成功";
            break;
        case SIAPPurchFailed:
            NSLog(@"购买失败");
             string=@"购买失败";
            break;
        case SIAPPurchCancle:
            NSLog(@"用户取消购买");
            string=@"已取消购买";
            break;
        case SIAPPurchVerFailed:
            NSLog(@"订单校验失败");
            break;
        case SIAPPurchVerSuccess:
            NSLog(@"订单校验成功");
            break;
        case SIAPPurchNotArrow:
            NSLog(@"不允许程序内付费");
              string=@"不允许程序内付费";
            break;
        default:
            break;
    }
    if(_handle){
        _handle(type,string);
    }
}
#pragma mark - delegate
// 交易结束
- (void)completeTransaction:(SKPaymentTransaction *)transaction{

    // Your application should implement these two methods.
    NSString * productIdentifier = transaction.payment.productIdentifier;
//    NSString * receipt = [transaction.transactionReceipt base64EncodedString];
    
//    NSDictionary * transactionDic=[CommHelp readFile:[UserInfoRequestManager sharedInstance].user.customerId];
//    NSArray * transactionArr=[transactionDic objectForKey:@"transaction"];
       NSLog(@"productIdentifier=%@",productIdentifier);
        NSLog(@"productIdentifier_applicationUsername%@",transaction.payment.applicationUsername);
    if ([productIdentifier length] > 0) {
        NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
        if(!receipt){
            // 交易凭证为空验证失败
            [self handleActionWithType:SIAPPurchVerFailed data:nil];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
        else{
            //如果从购买页发起的直接回调
            if (_handle) {
                [self handleActionWithType:SIAPPurchSuccess data:receipt];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
            
            else{
                if ([[UserInfoRequestManager sharedInstance].user.customerId length]>0) {
                    NSArray *array = [transaction.payment.applicationUsername componentsSeparatedByString:@","];
                    NSString * orderId;
                    if (array.count==2) {
                        if ([[array objectAtIndex:1] isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
                            orderId =[array objectAtIndex:0];
                        }
                    }
                    else{
                        orderId=transaction.payment.applicationUsername;
                    }
                    //   app启动时候检查凭证  如果有保存到本地
                    if (orderId != nil) {
                        NSLog(@"启动保存凭证");
                        StorePayOrderMode *currentPayMode=[[StorePayOrderMode alloc ]init];
                        currentPayMode.orderId=orderId;
                        currentPayMode.receiptString=[receipt base64EncodedStringWithOptions:0];
                     //   NSMutableArray  *transactionArr=[NSMutableArray arrayWithArray:[self readFile]];
                    //    [transactionArr addObject: currentPayMode];
                    //    [self writeFile:transactionArr];
                        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                    }
                }
            }
        }
          // 向自己的服务器验证购买凭证
    }
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
 
    
    
   // [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:NO];
}
// 交易失败
- (void)failedTransaction:(SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled) {
        [self handleActionWithType:SIAPPurchFailed data:nil];
    }else{
        [self handleActionWithType:SIAPPurchCancle data:nil];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)verifyPurchaseWithPaymentTransaction:(SKPaymentTransaction *)transaction isTestServer:(BOOL)flag{
    //交易验证
    return;
    NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
    if(!receipt){
        // 交易凭证为空验证失败
        [self handleActionWithType:SIAPPurchVerFailed data:nil];
        return;
    }
    // 购买成功将交易凭证发送给服务端进行再次校验
  //   [self handleActionWithType:SIAPPurchSuccess data:receipt];
    NSError *error;
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0]
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    if (!requestData) { // 交易凭证为空验证失败
        [self handleActionWithType:SIAPPurchVerFailed data:nil];
        return;
    }
    //In the test environment, use https://sandbox.itunes.apple.com/verifyReceipt
    //In the real environment, use https://buy.itunes.apple.com/verifyReceipt
    
    NSString *serverString = @"https://buy.itunes.apple.com/verifyReceipt";
    if (flag) {
        serverString = @"https://sandbox.itunes.apple.com/verifyReceipt";
    }
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   // 无法连接服务器,购买校验失败
                                   [self handleActionWithType:SIAPPurchVerFailed data:nil];
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) {
                                       // 苹果服务器校验数据返回为空校验失败
                                       [self handleActionWithType:SIAPPurchVerFailed data:nil];
                                   }
                                   
                                   // 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
                                   NSString *status = [NSString stringWithFormat:@"%@",jsonResponse[@"status"]];
                                   if (status && [status isEqualToString:@"21007"]) {
                                       [self verifyPurchaseWithPaymentTransaction:transaction isTestServer:YES];
                                   }else if(status && [status isEqualToString:@"0"]){
                                       [self handleActionWithType:SIAPPurchVerSuccess data:nil];
                                   }
                                   
                                   DDLogInfo(@"----验证结果 %@",jsonResponse);
                                   [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                                   
                               }
                           }];
    
    
    // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
  
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *product = response.products;
    if([product count] <= 0){
#if DEBUG
        NSLog(@"--------------没有商品------------------");
#endif
        
       [self handleActionWithType:SIAPPurchNotProduct data:nil];
        return;
    }
    
    SKProduct *p = nil;
    for(SKProduct *pro in product){
        if([pro.productIdentifier isEqualToString:_purchID]){
            p = pro;
            break;
        }
    }
    
#if DEBUG
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(@"产品付费数量:%lu",(unsigned long)[product count]);
    NSLog(@"%@",[p description]);
    NSLog(@"%@",[p localizedTitle]);
    NSLog(@"%@",[p localizedDescription]);
    NSLog(@"%@",[p price]);
    NSLog(@"%@",[p productIdentifier]);
    NSLog(@"发送购买请求");
#endif

    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:p];
    payment.applicationUsername=[NSString stringWithFormat:@"%@,%@",_orderID,[UserInfoRequestManager sharedInstance].user.customerId];
    NSLog(@"payment.productIdentifier=%@",payment.productIdentifier);
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//请求失败
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
     [self handleActionWithType:SIAPPurchFailed data:nil];
    NSLog(@"------------------错误-----------------:%@", error);
}

- (void)requestDidFinish:(SKRequest *)request{
    NSLog(@"------------反馈信息结束-----------------");
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    
    self.transactions=[NSMutableArray array];
    for (SKPaymentTransaction *tran in transactions) {
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchased:
            NSLog(@"商品*****111%@",tran.transactionIdentifier);
              [self handleTransaction:tran];
                break;
            case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStateRestored:
                // 消耗型不支持恢复购买
               [[SKPaymentQueue defaultQueue] finishTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:tran];
                break;
            default:
                break;
        }
    }
        [self veryfyTransaction:nil];
}
-(void)handleTransaction:(SKPaymentTransaction *)tran{
   
        if ([tran.payment.applicationUsername length]>0) {
                [self.transactions addObject:tran];
        }
        else  if ([_orderID length]>0) {
            
            [self.transactions addObject:tran];
        }
        else  {
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        }
}
-(void)veryfyTransaction:(JHFinishBlock)completeBlock{
    
    if (![JHRootController isLogin]) {
        return;
    }
    if ([self.transactions count]<=0) {
        return;
    }
    NSMutableArray * tempTransactions=[self.transactions mutableCopy];
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        dispatch_group_t group = dispatch_group_create();
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
        [tempTransactions enumerateObjectsUsingBlock:^(SKPaymentTransaction * _Nonnull transaction, NSUInteger idx, BOOL * _Nonnull stop) {
            NSURL *recepitURL = [[NSBundle mainBundle] appStoreReceiptURL];
            NSData *receipt = [NSData dataWithContentsOfURL:recepitURL];
            NSString  * receiptString=[receipt base64EncodedStringWithOptions:0];
            if(!receipt){
                // 交易凭证为空验证失败
                [self handleActionWithType:SIAPPurchVerFailed data:nil];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                //跳出本次循环Block，相当于for循环中continue的用法
                return;
            }
            NSString * orderId=_orderID;
            if ([transaction.payment.applicationUsername length]>0 ) {
                NSArray *array = [transaction.payment.applicationUsername componentsSeparatedByString:@","];
                if (array.count==2) {
                    if ([[array objectAtIndex:1] isEqualToString:[UserInfoRequestManager sharedInstance].user.customerId]) {
                        orderId =[array objectAtIndex:0];
                    }
                    else{
                        return;
                     }
                }
                else{
                    orderId=transaction.payment.applicationUsername;
                }
            }
            
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            dispatch_group_enter(group);
           [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/apple/receipt/v2") Parameters:@{@"receiptData":receiptString,@"outTradeNo":orderId,@"transactionId":transaction.transactionIdentifier} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
               NSLog(@"商品*****校验结果====%ld",(long)respondObject.code);
                [self.transactions removeObject:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                dispatch_group_leave(group);
                dispatch_semaphore_signal(semaphore);
            }
                failureBlock:^(RequestModel *respondObject) {
                                dispatch_group_leave(group);
                                dispatch_semaphore_signal(semaphore);
                    }];
        }];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            NSLog(@"完成!");
           [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameRechargeSuccess object:nil];
            [self handleActionWithType:SIAPPurchSuccess data:nil];
            if (completeBlock) {
                completeBlock();
            }
        });
    });
}
@end
