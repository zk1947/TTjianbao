//
//  JHStoreDetailTagCell.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品标签区

#import <UIKit/UIKit.h>
#import "JHStoreDetailBaseCell.h"
#import "JHStoreDetailTagViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailTagCell : JHStoreDetailBaseCell
@property (nonatomic, strong) JHStoreDetailTagViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
