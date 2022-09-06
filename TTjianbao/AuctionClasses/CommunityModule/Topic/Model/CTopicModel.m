//
//  CTopicModel.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "CTopicModel.h"

@implementation CTopicModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [CTopicData class]};
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
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v1/topic/list?page=%ld"), (long)self.page];
    return url;
}

- (NSString *)toSearchUrlWithKey:(NSString *)key {
    self.page = self.willLoadMore ? self.page+1 : 1;
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v1/topic/list?page=%ld&q=%@"), (long)self.page, key];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return url;
}

- (void)configModel:(CTopicModel *)model {
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


@implementation CTopicData

- (void)setPreview_image:(NSString *)preview_image {
    //url中文转码
    _preview_image = [preview_image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
