//
//  JHRecycleSoldModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleSoldModel.h"
#import "CommHelp.h"

@implementation JHRecycleButtonsModel

@end

@implementation JHRecycleAvatarModel

@end

@implementation JHRecycleGoodsUrlModel

@end

@implementation JHRecycleSoldModel

- (NSInteger)timeDuring {
    NSString *timeString = [CommHelp getNowTimeTimestamp];
    return (self.expiredTime.longLongValue / 1000 - timeString.longLongValue / 1000);
}

@end
