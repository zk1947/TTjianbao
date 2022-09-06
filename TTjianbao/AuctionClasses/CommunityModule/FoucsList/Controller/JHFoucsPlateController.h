//
//  JHFoucsPlateController.h
//  TTjianbao
//
//  Created by apple on 2020/9/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHFoucsPlateController : JHBaseViewController
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) dispatch_block_t updateNumberBlock;
@property (nonatomic, assign) JHPageType pageType;

@end

NS_ASSUME_NONNULL_END
