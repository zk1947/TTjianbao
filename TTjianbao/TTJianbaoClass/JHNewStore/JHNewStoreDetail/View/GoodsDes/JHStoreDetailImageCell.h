//
//  JHStoreDetailImageCell.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品介绍区（大图）

#import <UIKit/UIKit.h>
#import "JHStoreDetailBaseCell.h"
#import "JHStoreDetailImageViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailImageCell : JHStoreDetailBaseCell
@property (nonatomic, strong) JHStoreDetailImageViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
