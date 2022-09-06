//
//  JHSQHotListController.h
//  TaodangpuAuction
//
//  Created by wuyd on 2020/6/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  社区首页 - 热帖列表
//

#import "YDBaseViewController.h"
#import "JXCategoryView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HeadScrollBlock)(BOOL isUp);

@interface JHSQHotListController : YDBaseViewController <JXCategoryListContentViewDelegate>

@property (nonatomic, copy) HeadScrollBlock headScrollBlock;

@end

NS_ASSUME_NONNULL_END
