//
//  JHPlateSelectModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateSelectModel.h"

@implementation JHPlateSelectModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [JHPlateSelectData class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _list = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toUrl {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/content/cateListV2");
    return url;
}

@end


#pragma mark - 版块数据
@implementation JHPlateSelectData
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items" : [JHPlateSelectDataItem class],
             @"channel_stats" : [JHPlateSelectDataStats class]
    };
}
- (void)setChannel_image:(NSString *)channel_image {
    _channel_image = [channel_image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}
@end


#pragma mark - 统计数据 <浏览量、评论数等>
@implementation JHPlateSelectDataStats

@end


#pragma mark - 版块下的子类
@implementation JHPlateSelectDataItem
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"item_id" : @"id"};
}
@end
