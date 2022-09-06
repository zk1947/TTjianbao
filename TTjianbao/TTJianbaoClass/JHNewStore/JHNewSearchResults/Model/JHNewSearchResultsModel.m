//
//  JHNewSearchResultsModel.m
//  TTjianbao
//
//  Created by hao on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewSearchResultsModel.h"

///运营位栏位列表
@implementation JHNewSearchResultPositionTargetModel
@end
@implementation JHNewSearchResultOperationListModel
- (void)setLandingTarget:(NSString *)landingTarget {
    _landingTarget = landingTarget;
    NSDictionary *dic = [_landingTarget mj_JSONObject];
    _target = [JHNewSearchResultPositionTargetModel mj_objectWithKeyValues:dic];
}
@end



@implementation JHNewSearchResultsModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"productList" : [JHNewStoreHomeGoodsProductListModel class],
        @"liveList"    : [JHLiveRoomMode class],
        @"operationPositionList":[JHNewSearchResultOperationListModel class],
    };
}
@end
