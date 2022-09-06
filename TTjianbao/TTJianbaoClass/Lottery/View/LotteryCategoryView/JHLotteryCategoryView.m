//
//  JHLotteryCategoryView.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryCategoryView.h"

@interface JHLotteryCategoryView ()

@end

@implementation JHLotteryCategoryView

- (void)initializeData {
    [super initializeData];
    
    _dataList = [NSMutableArray new];
}

//返回自定义的cell class
- (Class)preferredCellClass {
    return [JHLotteryCategoryCell class];
}

- (void)refreshDataSource {
    NSMutableArray *dataArray = [NSMutableArray array];
    for (int i = 0; i < _dataList.count; i++) {
        JHLotteryCategoryCellModel *cellModel = [[JHLotteryCategoryCellModel alloc] init];
        [dataArray addObject:cellModel];
    }
    self.dataSource = dataArray;
}

- (void)refreshCellModel:(JXCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];
    
    if (_dataList.count == 0) {
        return;
    }
    
    JHLotteryData *data = _dataList[index];
    JHLotteryActivityData *activityData = data.activityList.firstObject;
    
    JHLotteryCategoryCellModel *model = (JHLotteryCategoryCellModel *)cellModel;
    
    model.dateStr = data.date;
    model.stateStr = data.desc;
    model.imgUrl = data.img;
    if (activityData.state == 1) { //进行中状态
        model.dateColorNormal = UIColorHex(FF9A00);
        model.dateColorSelected = UIColorHex(FF9A00);
        model.stateBgColorNormal = UIColorHex(FF9A00);
        model.stateBgColorSelected = UIColorHex(FF9A00);
        
    } else {
        model.dateColorNormal = kColor999;
        model.dateColorSelected = kColor999;
        model.stateBgColorNormal = UIColorHex(BCC1D5);
        model.stateBgColorSelected = UIColorHex(BCC1D5);
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    return [JHLotteryCategoryCell cellSize].width;
}

@end
