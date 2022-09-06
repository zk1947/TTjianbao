//
//  JHShopHomeController.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/19.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  店铺主页
//

#import "JHBaseViewExtController.h"
@class JHSellerInfo;
NS_ASSUME_NONNULL_BEGIN

@interface JHShopHomeController : JHBaseViewExtController

///商家id(店铺id)
@property (nonatomic, assign) NSInteger sellerId;

/// 关注列表
@property (nonatomic, copy) void(^focusBlock)(BOOL isFocus);


@end

NS_ASSUME_NONNULL_END
