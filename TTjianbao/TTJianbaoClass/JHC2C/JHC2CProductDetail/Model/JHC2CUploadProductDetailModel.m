//
//  JHC2CUploadProductDetailModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CUploadProductDetailModel.h"

@implementation BackAttrRelationResponse

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"keyID":@"id"};
}

@end

@implementation BackProductPicConfResponse

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"keyID":@"id"};
}

@end

@implementation AppraisalCategoryAttrDTO

@end

@implementation OrdermyCouponVoInfoResp

@end

@implementation OrderDiscountListResp
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"myCouponVoList": OrdermyCouponVoInfoResp.class };
}

@end


@implementation JHC2CUploadProductDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"backAttrRelationResponses": BackAttrRelationResponse.class,
             @"backProductPicConfResponses": BackProductPicConfResponse.class
    };
}

@end
