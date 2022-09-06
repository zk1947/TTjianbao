//
//  JHChannelBannerModel.m
//  TTjianbao
//
//  Created by YJ on 2020/12/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHChannelBannerModel.h"
#import "BannerMode.h"

@implementation JHChannelBannerModel

- (void)setLandingTarget:(NSString *)landingTarget
{
    _landingTarget = landingTarget;
    NSDictionary *dic = [_landingTarget mj_JSONObject];
    _target = [TargetModel mj_objectWithKeyValues:dic];
}

@end
