//
//  JHBusinessFansSettingModel.m
//  TTjianbao
//
//  Created by user on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansSettingModel.h"

@implementation JHBusinessFansSettingModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"levelMsgList" : [JHBusinessFansSettingLevelMsgListModel class],
        @"levelRewardDTOList" : [JHBusinessFansSettinglevelRewardDTOListModel class],
        @"taskCheckList" : [JHBusinessFansSettingTaskCheckListModel class],
        @"levelTemplateVos" : [JHBusinessFansLevelTemplateVosModel class],
        
    };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"fansId" : @"id"
    };
}
@end


@implementation JHBusinessFansLevelTemplateVosModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"temID" : @"id"
    };
}
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"levelMsgList" : [JHBusinessFansSettingLevelMsgListModel class],
    };
}
@end

@implementation JHBusinessFansSettingLevelMsgListModel
@end

@implementation JHBusinessFansSettinglevelRewardDTOListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"rewardVos" : [JHBusinessFansSettinglevelRewardVosModel class]
    };
}
@end


@implementation JHBusinessFansSettinglevelRewardVosModel
@end

@implementation JHBusinessFansSettingTaskCheckListModel
@end
