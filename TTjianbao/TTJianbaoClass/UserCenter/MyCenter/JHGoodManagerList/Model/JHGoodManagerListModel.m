//
//  JHGoodManagerListModel.m
//  TTjianbao
//
//  Created by user on 2021/8/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListModel.h"

/// 请求体
@implementation JHGoodManagerListRequestModel

@end


/// 总
@implementation JHGoodManagerListAllDataModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"statistics" : [JHGoodManagerListTabChooseModel class]
    };
}
@end


@implementation JHGoodManagerListRecordModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"lists" : [JHGoodManagerListModel class]
    };
}
@end


/// 商品tab
@implementation JHGoodManagerListTabChooseModel

@end


/// 商品列表
@implementation JHGoodManagerListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"goodId" : @"id"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"mainImageUrls" : [JHGoodManagerListImageModel class]
    };
}

- (NSString *)productStatusStr {
    switch (self.productStatus) {
        case JHGoodManagerListRequestProductStatus_PutOn:
            return @"上架中";
        case JHGoodManagerListRequestProductStatus_PutOff:
            return @"下架";
        case JHGoodManagerListRequestProductStatus_IllegalSale:
            return @"违规禁售";
        case JHGoodManagerListRequestProductStatus_Trailer:
            return @"预告中";
        case JHGoodManagerListRequestProductStatus_AlreadySold:
            return @"已售出";
        case JHGoodManagerListRequestProductStatus_NoOneBuy:
            return @"流拍";
        case JHGoodManagerListRequestProductStatus_Cancel:
            return @"交易取消";
        default:
            return nil;
    }
}
@end

@implementation JHGoodManagerListImageModel

@end

/// 上架
@implementation JHGoodManagerListItemPutOnRequestModel

@end
