//
//  JHStealTowerRequestModel.h
//  TTjianbao
//
//  Created by zk on 2021/8/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHStealTowerRequestModel : NSObject

@property (nonatomic, assign) NSInteger priceSortFlag;
@property (nonatomic, assign) NSInteger frontFirstCategoryId;
@property (nonatomic, assign) NSInteger frontSecondCategoryId;
@property (nonatomic, assign) NSInteger frontThirdCategoryId;
@property (nonatomic, assign) float startPrice;
@property (nonatomic, assign) float endPrice;

@end

NS_ASSUME_NONNULL_END
