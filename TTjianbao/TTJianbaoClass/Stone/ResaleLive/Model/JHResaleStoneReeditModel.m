//
//  JHResaleStoneReeditModel.m
//  TTjianbao
//
//  Created by Jesse on 3/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHResaleStoneReeditModel.h"

@implementation JHResaleStoneReeditModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{ @"urlList" : [JHMediaModel class]
            };
}

- (void)requestReeditModel:(JHResaleStoneReeditReqModel*)model response:(JHResponse)response
{
    [JH_REQUEST asynPost:model success:^(id respData) {
        if(response)
        {
            response(nil, [JHRespModel nullMessage]);
        }
    } failure:^(NSString *errorMsg) {
        if(response)
        {
            response([JHRespModel nullMessage], errorMsg);
        }
    }];
}

- (void)requestReeditStoneId:(NSString*)stoneId response:(JHResponse)response
{
    JHResaleStoneDetailReeditReqModel* model = [JHResaleStoneDetailReeditReqModel new];
    model.stoneRestoreId = stoneId;
//    JH_WEAK(self)
    [JH_REQUEST asynPost:model success:^(id respData) {
//        JH_STRONG(self)
        JHResaleStoneReeditModel* data = [JHResaleStoneReeditModel convertData:respData];

        if(response)
        {
            response(data, [JHRespModel nullMessage]);
        }
    } failure:^(NSString *errorMsg) {
        if(response)
        {
            response([JHRespModel nullMessage], errorMsg);
        }
    }];
}
@end

@implementation JHResaleStoneReeditReqModel
///主播-原石回血-二次编辑
- (NSString *)uriPath
{
    return @"/app/stone-restore/update";
}
@end

@implementation JHResaleStoneDetailReeditReqModel
///主播-原石回血-拉取数据展示详情（二次编辑）
- (NSString *)uriPath
{
    return @"/anon/stone-restore/detail-for-update";
}
@end

