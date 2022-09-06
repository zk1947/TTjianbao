//
//  JHMyCommentsViewController.h
//  TTjianbao
//
//  Created by YJ on 2021/1/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "YDBaseViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCommentsViewController : YDBaseViewController <JXPagerViewListViewDelegate>

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) dispatch_block_t refreshBlock;

@end

NS_ASSUME_NONNULL_END
