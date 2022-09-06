//
//  JHAnchorCommentListController.h
//  TTjianbao
//
//  Created by lihui on 2020/7/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///主播个人主页 - 个人介绍页 评价列表

#import "YDBaseViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@class ChannelMode;

@interface JHAnchorCommentListController : YDBaseViewController <JXPagerViewListViewDelegate>

///直播间信息
@property (nonatomic, strong) ChannelMode *channel;
///主播id
@property (nonatomic, copy) NSString *anchorId;
///直播间id
@property (nonatomic, copy) NSString *roomId;

@end

NS_ASSUME_NONNULL_END
