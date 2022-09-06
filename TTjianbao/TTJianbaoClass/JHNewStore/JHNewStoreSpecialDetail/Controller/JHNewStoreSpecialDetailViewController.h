//
//  JHNewStoreSpecialDetailViewController.h
//  TTjianbao
//
//  Created by liuhai on 2021/2/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreSpecialDetailViewController : JHBaseViewController
@property(nonatomic, copy) NSString *showId; //专场id
@property(nonatomic, copy) NSString *fromPage; //进入来源
@property(nonatomic, copy) void (^startRemindBtnBlock)(BOOL isSuccess);
@end

NS_ASSUME_NONNULL_END
