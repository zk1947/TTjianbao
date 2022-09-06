//
//  JHPriceWrapper.m
//  TTjianbao
//  Description:价格与人民币符号调整
//  Created by jesee on 16/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPriceWrapper.h"
#import "NSString+Common.h"

#define kListSignFontSize 11
#define kListPartFontSize 17
#define kDetailSignFontSize 18
#define kDetailPartFontSize 24

@implementation JHPriceWrapper

- (NSMutableAttributedString*)showPrice
{
    NSMutableAttributedString* price = [[NSMutableAttributedString alloc] initWithString:@""];
    if(![NSString isEmpty:self.priceSign] && ![NSString isEmpty:self.pricePart])
    {
        price = [self makeAttributedString];
    }
    return price;
}

- (NSMutableAttributedString*)makeAttributedString
{
    NSString *price = [NSString stringWithFormat:@"%@%@", self.priceSign, self.pricePart];
    if(![NSString isEmpty:self.priceFraction])
    {
        price = [price stringByAppendingString: self.priceFraction];
    }
    NSInteger signFontSize = kListSignFontSize, partFontSize = kListPartFontSize;
    if(self.showStyle == JHPriceShowStyleDetail)
    {
        signFontSize = kDetailSignFontSize;
        partFontSize = kDetailPartFontSize;
    }
    else
    {
        signFontSize = kListSignFontSize;
        partFontSize = kListPartFontSize;
    }
    CGFloat fontRatio = 0.26;//基线偏移比率，默认底部对齐
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:price];
    //￥
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(fontRatio * (partFontSize - signFontSize)) range:NSMakeRange(0, self.priceSign.length)]; //位置
    [attributedString addAttributes:@{NSFontAttributeName:JHFont(signFontSize),
                                      NSForegroundColorAttributeName:HEXCOLOR(0xFC4200)} range:NSMakeRange(0, self.priceSign.length)];
    //整数部分
    [attributedString addAttributes:@{NSFontAttributeName: JHFont(partFontSize),
                                      NSForegroundColorAttributeName:HEXCOLOR(0xFC4200)} range:NSMakeRange(self.priceSign.length, self.pricePart.length)];
    //小数点及小数部分
    if(![NSString isEmpty:self.priceFraction])
    {
        [attributedString addAttributes:@{NSFontAttributeName: JHFont(signFontSize),
                                          NSForegroundColorAttributeName:HEXCOLOR(0xFC4200)} range:NSMakeRange(self.priceSign.length + self.pricePart.length, self.priceFraction.length)];
    }
    
    return attributedString;
}

@end
