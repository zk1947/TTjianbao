//
//  JHStoreDetailTitleCell.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品标题区

#import <UIKit/UIKit.h>
#import "JHStoreDetailBaseCell.h"
#import "JHStoreDetailTitleViewModel.h"




NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailTitleCell : JHStoreDetailBaseCell
@property (nonatomic, strong) JHStoreDetailTitleViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
