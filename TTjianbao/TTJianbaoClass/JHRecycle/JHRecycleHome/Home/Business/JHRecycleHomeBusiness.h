//
//  JHRecycleHomeBusiness.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleHomeBusiness : NSObject
+ (void)requestRecycleHomeWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

+ (void)requestRecycleHomeProblemParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
