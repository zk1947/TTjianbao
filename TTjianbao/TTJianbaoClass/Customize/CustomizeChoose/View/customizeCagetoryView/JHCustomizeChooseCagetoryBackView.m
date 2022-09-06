//
//  JHCustomizeChooseCagetoryBackView.m
//  TTjianbao
//
//  Created by user on 2020/12/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeChooseCagetoryBackView.h"
#import "JHCustomizeChooseCategoryTitleBackgroundCell.h"
#import "JHCustomizeChooseCategoryTitleBackgroundCellModel.h"
#import "JXCategoryBaseCellModel.h"

@implementation JHCustomizeChooseCagetoryBackView


- (void)initializeData {
    [super initializeData];

    self.cellWidthIncrement      = 26;
    self.normalBackgroundColor   = HEXCOLOR(0xFFFFFF);
    self.normalBorderColor       = [UIColor clearColor];
    self.selectedBackgroundColor = HEXCOLOR(0xFFFDED);
    self.selectedBorderColor     = HEXCOLOR(0xFEE100);
    self.borderLineWidth         = 1;
    self.backgroundCornerRadius  = 4;
    self.backgroundWidth         = JXCategoryViewAutomaticDimension;
    self.backgroundHeight        = 26.f;
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
