//
//  JHLiveStoreBottomListView.h
//  TTjianbao
//
//  Created by YJ on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSegmentPageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLiveStoreBottomListView : JHSegmentPageView

@property (nonatomic, copy) dispatch_block_t removeBlock;

@property (nonatomic, copy) void (^hiddenBlock) (BOOL hidden);

//卖家列表
- (void)setViewUIConfig:(ChannelMode *)channel;
//用户列表
- (void)setViewUIConfigForUserWithChannel:(ChannelMode *)channel;

@end

NS_ASSUME_NONNULL_END
