//
//  JHUserInfoCommentListController.h
//  TTjianbao
//
//  Created by lihui on 2020/6/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDBaseViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserInfoCommentListController : YDBaseViewController <JXPagerViewListViewDelegate>

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) dispatch_block_t refreshBlock;


@end

NS_ASSUME_NONNULL_END
