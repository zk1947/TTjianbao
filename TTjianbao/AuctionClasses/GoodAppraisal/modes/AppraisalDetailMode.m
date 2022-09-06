//
//  AppraisalDetailMode.m
//  TTjianbao
//
//  Created by jiangchao on 2019/1/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "AppraisalDetailMode.h"
#import "ApprailsaiDetailAnchorMode.h"

@implementation AppraisalDetailMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ApprailsaiDetailAnchorMode" : @"appraiser",
             };
}

@end
