//
//  JHBillDetailModel.m
//  TTjianbao
//
//  Created by apple on 2019/12/18.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillDetailModel.h"

@implementation JHBillDetailModel

-(void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues
{
    self.changeMoneyStr = [NSString stringWithFormat:@"%@￥%.2f",NONNULL_STR(self.sign),self.changeMoney];
//    self.flowDate = [self.flowDate substringToIndex:10];
}

@end
