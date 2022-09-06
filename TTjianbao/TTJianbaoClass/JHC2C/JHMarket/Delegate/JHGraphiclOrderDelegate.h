//
//  JHGraphiclOrderDelegate.h
//  TTjianbao
//
//  Created by miao on 2021/7/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHGraphicalSubModel;

NS_ASSUME_NONNULL_BEGIN

@protocol JHGraphiclOrderDelegate <NSObject>
/// 倒计时结束
- (void)countdownOver;
/// 取消鉴定
- (void)cancelAppraisalWith:(JHGraphicalSubModel *)graphicalModel;
/// 去支付
- (void)toPayWith:(JHGraphicalSubModel *)graphicalModel;
/// 删除
- (void)toDeleteWith:(JHGraphicalSubModel *)graphicalModel;
/// 查看报告
- (void)checkTheReportWith:(JHGraphicalSubModel *)graphicalModel;

@optional
- (void)contactCustomerService;

@end

@protocol JHGraphicalSubListVCDelegate <NSObject>

/// 重新刷新页面
- (void)toRefreshGraphicalSubListPage;

@end


NS_ASSUME_NONNULL_END
