//
//  JHMaskingManager.h
//  TTjianbao
//
//  Created by LiHui on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JHStoreNewRedpacketModel;
typedef NS_ENUM(NSInteger, JHMaskPopWindowType) {
    ///新人优惠券
    JHMaskPopWindowTypeRedbag = 1,
    ///新人礼物
    JHMaskPopWindowTypeGift = 2,
};

@interface JHMaskingManager : NSObject

///弹窗类型
@property (nonatomic, assign) JHMaskPopWindowType windowType;


+ (instancetype)shareApiManager;

- (void)dealData:(NSString *)type;

///判断是否需要显示红包
//- (void)getUserRedbagInfo:(void(^)(BOOL isNeedGrant,NSString *message))block;
///判断是否需要显示礼物
- (void)getUserGiftInfo:(void(^)(BOOL isNeedGrant,NSString *message))block;

///发放红包/礼物
- (void)commitData:(NSString *)type completeBlock:(void(^)(BOOL hasError,NSString *message))completeBlock;


///显示红包弹窗
//- (void)showRedbagView;
///显示礼物弹窗
//+ (void)showGiftView;

/// 根据类型显示弹窗
/// @param type 弹窗类型
+ (void)showPopWindow:(JHMaskPopWindowType)type;
///移除弹窗
+ (void)dismissPopWindow;

/// 根据类型显示弹窗
/// @param type 弹窗类型
+ (void)showPopWindowWithType:(JHMaskPopWindowType)type;

+ (void)showNewUserRedPacketWithRedpacketModel:(JHStoreNewRedpacketModel *)model;

///移除红包的key
+ (void)removeRedPocketKey;

@end
