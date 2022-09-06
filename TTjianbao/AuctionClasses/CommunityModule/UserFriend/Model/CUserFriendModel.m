//
//  CUserFriendModel.m
//  TTjianbao
//
//  Created by wuyd on 2019/9/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "CUserFriendModel.h"

@implementation CUserFriendModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [CUserFriendData class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _uniq_id = 0;
        _list = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toParams {
    self.page = self.willLoadMore ? self.page + 1 : 0;
    if (!self.willLoadMore) {
        _uniq_id = 0;
    }
    // user/list/pageIndex/user_id/last_uniq_id/page
    NSString *params = [NSString stringWithFormat:@"%ld/%ld/%ld/%ld", (long)_pageIndex, (long)_user_id, (long)_uniq_id, (long)self.page];
    return params;
}

- (void)configModel:(CUserFriendModel *)model {
    if (self.willLoadMore) {
        _list = [_list arrayByAddingObjectsFromArray:model.list].mutableCopy;
    } else {
        _list = [NSMutableArray arrayWithArray:model.list];
    }
    
    _uniq_id = _list.lastObject.uniq_id;
    self.canLoadMore = (model.list.count > 0);
}

@end


@implementation CUserFriendData

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"userTycoonLevelIcon":@"consume_tag_icon"
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"userTycoonLevelIcon":@"consume_tag_icon"
    };
}

- (void)setAvatar:(NSString *)avatar {
    //url中文转码
    _avatar = [avatar stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end

