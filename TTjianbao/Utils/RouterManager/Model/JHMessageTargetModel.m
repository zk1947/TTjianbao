//
//  JHMessageTargetModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/3/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageTargetModel.h"

@implementation JHMessageTargetModel

- (JHMessageTargetParamsModel*)paramTargetModel
{
    JHMessageTargetParamsModel* model = [JHMessageTargetParamsModel mj_objectWithKeyValues:self.params];
    return model;
}
@end

@implementation JHMessageTargetParamsModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end
