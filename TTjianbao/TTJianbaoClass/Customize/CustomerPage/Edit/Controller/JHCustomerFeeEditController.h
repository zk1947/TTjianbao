//
//  JHCustomerFeeEditController.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerFeeEditController : JHBaseViewController

///直播间ID
@property (nonatomic, copy) NSString *channelLocalId;

///保存成功
@property (nonatomic, copy) dispatch_block_t callbackMethod;

@end

NS_ASSUME_NONNULL_END
