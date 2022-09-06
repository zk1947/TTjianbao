//
//  JHNewShopDetailViewController.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  商铺详情

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopDetailViewController : JHBaseViewController
@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *customerId;//如果shopId为空，则用customerId
@property (nonatomic, assign) BOOL isFollow;
///指定跳转到页面 1:用户评论
@property(nonatomic) NSInteger defaultSelectedIndex;

@end




NS_ASSUME_NONNULL_END
