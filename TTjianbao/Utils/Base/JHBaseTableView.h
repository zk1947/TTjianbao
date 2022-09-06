//
//  JHBaseTableView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBaseTableView : BaseView  <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)UITableView *tableView;
- (void)makeUI;
@end

NS_ASSUME_NONNULL_END
