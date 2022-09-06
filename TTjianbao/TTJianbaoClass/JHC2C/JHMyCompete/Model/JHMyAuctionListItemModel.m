//
//  JHMyAuctionListItemModel.m
//  TTjianbao
//
//  Created by zk on 2021/9/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyAuctionListItemModel.h"

@implementation JHMyAuctionListItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
   return @{
       @"productName":@"productDesc"
   };
}

- (NSString *)num {
    if (isEmpty(_num)) {
        return _priceNumber;
    }
    return _num;
}

- (NSInteger)productType{
    return 1;
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
    ///按钮
    if (self.immediatePaymentHidden == NO || self.auctionStatus == 2 || self.auctionStatus == 3 || self.auctionStatus == 4 || self.auctionStatus == 7) {
        needHeight += (7.f + 28.f);
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

- (BOOL)auctionStatusViewHidden {
    if (self.auctionStatus == 2 ||
        self.auctionStatus == 3 ||
        self.auctionStatus == 4 ||
        self.auctionStatus == 7) {
        return NO;
    }
    return YES;
}

- (NSAttributedString *)auctionStatusText {
    
    NSString *title = @"";
    NSString *dec = @"";
    // 0无状态 1 失效 2出局 3领先 4中拍 5:已结束 6:已下架
    if (self.auctionStatus == 2) {
        if (self.productAuctionStatus == 1) {
//            dec = @"再出价";
            dec = @"";
        }else {
            dec = @"";
        }
        title = @"出局";
    } else if (self.auctionStatus == 3) {
        title = @"领先";
    } else if (self.auctionStatus == 4) {
        title = @"成交";
    } else if (self.auctionStatus == 7) {
        title = @"待出价";
    }
    NSDictionary *dic = @{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:14.0f]};
    NSDictionary *dict = @{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:11.0f]};
    
    NSMutableAttributedString *muta = [[NSMutableAttributedString alloc] initWithString:title attributes:dic];
    if (dec.length > 0) {
        NSMutableAttributedString *cr = [[NSMutableAttributedString alloc] initWithString: @"\n"];
        
        NSMutableAttributedString *adec = [[NSMutableAttributedString alloc] initWithString:dec attributes:dict];
        
        [muta appendAttributedString:cr];
        [muta appendAttributedString:adec];
    }
    
    return muta;
}

- (UIColor *)auctionStatusBackgroundColor {
    
    return self.auctionStatus == 3 || self.auctionStatus == 4 ?  HEXCOLORA(0xFF6A00, 0.8) : HEXCOLORA(0x000000, 0.5);
}

@end
