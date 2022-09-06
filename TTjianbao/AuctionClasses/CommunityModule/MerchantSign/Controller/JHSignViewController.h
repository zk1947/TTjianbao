//
//  JHSignViewController.h
//  TTjianbao
//
//  Created by apple on 2019/11/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTableViewController.h"
#import "JHBaseViewExtController.h"

typedef NS_ENUM(NSUInteger, JHCheckStatus) {
    JHCheckStatusUnCheck = 0,       ///未审核
    JHCheckStatusChecking,          ///审核中
    JHCheckStatusCheckSuccess,      ///审核通过
    JHCheckStatusCheckFailure,      ///审核失败
};

NS_ASSUME_NONNULL_BEGIN

@interface JHSignViewController : JHBaseViewExtController


@property (nonatomic, assign) JHCheckStatus checkStatus;


@end

NS_ASSUME_NONNULL_END
