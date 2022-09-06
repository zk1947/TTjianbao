//
//  JHCommunityNewListViewController.h
//  TTjianbao
//
//  Created by YJ on 2021/1/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCommunityNewListViewController : JHBaseViewController

@property (strong, nonatomic) NSString *titleStr;

@property (strong, nonatomic) NSString *pageType; /// 用于区分社区还是回收

@end

NS_ASSUME_NONNULL_END
