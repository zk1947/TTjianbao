//
//  JHMyCenterApiManager.h
//  TTjianbao
//
//  Created by lihui on 2020/3/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHAllowSignModel;
@interface JHMyCenterApiManager : NSObject

@property(nonatomic, strong) JHAllowSignModel *allowSignModel;

+ (instancetype)shareInstance;

///获取签到信息
///POST /app/opt/checkin/customer/get_check
+ (void)getUserCheckInfo:(HTTPCompleteBlock)block;

///个人中心点击签到有礼
//POST /app/opt/checkin/customer/initiative_click
+ (void)clickPersonCenterCheckBtn:(HTTPCompleteBlock)block;

///是否显示签到有礼按钮
///POST /app/opt/checkin/customer/is_allowed
+ (void)isAllowCustomerCheck:(HTTPCompleteBlock)block;

///弹窗点击
//POST /app/opt/checkin/customer/popup_click
+ (void)customerClickPopup:(HTTPCompleteBlock)block;

+ (void)commitCheckInfo;


@end

NS_ASSUME_NONNULL_END
