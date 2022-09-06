//
//  JHStoreDetailCouponListCellViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCouponListCellViewModel.h"

@implementation JHStoreDetailCouponListCellViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Private Functions
- (void)setupData{
    self.cellType = CouponCell;
    self.height = 74;
}
- (void)setSaleMoney : (NSString *)money {
    if (money == nil || money.length <= 0) { return; }
    
    NSString *newMoney = [NSString stringWithFormat:@"%@", money];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]initWithString:newMoney attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:30]}];
    
    NSAttributedString *disCount = [[NSAttributedString alloc] initWithString:@"折" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
    [text appendAttributedString:disCount];
    self.moneyText = text;
}
- (void)setMoney : (NSString *)money {
    if (money) {
        NSMutableAttributedString *attPrice = [[NSMutableAttributedString alloc] initWithString:money attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:30]}];
        
        NSAttributedString *xx = [[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]}];
        [attPrice insertAttributedString:xx atIndex:0];
        self.moneyText = attPrice;
    }
}
- (void)setDate : (NSString *)start endDate : (NSString *)end {
    if (start == nil || end == nil) { return; }
    self.dateText = [NSString stringWithFormat:@"%@ - %@",start, end];
}
- (void)setDateWithDay : (NSString *)day {
    self.dateText = [NSString stringWithFormat:@"自领取之日起%@天内有效", day];
}
#pragma mark - Action functions
#pragma mark - Lazy


- (RACSubject *)receiveAction {
    if (!_receiveAction) {
        _receiveAction = [RACSubject subject];
    }
    return _receiveAction;
}
- (void)setMoneyRuleText:(NSString *)moneyRuleText {
    _moneyRuleText = moneyRuleText;
}
- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
}

@end
