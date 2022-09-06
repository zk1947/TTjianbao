//
//  JHTestModelTestModel.m
//  TTjianbao
//
//  Created by user on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTestModel.h"


@implementation JHCustomizeLogisticsModelTestModel
@end

@implementation JHCustomizeLogisticsUserExpressInfoModelTestModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"data" : [JHCustomizeLogisticsDataModelTestModel class]
    };
}
@end

@implementation JHCustomizeLogisticsDataModelTestModel
@end

