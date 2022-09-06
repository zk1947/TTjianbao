//
//  JHCustomizeOrderFlyListView.h
//  TTjianbao
//
//  Created by user on 2021/1/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPopBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class JHCheckCustomizeOrderListModel;
@class JHCustomizeOrderFlyListView;

typedef void (^customizeActionBlock)(JHCheckCustomizeOrderListModel *model, JHCustomizeOrderFlyListView *view);
/// 定制订单列表
@interface JHCustomizeOrderFlyListView : JHPopBaseView
@property (nonatomic, assign) NSInteger customerId; /// 用户id
@property (nonatomic,   copy) customizeActionBlock cusActionBlock;
- (instancetype)initWithCustomerId:(NSInteger)customerId;
@end

NS_ASSUME_NONNULL_END
