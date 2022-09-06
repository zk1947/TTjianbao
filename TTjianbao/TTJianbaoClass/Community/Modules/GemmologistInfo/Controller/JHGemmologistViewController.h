//
//  JHGemmologistViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGemmologistViewController : YDBaseViewController
/** 鉴定师id*/
@property (nonatomic, copy) NSString *anchorId;

/** 关注状态传值*/
@property (nonatomic, copy) void (^finishFollow)(NSString *anchorId, BOOL isFollow);
@property (nonatomic, copy) NSString *pageFrom;
/** 是否是从直播间进来的*/
@property (nonatomic, assign) BOOL isFromLivingRoom;
@end

NS_ASSUME_NONNULL_END
