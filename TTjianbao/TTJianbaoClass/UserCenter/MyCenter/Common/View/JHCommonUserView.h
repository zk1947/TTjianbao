//
//  JHCommonUserView.h
//  TTjianbao
//
//  Created by lihui on 2020/4/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCommonUserView : BaseView

///滑动的回调block
@property (nonatomic, copy) void(^scrollBlock)(CGFloat offSet);
///滑动的停止回调block
@property (nonatomic, copy) void(^scrollEndBlock)(CGFloat offSet);
///进入上架认证界面
//- (void)enterMerchantVC;

///进入个人主页
- (void)enterUserInfoVC;
///刷新列表数据
- (void)refreshPersonCenterData;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
