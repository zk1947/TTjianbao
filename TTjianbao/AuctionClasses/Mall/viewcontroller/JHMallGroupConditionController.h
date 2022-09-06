//
//  JHMallGroupConditionController.h
//  TTjianbao
//
//  Created by apple on 2020/3/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMallGroupConditionController : JHBaseViewController

@property (nonatomic, copy) NSArray *groupIdArray;

// 1是从我足迹 0是条件
@property (nonatomic, assign)  int type;

@property (nonatomic, copy) NSArray *dataArray;
@end

NS_ASSUME_NONNULL_END
