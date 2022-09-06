//
//  JHMyShopModel.m
//  TTjianbao
//
//  Created by apple on 2019/12/18.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMyShopModel.h"

@implementation JHMyShopAccountModel

@end

@implementation JHMyShopModel

-(void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues{
    if(self.accountDate && self.accountDate.length > 10){
        self.accountDate = [self.accountDate substringToIndex:10];
    }
}

@end

