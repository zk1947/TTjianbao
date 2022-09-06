//
//  JHRecycleHomeModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeModel.h"

@implementation JHRecycleHomeProductImageModel
@end

///回收分类
@implementation JHHomeRecycleCategoryListModel

@end


///订单信息列表
@implementation JHHomeOrderInfoListModel

@end

///运营位
@implementation PositionTargetModel
@end
@implementation JHHomeOperatingPositionModel
- (void)setLandingTarget:(NSString *)landingTarget {
    _landingTarget = landingTarget;
    NSDictionary *dic = [_landingTarget mj_JSONObject];
    _target = [PositionTargetModel mj_objectWithKeyValues:dic];
}
@end


///回收直播
@implementation JHHomeRecycleLiveListModel
- (void)setViewers:(NSString *)viewers{
    NSString *watchTotalStr = @"";
    double watchTotalInt = viewers.doubleValue;
    if (watchTotalInt > 10000) {
        watchTotalStr = [NSString stringWithFormat:@"%.1f", watchTotalInt / 10000.f];
        NSArray *array = [watchTotalStr componentsSeparatedByString:@"."];
        if (array.count == 2) {
            NSString *string = array.lastObject;
            if ([string isEqualToString:@"0"]) {
                watchTotalStr = array.firstObject;
            }
        }
        watchTotalStr = [NSString stringWithFormat:@"%@万", watchTotalStr];
    }else{
        watchTotalStr = viewers;
    }
    _watchTotalString = watchTotalStr;
}

@end


///回收商品
@implementation JHHomeHotRecycleProductsListModel

@end


///常见问题
@implementation JHHomeRecycleHelpArticleListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}
@end

@implementation JHRecycleHomeModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"recycleCategoryList" : [JHHomeRecycleCategoryListModel class],
        @"orderInfoList": [JHHomeOrderInfoListModel class],
        @"recycleLiveList": [JHHomeRecycleLiveListModel class],
        @"productAggVOList": [JHHomeHotRecycleProductsListModel class],
        @"recycleHelpArticleList": [JHHomeRecycleHelpArticleListModel class],
    };
}
@end



@implementation JHRecycleHomeGetRecyclePlateModel

@end
