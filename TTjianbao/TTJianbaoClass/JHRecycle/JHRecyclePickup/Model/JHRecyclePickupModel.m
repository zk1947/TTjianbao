//
//  JHRecyclePickupModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePickupModel.h"


@implementation JHRecyclePickupAppointmentInfoImgUrlModel
@end


@implementation JHRecyclePickupAppointmentPickAddressModel
@end

@implementation JHRecyclePickupLogisticsInfoModel
@end

@implementation JHRecyclePickupGoToAppointmentModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"logisticsInfo" : [JHRecyclePickupLogisticsInfoModel class],
    };
}
@end


@implementation JHRecyclePickupAppointmentSuccessModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"logisticsInfo" : [JHRecyclePickupLogisticsInfoModel class],
    };
}
@end

