//
//  JHPlateDetailModel.m
//  TTjianbao
//
//  Created by wuyd on 2020/8/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateDetailModel.h"

@implementation JHPlateDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"owners" : [JHPublisher class],
             @"sign_list" : [JHPostData class],
             @"topic_list" : [JHTopicInfo class],
             @"cate_tabs" : [JHTopicDetailCateModel class]
    };
}

- (void)setBg_image:(NSString *)bg_image {
    _bg_image = [bg_image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setImage:(NSString *)image {
    _image = [image stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues
{
    _scan_num = [self getNumStringWithNum:_scan_num];
    _comment_num = [self getNumStringWithNum:_comment_num];
    _content_num = [self getNumStringWithNum:_content_num];
    if(!_bg_image)
    {
        _bg_image = _image;
    }
}

-(NSString *)getNumStringWithNum:(NSString *)numStr
{
    CGFloat num = numStr.floatValue;
    
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
