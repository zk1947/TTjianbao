//
//  JHTitleImageBackgroundView.m
//  TTjianbao
//
//  Created by lihui on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTitleImageBackgroundView.h"
#import "JHTItleImageBackgroundCell.h"
#import "JXTitleImageBackgroundCellModel.h"

@implementation JHTitleImageBackgroundView
- (void)initializeData {
    [super initializeData];

    self.cellWidthIncrement = 20;
    self.normalBackgroundColor = [UIColor lightGrayColor];
    self.normalBorderColor = [UIColor clearColor];
    self.selectedBackgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    self.selectedBorderColor = HEXCOLOR(0xFEE100);
    self.borderLineWidth = 1;
    self.backgroundCornerRadius = 13;
    self.backgroundWidth = JXCategoryViewAutomaticDimension;
    self.backgroundHeight = 26;
}

//返回自定义的cell class
- (Class)preferredCellClass {
    return [JHTItleImageBackgroundCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        JXTitleImageBackgroundCellModel *cellModel = [[JXTitleImageBackgroundCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(JXCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];
    JXTitleImageBackgroundCellModel *myModel = (JXTitleImageBackgroundCellModel *)cellModel;
    myModel.normalBackgroundColor = self.normalBackgroundColor;
    myModel.normalBorderColor = self.normalBorderColor;
    myModel.selectedBackgroundColor = self.selectedBackgroundColor;
    myModel.selectedBorderColor = self.selectedBorderColor;
    myModel.borderLineWidth = self.borderLineWidth;
    myModel.backgroundCornerRadius = self.backgroundCornerRadius;
    myModel.backgroundWidth = self.backgroundWidth;
    myModel.backgroundHeight = self.backgroundHeight;
    myModel.selectGradients = @[HEXCOLOR(0xFFC242), HEXCOLOR(0xFEE100)];
    myModel.cellSpacing = 10.f;
}


@end
