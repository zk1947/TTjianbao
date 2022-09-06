//
//  JHAllowanceListModel.m
//  TTjianbao
//
//  Created by apple on 2020/2/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAllowanceListModel.h"

@implementation JHAllowanceListModel

-(void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues
{
    if ([_changeType isEqualToString:@"+"]) {
        _isGetMoney = YES;
    }else {
        _isGetMoney = NO;
    }
    
    if(_type && [_type isEqualToString:@"expiration"])
    {
        _isExpired = YES;
    }
    else
    {
        _isExpired = NO;
    }
        
}

@end
