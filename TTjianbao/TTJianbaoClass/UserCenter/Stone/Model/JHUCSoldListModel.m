//
//  JHUCSoldListModel.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHUCSoldListModel.h"

@implementation JHUCSoldPageModel

+ (NSDictionary*)mj_objectClassInArray
{
    return @{
                @"list" : [JHUCSoldListModel class]
             };
}
@end

@implementation JHUCSoldListModel

@end

@implementation JHUCSoldListReqModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.pageIndex = 0;
        self.pageSize = 10; //初始化默认值
    }
    
    return self;
}

- (NSString *)uriPath
{
    return @"/app/stone-restore/list-my-sold";
}

@end
