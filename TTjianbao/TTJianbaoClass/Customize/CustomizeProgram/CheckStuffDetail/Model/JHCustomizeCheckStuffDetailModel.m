//
//  JHCustomizeCheckStuffDetailModel.m
//  TTjianbao
//
//  Created by user on 2020/12/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckStuffDetailModel.h"

@implementation JHCustomizeCheckStuffDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id"
    };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"materialList" : [JHCustomizeCheckStuffDetailPictsModel class]
    };
}

@end



@implementation JHCustomizeCheckStuffDetailPictsModel

@end
