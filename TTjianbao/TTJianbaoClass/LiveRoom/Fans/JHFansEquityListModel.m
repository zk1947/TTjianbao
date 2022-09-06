//
//  JHFansEquityListModel.m
//  TTjianbao
//
//  Created by liuhai on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansEquityListModel.h"

@implementation JHFansEquityInfoModel

@end

@implementation JHFansEquityLVModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"rewardVos" : @"JHFansEquityInfoModel",
    };
}
@end

@implementation JHFansEquityListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"levelRewardVos" : @"JHFansEquityLVModel",
    };
}
@end

@implementation JHFansEquityTipListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"rewardVoList" : @"JHFansEquityInfoModel",
    };
}
@end
