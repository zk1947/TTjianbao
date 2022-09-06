//
//  JXCategoryTitleBackgroundView.m
//  JXCategoryView
//
//  Created by jiaxin on 2019/8/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "JXCategoryTitleBackgroundView.h"

@implementation JXCategoryTitleBackgroundView

- (void)initializeData {
    [super initializeData];

    self.normalBackgroundColor = HEXCOLOR(0xF5F5F5);
    self.normalBorderColor = [UIColor clearColor];
    self.selectedBackgroundColor =  HEXCOLOR(0xFCEC9D);
    self.selectedBorderColor = [UIColor clearColor];
    self.borderLineWidth = 0.0;
    self.backgroundCornerRadius = 12;
    self.backgroundWidth = JXCategoryViewAutomaticDimension;
    self.backgroundHeight = 24;
}

//返回自定义的cell class
- (Class)preferredCellClass {
    return [JXCategoryTitleBackgroundCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        JXCategoryTitleBackgroundCellModel *cellModel = [[JXCategoryTitleBackgroundCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(JXCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    JXCategoryTitleBackgroundCellModel *myModel = (JXCategoryTitleBackgroundCellModel *)cellModel;
    myModel.normalBackgroundColor = self.normalBackgroundColor;
    myModel.normalBorderColor = self.normalBorderColor;
    myModel.selectedBackgroundColor = self.selectedBackgroundColor;
    myModel.selectedBorderColor = self.selectedBorderColor;
    myModel.borderLineWidth = self.borderLineWidth;
    myModel.backgroundCornerRadius = self.backgroundCornerRadius;
    myModel.backgroundWidth = self.backgroundWidth;
    myModel.backgroundHeight = self.backgroundHeight;
}


@end
