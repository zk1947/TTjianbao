//
//  JHMarketPublishModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketPublishModel.h"

@implementation JHMarketPublishCoverModel

@end

@implementation JHMarketPublishAuctionModel

@end

@implementation JHMarketProductExtModel

@end

@implementation JHMarketPublishModel
- (NSInteger)timeDuring {
    NSString *timeString = [CommHelp getNowTimeTimestamp];
    if (self.auctionStartTimeMillis.longLongValue >= timeString.longLongValue) {
        return (self.auctionStartTimeMillis.longLongValue / 1000 - timeString.longLongValue / 1000);
    } else {
        return (self.auctionEndTimeMillis.longLongValue / 1000 - timeString.longLongValue / 1000);
    }
}

@end

