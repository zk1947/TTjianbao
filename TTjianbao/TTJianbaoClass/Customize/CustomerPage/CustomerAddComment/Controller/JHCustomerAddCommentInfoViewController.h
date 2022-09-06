//
//  JHCustomerAddCommentInfoViewController.h
//  TTjianbao
//
//  Created by user on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerAddCommentInfoViewController : JHBaseViewController
@property (nonatomic,   copy) dispatch_block_t popAction;
/// 定制订单ID
@property (nonatomic, strong) NSString *customizeOrderId;
/// 定制过程ID 
@property (nonatomic, strong) NSString *customizeCommentId;
@end

NS_ASSUME_NONNULL_END
