//
//  JHResaleLiveRoomTabView.h
//  TTjianbao
//  Description:回血直播间：4tab-@"原石回血", @"我的回血", @"买家出价",  @"我的出价"
//  Created by Jesse on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSegmentPageView.h"
#import "JHResaleLiveRoomTabSubviewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHResaleLiveRoomTabView : JHSegmentPageView

- (void)drawSubviews:(NSString*)mChannelId action:(JHActionBlock)action;
//收缩page controller
- (void)shrinkPageviewController:(BOOL)shrink;
//刷新页面
- (void)refreshTableWithTab:(JHResaleLiveRoomTabType)type;
@end

NS_ASSUME_NONNULL_END
