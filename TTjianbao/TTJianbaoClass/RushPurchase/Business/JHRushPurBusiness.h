//
//  JHRushPurBusiness.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRushPurChaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRushPurBusiness : NSObject

///获取天天秒杀主页
+ (void)requestRushPur:(NSDictionary *)par completion:(void (^)(NSError * _Nullable error, JHRushPurChaseModel * _Nullable model))completion;



///设置挺行
+ (void)requestSalesReminder:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
