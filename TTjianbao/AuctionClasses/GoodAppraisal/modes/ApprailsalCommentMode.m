//
//  ApprailsalCommentMode.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "ApprailsalCommentMode.h"

@implementation ApprailsalCommentMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"ID" : @"id",
//        @"userTycoonLevelIcon":@"consume_tag_icon"
    };
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
//        @"userTycoonLevelIcon":@"consume_tag_icon"
    };
}

@end
