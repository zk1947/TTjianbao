//
//  JHRankingModel.m
//  TTjianbao
//
//  Created by yaoyao on 2019/1/15.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHRankingModel.h"

@implementation JHRankingModel

@end

@implementation JHRankingNewModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"reportRecordScoreFieldList" : @"NSDictionary",
             };
    
}


@end

@implementation JHRankingDataModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"reportRankingList" : @"JHRankingNewModel",
             };

}
@end



