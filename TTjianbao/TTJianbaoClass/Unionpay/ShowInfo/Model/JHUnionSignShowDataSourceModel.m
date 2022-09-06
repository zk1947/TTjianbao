//
//  JHUnionSignShowDataSourceModel.m
//  TTjianbao
//
//  Created by apple on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionSignShowDataSourceModel.h"

@implementation JHUnionSignShowDataSourceModel

-(void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues{
    self.isPerson = NO;
    if(_customerType && [_customerType isEqualToString:@"02"]){
        self.isPerson = YES;
    }
}

@end
