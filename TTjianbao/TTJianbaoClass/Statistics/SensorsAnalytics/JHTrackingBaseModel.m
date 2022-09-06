//
//  JHTrackingBaseModel.m
//  TTjianbao
//
//  Created by apple on 2020/12/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTrackingBaseModel.h"

@implementation JHTrackingBaseModel
#pragma mark - 根据类型枚举设置共有属性


//- (void)setReferrerPage:(JHTrackingPage)referrerPage {
//
//    _source_page = referrerPage;
//
//    _referrer = [self pageNameWithEnum:referrerPage];
//}
//
//- (void)setCurrentPage:(JHTrackingPage)currentPage {
//    
//    _currentPage = currentPage;
//    
//    _screen_name = [self pageNameWithEnum:currentPage];
//}
//
//
//- (NSString *)pageNameWithEnum:(JHTrackingPage)pageEnum {
//    
//    NSArray *pageList = @[@"",
//                          @"Home"
//                   ];
//    
//    return pageList[pageEnum];
//}


#pragma mark - 事件属性
/**
 返回事件所需参数dic
 */
- (NSDictionary *)properties {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    // baseModel自己的属性，即为多个子类model所共有的属性
//    [params setValue:self.referrer forKey:@"$referrer"];
//    [params setValue:self.screen_name forKey:@"$screen_name"];
//    [params setValue:self.referrer_area forKey:@"referrer_area"];
//    [params setValue:self.referrer_index forKey:@"referrer_index"];
//    [params setValue:self.event_duration forKey:@"$event_duration"];
    
    // 加上子类的属性
    [params addEntriesFromDictionary:[self properties_aps]];
    
    return params;
}


// Model to NSDictionary 除去 properties
- (NSDictionary *)properties_aps {
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        // 过滤掉已加入的 properties 和 非事件属性的枚举属性
        if (![propertyName isEqualToString:@"properties"] &&
            ![propertyName isEqualToString:@"eventType"] &&
            ![propertyName isEqualToString:@"articleType"] &&
            ![propertyName isEqualToString:@"platformType"] &&
            ![propertyName isEqualToString:@"referrerPage"] &&
            ![propertyName isEqualToString:@"referrerAreaType"] &&
            ![propertyName isEqualToString:@"currentPage"] &&
            ![propertyName isEqualToString:@"shareType"] &&
            ![propertyName isEqualToString:@"operateType"] &&
            ![propertyName isEqualToString:@"clikeButton"]) {
            
            id propertyValue = [self valueForKey:(NSString *)propertyName];
            if (propertyValue) [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}
@end
