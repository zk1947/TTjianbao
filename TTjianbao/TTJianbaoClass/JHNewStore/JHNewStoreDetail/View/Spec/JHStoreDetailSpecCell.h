//
//  JHStoreDetailSpecCell.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品规格区（品牌、名称、尺寸....）

#import <UIKit/UIKit.h>
#import "JHStoreDetailBaseCell.h"
#import "JHStoreDetailSpecViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailSpecCell : JHStoreDetailBaseCell
@property (nonatomic, strong) JHStoreDetailSpecViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
