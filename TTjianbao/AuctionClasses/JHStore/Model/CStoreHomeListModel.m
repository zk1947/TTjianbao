//
//  CStoreHomeListModel.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "CStoreHomeListModel.h"

@implementation CStoreHomeListModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [CStoreHomeListData class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _list = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toUrl {
    NSInteger lastId = _list.count > 0 ? _list.lastObject.sc_id : 0;
    lastId = self.willLoadMore ? lastId : 0;
    self.page = self.willLoadMore ? self.page+1 : 1;
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v1/shop/homepage?last_id=%ld&page=%ld"), (long)lastId, (long)self.page];
    return url;
}

- (void)configModel:(CStoreHomeListModel *)model {
    if (!model) return;
    if (model.list.count <= 0) return;
    
    if (self.willLoadMore) {
        [_list addObjectsFromArray:model.list];
    } else {
        _list = [NSMutableArray arrayWithArray:model.list];
    }
    
    self.canLoadMore = model.list.count > 0;
}

@end


@implementation CStoreHomeListData

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"goodsList" : @"goods_list",
             @"sellerList" : @"rec_seller"
    };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsList" : [CStoreHomeGoodsData class],
             @"sellerList" : [CStoreHomeSellerData class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _goodsList = [NSMutableArray new];
        _sellerList = [NSMutableArray new];
    }
    return self;
}

- (void)setHead_img:(NSString *)head_img {
    //url中文转码
    _head_img = [head_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setTimerSourceIdentifier:(NSString *)timerSourceIdentifier {
    _timerSourceIdentifier = timerSourceIdentifier;
}

@end


@implementation CStoreHomeGoodsData

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"coverImgInfo" : @"cover_img"
    };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"coverImgInfo" : [CStoreHomeGoodsCoverImageInfo class],
             @"target" : [TargetModel class]
    };
}

- (void)setTimerSourceIdentifier:(NSString *)timerSourceIdentifier {
    _timerSourceIdentifier = timerSourceIdentifier;
}

@end


@implementation CStoreHomeSellerData

- (void)setHead_img:(NSString *)head_img {
    //url中文转码
    _head_img = [head_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setBg_img:(NSString *)bg_img {
    _bg_img = [bg_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end

@implementation CStoreHomeGoodsCoverImageInfo

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"imgUrl" : @"url"};
}

- (void)setImgUrl:(NSString *)imgUrl {
    //url中文转码
    _imgUrl = [imgUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
