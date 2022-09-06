//
//  JHAccountFlowModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/6.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHAccountFlowModel.h"

@implementation JHAccountFlowReqModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.pageSize = 10;
        self.pageIndex = 0;
    }
    return self;
}

-(NSString *)uriPath
{
    return @"/app/account-flow/list-new";
}

@end

@implementation JHAccountFlowModel

@end
