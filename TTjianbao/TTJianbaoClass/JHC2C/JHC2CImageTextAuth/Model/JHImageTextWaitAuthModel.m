//
//  JHImageTextWaitAuthModel.m
//  TTjianbao
//
//  Created by zk on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageTextWaitAuthModel.h"

@implementation JHImageTextWaitAuthModel

@end

@implementation JHImageTextWaitAuthListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"resultList" : [JHImageTextWaitAuthListItemModel class]
    };
}
@end

@implementation JHImageTextWaitAuthListItemModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"images" : [JHImageTextWaitAuthListItemsImageModel class]
    };
}

- (CGFloat)cellHeight{
    CGSize size = [self calculationTextWidthWithWidth:(kScreenWidth-44.f) string:self.productDesc font:JHFont(14)];
    return size.height + 230;
}

- (CGSize)calculationTextWidthWithWidth:(CGFloat)width string:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}


@end

@implementation JHImageTextWaitAuthListItemsImageModel

@end

@implementation JHImageTextWaitAuthDetailModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"images" : [JHImageTextWaitAuthDetailImageModel class],
        @"videos" : [JHImageTextWaitAuthDetailVideoModel class]
    };
}

- (CGFloat)cellHeight{
    CGSize size = [self calculationTextWidthWithWidth:(kScreenWidth-24.f) string:self.productDesc font:JHFont(16)];
    return size.height + 88;
}

- (CGSize)calculationTextWidthWithWidth:(CGFloat)width string:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}
@end

@implementation JHImageTextWaitAuthDetailImageModel
- (CGFloat)cellHeight{
    if ([self.h floatValue] != 0 && [self.w floatValue] != 0) {
        return [self.h floatValue]/[self.w floatValue]*(kScreenWidth-24.f);
    }else{
        return 0;
    }
}
@end

@implementation JHImageTextWaitAuthDetailVideoModel
- (CGFloat)cellHeight{
    return 9.0/16.0*(kScreenWidth-24.f);
}
@end


