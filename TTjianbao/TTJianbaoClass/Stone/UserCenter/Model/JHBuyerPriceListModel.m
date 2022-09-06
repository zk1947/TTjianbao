//
//  JHBuyerPriceListModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBuyerPriceListModel.h"

@implementation JHBuyerPriceModel

+ (NSDictionary*)mj_objectClassInArray
{
    return @{
                @"customerOfferList" : [JHBuyerPriceDetailModel class]
             };
}
@end

@implementation JHBuyerPriceDetailModel

@end

@implementation JHBuyerPriceListModel

+ (NSDictionary*)mj_objectClassInArray
{
    return @{
                @"stoneDetail" : [JHBuyerPriceModel class]
             };
}
@end

@implementation JHBuyerPriceListReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore-offer/list-for-saler";
    
}
@end

@implementation JHBuyerRejectPriceReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore-offer/reject";
}

+ (void)requestWithStoneModel:(JHBuyerPriceDetailModel*)priceModel finish:(JHFailure)failure
{
    JHBuyerRejectPriceReqModel* model = [JHBuyerRejectPriceReqModel new];
    model.stoneRestoreOfferId = priceModel.stoneRestoreOfferId;
    model.resaleFlag = priceModel.resaleFlag;
    [JH_REQUEST asynPost:model success:^(id respData) {
        failure([JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    }];
}

@end

@implementation JHAcceptBuyerPriceReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore-offer/accept";
}

@end

