//
//  JHStoreListBusiness.h
//  TTjianbao
//
//  Created by zk on 2021/10/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHStoreListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreListBusiness : NSObject

+ (void)loadData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, NSArray *_Nullable resourceArr, NSString *_Nullable isHaveData))completion;
@end

NS_ASSUME_NONNULL_END
