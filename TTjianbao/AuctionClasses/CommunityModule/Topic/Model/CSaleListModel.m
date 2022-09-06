//
//  CSaleListModel.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/6.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "CSaleListModel.h"

@implementation CSaleListModel

//返回一个 Dict，将 Model 属性名映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"contentList" : @"content_list"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"contentList" : [JHDiscoverChannelCateModel class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.page = 1;
        _item_id = @"0";
        _last_id = @"0";
        _contentList = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toParams {
    self.page = self.willLoadMore ? self.page + 1 : 1;
    return [NSString stringWithFormat:@"%@/%@/%ld", _item_id, _last_id, (long)self.page];
}

- (void)configModel:(CSaleListModel *)model {
    if (!model) {
        return;
    }
    
    _server_time = model.server_time;
    _end_time = model.end_time;
    
    if (self.willLoadMore) {
        _contentList = [_contentList arrayByAddingObjectsFromArray:model.contentList].mutableCopy;
    } else {
        _contentList = [NSMutableArray arrayWithArray:model.contentList];
    }
    
    _last_id = _contentList.lastObject.uniq_id;
    self.canLoadMore = (model.contentList.count > 0);
}

@end
