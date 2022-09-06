//
//  JHMyCenterMerchantViewModel.h
//  TTjianbao
//
//  Created by apple on 2020/4/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewModel.h"
#import "JHMyCenterMerchantCellModel.h"
#import "JHMyShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterMerchantViewModel : JHBaseViewModel

@property (nonatomic, strong) JHMyShopModel *dataSource;

@property (nonatomic, strong) NSMutableArray *livingData;
@property (nonatomic, strong) NSMutableArray *storeData;

- (void)reloadDataArray;
- (void)reloadAssistantArray;

@end

NS_ASSUME_NONNULL_END
