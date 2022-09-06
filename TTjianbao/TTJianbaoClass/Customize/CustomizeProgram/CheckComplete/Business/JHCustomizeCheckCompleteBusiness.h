//
//  JHCustomizeCheckCompleteBusiness.h
//  TTjianbao
//
//  Created by user on 2020/11/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCustomizeCheckCompleteModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeCheckCompleteBusiness : NSObject
/*
 * 查看定制完成信息
 * customizeOrderId : 定制订单id
 */
+ (void)getCustomizeCheckComplete:(NSString *)customizeOrderId
                      Completion:(void(^)(NSError *error, JHCustomizeCheckCompleteModel *_Nullable model))completion;

@end

NS_ASSUME_NONNULL_END
