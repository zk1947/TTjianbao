//
//  JHBusinessGoodsUploadBusiness.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHBusinesspublishModel.h"
#import "JHC2CPublishSuccessBackModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessGoodsUploadBusiness : NSObject
+ (void)requestB2CUploadProductWithModel:(JHBusinesspublishModel*)model completion:(void(^)(NSError *_Nullable error,JHC2CPublishSuccessBackModel *_Nullable model))completion;
+ (void)requestB2CEditProductWithModel:(JHBusinesspublishModel *)model completion:(void (^)(NSError * _Nullable,JHC2CPublishSuccessBackModel *_Nullable model))completion;
+ (void)requestB2CBackProductWithModel:(NSString *)productId Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
