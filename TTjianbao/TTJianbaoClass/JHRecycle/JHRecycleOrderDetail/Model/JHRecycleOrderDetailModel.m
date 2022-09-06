//
//  JHRecycleOrderDetailModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailModel.h"

@implementation JHRecycleOrderDetailModel

@end
/// 订单节点
@implementation JHRecycleOrderNodeInfo
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"recycleNodes" : [NSString class],
        @"recycleNodesStr" : [NSString class],
    };
}


@end

@implementation JHRecycleOrderInfo



@end


@implementation JHRecycleOrderButtonInfo



@end

@implementation JHRecycleCancelModel
- (void)setCode:(NSString *)code {
    _reasonType = code;
}
- (void)setMsg:(NSString *)msg {
    _reasonTypeDesc = msg;
}

@end



