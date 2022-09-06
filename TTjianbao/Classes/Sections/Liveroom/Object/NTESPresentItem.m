//
//  NTESPresentItem.m
//  TTjianbao
//
//  Created by chris on 16/3/31.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESPresentItem.h"

#define NTESPresentType  @"type"
#define NTESPresentCount @"count"

@implementation NTESPresentItem

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        _type  = [[aDecoder decodeObjectForKey:NTESPresentType] integerValue];
        _count = [[aDecoder decodeObjectForKey:NTESPresentCount] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:@(self.type)  forKey:NTESPresentType];
    [encoder encodeObject:@(self.count) forKey:NTESPresentCount];
}

@end
