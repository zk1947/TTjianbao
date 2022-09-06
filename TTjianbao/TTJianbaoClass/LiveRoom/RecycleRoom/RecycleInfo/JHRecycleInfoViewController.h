//
//  JHRecycleInfoViewController.h
//  TTjianbao
//
//  Created by user on 2021/4/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleInfoViewController : JHBaseViewController
///主播id
@property (nonatomic, copy) NSString *anchorId;
///直播间id
@property (nonatomic, copy) NSString *roomId;
///页面来源
@property (nonatomic, copy) NSString *fromSource;

@property (nonatomic, copy) NSString *channelLocalId; //deeplink 跳转主播页
@end

NS_ASSUME_NONNULL_END
