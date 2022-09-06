//
//  JHReqModel.m
//  TTjianbao
//  
//  Created by Jesse on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHReqModel.h"

@interface JHReqModel ()
//请求类型,区分URL域名
@property (nonatomic, assign) JHRequestHostType requestHostType;
@end

@implementation JHReqModel

- (void)setRequestSourceType:(JHRequestHostType)type
{
    _requestHostType = type;
}

- (NSString*)fullUrl
{
    if(self.requestHostType == JHRequestHostTypeSocial)
        return COMMUNITY_FILE_BASE_STRING([self uriPath]);
    else if(self.requestHostType == JHRequestHostTypeHtml5)
        return H5_BASE_STRING([self uriPath]);
    else if(self.requestHostType == JHRequestHostTypeDevDebuging)
        return DEV_DEBUG_HTTP_STRING([self uriPath]);
    else
        return FILE_BASE_STRING([self uriPath]);
}

- (NSString*)uriPath
{
    //子类重写,赋值具体请求url后半部分
    NSAssert(false, @"无效urlPath,请子类重写uriPath！！！");
    return @"/not url";
}

- (NSDictionary*)paramsDict
{
    return [self mj_keyValues];
}

- (NSString*)paramString
{
    return [self mj_JSONString];
}

@end
