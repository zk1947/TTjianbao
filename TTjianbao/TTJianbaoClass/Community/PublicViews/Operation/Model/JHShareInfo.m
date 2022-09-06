//
//  JHShareInfo.m
//  TTjianbao
//
//  Created by Jesse on 2020/10/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHShareInfo.h"

@implementation JHShareInfo

- (instancetype)init
{
    if(self = [super init])
    {
        self.shareType = -1;
    }
    return self;
}

- (void)setImg:(NSString *)img
{
    //url中文转码
    _img = [img stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
