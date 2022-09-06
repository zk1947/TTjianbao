//
//  JHMallModel.m
//  TTjianbao
//
//  Created by lihui on 2020/12/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallModel.h"
#import "BannerMode.h"

@implementation JHMallModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"operationPosition" : @"JHMallOperateModel",
        @"operationSubjectList" : @"JHMallCategoryModel",
        @"slideShow" : @"JHMallBannerModel",
    };
}

- (float)height {
    float h = 0;
    for (int i=0; i< self.operationPosition.count; i++) {
        JHMallOperateModel * mode = self.operationPosition[i];
        h = h + mode.cellHeight;
        NSLog(@"mode.cellHeight==%lf",mode.cellHeight);
    }
     return h;
}


@end

@implementation JHMallBannerModel
- (void)setLandingTarget:(NSString *)landingTarget {
    _landingTarget = landingTarget;
    NSDictionary *dic = [_landingTarget mj_JSONObject];
    _target = [TargetModel mj_objectWithKeyValues:dic];
}
@end

@implementation JHMallCategoryModel

- (void)setTarget:(NSDictionary *)target {
    _target = target;
    _targetModel = [TargetModel mj_objectWithKeyValues:_target];
}

@end

@implementation JHMallOperateModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"definiDetails" : @"JHMallOperateImgModel",
    };
}
- (float)cellHeight {
    float rate = 1;
    switch (self.definiDetails.count) {
        case 1:
            rate = 90/355.;
            break;
        case 2:
            rate = 100/355.;
            break;
        case 3:
            rate = 100/355.;
            break;
        case 4:
            rate = 100/355.;
            break;
        default:
           rate = 100/355.;
            break;
    }
    
    return (ScreenW-20)*rate;
}
@end

@implementation JHMallOperateImgModel

- (void)setLandingTarget:(NSString *)landingTarget {
    _landingTarget = landingTarget;
    _target = [TargetModel mj_objectWithKeyValues:[self.landingTarget mj_JSONObject]];
}

@end


