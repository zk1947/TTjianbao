//
//  JHVoucherListModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHVoucherListModel.h"

@implementation JHVoucherListModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [JHVoucherListData class]};
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _list = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toValidUrl {
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/voucher/seller/canGrantList/auth?sellerId=%@"), _sellerId];
    return url;
}

- (void)configModel:(JHVoucherListModel *)model {
    if (!model) return;
    if (model.list.count <= 0) return;
    
    _list = [NSMutableArray arrayWithArray:model.list];
}

@end


@implementation JHVoucherListData
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"voucherId" : @"id"};
}
@end
