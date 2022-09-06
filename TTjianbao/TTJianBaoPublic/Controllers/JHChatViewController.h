//
//  JHChatViewController.h
//  TTjianbao
//
//  Created by YJ on 2021/1/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHChatViewController : JHBaseViewController

@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *pageType; /// 消息类型，用于区分社区还是回收

@end

NS_ASSUME_NONNULL_END
