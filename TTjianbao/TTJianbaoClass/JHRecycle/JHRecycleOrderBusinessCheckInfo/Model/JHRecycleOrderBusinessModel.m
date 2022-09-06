//
//  JHRecycleOrderBusinessModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessModel.h"

@implementation JHRecycleOrderBusinessModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"imageList" : [JHRecycleOrderBusinessImageInfo class],
    };
}
@end


@implementation JHRecycleOrderBusinessImageInfo

@end
