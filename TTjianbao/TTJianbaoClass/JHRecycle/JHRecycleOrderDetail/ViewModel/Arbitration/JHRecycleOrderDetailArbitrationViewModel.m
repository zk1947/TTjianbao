//
//  JHRecycleOrderDetailArbitrationViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailArbitrationViewModel.h"

@interface JHRecycleOrderDetailArbitrationViewModel()

@end
@implementation JHRecycleOrderDetailArbitrationViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
        [self bindData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}

- (void)setupButtonListWithInfo : (JHRecycleOrderButtonInfo *)buttonInfo {
    [self.toolbarViewModel setupButtonListWithInfo:buttonInfo];
}
- (void)bindData {
    @weakify(self)
    [self.toolbarViewModel.clickEvent
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
         [self.clickEvent sendNext:x];
     }];
}
#pragma mark - Private Functions
- (void)setupData {
    self.cellType = RecycleOrderDetailArbitrationCell;
}
- (void)setupPriceText {
    
    NSDictionary *priceDict = @{NSForegroundColorAttributeName : HEXCOLOR(0xff4200),
                               NSFontAttributeName : [UIFont fontWithName:kFontNormal size:14]};
    NSDictionary *descDict = @{NSForegroundColorAttributeName : HEXCOLOR(0x666666),
                                  NSFontAttributeName : [UIFont fontWithName:kFontNormal size:12]};
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc]
                                          initWithString:@"达成交易价: "
                                          attributes:descDict];
    NSAttributedString *x = [[NSAttributedString alloc]
                                 initWithString:@"￥ "
                                 attributes:priceDict];
    NSAttributedString *price = [[NSAttributedString alloc]
                                 initWithString:self.price
                                 attributes:priceDict];
    [title appendAttributedString:x];
    [title appendAttributedString:price];
    self.attDescribeText = title;
    CGFloat height = 30;
    self.height += height;
    
}

// 设置高度 - 一般文本
- (void)setupHeight {
    CGFloat width = ScreenW - LeftSpace * 2 - ContentLeftSpace * 2;
    CGFloat height = [self.describeText heightForFont:[UIFont fontWithName:kFontNormal size:RecycleOrderDescribeFontSize] width:width];
    self.height = height + RecycleOrderNomalTopSpace + RecycleOrderNomalBottomSpace * 2 + RecycleOrderArbitrationToolbarHeight;
}
#pragma mark - Action functions
#pragma mark - Lazy

- (void)setDescribeText:(NSString *)describeText {
    _describeText = describeText;
    [self setupHeight];
}
- (void)setPrice:(NSString *)price {
    _price = price;
    [self setupPriceText];
}

- (JHRecycleOrderToolbarViewModel *)toolbarViewModel {
    if (!_toolbarViewModel) {
        _toolbarViewModel = [[JHRecycleOrderToolbarViewModel alloc] init];
    }
    return _toolbarViewModel;
}
@end
