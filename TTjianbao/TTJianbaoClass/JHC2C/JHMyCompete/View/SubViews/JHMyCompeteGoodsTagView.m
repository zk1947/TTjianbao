//
//  JHMyCompeteGoodsTagView.m
//  TTjianbao
//
//  Created by miao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCompeteGoodsTagView.h"
#import "UILabel+edgeInsets.h"

@implementation JHMyCompeteGoodsTagView

#pragma mark - Private Methods

+ (UILabel *)p_getCommonlable {
    UILabel *goodsTagLabel = [[UILabel alloc] init];
    goodsTagLabel.font = JHFont(10);
    goodsTagLabel.textColor = HEXCOLOR(0xF23730);
    [goodsTagLabel jh_cornerRadius:1.0 borderColor:HEXCOLOR(0xF23730) borderWidth:0.5];
    goodsTagLabel.edgeInsets = UIEdgeInsetsMake(1, 4, 1, 4);
    return goodsTagLabel;
}

#pragma mark - Public Method

- (void)reloadCompeteGoodsTagView:(NSArray <NSString *> *)titles {
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat sapce = 6.0;
    UILabel *beforeLabel;
    NSInteger actualNum = titles.count > 2 ? 2 : titles.count;
    for (NSInteger num = 0; num < actualNum; num++) {
        UILabel *goodslable = [JHMyCompeteGoodsTagView p_getCommonlable];
        [goodslable setText:[titles objectAtIndex:num]];
        [self addSubview:goodslable];
        [goodslable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            if (num == 0) {
                make.left.equalTo(self);
            }else {
                make.left.equalTo(beforeLabel.mas_right).offset(sapce);
            }
        }];
        beforeLabel = goodslable;
    }
    
}


@end
