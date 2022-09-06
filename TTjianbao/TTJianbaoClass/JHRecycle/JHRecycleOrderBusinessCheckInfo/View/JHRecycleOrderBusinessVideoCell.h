//
//  JHRecycleOrderBusinessVideoCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessBaseCell.h"
#import "JHRecycleOrderBusinessVideoViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderBusinessVideoCell : JHRecycleOrderBusinessBaseCell
/// 背景图
@property (nonatomic, strong) YYAnimatedImageView *bgImageView;
@property (nonatomic, strong) UIView *videoView;
@property (nonatomic, strong) JHRecycleOrderBusinessVideoViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
