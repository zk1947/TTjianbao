//
//  JHC2CRefundDetailModel.m
//  TTjianbao
//
//  Created by hao on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CRefundDetailModel.h"

@implementation JHApplyRefundImageModel
@end

@implementation JHRefundImagesModel
@end

@implementation JHRefundOperationListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"applyRefundImage" : [JHApplyRefundImageModel class],
        @"images" : [JHRefundImagesModel class],

    };
}
@end

@implementation JHRefundTypeModel
@end


@implementation JHRefundReasonsModel
@end


@implementation JHRefundRefuseReasonModel
@end

@implementation JHRefundButtonShowModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"deleteBtn" : @"delete"};
}
@end


@implementation JHC2CRefundDetailModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"operationList" : [JHRefundOperationListModel class],
        @"refundType" : [JHRefundTypeModel class],
        @"refundReasons" : [JHRefundReasonsModel class],
        @"refuseReason" : [JHRefundRefuseReasonModel class],
    };
}
@end
