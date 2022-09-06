//
//  JHC2CProductUploadBusiness.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHC2CUploadProductDetailModel.h"
#import "JHC2CUploadProductModel.h"
#import "JHC2CPublishSuccessBackModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductUploadBusiness : NSObject

/// c2c商品发布构建数据接口    /api/mall/product/productPubDataBuild
+ (void)requestC2CUploadProductDetailBackCateId:(NSString*)backCateId completion:(void(^)(NSError *_Nullable error, JHC2CUploadProductDetailModel *_Nullable model))completion;


+ (void)requestC2CUploadProductWithModel:(JHC2CUploadProductModel*)moodel completion:(void(^)(NSError *_Nullable error,JHC2CPublishSuccessBackModel *_Nullable model))completion;

@end

NS_ASSUME_NONNULL_END
