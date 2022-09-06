//
//  JHCustomerDescInProcessBusiness.h
//  TTjianbao
//
//  Created by user on 2020/12/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCustomerDescInProcessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerDescInProcessBusiness : NSObject

/// 点赞
+ (void)customizeSendLikeRequest:(NSString *)customizeOrderId
                      Completion:(void(^)(NSError *_Nullable error))completion;

/// 取消点赞
+ (void)customizeCancleLikeRequest:(NSString *)customizeOrderId
                        Completion:(void(^)(NSError *_Nullable error))completion;

/// 添加补充信息
+ (void)addCommentRequest:(JHCustomizeCommentRequestModel *)model
               Completion:(void(^)(NSError *_Nullable error))completion;

/// 隐藏
+ (void)hiddenRequest:(NSInteger)workId
             hideFlag:(NSString *)hideFlag
               Completion:(void(^)(NSError *_Nullable error,RequestModel * _Nullable respondObject))completion;
@end

NS_ASSUME_NONNULL_END
