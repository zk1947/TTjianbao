//
//  JHPostDetailToolBar.h
//  TTjianbao
//
//  Created by lihui on 2020/8/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 社区 - 帖子详情 底部评论工具栏

#import <UIKit/UIKit.h>
#import "JHPostDetailEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailModel;

@interface JHPostDetailToolBar : UIView

@property (nonatomic, copy) void(^actionBlock)(JHPostDetailActionType actionType);

@property (nonatomic, strong) JHPostDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
