//
//  JHStoreDetailCycleView.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetailCycleViewModel.h"
#import "JHStoreDetailCycleVideoItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCycleView : UIView
@property (nonatomic, strong) JHStoreDetailCycleViewModel *viewModel;
@property (nonatomic, strong) JHStoreDetailCycleVideoItem *videoView;
@property (nonatomic, assign) NSUInteger displayIndex;
@end

NS_ASSUME_NONNULL_END
