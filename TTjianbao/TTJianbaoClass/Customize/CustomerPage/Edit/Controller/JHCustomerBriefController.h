//
//  JHCustomerBriefController.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerBriefController : JHBaseViewController

@property (nonatomic, copy) NSString *text;

///直播间ID
@property (nonatomic, copy) NSString *channelLocalId;

///保存成功
@property (nonatomic, copy) dispatch_block_t callbackMethod;
///pop时需要返回的界面vc名称
@property (nonatomic, copy) NSString *vcName;

@property (nonatomic, strong) NSNumber *isRecycle; /// 是否是回收

@end

NS_ASSUME_NONNULL_END
