//
//  NTESLikeAttachment.m
//  TTjianbao
//
//  Created by chris on 16/3/30.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESLikeAttachment.h"
#import "NTESCustomKeyDefine.h"

@implementation NTESLikeAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *attach = @{
                               NTESCMType:@(NTESCustomAttachTypeLike),
                            };
    NSData *data = [NSJSONSerialization dataWithJSONObject:attach options:0 error:nil];
    NSString *str = @"{}";
    if (data) {
        str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return str;
}


@end
