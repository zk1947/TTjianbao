//
//  JHLiveRoomStatus.h
//  TTjianbao
//  Description:直播间状态
//  Created by Jesse on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *JHLiveRoomType:服务端(除了sell和appraise)还有偷窥者：sell_hide \ appraise_hide
*/

///直播间>卖场
#define JHLiveRoomSell @"sell"
///直播间>鉴定
#define JHLiveRoomAppraise @"appraise"
///直播间>卖场-偷窥者
#define JHLiveRoomSellHide @"sell_hide"
///直播间>鉴定-偷窥者
#define JHLiveRoomAppraiseHide @"appraise_hide"

typedef NS_ENUM(NSInteger, JHLiveRoomType)
{
    JHLiveRoomTypeSell,
    JHLiveRoomTypeAppraise,
    JHLiveRoomTypeSellHide,
    JHLiveRoomTypeAppraiseHide
};

/**
 *直播SDK类型:普通直播 or 互动直播
 */
typedef NS_ENUM(NSInteger, JHLiveSDKType){
    JHNomalLiveSDK = 0,
    JHInteractionLiveSDK,
};

@interface JHLiveRoomStatus : NSObject

+ (BOOL)isLiveRoomType:(JHLiveRoomType)type channelType:(NSString*)channelType;
@end

