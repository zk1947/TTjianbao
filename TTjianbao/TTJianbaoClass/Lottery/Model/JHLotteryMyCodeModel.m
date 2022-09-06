//
//  JHLotteryMyCodeModel.m
//  TTjianbao
//  
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryMyCodeModel.h"

@implementation JHLotteryMyCodeModel

+ (void)asynRequestActivityCode:(NSString*)code unionId:(NSString*)unionId resp:(JHActionBlocks)resp
{
    JHLotteryMyCodeReqModel* req = [JHLotteryMyCodeReqModel new];
    req.activityCode = code;
    req.unionId = unionId;
    
    [JH_REQUEST asynGet:req success:^(NSDictionary* respData) {
        if([respData isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dicData = [respData objectForKey:@"content"];
            NSArray* arr = [JHLotteryMyCodeModel convertData:dicData];
            resp([JHRespModel nullMessage], arr);
        }
        else
        {
            resp(@"请求失败", [JHRespModel nullMessage]);
        }
    } failure:^(NSString *errorMsg) {
        resp(errorMsg, [JHRespModel nullMessage]);
    }];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"lotteryCode":@"code"};
}
@end

@implementation JHLotteryMyCodeReqModel
///activity/api/lottery/activity/v2/myCode
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@myCode",kLotteryReqPrefix];
}
@end
