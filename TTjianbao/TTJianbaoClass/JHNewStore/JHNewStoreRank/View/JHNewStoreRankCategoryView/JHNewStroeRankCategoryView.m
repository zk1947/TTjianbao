//
//  JHNewStroeRankCategoryView.m
//  TTjianbao
//
//  Created by lihui on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStroeRankCategoryView.h"

@implementation JHNewStroeRankCategoryView

- (void)initializeData {
    [super initializeData];
    self.leftIndicatorImage = @"";
    self.rightIndicatorImage = @"";
    self.normalTitleColor = kColorFFF;
    self.selectTitleColor = kColorFFF;
    _dataList = [NSMutableArray array];
}

//返回自定义的cell class
- (Class)preferredCellClass {
    return [JHNewStoreCategoryCell class];
}

- (void)refreshDataSource {
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < _dataList.count; i++) {
        JHNewStoreCategoryCellModel *cellModel = [[JHNewStoreCategoryCellModel alloc] init];
        [dataArray addObject:cellModel];
    }
    self.dataSource = dataArray;
}

- (void)refreshCellModel:(JXCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];
    if (_dataList.count == 0) return;
    
    NSString *title = _dataList[index];
    JHNewStoreCategoryCellModel *model = (JHNewStoreCategoryCellModel *)cellModel;
    
    model.leftIndicatorImage = self.leftIndicatorImage;
    model.rightIndicatorImage = self.rightIndicatorImage;
    model.normalTitleColor = self.normalTitleColor;
    model.selectTitleColor = self.selectTitleColor;
    model.titleString = [title isNotBlank] ? title : @"";
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (_dataList.count == 0) {
        return CGFLOAT_MIN;
    }
    NSString *title = _dataList[index];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 14.) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:15.]} context:nil];
    return ceilf(rect.size.width)+24.;
}

@end
