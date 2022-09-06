//
//  JHLotteryReqModel.m
//  TTjianbao
//
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryReqModel.h"

@implementation JHLotteryReqModel

- (instancetype)init
{
    if(self = [super init])
    {
//        [self setRequestSourceType:JHRequestHostTypeDevDebuging];
    }
    return self;
}
//子类重写
- (NSString *)uriPath
{///activity/api/lottery/activity/v2/
    return kLotteryReqPrefix;
}
@end
