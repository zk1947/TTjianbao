//
//  JHProviceModel.m
//  AFNetworking
//
//  Created by lihui on 2020/4/24.
//

#import "JHProviceModel.h"

@implementation JHProviceModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _citys = [NSMutableArray array];
    }
    return self;
}

+ (JHProviceModel *)createProvinceModelWithDict:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    
    JHProviceModel *model = [[JHProviceModel alloc] init];
    model.provinceId = dict[@"provinceId"];
    model.provinceName = dict[@"provinceName"];
    model.citys = [NSMutableArray array];
    return model;
}

@end

@implementation JHCityModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _areas = [NSMutableArray array];
    }
    return self;
}

+ (JHCityModel *)createCityModelWithDict:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    
    JHCityModel *model = [[JHCityModel alloc] init];
    model.cityId = dict[@"cityId"];
    model.cityName = dict[@"cityName"];
    model.areas = [NSMutableArray array];
    return model;
}


@end

@implementation JHAreaModel

+ (JHAreaModel *)createAreaModelWithDict:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    
    JHAreaModel *model = [[JHAreaModel alloc] init];
    model.districtId = dict[@"districtId"];
    model.districtName = dict[@"districtName"];
    return model;
}


@end
