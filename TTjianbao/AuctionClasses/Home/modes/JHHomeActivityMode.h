//
//  JHHomeActivityMode.h
//  TTjianbao
//
//  Created by jiang on 2019/10/23.
//  Copyright © 2019 Netease. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BannerMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHHomeActivityInfoMode : NSObject
@property (strong, nonatomic)NSString *imgUrl;//图标地址
@property (strong, nonatomic)TargetModel *target;
//@property (strong, nonatomic)TargetModel *iosTarget;
@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface JHHomeTipMode : NSObject
@property (strong, nonatomic)NSString *html;//要打开的页面地址(在首页弹窗)
@end

@interface LiveRoomTip : JHResponseModel
@property (strong, nonatomic)NSString *html;
@property (strong, nonatomic)NSString *Id;

@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface JHHomeActivityMode : NSObject

@property (strong, nonatomic)NSString *padageComerId;//新人礼id，领取过传空
@property (strong, nonatomic)JHHomeTipMode *homeTip;
@property (strong, nonatomic)JHHomeActivityInfoMode *homeActivityIcon;
@property (strong, nonatomic)LiveRoomTip *roomTip;
@property (assign, nonatomic)NSInteger showRefund;

/// 周年礼包 0关   1开 （登录状态的)
@property (nonatomic, assign) NSInteger zhouNianTip;

/// 周年活动 0关   1开（未开始已经结束是 0）
@property (nonatomic, assign) NSInteger isZhouNianBegin;
@end

NS_ASSUME_NONNULL_END
