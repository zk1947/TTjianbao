//
//  JHStoreDetailSpecialViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品专场

#import "JHStoreDetailCellBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailSpecialViewModel : JHStoreDetailCellBaseViewModel
@property (nonatomic, copy) NSString *titleText;
/// 专场点击
//@property (nonatomic, strong) RACSubject *specialAction;


@end

NS_ASSUME_NONNULL_END
