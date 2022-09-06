//
//  JHLastSaleGoodsReqModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHLastSaleGoodsReqModel.h"
#import "JHLastSaleGoodsModel.h"

@implementation JHLastSaleGoodsReqModel

- (NSString*)uriPath
{
    NSString* url = @"/app/stone-restore/list-channel-sold";
    if(_reqType == JHLastSaleGoodsReqTypeWillSale)
        url = @"/app/stone-restore/list-channel-wait-shelve";
    else if(_reqType == JHLastSaleGoodsReqTypeStoneSale)
        url = @"/app/stone/page";
    else if(_reqType == JHLastSaleGoodsReqTypeLastSaleFromUserCenter)
        url = @"/app/stone-restore/list-sold";
    else if(_reqType == JHLastSaleGoodsReqTypeWillSaleFromUserCenter)
    url = @"/app/stone-restore/list-wait-shelve";
    return url;
}

@end
