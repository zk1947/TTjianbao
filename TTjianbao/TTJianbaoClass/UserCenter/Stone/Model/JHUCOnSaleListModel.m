//
//  JHUCOnSaleListModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHUCOnSaleListModel.h"
#import "NSString+Common.h"

@implementation JHUCOnSaleListModel

//0-未定义、1-待上架、2-已上架、3-正在支付、4-支付完成、5-已下架
+ (NSString*)convertFronSaleState:(NSString*)state
{
    NSString* stateStr = @"未定义";
    if([NSString isEmpty:state])
        return stateStr;
    switch ([state intValue])
    {
        case 1:
            stateStr = @"待上架";
            break;
        case 2:
            stateStr = @"已上架";
            break;
        case 3:
            stateStr = @"正在支付";
            break;
        case 4:
            stateStr = @"支付完成";
            break;
        case 5:
            stateStr = @"已下架";
            break;
        default:
            break;
    }
    return stateStr;
}
@end

@implementation JHUCOnSalePageModel

+ (NSDictionary*)mj_objectClassInArray
{
    return @{
                @"list" : [JHUCOnSaleListModel class]
             };
}
@end

@implementation JHUCOnSaleListReqModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.pageIndex = 0;
        self.pageSize = 10; //初始化默认值
    }
    
    return self;
}

- (NSString *)uriPath
{
    return @"/app/stone-restore/list-stone-on-sale";
}

@end
