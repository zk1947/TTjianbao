//
//  JHRecycleOrderToolbarView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecycleOrderToolbarViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderToolbarView : UIView
@property (nonatomic, strong) JHRecycleOrderToolbarViewModel *viewModel;
@property (nonatomic, assign) BOOL isHighlight;
@property (nonatomic, assign) CGFloat leftSpace;
@end

NS_ASSUME_NONNULL_END
