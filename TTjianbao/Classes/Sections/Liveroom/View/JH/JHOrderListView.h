//
//  JHOrderListView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/24.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderListView : BaseView

/**
 0 鉴定直播间 1 (直播)卖货直播间 2卖货直播间(助理)
 */
@property (nonatomic, assign) NSInteger roleType;
@property (nonatomic, assign) BOOL isAssistant;
@property (nonatomic, assign) BOOL isAndience;

- (void)showAlert;
- (void)hiddenAlert;

@end

NS_ASSUME_NONNULL_END
