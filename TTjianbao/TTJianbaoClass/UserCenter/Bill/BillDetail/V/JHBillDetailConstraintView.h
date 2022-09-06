//
//  JHBillDetailConstraintView.h
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBillDetailConstraintView : UIView


/// 运费补扣 = 0 结算 = 1  提现 = 2   退款 = 3  冲账 = 4 ，新增保价费 = 6
@property (nonatomic, assign) NSInteger result;

@property (nonatomic, copy) void(^resultBlock)(NSInteger result);

//-(void)reloadSelfView;

@end

NS_ASSUME_NONNULL_END
