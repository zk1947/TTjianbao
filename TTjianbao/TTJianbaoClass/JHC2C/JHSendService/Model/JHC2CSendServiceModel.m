//
//  JHC2CSendServiceModel.m
//  TTjianbao
//
//  Created by hao on 2021/6/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSendServiceModel.h"

@implementation JHC2CDeliverInfoModel

@end

@implementation JHC2CReceiveInfoModel

@end

@implementation JHC2CExpressCompanyListModel

@end

@implementation JHC2CPackageDescriptionModel

@end

@implementation JHC2CSendServiceModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"expressCompanyList" : [JHC2CExpressCompanyListModel class],
    };
}
@end
