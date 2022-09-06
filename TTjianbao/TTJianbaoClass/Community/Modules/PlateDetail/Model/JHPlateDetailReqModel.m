//
//  JHPlateDetailReqModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateDetailReqModel.h"

@implementation JHPlateDetailBaseReqModel

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setRequestSourceType:JHRequestHostTypeSocial];
    }
    return self;
}

- (NSString *)uriPath
{
    return @"/v2/content/channel";
}

@end


@implementation JHPlateDetailListReqModel

- (NSString *)uriPath
{
    return @"/v2/content/list";
}

@end

///版块关注
@implementation JHPlateDetailFocusReqModel
- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self setRequestSourceType:JHRequestHostTypeSocial];
    }
    return self;
}
@end
