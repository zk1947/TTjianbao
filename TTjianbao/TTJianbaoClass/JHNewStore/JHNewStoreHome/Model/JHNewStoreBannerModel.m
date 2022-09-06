//
//  JHNewStoreBannerModel.m
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreBannerModel.h"

@implementation JHNewStoreBannerModel
- (void)setLandingTarget:(NSString *)landingTarget {
    _landingTarget = landingTarget;
    NSDictionary *dic = [_landingTarget mj_JSONObject];
    _target = [TargetModel mj_objectWithKeyValues:dic];
}
@end

