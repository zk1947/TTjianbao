//
//  JHCustomizeNotHomePickupView.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/1/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPickerView.h"
#import "JHCustomizeSendOrderModel.h"

NS_ASSUME_NONNULL_BEGIN
@class OrderMode;
@interface JHCustomizeNotHomePickupView : UIView
@property (strong, nonatomic)  JHCustomizeSendOrderModel *model;
@property(strong,nonatomic) NSString *orderId;
@property(assign,nonatomic) BOOL  isSeller;
@property (nonatomic, strong) OrderMode *orderMode;

@end

NS_ASSUME_NONNULL_END
