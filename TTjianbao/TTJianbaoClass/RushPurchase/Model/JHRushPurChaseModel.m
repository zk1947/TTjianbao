//
//  JHRushPurChaseModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRushPurChaseModel.h"

@implementation JHRushPurChaseSeckillProductInfoModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"productTagList" : NSString.class};
}
@end

@implementation JHRushPurChaseSeckillTimeModel

@end

@implementation JHRushPurChasePageResultModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"resultList" : JHRushPurChaseSeckillProductInfoModel.class};
}

@end

@implementation JHRushPurChaseModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"seckillTimeList" : JHRushPurChaseSeckillTimeModel.class};
}

@end




