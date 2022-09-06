//
//  JHLotteryModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryModel.h"

@implementation JHLotteryModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"content"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [JHLotteryData class],
             @"dialog" : [JHLotteryDialog class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lotteryType = JHLotteryTypeCurrent;
        _list = [NSMutableArray new];
    }
    return self;
}

- (NSString *)toUrl {
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/activity/api/lottery/activity/v2/list?listType=%ld"),
                     _lotteryType];
    return url;
}

- (void)configModel:(JHLotteryModel *)model {
    if (!model) return;
    if (model.list.count == 0) return;
    
    _dialog = model.dialog;
    if(self.page == 0)
    {
        [_list removeAllObjects];
    }
    [_list addObjectsFromArray:model.list];
}

@end


#pragma mark -
#pragma mark - 活动列表数据
@implementation JHLotteryData

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"activityList" : @"activities"};
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"activityList" : [JHLotteryActivityData class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _activityList = [NSMutableArray new];
    }
    return self;
}

@end


#pragma mark -
#pragma mark - 活动内容
@implementation JHLotteryActivityData

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"shareInfo" : @"share",
             @"mediaList" : @"media"
    };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"shareInfo" : [JHShareInfo class],
             @"mediaList" : [JHLotteryMediaData class]
    };
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mediaList = [NSMutableArray new];
    }
    return self;
}

@end


#pragma mark -
#pragma mark - 奖品资源
@implementation JHLotteryMediaData
@end


#pragma mark -
#pragma mark - 中奖弹窗
@implementation JHLotteryDialog
@end
