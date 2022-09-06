//
//  JHSubmitVoucherView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHOrderReturnMode;

@interface JHSubmitVoucherView : BaseView
@property(strong,nonatomic) JHOrderReturnMode* orderReturnMode;
@property(strong,nonatomic) NSString* orderId;
@property(strong,nonatomic) NSString* workOrderId;
@property(strong,nonatomic) NSArray* reasonArr;
@property(strong,nonatomic) NSArray* statusArr;
@property(strong,nonatomic) JHActionBlock completeBlock;
@end

NS_ASSUME_NONNULL_END
