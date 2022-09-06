//
//  JHAnchorInfoModel.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/14.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHAnchorInfoModel.h"

@implementation JHAnchorInfoModel
- (NSString *)grade {
    if (_grade) {
        double d            = [_grade doubleValue];
        NSString *dStr      = [NSString stringWithFormat:@"%f", d];
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
        _grade         = [dn stringValue];
    }
    return _grade;

}

- (NSArray *)certificationFiles {
    if (!_certificationFiles) {
        _certificationFiles = @[];
    }
    return _certificationFiles;
}
- (void)setTags:(NSArray *)tags{
    NSString *goodString = @"";
    for (NSDictionary *dict in tags) {
        if (goodString.length > 0) {
            goodString = [goodString stringByAppendingString:@" "];
        }
        goodString = [goodString stringByAppendingString:dict[@"tagName"]];
    }
    _goodAt = goodString;
    _tags = tags;
    
}
@end

@implementation JHAnchorHomeModel


@end
