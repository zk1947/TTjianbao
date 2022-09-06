//
//  JHC2CClassBusiness.h
//  TTjianbao
//
//  Created by hao on 2021/6/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewStoreTypeTableCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CClassBusiness : NSObject
/// 分类别表  /api/mall/frontCateC2c/list
+ (void)requestClassListCompletion:(void(^)(NSError *_Nullable error, NSArray<JHNewStoreTypeTableCellViewModel*> *_Nullable models))completion;

/// 选择分类别表  /api/mall/backCate/list
+ (void)requestSelectClassListWithParams:(NSDictionary *)params Completion:(void(^)(NSError *_Nullable error, NSArray<JHNewStoreTypeTableCellViewModel*> *_Nullable models))completion;
@end

NS_ASSUME_NONNULL_END
