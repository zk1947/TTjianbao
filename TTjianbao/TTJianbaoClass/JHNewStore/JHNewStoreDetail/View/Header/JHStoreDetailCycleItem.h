//
//  JHStoreDetailCycleItem.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetailCycleItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCycleItem : UICollectionViewCell
@property (nonatomic, strong) JHStoreDetailCycleItemViewModel *viewModel;
/// 背景图
@property (nonatomic, strong) YYAnimatedImageView *imageView;

- (void)setupViewModel : (JHStoreDetailCycleItemViewModel *)viewModel;

- (void) setupUI;
- (void) layoutViews;
@end

NS_ASSUME_NONNULL_END
