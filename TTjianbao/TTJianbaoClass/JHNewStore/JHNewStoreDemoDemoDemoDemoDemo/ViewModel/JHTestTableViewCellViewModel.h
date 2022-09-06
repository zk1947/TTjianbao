//
//  JHTestTableViewCellViewModel.h
//  TTjianbao
//
//  Created by user on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHTestTableViewCellViewModel : NSObject
@property (nonatomic, strong) NSArray *dataArr;
+ (NSArray<JHTestTableViewCellViewModel *>*)setViewModelImpl:(JHCustomizeLogisticsModelTestModel *)model;

@end

NS_ASSUME_NONNULL_END
