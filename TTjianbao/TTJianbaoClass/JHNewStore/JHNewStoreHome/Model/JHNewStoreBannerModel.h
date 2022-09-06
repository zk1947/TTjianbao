//
//  JHNewStoreBannerModel.h
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BannerMode.h"

NS_ASSUME_NONNULL_BEGIN

@class TargetModel;
@interface JHNewStoreBannerModel : NSObject
///跳转参数
@property (nonatomic, copy) NSString *landingTarget;
///自定义属性
@property (strong, nonatomic) TargetModel *target;
///直播状态：0 休息中 1 ：禁用 2：直播中
@property (nonatomic, assign) NSInteger status;
///直播间封面图
@property (nonatomic, copy) NSString *smallCoverImg;
@end






NS_ASSUME_NONNULL_END
