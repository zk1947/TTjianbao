//
//  JHMainLiveSmartModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMainLiveSmartModel.h"
#import "JHPrinterManager.h"

@implementation JHMainLiveConsignReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore/consignment";
}
@end

@implementation JHMainLiveAttachModel

@end

@implementation JHMainLiveUpdatePriceReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore/update-price";
}

+ (void)requestWithStoneId:(NSString*)mId price:(NSString*)price flag:(int)flag finish:(JHFailure)failure
{
    JHMainLiveUpdatePriceReqModel* model = [JHMainLiveUpdatePriceReqModel new];
    model.stoneRestoreId = mId;
    model.price = price;
    model.flag = flag;
    [JH_REQUEST asynPost:model success:^(id respData) {
        failure([JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    }];
}

@end

@implementation JHMainLiveFindReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore/find";
}
@end

@implementation JHMainLiveConfirmConsignReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore/find-confirm-consignment";
}
@end

@implementation JHMainLiveConfirmSplitReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore/find-confirm-split";
}
@end

@implementation JHMainLiveSendBackReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore/send";
}

+ (void)request:(NSString*)channelCategory stoneId:(NSString*)stoneId finish:(JHFailure)failure
{
    JHMainLiveSendBackReqModel* model = [JHMainLiveSendBackReqModel new];
    model.channelCategory = channelCategory;
    model.stoneId = stoneId;
    [JH_REQUEST asynPost:model success:^(id respData) {
        failure([JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    }];
}
@end

@implementation JHMainLiveShelveReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore/shelve";
}
@end

@implementation JHMainLiveSplitReqModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"splitStoneList": [JHMainLiveSplitDetailModel class]};
}

- (NSString *)uriPath
{
    return @"/app/stone-restore/split";
}

@end

@implementation JHStoneLivePrintCodeReqModel

- (NSString *)uriPath
{
    return @"/app/stone/print-goods-code";
}

@end

@implementation JHStoneLivePrintCodeModel

+ (void)requestWithModel:(JHLastSaleGoodsModel*)model response:(JHFailure)failure
{
    if(model.stoneId)
    {
        JHStoneLivePrintCodeReqModel* reqModel = [JHStoneLivePrintCodeReqModel new];
        reqModel.channelCategory = @"roughOrder";
        reqModel.stoneId = model.stoneId;
        [JH_REQUEST asynPost:reqModel success:^(id respData) {
            
            JHStoneLivePrintCodeModel* printModel = [JHStoneLivePrintCodeModel convertData:respData];
            
            [[JHPrinterManager sharedInstance] printStoneBarCode:printModel.goodsCode ? : @"" andResult:^(BOOL success, NSString *desc) {
                if(success)
                    failure([JHRespModel nullMessage]);
                else
                    failure(desc);
            }];
            
        } failure:^(NSString *errorMsg) {
            failure(errorMsg);
        }];
    }
}

@end

@implementation JHMainLiveSmartModel

+ (void)request:(JHReqModel*)model response:(JHResponse)response
{
    [JH_REQUEST asynPost:model success:^(id respData) {
        //success
        response(respData,[JHRespModel nullMessage]);

    } failure:^(NSString *errorMsg) {
        //fail ~ tips
        response(nil,errorMsg);
    }];
}
@end

@implementation JHMainLiveSplitDetailModel

- (NSString*)purchasePrice
{
    if (_purchasePrice) {
        double d = [_purchasePrice doubleValue];
        NSString *dStr = [NSString stringWithFormat:@"%f", d];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
        _purchasePrice = [dn stringValue];
    }
    return _purchasePrice;
}

@end

//用户 取消并寄回
@implementation JHUserRejectConsignReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore/reject-consignment";
}
@end

//用户 确认寄回
@implementation JHUserConfirmConsignReqModel
- (NSString *)uriPath
{
    return @"/app/stone-restore/accept-consignment";
}
@end

@implementation JHResaleInformReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore-seek/inform";
}

+ (void)requestWithStoneId:(NSString*)mId finish:(JHFailure)failure
{
    JHResaleInformReqModel* model = [JHResaleInformReqModel new];
    model.stoneRestoreId = mId;
    [JH_REQUEST asynPost:model success:^(id respData) {
        failure([JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        failure(errorMsg);
    }];
}
@end

@implementation JHResaleToSeeCountReqModel

- (NSString *)uriPath
{
    return @"/app/stone-restore-seek/count-by-channel";
}

+ (void)requestWithChannelId:(NSString*)mId finish:(JHResponse)resp
{
    JHResaleToSeeCountReqModel* model = [JHResaleToSeeCountReqModel new];
    model.channelId = mId;
    [JH_REQUEST asynPost:model success:^(id respData) {
        resp(respData, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        resp([JHRespModel nullMessage], errorMsg);
    }];
}
@end

@implementation JHUserAcceptPriceReqModel
- (NSString *)uriPath
{
    return @"/app/stone-restore-offer/accept";
}
@end

@implementation JHUserRejectPriceReqModel
- (NSString *)uriPath
{
    return @"/app/stone-restore-offer/reject";
}
@end

@implementation JHUserConfirmBreakReqModel
- (NSString *)uriPath
{
    return @"/app/stone-restore/confirm-split";
}
@end

