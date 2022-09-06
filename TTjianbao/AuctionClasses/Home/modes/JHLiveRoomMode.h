//
//  JHLiveRoomMode.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/11.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TargetModel;

@interface JHLiveRoomMode : NSObject

@property (strong,nonatomic)NSString* status; //0：禁用； 1：空闲； 2：直播中； 3：直播录制
@property (strong,nonatomic)NSString * title;
@property (strong,nonatomic)NSString* ID;
@property (strong,nonatomic)NSString* landingId;
@property (strong,nonatomic)NSString * coverImg;
@property (strong,nonatomic)NSString* charge;
@property (strong,nonatomic)NSString* anchorIcon;
@property (strong,nonatomic)NSString * anchorId;
@property (strong,nonatomic)NSString* anchorName;
@property (strong,nonatomic)NSString* anchorTitle;
@property (strong,nonatomic)NSString * grade;
@property (strong,nonatomic)NSString* watchTotal;
@property (strong,nonatomic)NSString* watchTotalString;
@property (strong,nonatomic)NSString* location;
@property (strong,nonatomic)NSString* rtmpPullUrl;
@property (strong,nonatomic)NSString* smallCoverImg;
@property (strong,nonatomic)NSString* anchorAuthInfo;
@property (strong,nonatomic)NSArray* tags;
@property (assign,nonatomic)NSInteger canAppraise;
@property (strong,nonatomic)NSString *tagUrl;
@property (strong,nonatomic)NSString *tagContent;
@property (strong,nonatomic)NSString *activityRank;  //排名
//是否关注
@property (assign,nonatomic)BOOL isFollow;
//关注数
@property (assign,nonatomic) NSInteger recommendCount;

//回血直播间id
@property (strong,nonatomic)  NSString  *restoreChannelId;

//定制直播间
@property (nonatomic,copy)  NSString  *channelLocalId;
@property (nonatomic , assign) BOOL customizedFlag;  //是否是定制师.列表用
@property (nonatomic , assign) BOOL connectingFlag;  //连麦中
@property (nonatomic,copy)  NSString  *customizedDesc;
@property (nonatomic,copy)  NSString  *roomId;
//回收直播间
@property (nonatomic, copy) NSString  *recycleFlag;//是否回收


@property (assign,nonatomic)  BOOL  hasRedPacket;
@property (nonatomic , assign) NSInteger    title_row;// 标题显示行数
@property (nonatomic , assign) CGFloat      wh_scale; // 图片宽高比
//计算之后的高度
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat picHeight;
@property (nonatomic, assign) CGFloat titleHeight;

@property (nonatomic, copy) NSString *canCustomize;//是否支持定制：0-不支持、1-支持定制
//直播间类型
//@property (nonatomic, copy) NSString  *channelCategory;
//normal-常规直播间、roughOrder-原石直播间、processingOrder-加工服务直播间、daiGouOrder-代购直播间、restoreStone-回血直播间、customized-定制直播间',  目前用不到了

///跳转参数
@property (nonatomic, copy) NSString *landingTarget;

///自定义属性
@property (strong, nonatomic) TargetModel *target;

///类型    0：直播间   1：运营位
@property (nonatomic, assign) NSInteger type;

///运营封面图
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, copy) NSArray <NSString *>*appraiserTags;

@end

@interface JHChannelData : NSObject
@property (strong,nonatomic)NSString* appraiseTotal;
@property (strong,nonatomic)NSString * remind;
@property (strong,nonatomic)NSArray<JHLiveRoomMode*> * channels;
@end


