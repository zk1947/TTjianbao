//
//  JHBillTotalViewModel.h
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "JHBillTotalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBillTotalViewModel : JHBaseViewModel

@property (nonatomic, strong) JHBillTotalModel *dataSource;

@property (nonatomic, copy) NSString *accountDate;

@property (nonatomic, strong) RACCommand *totalMoneyRequestCommand;

@end

NS_ASSUME_NONNULL_END
