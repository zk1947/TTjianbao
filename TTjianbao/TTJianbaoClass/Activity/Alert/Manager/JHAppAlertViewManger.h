//
//  JHAppAlertViewManger.h
//  TTjianbao
//
//  Created by apple on 2020/5/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHAppAlertModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface JHAppAlertViewManger : NSObject

/// APP当前位置
+ (void)appCurrentLocalHomePage:(JHAppAlertLocalType)homePage;

/// 弹框显示状态
+ (void)appAlertshowing:(BOOL)appAlertshowing;

/// 是否禁止展示弹窗 
+ (void)forbidShowAlert:(BOOL)forbidShowAlert;

/// 访客是不是在连麦中
+ (void)isLinking:(BOOL)isLinking;

/// 当前的直播间
+ (void)channelLocalId:(NSString *)channelLocalId;

/// 添加弹框去重集合
+ (void)addRedPacketWithId:(NSString *)redPacketId;

///根据服务端消息 去除过期红包
+ (void)cancleShowRedPacketWithModelArray:(NSArray<JHAppAlertModel *> *)modelArray;

/// 添加弹框
+ (void)addModelArray:(NSArray <JHAppAlertModel *> *)array;

/// 优先级排序
+ (void)getAlertSort;

///变为可以继续展示的状态
+ (void)switchSuperRedPacketAppear:(BOOL)appear;

/// 在view上显示入口
+ (void)showSuperRedPacketEnterWithSuperView:(UIView *)sender;

///变为可以继续展示的状态
+ (void)publishChangeTimeIntervalStatus;

/// 设置小框位置
+ (void)setShowSuperRedPacketEnterWithTop:(CGFloat)top;

/// 设置小框位置
+ (void)setShowSuperRedPacketEnterWithLeft:(CGFloat)left;

/// 获取当前小框位置
+ (CGRect)getShowSuperRedPacketEnterRect;

@end

NS_ASSUME_NONNULL_END
