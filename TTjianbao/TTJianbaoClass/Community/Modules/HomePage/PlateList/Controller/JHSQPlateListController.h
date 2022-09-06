//
//  JHSQPlateListController.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  社区首页 - 版块列表
//

#import "JHBaseViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HeadScrollBlock)(BOOL isUp);

@interface JHSQPlateListController : JHBaseViewController <JXCategoryListContentViewDelegate>

@property (nonatomic, copy) HeadScrollBlock headScrollBlock;

///tabBar点击
- (void)handleTabBarClick;

@property (nonatomic, assign) JHPageType pageType;

@end

NS_ASSUME_NONNULL_END
