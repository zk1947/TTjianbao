//
//  JHBuryPointOperator.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/26.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMengManager.h"
NS_ASSUME_NONNULL_BEGIN

@class JHBuryPointShareModel;
@class JHBuryPointLiveInfoModel;
@class JHBuryPointVideoInfoModel;
@class JHBuryPointEnterBuyGoods;
@class JHBuryPointDiscoverDetailInfoModel;
@class JHBuryPointCommunityArticleModel;//用于统计
@class JHBuryPointEnterTopicDetailModel; //进入话题页
@class JHBuryPointStoreGoodsDetailBrowseModel;  //商品详情页面浏览（开始/结束）
@class JHBuryPointStoreGoodsListBrowseModel;  //浏览商城商品item

@interface JHBuryPointOperator : NSObject
+ (JHBuryPointOperator *)shareInstance;

- (void)buryWithEtype:(NSString *)eType param:(id)param;

+ (void)buryWithEventId:(NSString *)eventId param:(id)param;

- (void)devInBury;
- (void)devOutBury;
- (void)userLogoutBury;
- (void)shareBuryWithModel:(JHBuryPointShareModel *)model;
- (void)liveOutBuryWithModel:(JHBuryPointLiveInfoModel *)model;
- (void)liveInBuryWithModel:(JHBuryPointLiveInfoModel *)model;
- (void)videoInBuryWithModel:(JHBuryPointVideoInfoModel *)model;
- (void)videoOutBuryWithModel:(JHBuryPointVideoInfoModel *)model;
//- (void)liveLikeBuryWithModel:(JHBuryPointLiveInfoModel *)model;
- (void)liveLikeBuryWithModel:(JHBuryPointLiveInfoModel *)model isDouble:(BOOL)isDouble;//是否双击
//开始播放视频
- (void)discoverDetailInBuryWithModel:(JHBuryPointDiscoverDetailInfoModel *)model;
//结束播放视频
- (void)discoverDetailOutBuryWithModel:(JHBuryPointDiscoverDetailInfoModel *)model;
- (void)discoverEnterBuyGoodsQyWithModel:(JHBuryPointEnterBuyGoods *)model;

//进入话题页统计
- (void)enterTopicDetailWithModel:(JHBuryPointEnterTopicDetailModel *)model;

//直播观看上报
- (void)viewTimeWithChannelLocalId:(NSString *)Id type:(NSInteger)type bz_val:(NSInteger)bz_val;

//app启动
- (void)appStartBury;

///商城相关统计
///商城商品详情开始浏览
- (void)beginBrowseStoreGoodsDetail:(JHBuryPointStoreGoodsDetailBrowseModel *)model;
///商城商品详情结束浏览
- (void)endBrowseStoreGoodsDetail:(JHBuryPointStoreGoodsDetailBrowseModel *)model;
///商城商品列表Item浏览
- (void)browseStoreGoodsList:(JHBuryPointStoreGoodsListBrowseModel *)model;


@end


@interface JHBuryPointModel : NSObject
@property(nonatomic, copy)NSString *ver;//”1.0”,//协议版本
@property(nonatomic, copy)NSString *app_ver;//”xxxxx”,//app版本
@property(nonatomic, copy)NSString *uid;//12342,
@property(nonatomic, copy)NSString *duid;//”xxxxxxxxx”,//设备唯一ID
@property(nonatomic, copy)NSString *platform;//”xxxxx”,//平台，Android、ios
@property(nonatomic, assign)NSTimeInterval c_time;//1232434234，//毫秒时间戳
@property(nonatomic, copy)NSString *e_type;//”xxxxx”,//事件类型
@property(nonatomic, copy)NSDictionary *e_info;//{}，//事件信息【对象类型】
@end


@interface JHBuryPointLoginModel : NSObject

@property(nonatomic, copy)NSString *brand;//”xxxx”,//品牌
@property(nonatomic, copy)NSString *model;//”xxxx”,机型
@property(nonatomic, copy)NSString *os_ver;//”xxxx”,//操作系统版本
@property(nonatomic, copy)NSString *app_ver;//”xxxx”,//app版本
@property(nonatomic, copy)NSString *channel;//”xxxx”,//渠道
@property(nonatomic, copy)NSString *platform;//”xxxx”,//平台，Android、ios
@property(nonatomic, assign)NSInteger is_new;//”1”,//是否是新设备，0、1
@property(nonatomic, copy)NSString *reyun_id;//热云id
@property(nonatomic, copy)NSString *idfa;//广告id


@end


@interface JHBuryPointShareModel : NSObject

@property(nonatomic, copy)NSString *from;//”xxxx”,//来源，如首页、直播、主播页等
@property(nonatomic, copy)NSString *to;//”xxxx”,//分享渠道，如微信、qq
@property(nonatomic, assign)NSInteger to_type;//”xxxx”,//朋友圈、朋友
@property(nonatomic, assign)NSInteger object_type;//”xxxx”,//分享对象类型，如直播、回放、主播
@property(nonatomic, copy)NSString *object_flag;//”xxxx”,//分享对象标识符，如ID、活动名称

@end

@interface JHBuryPointLiveInfoModel : NSObject

@property(nonatomic, copy)NSString *anchor_id;//23234234,//主播ID
@property(nonatomic, copy)NSString *room_id;//2342423,//房间ID
@property(nonatomic, copy)NSString *live_id;//33234234,//直播ID
@property(nonatomic, copy)NSString *channel_local_id;
@property(nonatomic, copy)NSString *from; //视频来源 4-社区首页列表
/**
 直播类型 1鉴定 2卖货
 */
@property(nonatomic, assign)NSInteger live_type;//1,//

@property(nonatomic, assign)NSTimeInterval time;//423423423,//进入直播间时间，毫秒

@end



@interface JHBuryPointVideoInfoModel : NSObject
@property(nonatomic, copy)NSString *video_id;//23234234,//视频
@property(nonatomic, assign)NSInteger video_type;//1,视频类别 1鉴定视频 2验货视频 3鉴定视频2列表 4社区
@property(nonatomic, copy)NSString *anchor_id;//23234234,//主播ID
@property(nonatomic, copy)NSString *room_id;//2342423,//房间ID
@property(nonatomic, copy)NSString *live_id;//33234234,//直播ID
@property(nonatomic, assign)NSInteger live_type;//1,//直播类型 1鉴定 2卖货
@property(nonatomic, copy)NSString *from;// 后面类型已废弃//视频来源 1排行榜 2鉴定记录 3订单，4首页社区列表
@property(nonatomic, assign)NSInteger time;//423423423,//播放开始时间，毫秒

@property(nonatomic, copy)NSString *playOver;//是否播放完成 True False

@property(nonatomic, assign)NSInteger videoDuration;//视频时间毫秒

/// 停留时长
@property(nonatomic, assign)NSInteger duration;

@end


@interface JHBuryPointDiscoverDetailInfoModel : NSObject

@property(nonatomic, assign) NSInteger entry_type;
@property(nonatomic, copy) NSString *entry_id;
@property(nonatomic, assign) NSInteger item_type;
@property(nonatomic, strong) NSString *item_id;
@property(nonatomic, strong) NSString *time;
@property (nonatomic, assign) NSInteger resource_type;//layout
@property(nonatomic, strong) NSString *request_id;//uuid

@end

@interface JHBuryPointEnterBuyGoods: NSObject
@property(nonatomic, assign) NSInteger entry_type;
@property(nonatomic, copy) NSString *entry_id;
@property(nonatomic, assign) NSInteger item_type;
@property(nonatomic, strong) NSString *item_id;
@property(nonatomic, strong) NSString *time;
@end

@interface JHBuryPointCommunityArticleModel : NSObject
@property(nonatomic, assign) NSInteger entry_type;
@property(nonatomic, copy) NSString *entry_id;
@property(nonatomic, strong) NSString *item_ids;
@property(nonatomic, strong) NSString *time;
@end

//话题首页类型
@interface JHBuryPointEnterTopicDetailModel : NSObject
@property (nonatomic,   copy) NSString *entry_id;
@property (nonatomic, assign) NSInteger entry_type;
@property (nonatomic,   copy) NSString *topic_id; //item_id
@property (nonatomic, assign) long long time; //进入时间
@end

//商城-商品详情页浏览统计
/*!
* entry_id：指定entry_type对应的入口ID
* 商城首页下面的列表商品点击传分类的id
* 商城首页横滑的橱窗列表商品点击传橱窗id
* 专题列表商品传专题id
* 店铺列表商品传店铺id
*/
@interface JHBuryPointStoreGoodsDetailBrowseModel : NSObject
@property (nonatomic, copy) NSString *entry_type; //页面来源
@property (nonatomic, copy) NSString *entry_id;
@property (nonatomic, copy) NSString *item_id;          //item_id
@property (nonatomic, copy) NSString *item_type;        //对象类型
@property (nonatomic, copy) NSString *resource_type;    //布局方式
@property (nonatomic, copy) NSString *request_id;

@end

@interface JHBuryPointStoreGoodsListBrowseModel : NSObject
@property (nonatomic, copy) NSString *entry_type;
@property (nonatomic, copy) NSString *entry_id;
@property (nonatomic, copy) NSString *item_ids; //items_id
@end


NS_ASSUME_NONNULL_END
