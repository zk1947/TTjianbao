//
//  JHNewShopClassResultViewModel.h
//  TTjianbao
//
//  Created by hao on 2021/7/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopBaseViewModel.h"
#import "JHNewStoreHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopClassResultViewModel : JHNewShopBaseViewModel
@property (nonatomic, strong) NSMutableArray *classResultDataArray;
@property (nonatomic, strong) RACCommand *shopClassResultCommand;
@end

NS_ASSUME_NONNULL_END
