//
//  JHStoreDetailSpecialCell.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品专场

#import <UIKit/UIKit.h>
#import "JHStoreDetailBaseCell.h"
#import "JHStoreDetailSpecialViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailSpecialCell : JHStoreDetailBaseCell
@property (nonatomic, strong) JHStoreDetailSpecialViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
