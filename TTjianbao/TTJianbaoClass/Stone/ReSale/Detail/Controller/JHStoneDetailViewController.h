//
//  JHStoneDetailViewController.h
//  TTjianbao
//
//  Created by apple on 2019/12/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneDetailViewController : JHBaseViewController

@property (nonatomic, copy) NSString *stoneId;

/// 0:原石回血    1:个人回血
@property (nonatomic, assign) NSInteger type;

/// 原始回血需要的字段
@property (nonatomic, copy) NSString *channelCategory;

/// 返回回调（原始回血需要的字段）
@property (nonatomic, copy) void(^complete)(id data);

@end

NS_ASSUME_NONNULL_END
