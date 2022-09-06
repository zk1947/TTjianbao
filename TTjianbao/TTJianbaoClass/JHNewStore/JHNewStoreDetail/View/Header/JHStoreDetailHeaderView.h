//
//  JHStoreHeaderView.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  Describe : 商品详情头（视频、轮播图）

#import <UIKit/UIKit.h>
#import "JHStoreDetailHeaderViewModel.h"
#import "JHStoreDetailCycleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailHeaderView : UIView
@property (nonatomic, strong) JHStoreDetailHeaderViewModel *viewModel;
@property (nonatomic, strong) JHStoreDetailCycleView *cycleView;
@end

NS_ASSUME_NONNULL_END
