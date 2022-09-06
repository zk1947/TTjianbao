//
//  JHOffSaleGoodsModel.h
//  TTjianbao
//  Description:宝友下架
//  Created by Jesse on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHGoodsRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOffSaleGoodsModel : JHGoodsRespModel

@property (nonatomic, strong) NSString* depositoryLocationCode; //"string",
@property (nonatomic, strong) NSString* unshelveTime; //"2019-12-04T09:36:30.836Z"
@property (nonatomic, strong) NSString* salePrice; //: 0,
@property (nonatomic, strong) NSString* stoneRestoreId; //: 0,

@end

NS_ASSUME_NONNULL_END
