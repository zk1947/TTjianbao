//
//  JHCustomerAddCommentModel.m
//  TTjianbao
//
//  Created by user on 2020/11/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerAddCommentModel.h"

@implementation JHCustomerAddCommentAttachmentVOModel
@end



@implementation JHCustomerAddCommentModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"imgList" : [JHCustomerAddCommentAttachmentVOModel class]
    };
}

@end
