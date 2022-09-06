//
//  JHRecycleAnchorLiveController.h
//  TTjianbao
//回收直播间
//  Created by jiangchao on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomHeader.h"

@interface JHRecycleAnchorLiveController : JHBaseViewController

@property (nonatomic, assign) JHAnchorLiveType anchorLiveType;
@property (nonatomic, assign) NIMVideoOrientation orientation;
@property (nonatomic, strong) ChannelMode *channel;
@property (nonatomic ,strong ) NTESFiterStatusModel *filterModel;
@property (nonatomic, strong) NSMutableDictionary *sendedReporterList;

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom currentMeeting:(NIMNetCallMeeting*)currentMeeting capture:(NTESMediaCapture*)capture delegate:(id<JHNormalLiveControllerDelegate>)delegate;

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom;

@end

