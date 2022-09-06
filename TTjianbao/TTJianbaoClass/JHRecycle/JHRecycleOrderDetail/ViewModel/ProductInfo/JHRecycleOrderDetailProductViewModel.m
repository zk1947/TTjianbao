//
//  JHRecycleOrderDetailProductViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailProductViewModel.h"

@implementation JHRecycleOrderDetailProductViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Public Functions
- (void)setupPrice : (NSString *)price {
    if (price == nil) return;
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]
                                        initWithString:@"宝贝报价："
                                        attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontNormal size:13],
                                                     NSForegroundColorAttributeName : HEXCOLOR(0x333333)}];
    NSAttributedString *x = [[NSAttributedString alloc]
                             initWithString:@"¥ "
                             attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontBoldDIN size:13],
                                          NSForegroundColorAttributeName : HEXCOLOR(0xff4200)}];
    NSAttributedString *priceAtt = [[NSAttributedString alloc]
                                 initWithString:price
                                 attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontBoldDIN size:18],
                                              NSForegroundColorAttributeName : HEXCOLOR(0xff4200)}];
    [title appendAttributedString:x];
    [title appendAttributedString:priceAtt];
    self.priceText = title;
    
}
#pragma mark - Private Functions
- (void)setupData {
    self.cellType = RecycleOrderDetailProductCell;
    self.height = 168;
}
#pragma mark - Action functions
#pragma mark - Lazy
- (void)setTitleText:(NSString *)titleText {
    _titleText = [NSString stringWithFormat:@"回收商家: %@", titleText];
}
- (void)setSortText:(NSString *)sortText {
    _sortText = [NSString stringWithFormat:@"回收分类: %@", sortText];
}
- (void)setDetailText:(NSString *)detailText {
    _detailText = [NSString stringWithFormat:@"回收说明: %@", detailText];
}
@end
