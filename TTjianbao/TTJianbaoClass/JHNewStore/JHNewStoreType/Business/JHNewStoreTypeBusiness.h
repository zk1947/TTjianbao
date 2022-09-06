//
//  JHNewStoreTypeBusiness.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewStoreTypeTableCellViewModel.h"
#import "JHNewStoreTypePageViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreTypeBusiness : NSObject

/// 请求类别信息  /api/mall/frontCate/list
+ (void)requestNewStoreTypeCompletion:(void(^)(NSError *_Nullable error, NSArray<JHNewStoreTypeTableCellViewModel*> *_Nullable models))completion;

///获取分类页数据
+ (void)loadClassPageListData:(void(^)(NSError * _Nullable error,JHNewStoreTypePageViewModel *model))completion;

@end

NS_ASSUME_NONNULL_END
