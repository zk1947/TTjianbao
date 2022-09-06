//
//  JHNewStoreHomeChooseCagetoryBackView.m
//  TTjianbao
//
//  Created by user on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeChooseCagetoryBackView.h"
#import "JHCustomizeChooseCategoryTitleBackgroundCell.h"
#import "JHCustomizeChooseCategoryTitleBackgroundCellModel.h"
#import "JXCategoryBaseCellModel.h"

@implementation JHNewStoreHomeChooseCagetoryBackView


- (void)initializeData {
    [super initializeData];

    self.cellWidthIncrement      = 30.f;
    self.normalBackgroundColor   = [UIColor clearColor];
    self.normalBorderColor       = [UIColor clearColor];
    self.selectedBackgroundColor = HEXCOLOR(0xEDEDED);
    self.selectedBorderColor     = HEXCOLOR(0xEDEDED);
    self.borderLineWidth         = 0;
    self.backgroundCornerRadius  = 12;
    self.backgroundWidth         = JXCategoryViewAutomaticDimension;
    self.backgroundHeight        = 24.f;
    self.cellSpacing             = 10.f;
}

//返回自定义的cell class
- (Class)preferredCellClass {
    return [JHCustomizeChooseCategoryTitleBackgroundCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        JHCustomizeChooseCategoryTitleBackgroundCellModel *cellModel = [[JHCustomizeChooseCategoryTitleBackgroundCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(JXCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];
    JHCustomizeChooseCategoryTitleBackgroundCellModel *myModel = (JHCustomizeChooseCategoryTitleBackgroundCellModel *)cellModel;
    myModel.normalBackgroundColor   = self.normalBackgroundColor;
    myModel.normalBorderColor       = self.normalBorderColor;
    myModel.selectedBackgroundColor = self.selectedBackgroundColor;
    myModel.selectedBorderColor     = self.selectedBorderColor;
    myModel.borderLineWidth         = self.borderLineWidth;
    myModel.backgroundCornerRadius  = self.backgroundCornerRadius;
    myModel.backgroundWidth         = self.backgroundWidth;
    myModel.backgroundHeight        = self.backgroundHeight;
}

@end
