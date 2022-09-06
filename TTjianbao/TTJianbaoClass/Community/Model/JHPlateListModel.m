//
//  JHPlateListModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateListModel.h"

@implementation JHPlateListModel
//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [JHPlateListData class]
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
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/channel/allChannelList");
    return url;
}

@end


@implementation JHPlateListData

- (void)setImage:(NSString *)image {
    _image = [image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
