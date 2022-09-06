//
//  JHNewShopUserCommentModel.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopUserCommentModel.h"

@implementation JHNewShopUserCommentListModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"commentID" : @"id"};
}

- (void)setCellHeight:(CGFloat)cellHeight{

}

- (CGFloat)getMaxHeightWithString:(NSString *)str width:(CGFloat)width font:(UIFont *)font{
    return [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
}
@end

@implementation JHNewShopUserCommentModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"commentList" : @"JHNewShopUserCommentListModel",
    };
}
@end
