//
//  JHLotteryShareModel.m
//  TTjianbao
//  分享成功
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryShareModel.h"

@implementation JHLotteryShareModel

+ (void)asynRequestActivityCode:(NSString*)code resp:(JHActionBlocks)resp
{
    JHLotteryShareReqModel* req = [JHLotteryShareReqModel new];
    req.activityCode = code;
    
    [JH_REQUEST asynGet:req success:^(id respData) {
        
        JHLotteryShareModel* model = [JHLotteryShareModel convertData:respData];
        resp([JHRespModel nullMessage], model);
    } failure:^(NSString *errorMsg) {
        resp(errorMsg, [JHRespModel nullMessage]);
    }];
}
@end

@implementation JHLotteryShareReqModel

///activity/api/lottery/activity/v2/auth/share
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@auth/share",kLotteryReqPrefix];
}
@end
