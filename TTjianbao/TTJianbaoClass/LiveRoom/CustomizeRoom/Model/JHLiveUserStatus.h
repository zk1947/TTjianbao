//
//  JHLiveUserStatus.h
//  TTjianbao
//  Description:直播间用户状态（主播&观众）
//  Created by Jesse on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JHAnchorLiveType){
    JHAnchorLiveAppraiseType = 0, // 鉴定主播
    JHAnchorLiveSaleType = 1,//     卖货主播  （主播端暂时用不到，只是为了和用户端保持一致 ）
    JHAnchorLiveSaleAssistantType = 2, // 卖货助理
    JHAnchorLiveCustomizeType = 9, //定制主播
    JHAnchorLiveCustomizeAssistantType = 10, //定制助理 （主播端暂时用不到，只是为了和用户端保持一致 ）
    JHAnchorLiveRecycleType = 11, //回收主播
    JHAnchorLiveRecycleAssistantType = 12, //回收助理 （主播端暂时用不到，只是为了和用户端保持一致 ）
};

typedef NS_ENUM(NSInteger, JHAudienceUserRoleType){
    JHAudienceUserRoleTypeAppraise = 0, // 鉴定观众
    JHAudienceUserRoleTypeSale = 1,// 卖货观众
    JHAudienceUserRoleTypeSaleAssistant = 2, //卖货助理
    JHAudienceUserRoleTypeCustomize= 9, // 定制观众
    JHAudienceUserRoleTypeCustomizeAssistant= 10, //定制助理
    
    JHAudienceUserRoleTypeRecycle= 11, //回收观众
    JHAudienceUserRoleTypeRecycleAssistant= 12, //回收助理
};

@interface JHLiveUserStatus : NSObject

@end

