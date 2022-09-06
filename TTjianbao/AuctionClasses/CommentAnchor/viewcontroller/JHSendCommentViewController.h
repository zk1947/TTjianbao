//
//  JHSendCommentViewController.h
//  TTjianbao
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSendCommentViewController : JHBaseViewExtController
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, copy) JHFinishBlock commentComplete;

@property (nonatomic, assign) BOOL isShow;//显示数据

@end

NS_ASSUME_NONNULL_END
