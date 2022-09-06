//
//  JHNewPaySuccessViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHNewPaySuccessViewController : JHBaseViewController
@property (nonatomic, strong) NSString * orderId;
@property (nonatomic, strong) NSString * paymoney;
@property (nonatomic, strong) OrderMode *orderMode;
@end

NS_ASSUME_NONNULL_END
