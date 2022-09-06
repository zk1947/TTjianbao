//
//  JHFlashSendOrderModel.m
//  TTjianbao
//
//  Created by user on 2021/10/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFlashSendOrderModel.h"

@implementation JHFlashSendOrderRequestModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"anewSecondCategoryId" : @"newSecondCategoryId"
    };
}
@end


@implementation JHFlashSendOrderUserListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"rows" : @"JHFlashSendOrderUserListPeopleModel",
    };
}
@end

@implementation JHFlashSendOrderUserListPeopleModel

@end


@implementation JHFlashSendOrderRecordListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"rows" : @"JHFlashSendOrderRecordListItemModel",
    };
}
@end


@implementation JHFlashSendOrderRecordListItemModel
@end
