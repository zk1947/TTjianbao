//
//  JHBusinessPubishNomalModel.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPubishNomalModel.h"
@implementation JHPublishTimeListModel

@end

@implementation JHBusinessPubishNomalModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"backCateList" : [JHGoodManagerFilterModel class],
        @"publishLastTimeList" : [JHPublishTimeListModel class],
        @"publishStartTimeList" : [JHPublishTimeListModel class]
    };
}
@end
