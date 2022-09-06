//
//  JHTestBusiness.h
//  TTjianbao
//
//  Created by user on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHTestTableViewCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHTestBusiness : NSObject

/// 物流信息
+ (void)requestCustomizeLogistics:(NSString *)orderId
                         userType:(NSString *)userType
                       Completion:(void(^)(NSError *_Nullable error, NSArray<JHTestTableViewCellViewModel *>* _Nullable models))completion;

@end

NS_ASSUME_NONNULL_END
