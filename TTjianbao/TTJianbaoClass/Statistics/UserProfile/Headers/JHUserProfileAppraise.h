//
//  JHUserProfileAppraise.h
//  TTjianbao
//  Description:鉴定
//  Created by Jesse on 2020/9/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#ifndef JHUserProfileAppraise_h
#define JHUserProfileAppraise_h

#pragma mark -------- 鉴定直播间 begin --------

//MARK: # 鉴定直播间
#define kUPEventTypeIdentifyHomeBrowse @"identification_home_browse" //<在线鉴定>首页停留时长
#define kUPEventTypeIdentifyHomeEntrance @"identification_home_entrance" //在线鉴定首页进入事件
#define kUPEventTypeIdentifyVideoListBrowse @"identification_video_list_browse" //鉴定视频列表页停留时长
#define kUPEventTypeIdentifyLiveRoomBrowse @"identification_live_room_browse" //鉴定直播间停留时长
#define kUPEventTypeIdentifyTopBannerBrowse @"identification_top_banner_browse" //在线鉴定banner活动页停留时长
#define kUPEventTypeIdentifyVideoDetailBrowse @"identification_video_detail_browse" //鉴定视频详情页停留时长
#define kUPEventTypeIdentifyChooseListBrowse @"identification_choose_list_browse" //选择鉴定师列表页停留时长
#define kUPEventTypeIdentifyLiveRoomEntrance @"identification_live_room_entrance" //鉴定直播间进入事件

///鉴定直播间发言
#define kUPEventTypeIdentifyLiveRoomSpeak @"speak_identification_live_room"

#pragma mark -------- 鉴定直播间 end --------





#pragma mark -------- 卖场直播间 begin --------

///卖场直播间发言
#define kUPEventTypeShoppingLiveRoomSpeak @"speak_shopping_live_room"

///回血直播间发言
#define kUPEventTypeReSaleLiveRoomSpeak @"speak_payback_live_room"

///直播间飞单
#define kUPEventTypeReSaleLiveRoomSendOrder @"pay_order_status"

///回血直播间详情停留时长
#define kUPEventTypePayBackLiveRoomDetailBrowse @"payback_live_room_detail_browse"

///原石回血直播间进入
#define kUPEventTypeResalLiveRoomDetailEntrance @"payback_live_room_entrance"

#pragma mark -------- 卖场直播间 end --------





#endif /* JHUserProfileAppraise_h */
