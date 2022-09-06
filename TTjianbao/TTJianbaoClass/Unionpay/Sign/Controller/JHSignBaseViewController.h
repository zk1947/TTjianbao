//
//  JHSignBaseViewController.h
//  TTjianbao
//
//  Created by lihui on 2020/4/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewExtController.h"
#import "JHUnionPayModel.h"
#import "STPickerArea.h"
#import "JHPickerView.h"
#import "JHProviceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSignBaseViewController : JHBaseViewExtController

// 流程数据
@property (nonatomic, copy) NSArray *processDatas;
///签约类型
@property (nonatomic, assign) JHCustomerType customerType;
@property (nonatomic, strong) UITableView *tableView;

///选择地区的picker
@property (nonatomic, strong) STPickerArea *pickerView;
///选择支行的pickerView
@property (nonatomic, strong) JHPickerView *singlePicker;

///提示信息
- (void)loadData;
///注册cell
- (void)registerCell;

- (void)nextStep;

///设置当前正在执行的流程
- (void)setCurrentSelectIndex:(NSInteger)currentSelectIndex;

@end

NS_ASSUME_NONNULL_END
