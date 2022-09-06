//
//  JHRecyclePublishedModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePublishedModel.h"
#import "CommHelp.h"
#import "JHRecyclePriceModel.h"
@implementation JHRecycleImageModel
@end

@implementation JHRecyclePublishedModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"bidVOs" : [JHRecyclePriceModel class]
    };
}

// 计算时间差
- (NSInteger)timeDuring {
    NSString *timeString = [CommHelp getNowTimeTimestamp];
    return (self.tipInitCountdownTime.longLongValue / 1000 - timeString.longLongValue / 1000);
}

// 状态
- (PublishedStatusType)statusType {
    switch (self.productStatus) {
        case 0: //上架
        {
            if (self.bidCount == 0) {
                _statusType = PublishedStatusTypeNoPrice;
            }else {
                _statusType = PublishedStatusTypeHavePrice;
            }
        }
            break;
        case 1: //下架
            _statusType = PublishedStatusTypeFailure;
            break;
        case 5: //平台拒绝
            _statusType = PublishedStatusTypeRefused;
            break;
        default:
            break;
    }
    return _statusType;
}
@end
