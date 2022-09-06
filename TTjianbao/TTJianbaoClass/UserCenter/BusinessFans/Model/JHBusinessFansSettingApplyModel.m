//
//  JHBusinessFansSettingApplyModel.m
//  TTjianbao
//
//  Created by user on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansSettingApplyModel.h"

@implementation JHBusinessFansSettingApplyModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"fansRewardConfigVoList" : [JHBusinessFansRewardConfigVoListApplyModel class],
        @"levelMsgList" : [JHBusinessFansLevelMsgListApplyModel class],
        @"taskCheckList" : [JHBusinessFansTaskCheckListApplyModel class],
    };
}
@end

@implementation JHBusinessFansRewardConfigVoListApplyModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"fansRewardConfigList" : [JHBusinessFansRewardConfigListApplyModel class]
    };
}
@end


@implementation JHBusinessFansRewardConfigListApplyModel
@end



@implementation JHBusinessFansLevelMsgListApplyModel
@end



@implementation JHBusinessFansTaskCheckListApplyModel
@end

@implementation JHFansCoupouModel
@end

