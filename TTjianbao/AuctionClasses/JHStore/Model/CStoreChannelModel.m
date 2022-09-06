//
//  CStoreChannelModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/2/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "CStoreChannelModel.h"

@implementation CStoreChannelModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [CStoreChannelData class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _list = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toUrl {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/shop/cate_nav");
    return url;
}

- (void)configModel:(CStoreChannelModel *)model {
    if (!model) return;
    _list = [NSMutableArray arrayWithArray:model.list];
}

@end


@implementation CStoreChannelData

@end
