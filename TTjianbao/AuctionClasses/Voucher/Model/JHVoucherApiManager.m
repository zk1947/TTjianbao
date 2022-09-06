//
//  JHVoucherApiManager.m
//  TTjianbao
//
//  Created by wuyd on 2020/3/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHVoucherApiManager.h"
#import "TTjianbaoHeader.h"

@implementation JHVoucherApiManager

///直播间卖家可以发放给个人的代金券列表
+ (void)getValidDataList:(JHVoucherListModel *)model block:(HTTPCompleteBlock)block {
    NSLog(@"获取直播间卖家可以发放给个人的代金券列表");
    if (model.isLoading) {return;}
    model.isLoading = YES;
    
    [HttpRequestTool getWithURL:[model toValidUrl] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        NSArray *dataList = [NSArray modelArrayWithClass:[JHVoucherListData class] json:respondObject.data];
        if (dataList.count > 0) {
            JHVoucherListModel *aModel = [[JHVoucherListModel alloc] init];
            aModel.list = dataList.mutableCopy;
            block(aModel, NO);
            
        } else {
//            JHVoucherListModel *aModel = [[JHVoucherListModel alloc] init];
//            for (NSInteger i = 0; i < 20; i++) {
//                JHVoucherListData *data = [[JHVoucherListData alloc] init];
//                data.sellerId = @"1";
//                data.voucherId = i+100;
//                data.name = [NSString stringWithFormat:@"100元情人节代金券 - %ld", (long)i];
//                [aModel.list addObject:data];
//            }
//            block(aModel, NO);
            
            block(nil, NO);
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

///发放代金券
+ (void)sendVoucherToUserId:(NSString *)userId
                   sellerId:(NSString *)sellerId
                 voucherIds:(NSArray *)voucherIds
                      block:(HTTPCompleteBlock)block
{
    NSLog(@"发放代金券");
    NSString *urlStr = FILE_BASE_STRING(@"/voucher/buyer/singleGrant/auth");
    NSString *ids = [voucherIds componentsJoinedByString:@","];
    NSDictionary *params = @{@"customerId":@(userId.integerValue),
                             @"sellerId":@(sellerId.integerValue),
                             @"couponIds":ids
    };
    
    [HttpRequestTool postWithURL:urlStr Parameters:params requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel * _Nullable respondObject) {
        block(respondObject, NO);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(respondObject, YES);
    }];
}

///创建代金券
+ (void)createVoucherWithParams:(NSDictionary *)params block:(HTTPCompleteBlock)block {
    //POST /voucher/seller/create/auth
    NSString *urlStr = FILE_BASE_STRING(@"/voucher/seller/create/auth");
    [HttpRequestTool postWithURL:urlStr Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        block(respondObject, NO);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(respondObject, YES);
    }];
}

@end
