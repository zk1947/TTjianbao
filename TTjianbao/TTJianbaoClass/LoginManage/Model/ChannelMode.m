//
//  ChannelMode.m
//  TTjianbao
//
//  Created by jiangchao on 2018/12/10.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "ChannelMode.h"

@implementation OrderTypeModel

@end

@implementation ShanGouInfo
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"Id":@"id"};
}
@end


@implementation ChannelMode
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"categories" : [OrderTypeModel class], @"flashCategories" : ShanGouInfo.class};
}
//-(NSString*)userLevelName{
//
//    return @"新铁杆粉丝儿";
//}
//-(NSString*)userLevelType{
//
//    return @"10";
//}
//-(BOOL)isOpen{
//
//    return 1;
//}

@end

@implementation StoneChannelMode

@end
