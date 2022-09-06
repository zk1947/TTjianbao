//
//  JHC2CGoodsListModel.m
//  TTjianbao
//
//  Created by hao on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CGoodsListModel.h"

///运营位栏位列表
@implementation JHC2CSearchPositionTargetModel
@end
@implementation JHC2COperatingPositionListModel
- (void)setLandingTarget:(NSString *)landingTarget {
    _landingTarget = landingTarget;
    NSDictionary *dic = [_landingTarget mj_JSONObject];
    _target = [JHC2CSearchPositionTargetModel mj_objectWithKeyValues:dic];
}
@end


@implementation JHC2CGoodsImageInfoModel
- (CGFloat)goodsImgHeight {
    if (self.w <= 0 || self.h <= 0) {
        if (self.medium.length > 0) {
            return [self imageNeedWidth];
        }else{
            return 0.f;
        }
    }
    CGFloat whRatio = [self.w doubleValue] / [self.h doubleValue];
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
    return (ScreenW - 11.f*3)/2.f;
}

- (CGFloat)aNewHeight {
    if (self.w.doubleValue <= 0 || self.h.doubleValue <= 0) {
        return 0.f;
    }
    if (self.w.doubleValue == self.h.doubleValue) {
        return [self imageNeedWidth];
    }
    CGFloat whRatio = (self.w.doubleValue / self.h.doubleValue);
    whRatio = [[NSString stringWithFormat:@"%.2f", whRatio] floatValue];
    if (whRatio >= 1) {
        return [self imageNeedWidth];
    } else if (whRatio < 0.75) {
        return [self imageNeedWidth]*4/3;
    } else {
        return [self imageNeedWidth]/whRatio;
    }
}


@end

///商品列表
@implementation JHC2CProductBeanListModel
- (CGFloat)sellerItemHeight {
    if (!self.images) {
        return 0.f;
    }
    CGFloat needHeight = 0.f;
    /// 图片
    needHeight += self.images.aNewHeight;
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
- (CGFloat)itemHeight {
    CGFloat cellHeight = 0.f;
    /// 图片
    cellHeight += self.images.goodsImgHeight;
    /// 标题
    if (!isEmpty(self.productDesc)) {
        NSString *nullStr = @"";
        if (self.auctionStatus == 1) {
            nullStr = @"          ";//拍卖中占位空格
        }
        CGSize size = [self calculationTextWidthWithWidth:([self imageNeedWidth]-12.f) string:[NSString stringWithFormat:@"%@%@",nullStr, self.productDesc] font:JHFont(14)];
        if (size.height > 20.f) {
            cellHeight += (8.f + 40.f);
        } else {
            cellHeight += (8.f + 20.f);
        }
    }
    /// 标签
    if (self.needFreight == 0 || self.auctionEndStatus == 1) {
        cellHeight += (6.f + 16.f);
    }
    /// 价格
    cellHeight += (6.f + 21.f);
    /// 用户
    cellHeight += (11.f + 14.f + 10.f);

    return cellHeight;
}

///价格处是否一行显示
- (BOOL)isOnelineOfMoney{
    //价格
    CGSize moneySize = [self calculationTextWidthWithWidth:CGFLOAT_MAX string:self.price.length>0 ? self.price : @"" font:JHDINBoldFont(18)];
    //出价次数
    NSString *bidNumStr;
    if ([self.num floatValue] > 9999) {
        bidNumStr = [NSString stringWithFormat:@"已出价%.1fw次",[self.num floatValue]/10000];
    }else{
        bidNumStr = [NSString stringWithFormat:@"已出价%@次",self.num];
    }
    CGSize bidNumSize = [self calculationTextWidthWithWidth:CGFLOAT_MAX string:bidNumStr font:JHFont(10)];

    if (moneySize.width + bidNumSize.width > ([self imageNeedWidth]-25)) {
        return NO;
    }
    return YES;
}

///用户信息处是否一行显示
- (BOOL)isOnelineOfUserInfo{
    //名字
    NSString *nameStr = self.name.length > 5 ? [NSString stringWithFormat:@"%@…",[self.name substringToIndex:5]] : self.name;
    CGSize nameSize = [self calculationTextWidthWithWidth:CGFLOAT_MAX string:nameStr font:JHFont(10)];
    //想要人数
    NSString *wantNumStr;
    if ([self.wantCount floatValue] > 9999) {
        wantNumStr = [NSString stringWithFormat:@"%.1fw人想要",[self.wantCount floatValue]/10000];
    }else{
        wantNumStr = [NSString stringWithFormat:@"%@人想要",self.wantCount];
    }
    CGSize wantNumSize = [self calculationTextWidthWithWidth:CGFLOAT_MAX string:wantNumStr font:JHFont(10)];

    if (nameSize.width + wantNumSize.width > ([self imageNeedWidth]-35)) {
        return NO;
    }
    return YES;
}


- (CGSize)calculationTextWidthWithWidth:(CGFloat)width string:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}

- (CGFloat)imageNeedWidth {
    return (ScreenW - 11.f*3)/2.f;
}

- (NSString *)jhPrice {
    return self.price;
}

- (NSString *)jhShowPrice {
    return self.showPrice;
}


@end


@implementation JHC2CGoodsListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"operationDefiniDetailsResponses" : [JHC2COperatingPositionListModel class],
        @"productListBeanList" : [JHC2CProductBeanListModel class],
    };
}
@end
