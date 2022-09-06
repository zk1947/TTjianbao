//
//  JHStoreDetailSectionCellViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 分区

#import <UIKit/UIKit.h>
#import "JHStoreDetailCellBaseViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailSectionCellViewModel : JHStoreDetailCellBaseViewModel
/// cells
@property (nonatomic, strong) NSMutableArray<JHStoreDetailCellBaseViewModel *> *cellViewModelList;

@end

NS_ASSUME_NONNULL_END
