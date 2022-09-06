//
//  JHStoreDetailSpecViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品规格参数ViewModel

#import <Foundation/Foundation.h>
#import "JHStoreDetailCellBaseViewModel.h"

static const CGFloat SpecFontSize = 13.0f;
static const CGFloat SpecSpace = 30.0f;
static const CGFloat SpecTopSpace = 4.0f;
static const CGFloat SpecTitleWidth = 60.0f;

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailSpecViewModel : JHStoreDetailCellBaseViewModel
/// 规格名称
@property (nonatomic, copy) NSString *titleText;
/// 规格参数
@property (nonatomic, copy) NSString *detailText;
/// 有说明
@property(nonatomic) BOOL hasIntroduct;
/// cell index
@property(nonatomic) NSInteger  index;

/// 说明title
@property (nonatomic, copy) NSString *attrDescTitle;

/// 说明ID
@property (nonatomic, copy) NSString *ID;

@end

NS_ASSUME_NONNULL_END
