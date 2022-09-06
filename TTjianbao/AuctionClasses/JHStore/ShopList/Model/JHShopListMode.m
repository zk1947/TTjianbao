//
//  JHShopListMode.m
//  TTjianbao
//
//  Created by apple on 2019/12/17.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHShopListMode.h"

@implementation JHShopListMode

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [JHShopListMode class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _list = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toUrl {
    self.page = self.willLoadMore ? self.page+1 : 1;
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/seller_list?page=%ld"), (long)self.page];
    return url;
}

- (NSString *)toSearchUrlWithKey:(NSString *)key {
    self.page = self.willLoadMore ? self.page+1 : 1;
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/seller_list?page=%ld&keyword=%@"), (long)self.page, key];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return url;
}

- (void)configModel:(JHShopListMode *)model {
    if (!model) return;
    if (model.list.count <= 0) {
        self.canLoadMore = NO;
        return;
    }
    
    if (self.willLoadMore) {
        [_list addObjectsFromArray:model.list];
    } else {
        _list = [NSMutableArray arrayWithArray:model.list];
    }
    
    self.canLoadMore = model.list.count > 0;
}




@end
