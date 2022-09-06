//
//  JHStoreDetailPriceCell.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 价格区

#import <UIKit/UIKit.h>
#import "JHStoreDetailBaseCell.h"
#import "JHStoreDetailPriceViewModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailPriceCell : JHStoreDetailBaseCell
@property (nonatomic, strong) JHStoreDetailPriceViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
