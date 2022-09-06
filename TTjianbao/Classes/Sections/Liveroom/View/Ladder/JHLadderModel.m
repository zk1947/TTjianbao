//
//  JHLadderModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLadderModel.h"

@implementation JHLadderModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [JHLadderData class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _list = [NSMutableArray new];
    }
    return self;
}

//获取用户津贴列表接口
- (NSString *)toListUrl {
    NSString *url = FILE_BASE_STRING(@"/anon/red-packet/findLadderByCustomerId");
    return url;
}
- (NSDictionary *)toListParams {
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    if (![customerId isNotBlank]) {
        customerId = @"0";
    }
    return @{@"channelId" : _channelId,
             @"customerId" : customerId
    };
}

//领取津贴接口 & 参数
- (NSString *)toReceiveUrl {
    NSString *url = FILE_BASE_STRING(@"/app/red-packet/takeLadder");
    return url;
}
- (NSDictionary *)toReceiveParams {
    return @{@"channelId" : _channelId,
             @"customerId" : [UserInfoRequestManager sharedInstance].user.customerId,
             @"ladderFlag" : _ladderFlag
    };
}

- (void)configModel:(JHLadderModel *)model {
    if (!model) return;
    if (model.list.count > 0) {
        _list = [NSMutableArray arrayWithArray:model.list];
    }
}

@end


@implementation JHLadderData

@end

