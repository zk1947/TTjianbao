//
//  JHPersonalResellModel.m
//  TTjianbao
//
//  Created by jesee on 20/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPersonalResellModel.h"

#define kPersonalResellReqPathPrefix @"/app/stone/resale/"

@implementation JHPersonalResellModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"list":[JHPersonalResellListModel class]};
}
@end

@implementation JHPersonalResellListModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"salePriceWrapper":[JHPersonalResellSalePriceWrapperModel class]};
}
@end

@implementation JHPersonalResellSalePriceWrapperModel

@end

///原石转售-个人中心-在售（已上架）列表
@implementation JHPersonalResellShelveListReqModel
//~/app/stone/resale/shelve-list
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@shelve-list",kPersonalResellReqPathPrefix];
}
@end

///原石转售-个人中心-已售列表
@implementation JHPersonalResellSoldReqModel
//~/app/stone/resale/sold-list
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@sold-list",kPersonalResellReqPathPrefix];
}
@end

///原石转售-个人中心-待上架列表
@implementation JHPersonalResellWaitshelveReqModel
//~/app/stone/resale/wait-shelve-list
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@wait-shelve-list",kPersonalResellReqPathPrefix];
}
@end

///原石转售-个人中心-list item
@implementation JHPersonalResellListItemReqModel
//~/anon/stone/resale/find-detail-for-list
- (NSString *)uriPath
{
    return @"/anon/stone/resale/find-detail-for-list";
}
@end

///原石转售-上架-操作
@implementation JHPersonalResellShelveReqModel
//~/app/stone/resale/shelve
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@shelve",kPersonalResellReqPathPrefix];
}
@end

///原石转售-下架-操作
@implementation JHPersonalResellUnshelveReqModel
//~/app/stone/resale/un-shelve
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@un-shelve",kPersonalResellReqPathPrefix];
}
@end

///原石转售-个人中心-删除
@implementation JHPersonalResellDeleteReqModel
//~/app/stone/resale/delete
- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@delete",kPersonalResellReqPathPrefix];
}
@end

@implementation JHPersonalResellReqModel

@end
