//
//  JHStoreDetailViewController.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品详情

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailViewController : JHBaseViewController
@property (nonatomic, copy) NSString *productId;
/// 刷新上层页面-当关注、优惠券领取状态改变时触发。
@property (nonatomic, strong) RACSubject *refreshUpper;
/// 商品售卖状态描述
@property (nonatomic, copy) NSString *sellStatusDesc;
/// 来源
@property (nonatomic, copy) NSString *fromPage;

/// 缩略模式
@property(nonatomic) BOOL  shotScreen;
/// 添加子view
- (void)setupViews;
/// 约束
- (void)layoutViews;
@end

NS_ASSUME_NONNULL_END
