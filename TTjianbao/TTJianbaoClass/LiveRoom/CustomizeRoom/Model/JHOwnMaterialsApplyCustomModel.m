//
//  JHOwnMaterialsApplyCustomModel.m
//  TTjianbao
//
//  Created by apple on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOwnMaterialsApplyCustomModel.h"

@implementation JHOwnMaterialsImageInfo
@end

@implementation JHOwnMaterialsApplyCustomModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _materialList = [NSMutableArray new];
    }
    return self;
}
//+ (NSDictionary *)mj_replacedKeyFromPropertyName {
//    return @{
//        @"resourceData" : @"resource_data"
//    };
//}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"materialList":[JHOwnMaterialsImageInfo class]
            };
}
@end
