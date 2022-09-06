//
//  JHStoneSearchConditionModel.h
//  TTjianbao
//
//  Created by apple on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneSearchConditionModel : NSObject

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, copy) NSString *label;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *lowPrice;

@property (nonatomic, copy) NSString *heighPrice;

@end

@interface JHStoneSearchConditionSelectModel : NSObject


/// 选取的时间
@property (nonatomic, copy) NSString *shelveDay;

/// 标签Id数组 复选
@property (nonatomic, copy) NSMutableArray *labelIdList;


@property (nonatomic, copy) NSString *minPrice;

@property (nonatomic, copy) NSString *maxPrice;

@end

NS_ASSUME_NONNULL_END
