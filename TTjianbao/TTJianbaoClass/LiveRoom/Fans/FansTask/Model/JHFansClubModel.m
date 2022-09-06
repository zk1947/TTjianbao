//
//  JHFansClubModel.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansClubModel.h"

@implementation JHFansClubModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"taskVos": @"JHFansTaskModel"
    };
}

- (CGFloat)freezeUnfloderHeight{
    if (!self.freezeExpDesc.length) {return 0.f;}
    CGFloat height =  29.f;
    if (self.isUnFlod) {
        ///计算
         CGFloat wide = kScreenWidth - 30.f - 16.f;
         CGSize size = [self.freezeExpDesc boundingRectWithSize:CGSizeMake(wide, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:
                        @{NSFontAttributeName : JHFont(12)} context:nil].size;
        height = size.height + 35.f;
    }
    return height;
}

@end

@implementation JHFansTaskModel

@end
