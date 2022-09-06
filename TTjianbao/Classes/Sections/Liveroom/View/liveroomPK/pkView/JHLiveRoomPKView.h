//
//  JHLiveRoomPKView.h
//  TTjianbao
//
//  Created by apple on 2020/8/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "JHLiveBottomBar.h"
NS_ASSUME_NONNULL_BEGIN
@class ChannelMode;
typedef NS_ENUM(NSUInteger, JHLiveRoomPKViewType) {
    JHLiveRoomPKViewTypeTotal, //总榜
    JHLiveRoomPKViewTypeToday, //今日
    JHLiveRoomPKViewTypeFans,  //粉丝
};

@interface JHLiveRoomPKView : BaseView
@property (nonatomic, strong) ChannelMode *channel;
@property (nonatomic, strong) JHLiveBottomBar * bottomBar;
@property (nonatomic, copy) NSString * rankName; //埋点用
- (void)show;
- (instancetype)initWithFrame:(CGRect)frame andType:(NSInteger)type andchannelId:(NSString *)channelId;
@end

NS_ASSUME_NONNULL_END
