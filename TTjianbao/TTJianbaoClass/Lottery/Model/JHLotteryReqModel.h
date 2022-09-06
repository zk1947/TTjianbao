//
//  JHLotteryReqModel.h
//  TTjianbao
//
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"

#define kLotteryReqPrefix @"/activity/api/lottery/activity/v2/"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryReqModel : JHReqModel

@property (nonatomic, copy) NSString* activityCode; //e.g. 12121212,活动code
@end

NS_ASSUME_NONNULL_END
