//
//  JHRecycleOrderDetailStatusTitleViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailStatusTitleViewModel.h"
#import "JHRecycleOrderDetailStatusManager.h"
@interface JHRecycleOrderDetailStatusTitleViewModel()
/// 订单状态
@property (nonatomic, strong) JHRecycleOrderDetailStatusManager *statusManager;

@end

@implementation JHRecycleOrderDetailStatusTitleViewModel
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

#pragma mark - Private Functions
- (void)setupData {
    self.cellType = RecycleOrderDetailStatusTitleCell;
    self.height = 32;
}
#pragma mark - Action functions
- (void)setupOrderStatusText {
    [self.statusManager setupOrderStatus:self.orderStatus];
    
    self.orderTitleStatus = self.statusManager.orderTitleStatus;
    self.statusText = self.statusManager.statusText;
    self.iconUrl = self.statusManager.iconUrl;
}
- (void)setupPrice : (NSString *)price originalPrice : (NSString *)originalPrice {
    
    if (price == nil) { return; }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]
                             initWithString:@"¥ "
                             attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontMedium size:14],
                                          NSForegroundColorAttributeName : HEXCOLOR(0xff4200)}];
    
    NSAttributedString *priceAtt = [[NSAttributedString alloc]
                                           initWithString:price
                                           attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontMedium size:14],
                                                        NSForegroundColorAttributeName : HEXCOLOR(0xff4200)}];
    
    NSString *newOriginal = [NSString stringWithFormat:@" (首次报价¥%@)", originalPrice];
    NSAttributedString *originalPriceAtt = [[NSAttributedString alloc]
                                            initWithString:newOriginal
                                            attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontNormal size:12],
                                                         NSForegroundColorAttributeName : HEXCOLOR(0x999999)}];
    
    [att appendAttributedString:priceAtt];
    [att appendAttributedString:originalPriceAtt];
    
    self.priceText = att;
    
}
- (void)setupPriceText {
    
}
#pragma mark - Lazy
- (void)setOrderStatus:(RecycleOrderStatus)orderStatus {
    _orderStatus = orderStatus;
    [self setupOrderStatusText];
}
- (JHRecycleOrderDetailStatusManager *)statusManager {
    if (!_statusManager) {
        _statusManager = [[JHRecycleOrderDetailStatusManager alloc] init];
    }
    return _statusManager;
}
@end
