//
//  JHCustomerDescInProcessModel.m
//  TTjianbao
//
//  Created by user on 2020/11/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerDescInProcessModel.h"

@implementation JHAttachmentVOModel
@end

@implementation JHCustomizeDetailVOModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"materialAttachments" : [JHAttachmentVOModel class],
        @"worksAttachments" : [JHAttachmentVOModel class],
        @"customizeCommentVOS":[JHCustomizeCommentInfoVOModel class]
    };
}
@end

@implementation JHCustomerDetailVOInfoShareDataModel

@end



@implementation JHCustomizeCommentItemVOSModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"commentItemImgList" : [JHCustomizeCommentPublishImgList class]
    };
}

@end

@implementation JHCustomizeCommentPublishImgList
@end

@implementation JHCustomizeCommentInfoVOModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"customizeCommentItemVOS" : [JHCustomizeCommentItemVOSModel class],
        @"publishImgList" : [JHCustomizeCommentPublishImgList class]
    };
}

@end



@implementation JHCustomizeCommentRequestModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"imgList" : [JHAttachmentVOModel class]
    };
}
@end
