//
//  JHHotWordModel.m
//  TTjianbao
//
//  Created by LiHui on 2020/2/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHotWordModel.h"

@implementation JHHotWordModel
- (void)setName:(NSString *)name{
    if (name.length > 0) {
        _title = name;
    }
}
@end


@implementation JHHotWordTarget

//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{
//        @"componentName" : @"ComponentName"
//    };
//}

@end
