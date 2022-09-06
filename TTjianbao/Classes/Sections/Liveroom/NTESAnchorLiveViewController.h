//
//  NTESAnchorLiveViewController.h
//  NIM
//  Description:鉴定直播间
//  Created by chris on 15/12/16.
//  Copyright © 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomHeader.h"

@class ChannelMode;


@interface NTESAnchorLiveViewController : JHBaseViewController

@property (nonatomic) NIMVideoOrientation orientation;

@property (nonatomic, strong) ChannelMode *channel;

@property (nonatomic ,strong ) NTESFiterStatusModel *filterModel;
@property (nonatomic, strong) NSMutableDictionary *sendedReporterList;


- (instancetype)initWithChatroom:(NIMChatroom *)chatroom currentMeeting:(NIMNetCallMeeting*)currentMeeting capture:(NTESMediaCapture*)capture delegate:(id<JHNormalLiveControllerDelegate>)delegate;

- (instancetype)initWithChatroom:(NIMChatroom *)chatroom;


/**
 0 直播鉴定 1 直播卖货
 */
@property (nonatomic, assign) NSInteger type;


@end

