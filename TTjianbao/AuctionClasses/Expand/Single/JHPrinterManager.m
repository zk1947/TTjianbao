//
//  JHPrinterManager.m
//  TTjianbao
//
//  Created by jiang on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPrinterManager.h"
#import "JHOrderViewModel.h"
/**缺少x86库，模拟器编译暂时忽略此功能*/
#if TARGET_IPHONE_SIMULATOR

@implementation JHPrinterManager
+ (instancetype)sharedInstance{
    return nil;
}
@end

#else

#import <QRPrinter/QRPrinterInterface.h>
#import "TTjianbaoHeader.h"
#import "TTjianbaoBussiness.h"
static JHPrinterManager *instance = nil;
@interface JHPrinterManager ()<QRPrinterInterfaceDelegate>
@property (nonatomic, strong) QRPrinterInterface *mTPrinterInterface;
@property (nonatomic, strong) printerMessage *currentPrinter;

@property (nonatomic, strong) JHResultHandler connectHandle;
@property (nonatomic, strong) JHResultHandler printHandle;
@end

@implementation JHPrinterManager
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        instance = [[JHPrinterManager alloc] init];
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mTPrinterInterface  = [QRPrinterInterface sharedInstance];
        [QRPrinterInterface registerPrinter];
        self.mTPrinterInterface.delegate = self;
        [_mTPrinterInterface checkPrinterStatus];
    }
    return self;
}
- (void)searchPrinter{
    [self.mTPrinterInterface searchPrinter];
}
- (void)connectPrinter:(JHResultHandler)connectHandle{
    self.connectHandle = connectHandle;
    if (!self.isOnBluetooth) {
        if (self.connectHandle){
            self.connectHandle(NO, @"请打开手机蓝牙");
        }
        return;
    }
    if (!self.isSearchPrinter) {
        if (self.connectHandle){
            self.connectHandle(NO, @"未搜索到打印机");
        }
        
        return;
    }
    [self.mTPrinterInterface connect:self.currentPrinter];
}
- (BOOL)isSearchPrinter{
    if (self.currentPrinter) {
        return YES;
    }
    else{
        return NO;
    }
}
#pragma mark - MTPrinterInterfaceDelegate
- (void)bleDidDiscoverPrints:(NSArray<printerMessage *> *)devices{
    NSLog(@"搜索");
    for (printerMessage * printer in devices) {
        NSLog(@"搜索Printer--name=%@",printer.name);
        NSLog(@"Printer--identifiere%@",printer.identifier);
          //QR-386A-5BB7
        if ([printer.name containsString:@"QR-386A"]||[printer.name containsString:@"QR380A"]) {
            NSLog(@"已经搜索到%@",printer.name);
            self.currentPrinter=printer;
            [self.mTPrinterInterface stopsearchPrinter];
        }
    }
}
- (void)bleDidConnectFail:(NSError *)error{
    if (self.connectHandle){
        self.connectHandle(NO, error.description);
    }
}
- (void)bleDidConnect{
    NSLog(@"Printer-bleDidConnect");
    if (self.connectHandle){
        self.connectHandle(YES, @"打印机连接成功");
    }
}
- (void)bleDidUpdateRSSI:(NSNumber *)rssi{
    
    NSLog(@"Printer-bleDidUpdateRSSI");
}

- (void)bleDidUpdateState:(printerState)state{
    if(state == printerStatePoweredOn){
        NSLog(@"Printer-printerStatePoweredOn");
        self.isOnBluetooth=YES;
    }
    if(state == printerStatePoweredOff){
        NSLog(@"Printer-printerStatePoweredOff");
        self.isOnBluetooth=NO;
    }
}
- (void)bleDidFinishPrint:(printResult)state{
    if (state == printResultSuccessful) {
        NSLog(@"打印成功");
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
        if ( self.printHandle) {
            self.printHandle(YES, @"打印成功");
        }
        
    } else {
        NSLog(@"打印失败: %ld", (long)state);
        if ( self.printHandle) {
            self.printHandle(YES, @"打印失败");
        }
    }}
- (void)blePrinterStatus:(printStatus)status{
    
    switch (status) {
        case printResultCoverOpen:
            [[UIApplication sharedApplication].keyWindow makeToast:@"纸舱盖打开" duration:2.0 position:CSToastPositionCenter];
            break;
        case printResultOverHeat:
            [[UIApplication sharedApplication].keyWindow makeToast:@"打印头过热" duration:2.0 position:CSToastPositionCenter];
            break;
        case printResultBatteryLow:
            [[UIApplication sharedApplication].keyWindow makeToast:@"低电压" duration:2.0 position:CSToastPositionCenter];
            break;
        case printResultNoPaper:
            [[UIApplication sharedApplication].keyWindow makeToast:@"缺纸" duration:2.0 position:CSToastPositionCenter];
            break;
        case printResultPrinting:
            [[UIApplication sharedApplication].keyWindow makeToast:@"打印中" duration:2.0 position:CSToastPositionCenter];
            break;
        case printResultOk:
            NSLog(@"printResultOk");
            break;
        default:
            break;
    }
    
//    if (status!=printResultOk) {
//        if (self.connectHandle) {
//            self.connectHandle(NO, @"");
//        }
//    }
}
- (void)printOrderBarCode:(NSString*)orderId andResult:(JHResultHandler)handle
{
    [SVProgressHUD showWithStatus:@"设备连接中"];
    [self connectPrinter:^(BOOL success, NSString * _Nonnull desc) {
        if (success) {
            JH_WEAK(self)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                JH_STRONG(self)
                [SVProgressHUD showWithStatus:@"数据请求中"];
                [JHOrderViewModel requestOrderDetail:orderId isSeller:YES completion:^(RequestModel *respondObject, NSError *error) {
                    if (!error) {
                        OrderMode * order = [OrderMode mj_objectWithKeyValues: respondObject.data];
                        [SVProgressHUD showWithStatus:@"数据传输中"];
                        [self printOrder:order andResult:^(BOOL success, NSString *desc) {
                            [SVProgressHUD showSuccessWithStatus:desc];
                            if (handle) {
                                handle(success, desc);
                            }
                        }];
                    }
                    else{
                        [SVProgressHUD showInfoWithStatus:error.localizedDescription];
                        if (handle) {
                            handle(NO, error.localizedDescription);
                        }
                    }
                }];
            });
        }
        else{
            if (handle) {
                handle(NO, desc);
            }
            [SVProgressHUD showInfoWithStatus:desc];
        }
    }];
}
- (void)printStoneBarCode:(NSString*)barCode andResult:(JHResultHandler)handle{
    [SVProgressHUD showWithStatus:@"设备连接中"];
    [self connectPrinter:^(BOOL success, NSString * _Nonnull desc) {
        if (success) {
            JH_WEAK(self)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                JH_STRONG(self)
                [SVProgressHUD showWithStatus:@"数据传输中"];
                [self printStone:barCode andResult:^(BOOL success, NSString *desc) {
                    [SVProgressHUD showSuccessWithStatus:desc];
                    if (handle) {
                        handle(success, desc);
                    }
                }];;
            });
        }
        else{
            if (handle) {
                handle(NO, desc);
            }
            [SVProgressHUD showInfoWithStatus:desc];
        }
    }];
    
}

#pragma ---- print method
- (void)printOrder:(OrderMode*)mode andResult:(JHResultHandler)printHandle
{
    
    self.printHandle = printHandle;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
    [_mTPrinterInterface pageSetup:600 pageHeight:700];
    float x=30;
    //标题
    [_mTPrinterInterface drawText:120 text_y:10 strText:@"// 天天鉴宝订单卡 //" fontSize:fontSizeDot32 rotate:0 bold:YES reverse:NO underLine:NO];
    //条形码
    [_mTPrinterInterface drawBarCode:80 start_y:60 textStr:mode.barCode?:@"000000000000000" type:1 rotate:0 lineWidth:3 height:60];
    //条码文字
    [_mTPrinterInterface drawText:200 text_y:130 strText:mode.barCode?:@"000000000000000" fontSize:fontSizeDot24 rotate:0 bold:NO reverse:NO underLine:NO];
      float y=165;
      float space=52;
   //
    NSString *price = [NSString stringWithFormat:@"价格：￥%@",mode.originOrderPrice];
    //价格
    [_mTPrinterInterface drawText:x text_y:y strText:price fontSize:fontSizeDot32 rotate:0 bold:YES reverse:NO underLine:NO];
   
    if (mode.appraisalGuidePrice) {
        // 计算价格宽度
        NSDictionary *attribute =@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:34]};
        CGSize size = [price boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
          NSLog(@"width =  =====%lf",size.width);
        //指导价
        [_mTPrinterInterface drawText:x+size.width text_y:y+4 strText:[NSString stringWithFormat:@"指导价:￥%@",mode.appraisalGuidePrice] fontSize:fontSizeDotBold20 rotate:0 bold:YES reverse:NO underLine:NO];
    }
    //卖家
    [_mTPrinterInterface drawText:x text_y:y+=space strText:[NSString stringWithFormat:@"卖家：%@",mode.sellerName] fontSize:fontSizeDot32 rotate:0 bold:NO reverse:NO underLine:NO];
    //买家
    [_mTPrinterInterface drawText:x text_y:y+=space strText:[NSString stringWithFormat:@"买家：%@",mode.buyerName] fontSize:fontSizeDot32 rotate:0 bold:NO reverse:NO underLine:NO];
    //商品名字
    NSString * title = [NSString stringWithFormat:@"商品名：%@",mode.complementVo.goodsName];
    if ([title length]>16) {
        [_mTPrinterInterface drawText:x text_y:y+=space strText:[title substringToIndex:16] fontSize:fontSizeDot32 rotate:0 bold:NO reverse:NO underLine:NO];
        [_mTPrinterInterface drawText:x text_y:y+=space strText:[title substringFromIndex:16] fontSize:fontSizeDot32 rotate:0 bold:NO reverse:NO underLine:NO];
    }
    else{
        [_mTPrinterInterface drawText:x text_y:y+=space strText:title fontSize:fontSizeDot32 rotate:0 bold:NO reverse:NO underLine:NO];
    }
    [_mTPrinterInterface drawText:x text_y:y+=space strText:[NSString stringWithFormat:@"种类：%@",mode.complementVo.goodsCateValue?:@""] fontSize:fontSizeDot32 rotate:0 bold:NO reverse:NO underLine:NO];
    [_mTPrinterInterface drawText:x text_y:y+=space strText:[NSString stringWithFormat:@"订单号：%@",mode.orderCode?:@""] fontSize:fontSizeDot32 rotate:0 bold:NO reverse:NO underLine:NO];
    [_mTPrinterInterface drawText:x text_y:y+=space strText:[NSString stringWithFormat:@"主货：%@  赠品：%@",mode.complementVo.mainCount?:@"0",mode.complementVo.giftCount?:@"0"] fontSize:fontSizeDot32 rotate:0 bold:NO reverse:NO underLine:NO];
    
   [_mTPrinterInterface drawText:x text_y:y+=space strText:[NSString stringWithFormat:@"声明：%@",[mode.complementVo.statement count]>0?[mode.complementVo.statement componentsJoinedByString:@" "]:@""] fontSize:fontSizeDot32 rotate:0 bold:NO reverse:NO underLine:NO];
    [_mTPrinterInterface drawText:x text_y:y+=space strText:[NSString stringWithFormat:@"订单类型：%@",mode.orderCategoryString?:@""] fontSize:fontSizeDot32 rotate:0 bold:NO reverse:NO underLine:NO];
    
    [_mTPrinterInterface print:0 skip:1];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
    
    // [_mTPrinterInterface feed];
    
}
- (void)printStone:(NSString*)barCode andResult:(JHResultHandler)printHandle
{
    self.printHandle = printHandle;
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
    [_mTPrinterInterface pageSetup:600 pageHeight:650];
    //条形码
    [_mTPrinterInterface drawBarCode:130 start_y:60 textStr:barCode?:@"000000000000" type:1 rotate:0 lineWidth:3 height:60];
    //条码文字
    [_mTPrinterInterface drawText:200 text_y:130 strText:barCode?:@"000000000000" fontSize:fontSizeDot24 rotate:0 bold:NO reverse:NO underLine:NO];
    [_mTPrinterInterface print:0 skip:1];
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantPast]];
}

@end
#endif
