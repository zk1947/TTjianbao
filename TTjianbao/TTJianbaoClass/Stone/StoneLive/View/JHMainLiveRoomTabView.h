//
//  JHMainLiveRoomTabView.h
//  TTjianbao
//  Description:MainRoom 4 个 tab:@"最近售出", @"待上架原石", @"宝友求看",  @"宝友下架"
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSegmentPageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMainLiveRoomTabView : JHSegmentPageView
@property (nonatomic, strong) NSString* channelCategory;// (string): 直播间类型：roughOrder-原石直播间、restoreStone-回血直播间 = ['NORMAL', 'ROUGH_ORDER', 'PROCESSING_ORDER', 'DAIGOU_ORDER', 'RESTORE'],
@property (nonatomic, assign) BOOL isAssitant;
- (void)drawSubviews:(NSString*)mChannelId;
@end

NS_ASSUME_NONNULL_END
