//
//  JHUnionSignShowBaseController.h
//  TTjianbao
//
//  Created by apple on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHUnionSignShowBaseCell.h"
#import "JHBaseViewController.h"
#import "JHUnionSignShowBaseModel.h"
#import "JHUnionSignShowDataSourceModel.h"




NS_ASSUME_NONNULL_BEGIN

@interface JHUnionSignShowBaseController : JHBaseViewController

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) JHUnionSignShowDataSourceModel *model;

@end

NS_ASSUME_NONNULL_END
