//
//  JHStoreSnapShootPriceCell.h
//  TTjianbao
//
//  Created by jiangchao on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetailBaseCell.h"
#import "JHStoreSnapShootPriceViewModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface JHStoreSnapShootPriceCell : JHStoreDetailBaseCell
@property (nonatomic, strong) JHStoreSnapShootPriceViewModel *viewModel;
@property (nonatomic, strong) UILabel *priceLabel;
@end

NS_ASSUME_NONNULL_END
