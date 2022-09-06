//
//  CTopicDetailModel.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/4.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "CTopicDetailModel.h"

@implementation CTopicDetailModel

//返回一个 Dict，将 Model 属性名映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"contentList" : @"content_list",
             @"hotContentList" : @"hot_content_list",
             @"topicInfo" : @"topic",
             @"saleInfo" : @"especially_buy_info"
             };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"contentList" : [JHDiscoverChannelCateModel class],
             @"hotContentList" : [JHDiscoverChannelCateModel class],
             @"topicInfo" : [CTopicInfo class],
             @"saleInfo" : [CTopicSaleInfo class]
             };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _item_id = @"0";
        _last_uniq_id = @"0";
        _contentList = [NSMutableArray new];
        _hotContentList = [NSMutableArray new];
        _topicInfo = [CTopicInfo new];
        _saleInfo = [CTopicSaleInfo new];
    }
    return self;
}

- (NSString *)toRefreshParams {
    self.page = self.willLoadMore ? self.page + 1 : 1;
    NSString *params = [NSString stringWithFormat:@"%@/%@/%ld/%ld", _item_id, _last_uniq_id, (long)self.page, (long)_pageIndex];
    return params;
}

- (void)configModel:(CTopicDetailModel *)model {
    
    _topicInfo = model.topicInfo;
    _saleInfo = model.saleInfo;
    
    _contentList = [NSMutableArray arrayWithArray:model.contentList];
    _hotContentList = [NSMutableArray arrayWithArray:model.hotContentList];
    
    _last_uniq_id = _contentList.lastObject.uniq_id;
    self.canLoadMore = (model.hotContentList.count > 0);
}

- (void)configRefreshModel:(CTopicDetailModel *)model {
    if (self.willLoadMore) {
        _contentList = [_contentList arrayByAddingObjectsFromArray:model.contentList].mutableCopy;
        _hotContentList = [_hotContentList arrayByAddingObjectsFromArray:model.hotContentList].mutableCopy;
    } else {
        
        _contentList = [NSMutableArray arrayWithArray:model.contentList];
        _hotContentList = [NSMutableArray arrayWithArray:model.hotContentList];
    }
    
    _last_uniq_id = _contentList.lastObject.uniq_id;
    self.canLoadMore = (model.contentList.count > 0);
}

@end


@implementation CTopicInfo

//返回一个 Dict，将 Model 属性名映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"shareInfo" : @"share_info"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shareInfo" : [CTopicShareInfo class]};
}

- (void)setBg_image:(NSString *)bg_image {
    //url中文转码
    _bg_image = [bg_image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end


@implementation CTopicShareInfo //分享信息

- (void)setImg:(NSString *)img {
    //url中文转码
    _img = [img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end


@implementation CTopicSaleInfo

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
        _contentList = [NSMutableArray new];
    }
    return self;
}

@end
