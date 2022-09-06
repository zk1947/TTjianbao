//
//  JHRecycleSoldViewModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleSoldModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleSoldViewModel : NSObject

///获取卖出的列表的接口
+ (void)getSoldList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSArray<JHRecycleSoldModel *> *_Nullable array))completion;
///取消订单
///确认收货
///删除
///申请仲裁
///申请退回
///申请销毁
///获取存金通链接地址
+ (void)getGoldUrlString:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSString *_Nullable urlString))completion;
@end

NS_ASSUME_NONNULL_END
