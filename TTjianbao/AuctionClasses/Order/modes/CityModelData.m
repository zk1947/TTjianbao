//
//  CityModelData.m
//  ProvinceAndCityAndTown
//
//  Created by 冷求慧 on 16/12/27.
//  Copyright © 2016年 冷求慧. All rights reserved.
//

#import "CityModelData.h"

@implementation CityModelData

+(NSDictionary *)mj_objectClassInArray {
    return @{@"province" : [Province class]};
}
+ (NSDictionary *)objectClassInArray{
    return @{@"province" : [Province class]};
}
@end
@implementation Province
+(NSDictionary *)mj_objectClassInArray {
    return @{@"child" : [City class]};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"child" : [City class]};
}

@end


@implementation City
+(NSDictionary *)mj_objectClassInArray {
    return @{@"child" : [District class]};
}

+ (NSDictionary *)objectClassInArray{
    return @{@"child" : [District class]};
}

@end


@implementation District

@end
