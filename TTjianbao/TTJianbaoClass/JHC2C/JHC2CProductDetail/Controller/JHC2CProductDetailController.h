//
//  JHC2CProductDetailController.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
//#import "JHBasePostDetailController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHC2CProductDetailVCType){
    JHC2CProductDetailVCType_YiKouJia = 0,
    JHC2CProductDetailVCType_PaiMai,
} ;

@interface JHC2CProductDetailController : JHBaseViewController


/// 商品id
@property(nonatomic, strong) NSString * productId;


@end

NS_ASSUME_NONNULL_END
