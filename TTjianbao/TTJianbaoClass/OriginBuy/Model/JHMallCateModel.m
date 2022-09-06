//
//  JHMallCateModel.m
//  TTjianbao
//
//  Created by jiangchao on 2020/7/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallCateModel.h"

@implementation JHMallCateModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id"};
}

- (void)setNotSelectedIcon:(NSString *)notSelectedIcon {
    _notSelectedIcon = [notSelectedIcon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (void)setSelectedIcon:(NSString *)selectedIcon {
    _selectedIcon = [selectedIcon stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.Id = [coder decodeObjectForKey:@"Id"];
        self.name = [coder decodeObjectForKey:@"name"];
        self.notSelectedIcon = [coder decodeObjectForKey:@"notSelectedIcon"];
        self.selectedIcon = [coder decodeObjectForKey:@"selectedIcon"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.name forKey:@"name"];
    [coder encodeObject:self.notSelectedIcon forKey:@"notSelectedIcon"];
    [coder encodeObject:self.selectedIcon forKey:@"selectedIcon"];
    [coder encodeObject:self.Id forKey:@"Id"];
}

@end
