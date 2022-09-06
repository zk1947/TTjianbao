//
//  JHFoucsShopListController.h
//  TTjianbao
//
//  Created by apple on 2020/2/13.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
/// 我关注的店铺
@interface JHFoucsShopListController : JHBaseViewController

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) dispatch_block_t updateNumberBlock;

@end

NS_ASSUME_NONNULL_END
