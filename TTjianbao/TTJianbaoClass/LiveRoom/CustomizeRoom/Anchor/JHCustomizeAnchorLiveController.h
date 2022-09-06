//
//  JHCustomizeAnchorLiveController.h
//  NIM
//  Description:定制直播间<主播端
//  Created by chris on 15/12/16.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomHeader.h"

@interface JHCustomizeAnchorLiveController : JHBaseViewController

@property (nonatomic, assign) JHAnchorLiveType anchorLiveType;
@property (nonatomic, assign) NIMVideoOrientation orientation;
@property (nonatomic, strong) ChannelMode *channel;
@property (nonatomic ,strong ) NTESFiterStatusModel *filterModel;
@property (nonatomic, strong) NSMutableDictionary *sendedReporterList;

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom currentMeeting:(NIMNetCallMeeting*)currentMeeting capture:(NTESMediaCapture*)capture delegate:(id<JHNormalLiveControllerDelegate>)delegate;

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom;

@end

