//
//  JHStoneSearchConditionViewModel.h
//  TTjianbao
//
//  Created by apple on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "JHStoneSearchConditionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneSearchConditionViewModel : JHBaseViewModel

@property (nonatomic, copy) NSArray *sectionTitleArray;

@property (nonatomic, strong) NSMutableArray *priceArray;

@property (nonatomic, strong) NSMutableArray *dateArray;

@property (nonatomic, strong) NSMutableArray *tagArray;

@property (nonatomic, copy) NSString *lowPrice;

@property (nonatomic, copy) NSString *heighPrice;

-(void)cancleData;

@end

NS_ASSUME_NONNULL_END
