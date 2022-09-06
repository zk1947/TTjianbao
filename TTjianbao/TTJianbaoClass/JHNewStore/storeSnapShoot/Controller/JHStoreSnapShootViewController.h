//
//  JHStoreSnapShootViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetailViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreSnapShootViewController : JHBaseViewController
@property (nonatomic, copy) NSString *productId;
/// 商品售卖状态描述
@property (nonatomic, copy) NSString *sellStatusDesc;
/// 添加子view
- (void)setupViews;
/// 约束
- (void)layoutViews;
@end

NS_ASSUME_NONNULL_END
