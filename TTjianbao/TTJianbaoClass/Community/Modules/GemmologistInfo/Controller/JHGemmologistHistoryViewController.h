//
//  JHGemmologistHistoryViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JXPagerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGemmologistHistoryViewController : JHBaseViewController<JXPagerViewListViewDelegate>

/** 用户id*/
@property (nonatomic, copy) NSString *anchorId;
@end

NS_ASSUME_NONNULL_END
