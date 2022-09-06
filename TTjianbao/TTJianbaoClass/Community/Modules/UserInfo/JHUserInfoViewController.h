//
//  JHUserInfoViewController.h
//  TTjianbao
//
//  Created by lihui on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

//更新关注状态，用户id和是否已关注
typedef void(^UserFollowStatusChangedBlock)(NSString *userId, BOOL isFollow);

@interface JHUserInfoViewController : YDBaseViewController

///用户id
@property (nonatomic, copy) NSString *userId;
///页面来源
@property (nonatomic, copy) NSString *fromSource;

@property (nonatomic, copy) UserFollowStatusChangedBlock followStatusChangedBlock;

/// 评过:1 发过:2  赞过:3
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
