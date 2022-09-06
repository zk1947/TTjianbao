//
//  JHBuyAppraiseHeaderView.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBuyAppraiseHeaderView : BaseView

/// 直播或者回放开始
- (void)start;

/// 直播或者回放结束
- (void)stop;

/// 刷新
- (void)refreshData;

/** 反向传值,筛选数据*/
@property (nonatomic, copy) void(^selectBlock)(NSDictionary *params);
@end

NS_ASSUME_NONNULL_END
