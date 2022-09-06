//
//  JHSessionManager.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHChatManager.h"
#import "JHIMLoginManager.h"
#import "JHChatMediaModel.h"
#import "AVAsset+NIMKit.h"
#import "JHChatMenuItemModel.h"
#import "JHChatUserInfo.h"
#import "JHIMQuickModel.h"
#import "JHChatCouponInfoModel.h"
#import "JHChatEvaluationModel.h"

NS_ASSUME_NONNULL_BEGIN
static NSInteger const TimeInterval = 5 * 60;

typedef void(^CanSendMessageHandler)(BOOL isCan);
@protocol JHSessionManagerDelegate <NSObject>

- (void)insertManagerWithIndex : (NSInteger) index;
- (void)reloadAllDatas;
- (void)reloadMoreDatasWithScrollIndex : (NSInteger)index;
- (void)audioDidStartPlay;
- (void)audioDidPlayCompleted;
- (void)reloadCell : (NSUInteger)index;
@end

@interface JHSessionManager : NSObject

@property (nonatomic, assign) JHIMSourceType sourceType;
/// 本人accID
@property (nonatomic, copy) NSString *myAccount;
/// 对方accID
@property (nonatomic, copy) NSString *receiveAccount;
/// 本人用户信息
@property (nonatomic, strong) JHChatUserInfo *userInfo;
/// 对方用户信息
@property (nonatomic, strong) JHChatUserInfo *receiveUserInfo;
/// 聊天管理
@property (nonatomic, strong) JHChatManager *chatManager;

/// 商品信息
@property (nonatomic, strong) JHChatGoodsInfoModel *goodsInfo;
/// 订单信息
@property (nonatomic, strong) JHChatOrderInfoModel *orderInfo;

@property (nonatomic, weak) id<JHSessionManagerDelegate> delegate;
/// 更多列表数据
@property (nonatomic, strong) NSArray<JHChatMediaModel *> *mediaList;
/// 快捷回复数据
@property (nonatomic, strong) NSArray<JHIMQuickModel *> *quickInfoList;
/// 优惠券信息
@property (nonatomic, strong) NSArray<JHChatCouponInfoModel *> *couponDataSource;
/// 显示警告视图
@property (nonatomic, strong) RACReplaySubject *showWarningView;
/// 刷新视图
@property (nonatomic, strong) RACSubject *reloadDataSubject;
@property (nonatomic, strong) RACSubject *showUnReadSubject;
@property (nonatomic, strong) RACSubject <NSString *> *toastSubject;
/// 操作消息
@property (nonatomic, strong) RACSubject<JHChatCustomTipInfo *> *eventSubject;

@property (nonatomic, strong) RACSubject<NSDictionary *> *pushEventSubject;
@property (nonatomic, assign) NSInteger canSendNewCustomMessage;

- (void)startSessionWithReceiveAccount : (NSString *)receiveAccount;
/// 获取所有 图片、视频消息-可预览
- (NSArray *)getAllBrowserMessage;
/// 获取该消息的操作项-复制、删除等
- (NSArray<JHChatMenuItemModel *> *)getItemModelsWithMessage : (JHMessage *)message;

- (BOOL)canInsertTipMessage;
- (void)showWaringView;
- (NSTimeInterval)getNowDateInterval;
/// 设置警告框已展示
- (void)setWaringHiden;

/// 发送商品信息
- (void)sendGoodsMessage;
- (void)sendMessageWithGoods : (JHChatGoodsInfoModel *)goodsInfo;
/// 发送订单消息
- (void)sendMessageWithOrder : (JHChatOrderInfoModel *)orderInfo;
/// 发送优惠券
- (void)sendCouponMessage : (NSArray<JHChatCouponInfoModel *> *)coupons;
- (void)resendMessage : (JHMessage *)message;
/// 插入tip  消息
- (void)insertTipMessageWithText : (NSString *)text;
/// 评价
- (void)evaluationWithModel : (JHChatEvaluationModel *)model;
- (void)canEvaluation : (void(^)(BOOL canEvaluation))handler;
/// 商家发送评价
- (void)businessSendEvaluation;
/// 点击消息
- (void)didClickMessage : (JHMessage *)message;
- (void)canSendMessage : (CanSendMessageHandler)handler;
@end

NS_ASSUME_NONNULL_END
