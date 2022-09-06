//
//  JHSQHomePageController.h
//  TTjianbao
//  Description:文玩社区
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  社区首页框架
//

#import "YDBaseTitleBarController.h"
#import "JXCategoryView.h"
#import "JHSQRcmdListController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HeadScrollBlock)(BOOL isUp);

@interface JHSQHomePageController : YDBaseTitleBarController <JXCategoryListContentViewDelegate>

@property (nonatomic, copy) HeadScrollBlock headScrollBlock;

- (void)trackUserProfilePage:(BOOL)isBegin;

@end

NS_ASSUME_NONNULL_END
