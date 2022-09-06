//
//  JHAnchorLiveViewController.h
//  TTjianbao
//  Description:卖场直播间>直播卖货、回血主播
//  Created by jiang on 2019/9/3.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomHeader.h"
#import "JHMediaCapture.h"

@class ChannelMode;

@interface JHNormalLiveController : JHBaseViewController

@property (nonatomic) NIMVideoOrientation orientation;

@property (nonatomic, strong) ChannelMode *channel;
@property (nonatomic ,strong ) NTESFiterStatusModel *filterModel;
@property (nonatomic, strong) NSMutableDictionary *sendedReporterList;


- (instancetype)initWithChatroom:(NIMChatroom *)chatroom currentMeeting:(NIMNetCallMeeting*)currentMeeting capture:(JHMediaCapture*)capture delegate:(id<JHNormalLiveControllerDelegate>)delegate;

/**
 0 直播鉴定 1 直播卖货
 */
@property (nonatomic, assign) NSInteger type;


@end

