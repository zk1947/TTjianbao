//
//  STRIAPManager.h
//  TaodangpuDetection
//
//  Created by jiangchao on 2019/1/5.
//  Copyright © 2019 jiangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SIAPPurchSuccess = 0,       // 购买成功
    SIAPPurchFailed = 1,        // 购买失败
    SIAPPurchCancle = 2,        // 取消购买
    SIAPPurchVerFailed = 3,     // 订单校验失败
    SIAPPurchVerSuccess = 4,    // 订单校验成功
    SIAPPurchNotArrow = 5,      // 不允许内购
     SIAPPurchNotProduct = 6,      // 没商品
}SIAPPurchType;

typedef void (^IAPCompletionHandle)(SIAPPurchType type,NSString *description );

@interface STRIAPManager : NSObject
+ (instancetype)shareSIAPManager;

- (void)startPurchWithID:(NSString *)purchID  andOrderId:(NSString*)orderId  completeHandle:(IAPCompletionHandle)handle;
-(void)veryfyTransaction:(JHFinishBlock)completeBlock;
@end


