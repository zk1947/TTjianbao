//
//  JHStoreDetailImageViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品介绍（大图）ViewModel

#import <Foundation/Foundation.h>
#import "JHStoreDetailCellBaseViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailImageViewModel : JHStoreDetailCellBaseViewModel
///图片地址
@property (nonatomic, copy) NSString *imageUrl;
/// 该图片的index - 放大展示用
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
