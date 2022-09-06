//
//  JHSelectMerchantViewController.h
//  TTjianbao
//
//  Created by apple on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSelectMerchantViewController : JHBaseViewExtController

@property (nonatomic, assign) NSInteger signStatus;  ///签约状态
@property (nonatomic, assign) NSInteger merchantType;  ///商家类型  认证类型
@property (nonatomic, assign) NSInteger authStatus;  ///认证状态：0 未认证 1 已认证 2 认证中 3 认证失败

@end

NS_ASSUME_NONNULL_END
