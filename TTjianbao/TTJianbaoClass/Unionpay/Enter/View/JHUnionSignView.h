//
//  JHUnionSignView.h
//  TTjianbao
//
//  Created by apple on 2020/4/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbaoMarcoEnum.h"

NS_ASSUME_NONNULL_BEGIN

/// 签约弹框
@interface JHUnionSignAlertView : UIView

+ (JHUnionSignAlertView *)creatUnionSignAlertViewWithStatus:(JHUnionSignStatus)status;

@end


/// 签约 View
@interface JHUnionSignView : UIImageView

/// 是否是橘色
@property (nonatomic, assign) BOOL isOrange;

+ (void)signMethod;

+ (CGFloat)viewHeight;

/// 获取签约状态  查询自己千万不要传 customerId
+ (void)getUnionSignStatusWithCustomerId:(NSString * __nullable)customerId statusBlock:(nullable void(^)(JHUnionSignStatus status))statusBlock;

@end

NS_ASSUME_NONNULL_END
/*
 使用说明
 
 JHUnionSignView *signView = [JHUnionSignView new];
 [self.view addSubview:signView];
 signView.isOrange = YES;
 [signView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.view).offset(10);
     make.right.equalTo(self.view).offset(-10);
     make.top.equalTo(self.view).offset(200);
     make.height.mas_equalTo([JHUnionSignView viewHeight]);
 }];
 
 */
