//
//  JHTopicDetailController.h
//  TTjianbao
//  话题详情
//  Created by wangjianios on 2020/8/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHTopicDetailController : JHBaseViewController

/// 话题ID
@property (nonatomic, copy) NSString *topicId;
@property (nonatomic, copy) NSString *pageFrom;
/**是否支持进入帖子详情*/
@property (nonatomic, assign) BOOL supportEnterVideo;

@end

NS_ASSUME_NONNULL_END


