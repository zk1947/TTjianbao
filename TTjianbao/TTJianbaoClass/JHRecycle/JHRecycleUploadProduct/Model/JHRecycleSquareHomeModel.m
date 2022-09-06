//
//  JHRecycleSquareHomeModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleSquareHomeModel.h"

@implementation JHRecycleSquareHomeListModel

- (CGFloat)imageHeight{
    CGFloat wide = (ScreenWidth - 24 - 5)/2.0;
    CGFloat height = 173;
    if (self.productImage.w.doubleValue > 0 && self.productImage.h.doubleValue > 0) {
        height = wide/self.productImage.w.doubleValue * self.productImage.h.doubleValue;
    }
    return height;
}

- (CGFloat)desHeight{
    CGFloat wide = (ScreenWidth - 24 - 5 - 32)/2.0;
    CGFloat height = [self.showProductDesc  boundingRectWithSize:CGSizeMake(wide, CGFLOAT_MAX)
                                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                                       attributes:@{NSFontAttributeName :JHFont(12)}
                                                                          context:nil].size.height;
    return fmin(ceil(height), 34.0);
}

- (NSString *)showCategoryName{
    return [NSString stringWithFormat:@"回收分类：%@",self.categoryName];
}

- (NSString *)showProductDesc{
    return [NSString stringWithFormat:@"回收说明：%@",self.productDesc];
}

@end

@implementation JHRecycleSquareHomeModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"resultList" : JHRecycleSquareHomeListModel.class};
}

@end
