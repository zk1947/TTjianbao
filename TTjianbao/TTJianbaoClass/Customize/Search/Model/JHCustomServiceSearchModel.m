//
//  JHCustomServiceSearchModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/9/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomServiceSearchModel.h"

@implementation JHCustomServiceSearchModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.pageNo = 0;
        self.pageSize   = 100;
    }
    return self;
}

- (NSString *)uriPath
{
    return @"/channel/customized/sell/list";
}

@end
