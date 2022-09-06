//
//  JHCustomizeCheckStuffDetailBusiness.h
//  TTjianbao
//
//  Created by user on 2020/12/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCustomizeCheckStuffDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeCheckStuffDetailBusiness : NSObject

/*
 * 查看原料详情
 * customizePlanId : 定制方案id
 */
+ (void)getCustomizeCheckStuffDetail:(NSString *)customizeOrderId
                      Completion:(void(^)(NSError *_Nullable error, JHCustomizeCheckStuffDetailModel *_Nullable model))completion;
@end

NS_ASSUME_NONNULL_END
