//
//  JHImageTextWaitAuthBusiness.h
//  TTjianbao
//
//  Created by zk on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHImageTextWaitAuthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHImageTextWaitAuthBusiness : NSObject

/**
 待鉴定列表数据
 */
+ (void)getImageTextAuthListData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize Completion:(void(^)(NSError *_Nullable error, JHImageTextWaitAuthListModel *_Nullable model))completion;

/**
 去鉴定效验
 */
+ (void)getAuthStatus:(int)taskId Completion:(void(^)(BOOL canAuth))completion;


/**
 待鉴定详情
 */
+ (void)getImageTextAuthDetailData:(int)recordInfoId Completion:(void(^)(NSError *_Nullable error, JHImageTextWaitAuthDetailModel *_Nullable model))completion;


+ (void)jumpAuthStep:(int)taskId completion:(void(^)(BOOL isSuccess))completion;

@end

NS_ASSUME_NONNULL_END
