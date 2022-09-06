//
//  JHLotteryJoinModel.m
//  TTjianbao
//
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryJoinModel.h"

@implementation JHLotteryJoinModel

+ (void)asynRequestActivityCode:(NSString*)code resp:(JHActionBlocks)resp
{
    JHLotteryJoinReqModel* req = [JHLotteryJoinReqModel new];
    req.activityCode = code;
    
    [JH_REQUEST asynGet:req success:^(id respData) {
        
        JHLotteryJoinModel* model = [JHLotteryJoinModel convertData:respData];
        resp([JHRespModel nullMessage], model);
    } failure:^(NSString *errorMsg) {
        resp(errorMsg, [JHRespModel nullMessage]);
    }];
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"dialog": [JHLotteryDialogModel class]
    };
}
@end

@implementation JHLotteryJoinReqModel

///activity/api/lottery/activity/v2/auth/join
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@auth/join",kLotteryReqPrefix];
}
@end

@implementation JHLotteryDialogModel
@end
