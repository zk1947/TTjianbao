//
//  JHRecycleUploadExampleModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleUploadExampleModel.h"

@implementation JHRecycleUploadExampleModel

@end

@implementation JHRecycleUploadExampleTotalModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"singleImgSimples": JHRecycleUploadExampleModel.class,
             @"multiImgSimples": JHRecycleUploadExampleModel.class
    };
}

@end



