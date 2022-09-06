//
//  JHUserFriendListController.h
//  TTjianbao
//
//  Created by wuyd on 2019/9/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "YDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserFriendListController : YDBaseViewController

//push到下一页面 - 解决侧滑问题！
@property (nonatomic, copy) void(^didPushBlock)(void);

@property (nonatomic, assign) NSInteger user_id;//宝友id

@property (nonatomic, copy) NSString *name;
/// 1：关注      2：粉丝
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) dispatch_block_t updateNumberBlock;

@end

NS_ASSUME_NONNULL_END
