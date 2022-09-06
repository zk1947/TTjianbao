//
//  JHCustomizeHomePickupView.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHCustomizeSendOrderModel,OrderMode;

@interface JHCustomizeHomePickupView : UIView
@property (nonatomic, strong) JHCustomizeSendOrderModel *sendOrderModel;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) OrderMode *orderMode;

@end

NS_ASSUME_NONNULL_END
