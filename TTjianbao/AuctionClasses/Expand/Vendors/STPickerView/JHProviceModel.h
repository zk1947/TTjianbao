//
//  JHProviceModel.h
//  AFNetworking
//
//  Created by lihui on 2020/4/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHCityModel;
@class JHAreaModel;

///省市model
@interface JHProviceModel : NSObject

@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *provinceName;
@property (nonatomic, strong) NSMutableArray <JHCityModel *>*citys;   ///城市集合

///创建模型
+ (JHProviceModel *)createProvinceModelWithDict:(NSDictionary *)dict;



@end

///城市model
@interface JHCityModel : NSObject

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, strong) NSMutableArray <JHAreaModel *>*areas;   ///区集合

+ (JHCityModel *)createCityModelWithDict:(NSDictionary *)dict;

@end

///区/县
@interface JHAreaModel : NSObject

@property (nonatomic, copy) NSString *districtId;
@property (nonatomic, copy) NSString *districtName;

+ (JHAreaModel *)createAreaModelWithDict:(NSDictionary *)dict;

@end



NS_ASSUME_NONNULL_END
