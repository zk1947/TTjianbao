//
//  JHStoreDetailShopItemViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailShopItemViewModel.h"

@implementation JHStoreDetailShopItemViewModel
#pragma mark - Life Cycle Functions
+ (CGFloat)getItemHeight {
    NSInteger itemWidth = (ScreenW - (LeftSpace * 2) - (shopItemSpace * 3)) / 4 - 1;
   
    return itemWidth + shopItemTitleTop + shopItemTitleHeight + shopItemPriceTop + shopItemPriceHeight;
}
- (instancetype)init{

    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
- (void)setupPrice : (NSString *)price {
    NSInteger itemWidth = (ScreenW - (LeftSpace * 2) - (shopItemSpace * 3)) / 4 - 1;
    self.width = itemWidth;
    self.height = itemWidth + shopItemTitleTop + shopItemTitleHeight + shopItemPriceTop + shopItemPriceHeight;
    
    if (!price) { return ;}
    
    NSMutableAttributedString *attPrice = [[NSMutableAttributedString alloc] initWithString:price attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}];
    
    NSAttributedString *xx = [[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]}];
    [attPrice insertAttributedString:xx atIndex:0];
    self.priceText = attPrice;
}
#pragma mark - Private Functions

#pragma mark - Action functions
#pragma mark - Lazy
- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    
}

@end
