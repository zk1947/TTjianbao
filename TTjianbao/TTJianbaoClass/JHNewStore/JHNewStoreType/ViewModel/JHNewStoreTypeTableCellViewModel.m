//
//  JHNewStoreTypeTableCellViewModel.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreTypeTableCellViewModel.h"
#import "JHNewStoreTypeModel.h"

@implementation JHNewStoreTypeTableCellViewModel

- (CGFloat)sectionHeight{
    CGFloat h = 50;
    if (self.scrollArr.count > 0) {
        h += 90;
    }
    if (self.videoArr.count > 0) {
        h += 170;
    }
    return h;
}

+ (JHNewStoreTypeTableCellViewModel*)viewModelWithNewStoryTypeModel:(JHNewStoreTypeModel*)model{
    JHNewStoreTypeTableCellViewModel *viewModel = [[JHNewStoreTypeTableCellViewModel alloc] init];
    viewModel.dataModel = model;
    viewModel.ID = model.ID;
    viewModel.cateName = model.cateName;
    viewModel.cateIcon = model.cateIcon;
    viewModel.pid = model.pid;
    viewModel.cateLevel = model.cateLevel;
    viewModel.sort = model.sort;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    if (model.children.count) {
        [model.children enumerateObjectsUsingBlock:^(JHNewStoreTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [arr addObject: [JHNewStoreTypeTableCellViewModel viewModelWithNewStoryTypeModel:obj]];
        }];
    }
    viewModel.children = arr.copy;
    return viewModel;
}
@end


