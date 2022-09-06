//
//  JHStoreDetailEducationCell.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品 用户教育区（跳转用户教育详情）

#import <UIKit/UIKit.h>
#import "JHStoreDetailBaseCell.h"
#import "JHStoreDetailEducationViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailEducationCell : JHStoreDetailBaseCell
@property (nonatomic, strong) JHStoreDetailEducationViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
