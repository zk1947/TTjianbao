//
//  JHRecycleInfoHeader.h
//  TTjianbao
//
//  Created by user on 2021/4/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN


//static const CGFloat kHeightOfCommonHeader = 359.f;//400.f;间距变小
static const CGFloat kHeightOfCommonHeader = 344.f;//400.f;间距变小

static NSString *_Nonnull const kChangeRecycleHeaderHeightNotification = @"kChangeRecycleHeaderHeightNotification";

@class JHUserInfoModel;
@class JHLiveRoomModel;

typedef NS_ENUM(NSInteger, JHRecycleInfoType) {
    JHRecycleInfoType_None,
    /// 店铺和直播间入口
    JHRecycleInfoType_ShopAndLiveRoom = 0,
    /// 回收师介绍
    JHRecycleInfoType_Introducation,
    /// 回收类别
    JHRecycleInfoType_RecycleCagetory
};

@interface JHRecycleInfoHeader : BaseView

/// 直播间信息
@property (nonatomic, strong) JHLiveRoomModel *roomInfo;
/// section的类型
@property (nonatomic, assign) JHRecycleInfoType infoType;
/// 关注按钮点击时间回调 isUser:判断是否为本人
@property (nonatomic, copy) void(^followBlock)(BOOL isFollow);
/// 刷新数据
@property (nonatomic, copy) void(^updateBlock)(void);
/// 点击头像
@property (nonatomic, copy) void(^iconActionBlock)(void);

@property (nonatomic, strong) UIImage  *userIcon;
@property (nonatomic,   copy) NSString *userName;
@property (nonatomic,   copy) NSString *userDesc;

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;

@end

NS_ASSUME_NONNULL_END
