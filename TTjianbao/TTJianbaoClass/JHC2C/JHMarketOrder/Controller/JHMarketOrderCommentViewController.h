//
//  JHMarketOrderCommentViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketOrderCommentViewController : JHBaseViewController
@property (nonatomic, copy) NSString *orderId;
//完成回调
@property (nonatomic, copy) void(^completeBlock)(void);
@end

NS_ASSUME_NONNULL_END
