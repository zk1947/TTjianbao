//
//  JHUserInfoEvaluateModel.m
//  TTjianbao
//
//  Created by hao on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserInfoEvaluateModel.h"

@implementation JHUserInfoEvaluatImagesModel

@end

@implementation JHEvaluateresultListModel

@end

@implementation JHUserInfoEvaluateModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"resultList" : [JHEvaluateresultListModel class],
    };
}
@end
