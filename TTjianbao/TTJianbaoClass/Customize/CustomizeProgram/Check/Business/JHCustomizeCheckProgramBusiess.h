//
//  JHCustomizeCheckProgramBusiess.h
//  TTjianbao
//
//  Created by user on 2020/11/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCustomizeCheckProgramModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeCheckProgramBusiess : NSObject
/*
 * 查看定制方案
 * customizePlanId : 定制方案id
 */
+ (void)getCustomizeCheckProgram:(NSString *)customizePlanId
                      Completion:(void(^)(NSError *error, JHCustomizeCheckProgramModel *_Nullable model))completion;

/*
 * 提交定制方案
 */
+ (void)uploadCustomizeCheckProgram:(NSString *)customizeOrderId
                         Completion:(void(^)(NSError *_Nullable error))completion;

/*
 * 删除定制方案
 * customizePlanId : 定制方案id
 * customizeOrderId : 定制订单id
 */
+ (void)deleteCustomizeCheckProgram:(NSString *)customizePlanId
                   customizeOrderId:(NSString *)customizeOrderId
                      Completion:(void(^)(NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
