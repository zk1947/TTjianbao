//
//  JHTopicDetailModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTopicDetailModel.h"

@implementation JHTopicDetailCateModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end


@implementation JHTopicDetailModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"cate_tabs": [JHTopicDetailCateModel class]};
}


@end


@implementation JHTopicDetailShareInfoModel

@end

@implementation JHTopicDetailInfoModel

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues
{
    _scan_num = [self getNumStringWithNum:_scan_num];
    _comment_num = [self getNumStringWithNum:_comment_num];
    _content_num = [self getNumStringWithNum:_content_num];
}

-(NSString *)getNumStringWithNum:(NSString *)numStr
{
    NSInteger num = numStr.integerValue;
    
    if(num < 10000)
    {
        return numStr;
    }
    else
    {
        return [NSString stringWithFormat:@"%.1fw",num / 10000.0];
    } 
}
@end
