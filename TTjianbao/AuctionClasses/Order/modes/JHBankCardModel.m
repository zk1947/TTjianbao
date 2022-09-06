//
//  JHBankCardModel.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBankCardModel.h"
#import "NSString+Extension.h"

@implementation JHBankCardModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id",
             @"iconUrl" : @"icon",
             };
}

- (NSString *)bankName {
    if (_bankName.length) {
        return _bankName;
    }
    return @" ";
}

- (NSString *)bankBranch {
    if (_bankBranch.length) {
        return _bankBranch;
    }
    return @" ";
}

- (NSString *)bankType {
    if (_bankType.length) {
        return _bankType;
    }
    return @" ";
}

- (NSString *)accountNo {
    if (_accountNo.length) {
        return [self cutStr:_accountNo];
    }
    return @" ";
}

- (NSString *)cutStr:(NSString *)cardNo {
    NSMutableArray *array = [NSMutableArray array];
    long len = cardNo.length / 4;
    for (int i = 0; i < len; i ++) {
        NSString *tmp = [cardNo substringWithRange:NSMakeRange(i * 4, 4)];
        [array addObject:tmp];
    }

    if (cardNo.length%4 > 0) {
        NSString *tmp = [cardNo substringFromIndex:len * 4];
        [array addObject:tmp];
    }
    
    for (int j = 0; j <= array.count - 2; j++ ) {
        array[j] = @"****";
    }
    
    return [array componentsJoinedByString:@" "];
}

@end
