//
//  JHUserAuthPersonalController.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHUserAuthModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserAuthPersonalController : JHBaseViewController
///审核状态
@property (nonatomic, strong) JHUserAuthModel *authModel;
@end

NS_ASSUME_NONNULL_END
