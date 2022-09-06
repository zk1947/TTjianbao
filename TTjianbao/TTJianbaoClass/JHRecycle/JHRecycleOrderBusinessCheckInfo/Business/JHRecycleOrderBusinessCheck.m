//
//  JHRecycleOrderBusinessCheck.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessCheck.h"

@implementation JHRecycleOrderBusinessCheck
/// 获取回收商验证信息
/// orderId : 订单ID
+ (void)getBusinessInfoWithOrderId : (NSString *)orderId
                    successBlock:(detailInfoBlock) success
                    failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{
        @"orderId" : orderId,
        @"imageType" : @"m,b,o",
    };
    NSString *url = FILE_BASE_STRING(@"/recycle/capi/auth/merchant/getConfirmPrice");
    
//    NSString *newUrl = [url stringByAppendingFormat:@"?orderId=%@&imageType=m,b,o",orderId];
    
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {

        NSDictionary *dic = respondObject.data;
        JHRecycleOrderBusinessModel *model = [JHRecycleOrderBusinessModel mj_objectWithKeyValues:dic];
        success(model);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}
@end
