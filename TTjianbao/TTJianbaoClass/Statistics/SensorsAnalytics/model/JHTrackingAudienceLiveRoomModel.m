//
//  JHTrackingAudienceLiveRoomModel.m
//  TTjianbao
//
//  Created by apple on 2021/1/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHTrackingAudienceLiveRoomModel.h"

@implementation JHTrackingAudienceLiveRoomModel
-(void)transitionWithModel:(ChannelMode *)model needFollowStatus:(BOOL)isNeed {
    self.channel_id = model.channelId;
    self.channel_name = model.title;
    self.anchor_id = model.anchorId;
    self.anchor_nick_name = model.anchorName;
//    anchor_role
    self.channel_local_id = model.channelLocalId;
    self.first_channel = @[model.channelType];
    
//    if ([model.second_channel isNotBlank]) {
//        self.second_channel = @[model.second_channel];
//    }
//    first_commodity
//    second_commodity
//    third_commodity
    if (isNeed) {
        self.is_follow_anchor = (model.isFollow != 0);
    }
}
@end
