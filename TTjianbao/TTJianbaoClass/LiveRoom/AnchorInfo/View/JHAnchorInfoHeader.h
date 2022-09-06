//
//  JHAnchorInfoHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/7/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

@class JHLiveRoomModel;

static const CGFloat kCommonHeaderHeight = 366.f;

static NSString *_Nonnull const kChangeAnchorHeaderHeightNotification = @"kChangeAnchorHeaderHeightNotification";

@class JHUserInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHAnchorInfoHeader : BaseView

///直播间信息
@property (nonatomic, strong) JHLiveRoomModel *roomInfo;
///关注按钮点击时间回调 isUser:判断是否为本人
@property (nonatomic, copy) void(^followBlock)(BOOL isFollow);
///刷新数据
@property (nonatomic, copy) void(^updateBlock)(void);
@property (nonatomic, copy) void(^updateHeightBlock)(CGFloat height);
- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;

@end

NS_ASSUME_NONNULL_END
