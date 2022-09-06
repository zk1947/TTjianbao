//
//  UITitleBarBackgroundView.m
//  TTjianbao
//
//  Created by wuyd on 2020/3/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UITitleBarBackgroundView.h"

@implementation UITitleBarBackgroundView

- (void)initializeData {
    [super initializeData];

    self.cellWidthIncrement = 20;
    self.normalBgColor = [UIColor clearColor];
    self.normalBorderColor = [UIColor clearColor];
    self.selectedBgColor = [UIColor clearColor];
    self.selectedBorderColor = [UIColor clearColor];
    self.borderLineWidth = 0;
    self.bgCornerRadius = 13;
    self.bgWidth = JXCategoryViewAutomaticDimension;
    self.bgHeight = 26;
}

//返回自定义的cell class
- (Class)preferredCellClass {
    return [UITitleBarBackgroundCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        UITitleBarBackgroundCellModel *cellModel = [[UITitleBarBackgroundCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(JXCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    UITitleBarBackgroundCellModel *myModel = (UITitleBarBackgroundCellModel *)cellModel;
    myModel.normalBgColor = self.normalBgColor;
    myModel.normalBorderColor = self.normalBorderColor;
    myModel.selectedBgColor = self.selectedBgColor;
    myModel.selectedBorderColor = self.selectedBorderColor;
    myModel.borderLineWidth = self.borderLineWidth;
    myModel.bgCornerRadius = self.bgCornerRadius;
    myModel.bgWidth = self.bgWidth;
    myModel.bgHeight = self.bgHeight;
}

@end
