//
//  JHOnlineAppraiseModel.m
//  TTjianbao
//
//  Created by lihui on 2020/12/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOnlineAppraiseModel.h"

@implementation JHOnlineAppraiseModel


+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}
//+ (NSDictionary *)mj_objectClassInArray{
//    return @{@"owners" : [JHOwnerInfo class]};
//}

- (void)setBg_img:(NSString *)bg_img {
    _bg_img = [bg_img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
