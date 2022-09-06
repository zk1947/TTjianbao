//
//  ExpressMode.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "ExpressMode.h"

@implementation ExpressMode

@end

@implementation ExpressVo
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"data":[ExpressRecord class]};
}
@end

@implementation ExpressRecord

@end

@implementation ExpressAppraiseMode

@end

@implementation orderStatusLogVosModel

@end

@implementation ExpressOrderStatusModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"orderStatusLogVos":[orderStatusLogVosModel class]};
}
@end

