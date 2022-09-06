//
//  JHLotteryRemindModel.m
//  TTjianbao
//
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryRemindModel.h"

@implementation JHLotteryRemindModel

+ (void)asynRequestActivityCode:(NSString*)code resp:(JHActionBlocks)resp
{
    JHLotteryRemindReqModel* req = [JHLotteryRemindReqModel new];
    req.activityCode = code;
    
    [JH_REQUEST asynGet:req success:^(id respData) {
        
        JHLotteryRemindModel* model = [JHLotteryRemindModel convertData:respData];
        resp([JHRespModel nullMessage], model);
    } failure:^(NSString *errorMsg) {
        resp(errorMsg, [JHRespModel nullMessage]);
    }];
}
@end

@implementation JHLotteryRemindReqModel

///activity/api/lottery/activity/v2/auth/remind
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@auth/remind",kLotteryReqPrefix];
}
@end
