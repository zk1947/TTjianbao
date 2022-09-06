//
//  JHLotteryEditAddressModel.m
//  TTjianbao
//
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryEditAddressModel.h"

@implementation JHLotteryEditAddressModel

+ (void)asynRequestActivityCode:(NSString*)code addressId:(NSString*)addressId resp:(JHActionBlocks)resp
{
    JHLotteryEditAddressReqModelExt* req;
    
    if([addressId length] > 0)
    {
        req = [JHLotteryEditAddressReqModelExt new];
        req.activityCode = code;
        req.addressId = addressId;
    }
    else
    {
        req = [JHLotteryEditAddressReqModel new];
        req.activityCode = code;
    }
    
    [JH_REQUEST asynGet:req success:^(id respData) {
        
        JHLotteryEditAddressModel* model = [JHLotteryEditAddressModel convertData:respData];
        resp([JHRespModel nullMessage], model);
    } failure:^(NSString *errorMsg) {
        resp(errorMsg, [JHRespModel nullMessage]);
    }];
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"address": [JHLotteryAddressDetailModel class]
    };
}
@end

@implementation JHLotteryEditAddressReqModel

///activity/api/lottery/activity/v2/auth/address
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@auth/address",kLotteryReqPrefix];
}
@end

@implementation JHLotteryEditAddressReqModelExt

@end

@implementation JHLotteryAddressDetailModel

@end
