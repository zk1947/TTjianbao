//
//  JHNewStoreHomeModel.m
//  TTjianbao
//
//  Created by user on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeModel.h"

/// 专场
@implementation JHNewStoreHomeBoutiqueModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"showList" : [JHNewStoreHomeBoutiqueShowListModel class],
    };
}
@end


@implementation JHNewStoreHomeBoutiqueShowListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"productList" : [JHNewStoreHomeBoutiqueShowListProductList class],
        @"tags" : [NSString class]
    };
}
@end


@implementation JHNewStoreHomeBoutiqueShowListProductList
@end



@implementation JHNewStoreHomeShareInfoModel
@end


/// 商品
@implementation JHNewStoreHomeGoodsTabInfoModel

@end

@implementation JHNewStoreHomeGoodsProductListModel
- (NSString *)num {
    if (isEmpty(_num)) {
        return _priceNumber;
    }
    return _num;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"productTagList" : [NSString class]
    };
}

- (CGFloat)itemHeight {
    if (!self.coverImage) {
        return 0.f;
    }
    CGFloat needHeight = 0.f;
    /// 图片
    needHeight += self.coverImage.aNewHeight;
    /// 标题
    if (!isEmpty(self.productName)) {
        CGSize size = [self calculationTextWidthWithWidth:([self imageNeedWidth] - 16.f) string:self.productName font:[UIFont fontWithName:kFontBoldDIN size:14.f]];
        if (size.height > 18.f) {
            needHeight += (10.f + 40.f);
        } else {
            needHeight += (10.f + 20.f);
        }
    }
    /// 标签
    if (self.productTagList.count >0) {
        needHeight += (5.f + 14.f);
    }
    /// 价格
    needHeight += (6.f + 21.f);
    /// 横线
    needHeight += (8.f + 0.5f);
    /// 专场
    if (!isEmpty(self.showName)) {
        needHeight += (6.f + 31.f);
    } else {
        needHeight += 8.f;
    }
    return needHeight;
}

- (CGSize)calculationTextWidthWithWidth:(CGFloat)width string:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}

- (CGFloat)imageNeedWidth {
    return (ScreenW - 12.f*2 - 9.f)/2.f;
}

- (NSString *)jhPrice {
    return self.price;
}

- (NSString *)jhShowPrice {
    return self.showPrice;
}

@end

@implementation JHNewStoreHomeGoodsImageInfoModel
- (CGFloat)aNewHeight {
    if (self.width <= 0 || self.height <= 0) {
        return 0.f;
    }
    if (self.width == self.height) {
        return [self imageNeedWidth];
    }
    CGFloat whRatio = (self.width / self.height);
    whRatio = [[NSString stringWithFormat:@"%.2f", whRatio] floatValue];
    if (whRatio >= 1) {
        return [self imageNeedWidth];
    } else if (whRatio < 0.75) {
        return [self imageNeedWidth]*4/3;
    } else {
        return [self imageNeedWidth]/whRatio;
    }
}

- (CGFloat)imageNeedWidth {
    return (ScreenW - 12.f*2 - 9.f)/2.f;
}

@end


@implementation JHNewStoreHomeGoodsListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"productList" : [JHNewStoreHomeGoodsProductListModel class],
        @"recommendTabList": [JHNewStoreHomeGoodsTabInfoModel class]
    };
}
@end



/// 秒杀
@implementation JHNewStoreHomeKillActivityModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"productPageResult" : [JHNewStoreHomeKillActivityPageItemModel class]
    };
}
@end

@implementation JHNewStoreHomeKillActivityPageItemModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"productTagList" : [NSString class]
    };
}
@end





@implementation JHNewStoreHomeKillActivityPageItemImageModel
@end
