//
//  JHGoodManagerFilterBusiness.h
//  TTjianbao
//
//  Created by user on 2021/8/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^succeedBlock)(RequestModel * _Nullable respondObject);
typedef void (^failureBlock)(RequestModel * _Nullable respondObject);

@interface JHGoodManagerFilterBusiness : NSObject
+ (void)getChannelFilterSuccessBlock:(succeedBlock)success
                        failureBlock:(failureBlock)failure;
+ (NSArray *)channelFilterDataSourceArray;

@end

NS_ASSUME_NONNULL_END
