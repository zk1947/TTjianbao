//
//  JHStealTowerViewController.h
//  TTjianbao
//
//  Created by zk on 2021/7/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStealTableView : UITableView <UIGestureRecognizerDelegate>

@end

@interface JHStealTowerViewController : JHBaseViewController

@property (nonatomic, strong) JHStealTableView *tableView;

@property (nonatomic, assign) BOOL cannotScroll;

@end

NS_ASSUME_NONNULL_END
