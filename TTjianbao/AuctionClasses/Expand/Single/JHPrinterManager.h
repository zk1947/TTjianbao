//
//  JHPrinterManager.h
//  TTjianbao
//
//  Created by jiang on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OrderMode.h"
//NS_ASSUME_NONNULL_BEGIN
typedef void (^JHResultHandler)( BOOL success ,  NSString* desc);
@interface JHPrinterManager : NSObject
+ (instancetype)sharedInstance;

@property (nonatomic, assign) BOOL isOnBluetooth;
- (BOOL)isSearchPrinter;//是否已搜索到打印机
- (void)searchPrinter;//搜索蓝牙设备
- (void)connectPrinter:(JHResultHandler)connectHandle;
/// 打印订单宝卡号
/// @param orderId 订单id
/// @param handle 打印成功回调
- (void)printOrderBarCode:(NSString*)orderId andResult:(JHResultHandler)handle;
/// 打印原石回血条码
/// @param barCode barCode description
/// @param handle handle description
- (void)printStoneBarCode:(NSString*)barCode andResult:(JHResultHandler)handle;
@end

//NS_ASSUME_NONNULL_END
