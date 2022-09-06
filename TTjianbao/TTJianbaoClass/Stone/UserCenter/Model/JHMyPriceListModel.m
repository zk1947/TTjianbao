//
//  JHMyPriceListModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMyPriceListModel.h"

@implementation JHMyPriceDetailModel

- (NSString*)offerPrice
{
    if (_offerPrice) {
        double d = [_offerPrice doubleValue];
        NSString *dStr = [NSString stringWithFormat:@"%f", d];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
        _offerPrice = [dn stringValue];
    }
    return _offerPrice;
}

@end

@implementation JHMyPriceListModel

@end

@implementation JHMyPriceListReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore-offer/list-for-buyer";
}

@end

@implementation JHMyCancelPriceReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore-offer/cancel";
}

+ (void)requestWithStoneModel:(JHMyPriceListModel*)stoneModel finish:(JHFailure)failure
{
    JHMyCancelPriceReqModel* model = [JHMyCancelPriceReqModel new];
    model.stoneRestoreOfferId = stoneModel.offerDetail.stoneRestoreOfferId;
    model.resaleFlag = stoneModel.resaleFlag;
    [JH_REQUEST asynPost:model success:^(id respData) {
        failure([JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    }];
}
@end
