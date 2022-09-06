//
//  JHStoreDetailShopTitleViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailShopTitleViewModel.h"

@implementation JHStoreDetailShopTitleViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
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
- (void)setupData {
    self.cellType = ShopTitleCell;
    self.height = 146;
    self.totalScore = @"5.0";
}
#pragma mark - Action functions

#pragma mark - Lazy

- (NSAttributedString *)praiseTextAtt{
    if (self.praiseText.length) {
        UIFont *font = [UIFont fontWithName:kFontBoldDIN size:22];
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.praiseText
                                                                                attributes:@{NSFontAttributeName : font,NSForegroundColorAttributeName :HEXCOLOR(0x333333)}];
        [att appendAttributedString:[[NSAttributedString alloc] initWithString:@" %"
                                                                    attributes:@{NSFontAttributeName : [UIFont fontWithName:kFontBoldDIN size:13],NSForegroundColorAttributeName :HEXCOLOR(0x333333)}]];
        return att.copy;
    }
    return nil;
}

- (RACReplaySubject *)goShopTextSubject {
    if (!_goShopTextSubject) {
        _goShopTextSubject = [RACReplaySubject subject];
        [_goShopTextSubject sendNext:@"进入店铺"];
    }
    return _goShopTextSubject;
}
- (RACSubject *)focusAction {
    if (!_focusAction) {
        _focusAction = [RACSubject subject];
    }
    return _focusAction;
}

- (RACSubject *)goShopBtnAction {
    if (!_goShopBtnAction) {
        _goShopBtnAction = [RACSubject subject];
    }
    return _goShopBtnAction;
}
@end
