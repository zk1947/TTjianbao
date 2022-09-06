//
//  JHShopWindowModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/5/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHShopWindowModel.h"

@implementation JHShopWindowModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"windowInfo" : @"cover_info",
             @"shareInfo" : @"share_info",
             @"tagList" : @"tag_list"
    };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"windowInfo" : [JHShopWindowInfo class],
             @"shareInfo" : [JHShareInfo class],
             @"tagList" : [JHShopWindowTagInfo class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _tagList = [NSMutableArray new];
        _tagTitles = [NSMutableArray new];
    }
    return self;
}

//获取专题信息url
- (NSString *)toUrl {
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v2/shop/cover_info?sc_id=%ld"),
                     (long)_sc_id];
    return url;
}

- (void)configModel:(JHShopWindowModel *)model {
    if (!model) return;
    _windowInfo = model.windowInfo;
    _shareInfo = model.shareInfo;
    _tagList = [NSMutableArray arrayWithArray:model.tagList];
    
    [_tagTitles removeAllObjects];
    if (_tagList.count > 0) {
        for (JHShopWindowTagInfo *tag in _tagList) {
            [_tagTitles addObject:tag.tag_name];
        }
    }
}

@end


@implementation JHShopWindowInfo

@end


@implementation JHShopWindowTagInfo

@end
