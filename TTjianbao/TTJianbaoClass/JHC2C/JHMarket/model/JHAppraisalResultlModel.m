//
//  JHAppraisalResultlModel.m
//  TTjianbao
//
//  Created by 张坤 on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAppraisalResultlModel.h"

@implementation JHAppraisalResultlModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"attrs" : [JHAppraisalAttrsResultlModel class],
    };
}
@end

@implementation JHAppraisalAttrsResultlModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"attrValues" : [JHAppraisalAttrValuesModel class],
    };
}

@end

@implementation JHAppraisalAttrValuesModel

@end
