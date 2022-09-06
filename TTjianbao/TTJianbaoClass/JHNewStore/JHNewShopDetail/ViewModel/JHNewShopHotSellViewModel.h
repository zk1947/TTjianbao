//
//  JHNewShopHotSellViewModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopBaseViewModel.h"
#import "JHNewStoreHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopHotSellViewModel : JHNewShopBaseViewModel
@property (nonatomic, strong) NSMutableArray *hotSellDataArray;
@property (nonatomic, strong) RACCommand *shopHotSellGoodCommand;

@end

NS_ASSUME_NONNULL_END
