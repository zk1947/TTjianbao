//
//  JHZeroAuctionModel.m
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHZeroAuctionModel.h"

@implementation JHZeroAuctionModel

@end

@implementation JHZeroAuctionHeadModel
+ (NSDictionary *)replacedKeyFromPropertyName{
     return @{
               @"ID" : @"id"
              };
}
@end

@implementation JHZeroAuctionContentModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"resultList" : [JHNewStoreHomeGoodsProductListModel class]
    };
}
@end
