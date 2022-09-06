//
//  JHLotteryCategoryView.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JXCategoryTitleView.h"
#import "JHLotteryCategoryCell.h"
#import "JHLotteryCategoryCellModel.h"
#import "JHLotteryModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryCategoryView : JXCategoryTitleView

//数据源
@property (nonatomic, strong) NSMutableArray<JHLotteryData *> *dataList;

//UI属性
@property (nonatomic, strong) UIColor *dateColorNormal;
@property (nonatomic, strong) UIColor *dateColorSelected;
@property (nonatomic, strong) UIColor *stateBgColorNormal;
@property (nonatomic, strong) UIColor *stateBgColorSelected;

@end

NS_ASSUME_NONNULL_END
