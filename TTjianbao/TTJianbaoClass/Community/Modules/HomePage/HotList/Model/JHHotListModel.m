//
//  JHHotListModel.m
//  TTjianbao
//
//  Created by lihui on 2020/6/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHotListModel.h"
#import "JHSQModel.h"

@implementation JHHotListModel

//返回一个 Dict，将 Model 属性名对映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"list" : @"data"};
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [JHPostData class]
    };
}


@end
