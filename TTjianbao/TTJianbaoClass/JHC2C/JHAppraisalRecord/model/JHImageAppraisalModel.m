//
//  JHImageAppraisalModel.m
//  TTjianbao
//
//  Created by liuhai on 2021/6/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHImageAppraisalModel.h"


@implementation JHImageAppraisalRecordInfoModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"images":JHBaseImageModel.class
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

@implementation JHImageAppraisalModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"resultList":JHImageAppraisalRecordInfoModel.class
    };
}
@end
