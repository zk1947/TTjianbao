//
//  JHRushPurChaseCellViewModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRushPurChaseCellViewModel.h"

@implementation JHRushPurChaseCellViewModel

+ (JHRushPurChaseCellViewModel *)rushPurChaseCellViewModelWithModel:(JHRushPurChaseSeckillProductInfoModel *)model{
    JHRushPurChaseCellViewModel *viewModel = [JHRushPurChaseCellViewModel new];
    viewModel.currentPriceAtt = [self attStrCurrentPriceWithStr:model.productSeckillPrice];
    viewModel.basePriceAtt = [self attStrBasePriceWithStr:model.productOriginalPrice];
    viewModel.leftImageUrl = model.mainImageUrl.middleUrl;
    viewModel.title = model.productName;
    viewModel.status = model.btnType;
    viewModel.productTagList = model.productTagList;
    viewModel.seckillProgress = model.seckillProgress;
    viewModel.productId = @(model.productId).stringValue;

    viewModel.saveMoney = model.saveMoney;

    viewModel.sellStock = model.sellStock;

    
    return viewModel;
}



+ (NSAttributedString*)attStrCurrentPriceWithStr:(NSString*)price{
    NSMutableAttributedString *attPrice = [[NSMutableAttributedString alloc] initWithString:price
                                                                                 attributes:@{NSFontAttributeName : JHDINBoldFont(21), NSBaselineOffsetAttributeName : @-2}];
    NSAttributedString *xx = [[NSAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName : JHFont(12)}];
    [attPrice insertAttributedString:xx atIndex:0];
    return attPrice;
}


+ (NSAttributedString*)attStrBasePriceWithStr:(NSString*)price{
    NSString *baseStr = [NSString stringWithFormat:@"￥%@ ", price];
    NSMutableAttributedString *attPrice = [[NSMutableAttributedString alloc] initWithString:baseStr attributes:@{
        NSFontAttributeName : JHFont(10), NSStrikethroughStyleAttributeName : @(NSUnderlinePatternSolid | NSUnderlineStyleSingle), NSForegroundColorAttributeName : HEXCOLOR(0xF7EDD4)}];
    [attPrice addAttributes:@{NSStrikethroughStyleAttributeName : @(NSUnderlinePatternSolid | NSUnderlineStyleSingle)} range:NSMakeRange(0, attPrice.length)];
    return attPrice;
}

@end
