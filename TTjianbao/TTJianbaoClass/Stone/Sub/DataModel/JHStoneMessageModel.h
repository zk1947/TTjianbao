//
//  JHStoneMessageModel.h
//  TTjianbao
//
//  Created by yaoyao on 2019/12/8.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "NIMSDK/NIMSDK.h"
#import "JHNimNotificationBody.h"
#import "JHSystemMsgAttachment.h"
#import "ChannelMode.h"
#import "JHRoomRedPacketModel.h"
#import "JHMyCenterDotModel.h"
NS_ASSUME_NONNULL_BEGIN

@class JHMainLiveSplitDetailModel;
@interface JHStoneMessageModel : JHNimNotificationBody
@property (nonatomic, assign) JHSystemMsgType type;
/**
 * 原石ID
 */
@property (nonatomic, copy) NSString *stoneId;

/**
 * 直播间类型
 */
@property (nonatomic, copy) NSString *channelCategory;

/**
 * 商品编号
 */
@property (nonatomic, copy) NSString *goodsCode;
/**
 * 商品标题
 */
@property (nonatomic, copy) NSString *goodsTitle;
/**
 * 商品图片
 */
@property (nonatomic, copy) NSString *coverUrl;

/**
 * 购入价格
 */
@property (nonatomic, copy) NSString *purchasePrice;
/**
 * 寄售价格
 */
@property (nonatomic, copy) NSString *salePrice;


/**
 * 出价id
 */
@property (nonatomic, copy) NSString *stoneRestoreOfferId;


/// 出价
@property (nonatomic, copy) NSString *offerPrice;


/**
 * 成交价格
 */
@property (nonatomic, copy) NSString *dealPrice;
/**
 * 买家，脱敏
 */
@property (nonatomic, copy) NSString *purchaseCustomerName;

/**
 * 买家头像
 */
@property (nonatomic, copy) NSString *purchaseCustomerImg;
/**
 * 货架（货位）编码
 */
@property (nonatomic, copy) NSString *depositoryLocationCode;

/// 拆单列表
@property (nonatomic, copy) NSArray<JHMainLiveSplitDetailModel *> *splitStoneList;

/**
 * 订单号 显示
 */
@property (nonatomic, copy) NSString *orderCode;

/**
 * 订单id
 */
@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) NSString *stoneRestoreId;

@property (nonatomic, copy) NSString *roomId;

@property (nonatomic, assign) NSInteger orderCount;

@property (nonatomic, assign) NSInteger explainingFlag;// 是否正在讲解，0否，1是

@property (nonatomic, copy) NSString *tips;
@end

@interface JHCustomChannelMessageModel : NSObject <NIMCustomAttachment>
@property(assign,nonatomic)JHSystemMsgType type;
@property(strong,nonatomic)StoneChannelMode *body;
@end

@interface JHCustomAlertMessageModel : NSObject <NIMCustomAttachment>
@property(assign,nonatomic)JHSystemMsgType type;
@property(strong,nonatomic)JHStoneMessageModel *body;
@end

@interface JHRedPacketMessageModel : NSObject <NIMCustomAttachment>
@property(assign,nonatomic)JHSystemMsgType type;
@property(strong,nonatomic)JHRoomRedPacketModel *body;
@end


@interface JHSystemMsgCustomizeOrder : NSObject
@property(strong,nonatomic)NSString *isBiggerThen;
@property(strong,nonatomic)NSString *customizeOrderName;
@property(strong,nonatomic)NSString *customizedFeeName;
@property(strong,nonatomic)NSString *orderId;
@property(strong,nonatomic)NSString *tip;
@property(strong,nonatomic)NSString *customizeImg;
@property(strong,nonatomic)NSString *customizeId;
@property(assign,nonatomic)BOOL showFlag;
@end
NS_ASSUME_NONNULL_END
