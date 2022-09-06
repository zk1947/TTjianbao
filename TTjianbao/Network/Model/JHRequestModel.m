//
//  JHRequestModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRequestModel.h"

@interface JHRequestModel ()

@property (nonatomic, copy) NSString* pathOfURI;
@end

@implementation JHRequestModel

- (void)dealloc
{
    NSLog(@"TTjianbao app>>>>><%@", [self description]);
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.pageIndex = 0;
        self.pageSize = 10; //初始化默认值
    }
    
    return self;
}

- (void)setRequestPath:(NSString*)url
{
    self.pathOfURI = url;
}

- (NSString*)uriPath
{
    //子类重写,赋值具体请求url后半部分
    NSAssert(self.pathOfURI, @"无效urlPath,请子类重写uriPath！！！");
    return self.pathOfURI;
}

@end
