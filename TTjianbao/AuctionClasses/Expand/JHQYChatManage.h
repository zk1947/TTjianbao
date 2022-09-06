//
//  JHQYChatManage.h
//  TTjianbao
//
//  Created by yaoyao on 2019/1/22.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYSDK.h"
#import "OrderMode.h"

@class CGoodsInfo;
@class JHMsgCenterModel;
@class CommunityArticalModel;
@class JHQYStaffInfo;

#define NotificationNameChatUnreadCountChanged @"NotificationNameChatUnreadCountChanged"
#define NotificationNameChatReceivedMessage @"NotificationNameChatReceivedMessage"

NS_ASSUME_NONNULL_BEGIN

//#define QYAppKey JHEnvVariableDefine.isTest?@"fdd795ade6386e5d64301cbc7264c7db":@"2735410ffc7e87d9e6b9e1a7dfccb0fc"

#define QYAppKey @"2735410ffc7e87d9e6b9e1a7dfccb0fc"

typedef NS_ENUM(NSInteger, JHChatSaleType) {
    JHChatSaleTypeFront = 0,//售前
    JHChatSaleTypeAfter = 1,//售后
};

///客服信息

@interface JHQYStaffInfo : NSObject
/**
 *  会话窗口标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  访客分流 分组Id
 */
@property (nonatomic, assign) int64_t groupId;

/**
 *  访客分流 客服Id
 */
@property (nonatomic, assign) int64_t staffId;

/**
 *  机器人Id
 */
@property (nonatomic, assign) int64_t robotId;

/**
 *  子商户Id
 */
@property (nonatomic, copy) NSString *shopId;

/**
*  需要默认发送一条文本消息
*/
@property (nonatomic, copy) NSString *text;

@end

@interface JHQYChatManage : NSObject <QYConversationManagerDelegate>

+ (JHQYChatManage *)shareInstance;
+ (void)setUpQY;
+ (void)logout;
+ (NSInteger)unreadMessage;
+ (JHMsgCenterModel *)getChatModel:(JHMsgCenterModel *)model;
//- (void)showPurchaseChatWithViewcontroller:(UIViewController *)vc withQYCommodityInfo: (QYCommodityInfo *__nullable)info;
//CommunityArticalModel *model

///清除单例数据
- (void)cleanData;

//联系官方客服
- (void)showChatWithViewcontroller:(UIViewController *__nullable)vc;
///联系官方客服-无groupID
- (void)showNoGroupChatWithViewcontroller:(UIViewController *)vc;
//联系平台客服（从消息中心进入）add by wuyd 2019.08.29
- (void)showPlatformChatWithViewcontroller:(UIViewController *)vc;

//联系珠宝顾问 社区
- (void)showPurchaseChatWithViewcontroller:(UIViewController *)vc withQYCommodityInfo:(CommunityArticalModel *__nullable)info;

///客服 - 显示特卖商品详情客服
- (void)showStoreChatWithViewController:(UIViewController *)vc goodsInfo:(CGoodsInfo *__nullable)goodsInfo;

- (void)showShopChatWithViewcontroller:(UIViewController *)vc orderModel:(OrderMode *)model;

- (void)showShopChatWithViewcontroller:(UIViewController *)vc anchorId:(NSString *)anchorId;

///退货退款发起申请后 进入客服
- (void)showShopChatWithViewcontroller:(UIViewController *)vc anchorId:(NSString *)anchorId defaultText:(NSString *)text;

/// 根据客服信息调取客服会话
/// @param vc vc description
/// @param info info description
/// @param model model description
- (void)showShopChatWithViewcontroller:(UIViewController *)vc staffInfo:(JHQYStaffInfo *)info orderModel:(OrderMode *)model;

/// 根据卖家用户id查询客服信息
/// @param customerId 卖家id
/// @param type 售前、售后
/// @param chatTypeResult 返回结果 staffInfo为nil 表示请求失败
+ (void)checkChatTypeWithCustomerId:(NSString *)customerId saleType:(JHChatSaleType)type completeResult:(void(^)(BOOL isShop, JHQYStaffInfo *model))chatTypeResult;

/// 根据客服信息调起客服对话框
/// 个人中心 进入子商户客服
/// @param vc vc description
/// @param staffInfo staffInfo description
- (void)showShopChatWithViewcontroller:(UIViewController *)vc shopId:(NSString *)shopId title:(NSString *)title;

/// 发送已支付订单信息
/// 个人中心 进入子商户客服
/// @param shopId 店铺id
/// @param staffInfo staffInfo description
- (void)sendTextWithViewcontroller:(UIViewController *)vc ToShop:(NSString *)shopId title:(NSString *)title andOrderId:(NSString *)orderId isPayFinish:(BOOL)isPay;


/// 获取最近客服对话列表
+ (NSMutableArray<JHMsgCenterModel *> *)getChatSessionList;


/// 根据shopId 删除最近会话
/// @param shopId shopId description
+ (void)deleteSessionWithShopId:(NSString *)shopId;

@end


NS_ASSUME_NONNULL_END
