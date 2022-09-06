//
//  ChannelMode.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/10.
//  Copyright © 2018 Netease. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface OrderTypeModel : JHResponseModel
@property (copy,nonatomic)NSString *Id;//":"giftOrder",
@property (copy,nonatomic)NSString *name;//":"赠品订单"
@end


@interface ShanGouInfo : NSObject

@property (copy,nonatomic)NSString *Id;
@property (copy,nonatomic)NSString *name;
@property (assign,nonatomic)NSInteger sort;

@end

@interface ChannelMode : NSObject
@property (strong,nonatomic)NSString* channelId;
@property (strong,nonatomic)NSString * pushUrl;
@property (strong,nonatomic)NSString* httpPullUrl;
@property (strong,nonatomic)NSString * hlsPullUrl;
@property (strong,nonatomic)NSString* rtmpPullUrl;
@property (strong,nonatomic)NSString* roomId;
@property (strong,nonatomic)NSString * roomExt;
@property (strong,nonatomic)NSString * creatorId;
@property (strong,nonatomic)NSString * meetingName;
@property (strong,nonatomic)NSString * anchorName;
@property (strong,nonatomic)NSString * anchorIcon;
@property (strong,nonatomic)NSString * status;
@property (strong,nonatomic)NSArray * roomAddrs;
@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString * coverImg;
//主播id
@property (strong,nonatomic)NSString * anchorId;
@property (strong,nonatomic)NSString * channelLocalId;
@property (strong,nonatomic)NSString * lastVideoUrl;
@property (assign,nonatomic)NSInteger watchTotal;
@property (assign,nonatomic)NSInteger isAssistant;//是否助理
@property (assign,nonatomic)NSInteger bought;
@property (strong,nonatomic)NSString *currentRecordId;
@property (nonatomic, assign) long liveStartTime;
@property (nonatomic, assign) long startShowTime;
@property (assign,nonatomic)NSInteger canAppraise; //是否可以鉴定
@property (assign,nonatomic)NSInteger likeCount;
@property (assign,nonatomic)NSInteger isFollow;
@property (copy,nonatomic)NSString *orderCommentCount;
//卖场sell 鉴定appraise
@property (copy,nonatomic)NSString *channelType;
@property (assign,nonatomic)NSInteger canAuction;

//JHRoomTypeName
@property (copy,nonatomic)NSString *channelCategory;//channelCategory有个直播间品类，normal("常规直播间"),roughOrder("原石直播间") ,restoreStone(回血直播间)  processingOrder("加工服务直播间") daiGouOrder("代购直播间")

/// 是否被禁言 1被禁言
@property (nonatomic, assign)int isMutedInRoom;
@property (strong,nonatomic)NSArray<OrderTypeModel *> *categories;
//！ 直播间公告地址
@property (nonatomic, copy) NSString *roomNoticeUrl;

@property (nonatomic, assign) int canSendLivingTip;//是否可发送开播提醒 0否，1是
@property (nonatomic, copy) NSString *buyGuideShow;  //购物攻略样式突出显示
@property (nonatomic, assign) NSInteger boughtOther;   //是否有其他直播间购买记录

///自定义属性
@property (nonatomic, copy) NSString *first_channel;  //直播间一级分类
@property (nonatomic, copy) NSString *second_channel;  //直播间二级分类

//粉丝团属性
@property (nonatomic, assign) BOOL isOpen;  //是否开通粉丝团，1是，0否
@property (nonatomic, copy) NSString *fansClubId;  //粉丝团id
@property (nonatomic, copy) NSString *fansClubName;  //粉丝团名称
@property (nonatomic, assign) BOOL specialEffectFlag;  //特效标识，0无，1有
@property (nonatomic, assign) BOOL joinFlag; //"加入粉丝团标识，0无，1有"

@property (nonatomic, assign) NSInteger fansClubStatus; //"粉丝团状态，0正常，1挂起"

//用户粉丝牌级别
@property (assign,nonatomic)NSString *userLevelType;
//用户粉丝牌名字
@property (copy,nonatomic)NSString *userLevelName;
//用户粉丝牌
@property (copy,nonatomic)NSString *levelImg;

@property (nonatomic, assign) NSInteger awaitNum;//待回收数量

@property (nonatomic, assign) NSInteger recycleWaitOfferCount; // 回收主播端回收待确认
@property (nonatomic, assign) NSInteger recycleWaitPayCount;//回收主播端回收待出价


@property (copy,nonatomic)NSString *canFlashPurchase;

@property (copy,nonatomic) NSArray <ShanGouInfo*> *flashCategories;

@property (nonatomic, assign) BOOL showBlessingBag; //是否展示商家福袋，false不展示，true展示
 
@end

@interface StoneChannelMode : NSObject
@property (strong,nonatomic)NSString* channelCategory;
@property (strong,nonatomic)NSString* channelId;
@property (assign,nonatomic)NSInteger channelStatus;
@property (strong,nonatomic)NSString * rtmpPullUrl;
@property (assign ,nonatomic)NSUInteger saleCount;
@property (assign ,nonatomic)NSUInteger seekCount;//求看人数
@property (assign ,nonatomic)NSUInteger orderCount;
@property (copy,nonatomic)NSString* totalPrice;

@end
