//
//  JHBuyAppraiseCheckCountView.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBuyAppraiseCheckCountView : BaseView

/** 刷新数据*/
- (void)refreshData;

/** 反向传值,筛选数据*/
@property (nonatomic, copy) void(^selectBlock)(NSDictionary *params);
@end

NS_ASSUME_NONNULL_END
