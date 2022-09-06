//
//  JHChannelBannerModel.h
//  TTjianbao
//
//  Created by YJ on 2020/12/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMallModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHChannelBannerModel : NSObject

@property (nonatomic, copy) NSString *detailsId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *targetName;
@property (nonatomic, copy) NSString *landingId;
@property (nonatomic, copy) NSString *landingTarget;

@property (strong, nonatomic) TargetModel *target;
///直播状态：0 休息中 1 ：禁用 2：直播中


@end

NS_ASSUME_NONNULL_END
