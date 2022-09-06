//
//  JHAnchorLiveRoomInfoView.h
//  TTjianbao
//  Description:直播间左侧>直播介绍+主播介绍
//  Created by jesee on 19/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAnchorLiveRoomInfoView : UIView

- (void)refreshViewWithChannelLocalId:(NSString*)channelLocalId roleType:(NSInteger)type;
@end

NS_ASSUME_NONNULL_END
