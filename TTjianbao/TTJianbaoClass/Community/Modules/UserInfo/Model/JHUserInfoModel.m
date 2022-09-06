//
//  JHUserInfoModel.m
//  TTjianbao
//
//  Created by lihui on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUserInfoModel.h"

@implementation JHUserInfoPostModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [JHPostData class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _list = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toUserPostUrl:(NSInteger)type userId:(NSString *)userId {
    self.page = self.willLoadMore ? self.page+1 : 1;
    NSString *lastId = _list.count > 0 ? _list.lastObject.item_id : @"0";
    lastId = self.willLoadMore ? lastId : @"0";
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v2/user/history?type=%ld&user_id=%@"), (long)type, userId];

    return url;
}

- (void)configModel:(JHSQModel *)model {
    if (!model) return;
    if (model.list.count <= 0) return;
    
    //配置帖子内容
    for (JHPostData *data in model.list) {
        //配置帖子内容
        BOOL isNormal = data.item_type == JHPostItemTypePost;
        [data configPostContent:data.content isNormal:isNormal];
    }
    
    if (self.willLoadMore) {
        [_list addObjectsFromArray:model.list];
    } else {
        _list = [NSMutableArray arrayWithArray:model.list];
    }
    
    self.canLoadMore = model.list.count > 0;
}



@end

@implementation JHUserInfoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"isSpecialSale" : @"is_special_sale",
        @"sellerId" : @"seller_id",
        @"userTycoonLevelIcon" : @"consume_tag_icon",
        @"levelInfo" : @"level_icons",
        @"storeInfo":@"store_info",
        @"shareInfo":@"share_info"
    };
}

//返回一个 Dict，将 Model 属性名映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"isSpecialSale" : @"is_special_sale",
             @"sellerId" : @"seller_id",
             @"userTycoonLevelIcon" : @"consume_tag_icon",
             @"levelInfo" : @"level_icons",
             @"storeInfo":@"store_info",
             @"shareInfo":@"share_info"
    };
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"levelInfo" : [JHUserMedalInfo class]};
}

@end

@implementation JHUserMedalInfo

@end

@implementation JHStoreSellerInfo


@end
