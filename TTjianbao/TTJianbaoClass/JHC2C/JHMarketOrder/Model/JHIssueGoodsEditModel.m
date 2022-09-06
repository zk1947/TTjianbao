//
//  JHIssueGoodsEditModel.m
//  TTjianbao
//
//  Created by zk on 2021/8/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIssueGoodsEditModel.h"

@implementation JHIssueGoodsEditModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"mainImageUrl" : [JHIssueGoodsEditImageItemModel class],
        @"detailImages" : [JHIssueGoodsEditImageItemModel class],
    };
}

@end

@implementation JHIssueGoodsEditImageItemModel

@end

