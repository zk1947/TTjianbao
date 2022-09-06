//
//  JHZeroAuctionViewController.h
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHZeroTableView : UITableView <UIGestureRecognizerDelegate>

@end

@interface JHZeroAuctionViewController : JHBaseViewController

@property (nonatomic, strong) JHZeroTableView *tableView;

@property (nonatomic, assign) BOOL cannotScroll;

@end

NS_ASSUME_NONNULL_END
