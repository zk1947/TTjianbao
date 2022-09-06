//
//  JHStoreSnapShootPriceViewModel.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreSnapShootPriceViewModel.h"
#import "NSString+AttributedString.h"
@implementation JHStoreSnapShootPriceViewModel
#pragma mark - Private Functions
/// 设置金额
- (void)setupPriceWithSalePrice : (NSString *)salePrice
                          price : (NSString *)price
                       discount : (NSString *)discount {
    
    if (salePrice) {
      
        NSString * moneyString=[@"" stringByAppendingString:[NSString stringWithFormat:@"%@",salePrice ]];
        
        NSRange range = [moneyString rangeOfString:@"."];
        if (range.length) {
            range = NSMakeRange(range.location, moneyString.length - range.location);
        }
        NSMutableAttributedString *attPrice=[moneyString attributedFont:[UIFont fontWithName:kFontNormal size:12] color:kColorMainRed range:range];
        
        NSAttributedString *xx = [[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
        
        [ attPrice insertAttributedString:xx atIndex:0];
        
        self.salePriceText = attPrice;
        
    }
}
@end
