//
//  JHLiveRoomHeader.h
//  TTjianbao
//  Description:直播间头文件
//  Created by Jesse on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef JHLiveRoomHeader_h
#define JHLiveRoomHeader_h

#import "NTESMediaCapture.h"
#import "NIMSDK/NIMSDK.h"
//自定义
#import "JHLiveRoomStatus.h"
#import "JHLiveUserStatus.h"
#import "NTESFiterStatusModel.h"

@protocol JHNormalLiveControllerDelegate <NSObject>

-(void)onCloseLiveView;
@end

#endif /* JHLiveRoomHeader_h */
