//
//  JHMarketOrderModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketOrderModel.h"
@implementation JHMarketOrderButtonsModel

@end
@implementation JHMarketOrderAvatarModel

@end
@implementation JHMarketOrderGoodsUrlModel

@end
@implementation JHMarketOrderModel
- (NSInteger)timeDuring {
    NSString *timeString = [CommHelp getNowTimeTimestamp];
    return (self.expireTime.longLongValue / 1000 - timeString.longLongValue / 1000);
}

- (NSString *)appraisalResult {
    if (isEmpty(_appraisalResult)) {
        return @"999";
    }
    return _appraisalResult;
}
@end
