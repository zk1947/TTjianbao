//
//  JHBusinesspublishModel.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinesspublishModel.h"
@implementation JHBusinesspublishImageModel
@end
@implementation JHBusinesspublishModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"detailImages" : [JHIssueGoodsEditImageItemModel class],
        @"mainImages" : [JHIssueGoodsEditImageItemModel class],
        @"attrs" : [JHBusinessGoodsAttributeModel class]
    };
}

@end
