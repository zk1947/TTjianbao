//
//  JHLotteryActivityDetailModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryActivityDetailModel.h"

@implementation JHLotteryActivityDetailReqModel

- (NSString *)uriPath
{///activity/api/lottery/activity/v2/
    return [NSString stringWithFormat:@"%@info",kLotteryReqPrefix];
}
@end

@implementation JHLotteryActivityDetailModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"shareInfo" : @"share",
//             @"mediaList" : @"media"
//    };
//}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"address" : [JHLotteryAddress class],
             @"logistics" : [JHLotteryLogistics class],
             @"inviter" : [JHLotteryInviter class],
             @"shareInfo" : [JHShareInfo class],
             @"mediaList" : [JHLotteryMediaData class]
    };
}

- (CGFloat)statusViewHeight;
{
    CGFloat height = 220;
    
    if(self.hit == 1)
    {
        if(!self.address)
        {
            height = 313;
        }
        else
        {
            height = 320;
            if(self.logistics)
            {
                height = 427;
            }
        }
    }
    return height;
}

@end

#pragma mark -
#pragma mark - 收货地址
@implementation JHLotteryAddress

@end

#pragma mark -
#pragma mark - 物流信息
@implementation JHLotteryLogistics
@end

#pragma mark -
#pragma mark - 邀请人信息
@implementation JHLotteryInviter
@end
