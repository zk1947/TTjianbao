//
//  JHShopWindowListModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/5/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHShopWindowListModel.h"

@implementation JHShopWindowListModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"goodsList" : @"goods_list"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"goodsList" : [JHGoodsInfoMode class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _tag_id = 0;
        _sort = 0;
        _goodsList = [NSMutableArray new];
        _layoutList = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toUrl {
    self.page = self.willLoadMore ? self.page+1 : 1;
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v2/shop/cover_tag_goodslist?sc_id=%ld&tag_id=%ld&sort=%ld&page=%ld"),
                     (long)_sc_id, (long)_tag_id, (long)_sort, (long)self.page];
    return url;
}

- (void)configModel:(JHShopWindowListModel *)model {
    if (!model) return;
    if (model.goodsList.count <= 0) return;
    
    if (self.willLoadMore) {
        [_goodsList addObjectsFromArray:model.goodsList];
    } else {
        _goodsList = [NSMutableArray arrayWithArray:model.goodsList];
    }
    
    //配置布局
    [self configLayout:model.goodsList];
    
    self.canLoadMore = model.goodsList.count > 0;
}

- (void)configLayout:(NSMutableArray<JHGoodsInfoMode *> *)list {
    NSMutableArray *layouts = [NSMutableArray new];
    [list enumerateObjectsUsingBlock:^(JHGoodsInfoMode * _Nonnull goodsInfo, NSUInteger idx, BOOL * _Nonnull stop) {
        JHShopWindowLayout *layout = [[JHShopWindowLayout alloc] initWithModel:goodsInfo];
            [layouts addObject:layout];
    }];
    
    if (self.willLoadMore) {
        [self.layoutList addObjectsFromArray:layouts];
    } else {
        self.layoutList = [NSMutableArray arrayWithArray:layouts];
    }
}

@end
