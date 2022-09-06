//
//  JHPostDetailViewController.h
//  TTjianbao
//
//  Created by lihui on 2020/8/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 社区 - 长文章帖子详情页

#import "JHBasePostDetailController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPostDetailViewController : JHBasePostDetailController

/// 动态-20，帖子长文章-30，短视频-40
@property (nonatomic, assign) JHPostItemType itemType;

///帖子 ID
@property (nonatomic, copy) NSString *itemId;

///来源
@property (nonatomic, copy) NSString *pageFrom;


@end

NS_ASSUME_NONNULL_END
