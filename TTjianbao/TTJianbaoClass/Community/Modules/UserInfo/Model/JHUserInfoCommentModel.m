//
//  JHUserInfoCommentModel.m
//  TTjianbao
//
//  Created by lihui on 2020/7/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUserInfoCommentModel.h"
#import "JHAttributeStringTool.h"

@implementation JHUserInfoCommentModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"mainInfo" : @"main",
        @"postData" : @"content",
    };
}

//返回一个 Dict，将 Model 属性名映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"mainInfo" : @"main",
        @"postData" : @"content",
        @"comment":@"base_comment"
    };
}

// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"mainInfo" : [JHCommentModel class],
             @"comment":[JHCommentModel class],
             @"postData" : [JHPostData class],
    };
}

@end
