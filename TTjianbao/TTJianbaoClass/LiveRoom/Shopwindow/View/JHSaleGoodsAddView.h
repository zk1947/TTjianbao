//
//  JHSaleGoodsAddView.h
//  TTjianbao
//  Description:直播间-商品橱窗-添加商品
//  Created by jesee on 16/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSaleGoodsView.h"

@interface JHSaleGoodsCateModel : JHRespModel

@property (nonatomic, copy) NSString* cateId;
@property (nonatomic, copy) NSString* name;
@end

@interface JHSaleGoodsAddView : JHSaleGoodsView

@end

