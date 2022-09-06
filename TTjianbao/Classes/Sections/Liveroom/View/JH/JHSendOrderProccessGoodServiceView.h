//
//  JHSendOrderProccessGoodServiceView.h
//  TTjianbao
//
//  Created by Jesse on 2019/11/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "JHLastSaleGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHSendOrderProccessGoodServiceView : UIButton
@property (nonatomic, strong) OrderMode *orderModel;
@property (nonatomic, strong) JHLastSaleGoodsModel *stoneModel;

@end

NS_ASSUME_NONNULL_END
