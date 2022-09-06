//
//  JHNewUserRedPacketAlertView.h
//  TTjianbao
//  新人红包弹框
//  Created by wangjianios on 2021/1/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAPPAlertBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewUserRedPacketAlertViewSubModel : NSObject

/// 要展示的图片
@property (nonatomic, copy) NSString *img;

/// 要跳转的URL
@property (nonatomic, copy) NSString *url;

/// 按钮文案
@property (nonatomic, copy) NSString *btn;

@end

@interface JHNewUserRedPacketAlertViewModel : NSObject

/// 是否展示弹窗
@property (nonatomic, assign) BOOL show;

/// 弹框标题
@property (nonatomic, copy) NSString *title;

/// 未领取状态
@property (nonatomic, strong) JHNewUserRedPacketAlertViewSubModel *noReceive;

/// 已领取状态
@property (nonatomic, strong) JHNewUserRedPacketAlertViewSubModel *received;

/// 入口banner
@property (nonatomic, strong) JHNewUserRedPacketAlertViewSubModel *banner;

@end

/// 新人红包弹框
@interface JHNewUserRedPacketAlertView : JHAPPAlertBaseView

+ (void)showAlertViewWithModel:(JHNewUserRedPacketAlertViewModel *)model;

/// 弹框
+ (void)getNewUserRedPacketAlertView;

/// location 新人红包入口   1：源头直购-首页      2：源头直购-商城
+ (void)getNewUserRedPacketEntranceWithLocation:(NSInteger)location complete:(void (^) (JHNewUserRedPacketAlertViewModel * __nullable model))complete;

@end

NS_ASSUME_NONNULL_END

