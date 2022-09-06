//
//  JHMessage.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSAttributedString+YYText.h"
#import "JHIMHeader.h"
#import "JHChatGoodsInfoModel.h"
#import "JHChatOrderInfoModel.h"
#import <Photos/Photos.h>
#import "JHChatCustomDateModel.h"
#import "JHChatUserInfo.h"
#import "JHChatUserManager.h"
#import "JHChatCouponInfoModel.h"
#import "JHChatCustomTipModel.h"

typedef enum : NSUInteger {
    JHMessageSenderTypeMe,
    JHMessageSenderTypeOther,
} JHMessageSenderType;

typedef enum : NSUInteger {
    /// 文本消息
    JHMessageTypeText,
    /// 时间消息
    JHMessageTypeDate,
    /// 图片消息
    JHMessageTypeImage,
    /// 音频消息
    JHMessageTypeAudio,
    /// 视频消息
    JHMessageTypeVideo,
    /// 商品消息
    JHMessageTypeGoods,
    /// 订单消息
    JHMessageTypeOrder,
    /// 优惠券消息
    JHMessageTypeCoupon,
    /// 撤回消息
    JHMessageTypeRevoke,
    /// 提示消息
    JHMessageTypeTip,
    /// 自定义提示消息
    JHMessageTypeCustomTip,
    /// 未知消息
    JHMessageTypeUnknown = 1000,
} JHMessageType;
typedef enum : NSUInteger {
    JHMessageSendStateFail = 0,
    JHMessageSendStateSending = 1,
    JHMessageSendStateSuccess = 2,
    JHMessageSendStateBlack = 3,
} JHMessageSendState;

NS_ASSUME_NONNULL_BEGIN
@interface JHMessage : NSObject
/// 发送者类型
@property (nonatomic, assign) JHMessageSenderType senderType;
/// 消息类型
@property (nonatomic, assign) JHMessageType messageType;
/// 发送状态
@property (nonatomic, assign) JHMessageSendState sendState;

@property (nonatomic, strong) NIMMessage *message;

@property (nonatomic, strong) JHChatUserInfo *userInfo;

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) NSAttributedString *attText;

@property (nonatomic, assign) BOOL isRemoteRead;
/// 是否可以再次编辑
@property (nonatomic, assign) BOOL isEdit;
/// 远端 图片、视频、音频地址
@property (nonatomic, copy) NSString *imageUrl;
/// 远端视频、音频地址
@property (nonatomic, copy) NSString *mediaUrl;
/// 缩略图
@property (nonatomic, strong) UIImage *thumImage;
/// 原图
@property (nonatomic, strong) UIImage *image;
/// 缩略图url
@property (nonatomic, copy) NSString *thumUrl;
/// 商品消息
@property (nonatomic, strong) JHChatGoodsInfoModel *goodsInfo;
/// 订单消息
@property (nonatomic, strong) JHChatOrderInfoModel *orderInfo;
/// 优惠券信息
@property (nonatomic, strong) JHChatCouponInfoModel *couponInfo;
/// 日期消息
@property (nonatomic, copy) NSString *dateStr;
/// 自定义tip 信息
@property (nonatomic, strong) JHChatCustomTipInfo *customTipInfo;
/// 点击链接
@property (nonatomic, strong) RACSubject *clickLinksEvent;

@property (nonatomic, assign) BOOL isSelected;

- (instancetype)initWithMessage : (NIMMessage *)message;
- (instancetype)initWithDate : (NSString *)date;
- (instancetype)initWithText : (NSString *)text;
- (instancetype)initWithImage : (UIImage *)image thumImage : (UIImage *)thumImage;
- (instancetype)initWithVideo : (NSString *)url thumImage : (UIImage *)thumImage;
- (instancetype)initWithAudioUrl : (NSString *)url duration : (NSInteger)duration;
/// 商品消息
- (instancetype)initWithGoods : (JHChatGoodsInfoModel *)goodsInfo;
/// 订单消息
- (instancetype)initWithOrder : (JHChatOrderInfoModel *)orderInfo;
/// 优惠券消息
- (instancetype)initWithCoupon : (JHChatCouponInfoModel *)couponInfo;
- (instancetype)initRevokeMessage : (NSString *)msg text : (NSString *)text isEdit : (BOOL)isEdit;
- (instancetype)initTipMessage : (NSString *)msg senderType :(JHMessageSenderType)senderType;
/// 自定义提示消息
- (instancetype)initCustomTipMessage : (NSString *)senderTip receiverTip : (NSString *)receiverTip type : (JHChatCustomTipType)type;
/// 自定义提示消息- 带push
- (instancetype)initCustomTipApnsMessage : (NSString *)senderTip receiverTip : (NSString *)receiverTip type : (JHChatCustomTipType)type;
@end

NS_ASSUME_NONNULL_END
