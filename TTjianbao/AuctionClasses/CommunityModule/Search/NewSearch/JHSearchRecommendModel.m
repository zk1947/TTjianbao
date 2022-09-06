//
//  JHSearchRecommendModel.m
//  TTjianbao
//
//  Created by liuhai on 2021/10/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSearchRecommendModel.h"

@implementation JHSearchRecommendShopdModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"shopId":@"id"};
}
@end
@implementation JHSearchRecommendLivingModel

@end
@implementation JHSearchRecommendKeyWordModel

@end

@implementation JHSearchRecommendModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"operationSubjectResponses" : [JHSearchRecommendKeyWordModel class],
             @"hotLiveResponses" : [JHSearchRecommendLivingModel class],
             @"hotShopResponses" : [JHSearchRecommendShopdModel class]
    };
}
@end
