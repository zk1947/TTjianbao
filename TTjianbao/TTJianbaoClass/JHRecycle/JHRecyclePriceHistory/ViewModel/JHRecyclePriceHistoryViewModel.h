//
//  JHRecyclePriceHistoryViewModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecyclePriceHistoryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecyclePriceHistoryViewModel : NSObject

///获取出价记录列表的接口
+ (void)getPriceHistoryList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSArray<JHRecyclePriceHistoryModel *> *_Nullable array))completion;

@end

NS_ASSUME_NONNULL_END
