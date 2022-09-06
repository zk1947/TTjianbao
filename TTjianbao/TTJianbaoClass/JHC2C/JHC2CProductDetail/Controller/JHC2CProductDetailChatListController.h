//
//  JHC2CProductDetailChatListController.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CProductDetailChatListController : JHBaseViewController

@property(nonatomic, copy) void (^closeNeedRefresh)(BOOL refresh);

@property(nonatomic, copy) NSString * productSn;

@property(nonatomic, copy) NSNumber * sellerID;

@property(nonatomic, copy) void (^chatCountChange)(NSInteger count);

@end

NS_ASSUME_NONNULL_END
