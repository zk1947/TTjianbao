//
//  JHMsgSubListOrderTransportModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/8/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMsgSubListOrderTransportModel.h"

@implementation JHMsgSubListOrderTransportModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"ext" : [JHMsgSubListNormalNoticeOrderModel class]};
}
@end

@implementation JHMsgSubListNormalNoticeOrderModel

@end
