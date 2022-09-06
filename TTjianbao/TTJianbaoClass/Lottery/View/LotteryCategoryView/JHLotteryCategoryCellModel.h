//
//  JHLotteryCategoryCellModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JXCategoryTitleCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryCategoryCellModel : JXCategoryTitleCellModel

@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, copy) NSString *stateStr;
@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, strong) UIColor *dateColorNormal;
@property (nonatomic, strong) UIColor *dateColorSelected;
@property (nonatomic, strong) UIColor *stateBgColorNormal;
@property (nonatomic, strong) UIColor *stateBgColorSelected;

@end

NS_ASSUME_NONNULL_END
