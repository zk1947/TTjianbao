//
//  JHRecyclePriceModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePriceModel.h"
#import "CommHelp.h"

@implementation JHRecyclePriceModel
// 计算时间差
- (NSInteger)timeLeft {
    NSString *timeString = [CommHelp getNowTimeTimestamp];
    return (self.tipInitCountdownTime.longLongValue / 1000 - timeString.longLongValue / 1000);
}
@end
