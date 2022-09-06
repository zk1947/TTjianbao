//
//  JHCustomerInfoHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/9/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 定制师主页 - header部分

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

static const CGFloat kHeightOfCommonHeader = 379.f;//400.f;间距变小

static NSString *_Nonnull const kChangeCustomerHeaderHeightNotification = @"kChangeCustomerHeaderHeightNotification";

@class JHUserInfoModel;
@class JHLiveRoomModel;

typedef NS_ENUM(NSInteger, JHCustomerInfoType) {
    JHCustomerInfoTypeNone,
    /// 店铺和直播间入口
    JHCustomerInfoTypeShopAndLiveRoom = 0,
    /// 定制师介绍
    JHCustomerInfoTypeCustomerIntroducation,
    /// 代表作
    JHCustomerInfoTypeMasterpiece,
    /// 荣誉证书
    JHCustomerInfoTypeHonorCer,
    /// 定制材质
    JHCustomerInfoTypeStuffCagetory,
    /// 定制费用说明
    JHCustomerInfoTypeCustomizeFeeIntroducation
};

@interface JHCustomerInfoHeader : BaseView

///直播间信息
@property (nonatomic, strong) JHLiveRoomModel *roomInfo;
///section的类型
@property (nonatomic, assign) JHCustomerInfoType infoType;

///关注按钮点击时间回调 isUser:判断是否为本人
@property (nonatomic, copy) void(^followBlock)(BOOL isFollow);
///刷新数据
@property (nonatomic, copy) void(^updateBlock)(void);

/// 点击代表作
@property (nonatomic, copy) void(^mpActionBlock)(NSInteger index);

/// 点击荣誉证书
@property (nonatomic, copy) void(^hcActionBlock)(NSInteger index);

/// 点击头像
@property (nonatomic, copy) void(^iconActionBlock)(void);

@property (nonatomic, strong) UIImage  *userIcon;
@property (nonatomic,   copy) NSString *userName;
@property (nonatomic,   copy) NSString *userDesc;

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;

@end

NS_ASSUME_NONNULL_END
