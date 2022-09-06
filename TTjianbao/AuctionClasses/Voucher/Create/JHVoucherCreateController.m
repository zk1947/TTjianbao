//
//  JHVoucherCreateController.m
//  TTjianbao
//
//  Created by wuyd on 2020/3/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHVoucherCreateController.h"
#import "UITitleInputCell.h"
#import "UITitleValueMoreCell.h"
#import "JHVoucherReceiveModeCell.h"
#import "JHVoucherCreateModel.h"
#import "JHVoucherApiManager.h"
#import "ZHProgressHud.h"
#import "STPickerDate.h"
#import "LEEAlert.h"
#import <IQKeyboardManager.h>

@interface JHVoucherCreateController () <STPickerDateDelegate>
@property (nonatomic, strong) JHVoucherCreateModel *createModel;
@property (nonatomic, strong) NSArray<JHVoucherGroupItem *> *groupList;

@property (nonatomic, strong) STPickerDate *datePicker;
@end

@implementation JHVoucherCreateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"F5F6FA"];
    
    _createModel = [[JHVoucherCreateModel alloc] initWithCarryTimeType:@"A"];
    _groupList = _createModel.groupList;
    
    [self configNaviBar];
    [self configTableView];
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

#pragma mark -
#pragma mark - UI Methods

- (void)configNaviBar {
    [self showNaviBar];
    self.naviBar.title = @"创建代金券";
    self.naviBar.rightTitle = @"保存";
    self.naviBar.leftImage = kNavBackBlackImg;
    self.naviBar.bottomLine.hidden = NO;
}

//创建代金券
- (void)rightBtnClicked {
    NSString *errMsg = @"";
    for (JHVoucherGroupItem *group in _groupList) {
        for (JHVoucherCellItem *item in group.cellItems) {
            NSString *valueObj = [_createModel valueForKey:item.key];
            
            if (![valueObj isNotBlank]) {
                errMsg = @"请填写完整信息";
                [UITipView showTipStr:errMsg];
                return;
            }
        }
    }
    
    if (_createModel.name.length > 10) {
        errMsg = @"代金券券名称太长了";
        [UITipView showTipStr:errMsg];
        return;
    }
    if ([_createModel.type isEqualToString:@"OD"]) {
        if (_createModel.price.doubleValue>0.0001&&_createModel.price.doubleValue<=10) {
        } else {
            errMsg = @"折扣券应该在0-10之间取值";
            [UITipView showTipStr:errMsg];
            return;
        }
    }
    if ([_createModel.count integerValue] == 0) {
        errMsg = @"发行量应该大于0";
        [UITipView showTipStr:errMsg];
        return;
    }

    
    NSInteger time1 = [CommHelp timeSwitchTimestamp:_createModel.startTime andFormatter:@"yyyy-MM-dd"];
    NSInteger time2 = [CommHelp timeSwitchTimestamp:_createModel.endTime andFormatter:@"yyyy-MM-dd"];

    if (time1 > time2) {
        [UITipView showTipStr:@"结束时间不能小于开始时间"];
        return;
    }
    
    [ZHProgressHud showLoading:@"" inView:self.view];
    @weakify(self);
    [JHVoucherApiManager createVoucherWithParams:[_createModel toParams] block:^(RequestModel * _Nullable respObj, BOOL hasError) {
        [ZHProgressHud hide];
        if (hasError) {
            [UITipView showTipStr:respObj.message];
            
        } else {
            [ZHProgressHud showSuccess:@"创建成功" inView:self.view];
            [self sa_method];
            [ZHProgressHud sharedInstance].hud.completionBlock = ^{
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
            };
        }
    }];
}

- (void)sa_method {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.createModel.type forKey:@"voucher_type"];
    [params setValue:@(self.createModel.price.integerValue) forKey:@"voucher_value"];
    [params setValue:self.createModel.condition forKey:@"decrement_condition"];
    [params setValue:self.createModel.count forKey:@"extend_number"];
    [params setValue:self.createModel.receiveMode forKey:@"receive_method"];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"establishVoucher" params:params type:JHStatisticsTypeSensors];
}

- (void)configTableView {
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F5F6FA"];
    self.tableView.rowHeight = 44;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerClass:[UITitleInputCell class] forCellReuseIdentifier:kCellId_UITitleInputCell];
    [self.tableView registerClass:[UITitleValueMoreCell class] forCellReuseIdentifier:kCellId_UITitleValueMoreCell];
    [self.tableView registerClass:[JHVoucherReceiveModeCell class] forCellReuseIdentifier:kCellId_JHVoucherReceiveModeCell];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
//    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
//    }];
    self.tableView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(UI.statusAndNavBarHeight, 0, 0, 0));
}

#pragma mark -
#pragma mark - datePicker Methods

- (STPickerDate *)datePicker {
    if (!_datePicker) {
        _datePicker = [[STPickerDate alloc] init];
        _datePicker.yearLeast = [[NSDate date] year];
        _datePicker.yearSum = 20;
        _datePicker.delegate = self;
    }
    return _datePicker;
}

- (void)pickerDate:(STPickerDate *)pickerDate year:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {

    JHVoucherCellItem *item = _groupList[1].cellItems[pickerDate.tag];
    item.value = [NSString stringWithFormat:@"%zd-%zd-%zd", year,month,day];
    [_createModel setValue:item.value forKey:item.key];
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark - <UITableViewDelegate & UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _groupList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groupList[section].cellItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHVoucherGroupItem *group = _groupList[indexPath.section];
    __block JHVoucherCellItem *item = group.cellItems[indexPath.row];
    item.createModel = _createModel;
    
    //inputCell
    UITitleInputCell *inputCell = [tableView dequeueReusableCellWithIdentifier:kCellId_UITitleInputCell];
    if (!inputCell) {
        inputCell = [[UITitleInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId_UITitleInputCell];
    }
    
    BOOL keyboardNumType = ((indexPath.section == 0 && indexPath.row > 1)
                            || (indexPath.section == 1 && [item.key isEqualToString:@"usableDays"]));
    inputCell.textField.keyboardType = keyboardNumType ? UIKeyboardTypeDecimalPad : UIKeyboardTypeDefault;
    
    //valueMoreCell
    UITitleValueMoreCell *valueMoreCell = [tableView dequeueReusableCellWithIdentifier:kCellId_UITitleValueMoreCell];
    if (!valueMoreCell) {
        valueMoreCell = [[UITitleValueMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId_UITitleValueMoreCell];
    }
//    valueMoreCell.titleLabel.textColor = (indexPath.row >= group.cellItems.count - 2) ? kColor999 : kColor333;
    
    //modeCell
    JHVoucherReceiveModeCell *modeCell = [tableView dequeueReusableCellWithIdentifier:kCellId_JHVoucherReceiveModeCell];
    
    if (!modeCell) {
        modeCell = [[JHVoucherReceiveModeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId_JHVoucherReceiveModeCell];
    }
    
    inputCell.textValueChangedBlock = ^(NSString * _Nonnull text) {
        item.value = text;
    };
    
    modeCell.didSelectedBlock = ^(NSInteger index) {
        item.value = @(index).stringValue;
    };
    
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 0) {
                [valueMoreCell setTitle:item.title value:item.value placeholder:item.placeholder];
                return valueMoreCell;
                
            } else {
                [inputCell setTitle:item.title value:item.value placeholder:item.placeholder];
                return inputCell;
            }
        }
        case 1: {
            if (indexPath.row == 0) {
                [modeCell setTitle:item.title selectedIndex:item.value.integerValue];
                return modeCell;
                
            } else if ([item.key isEqualToString:@"usableDays"]) {
                [inputCell setTitle:item.title value:item.value placeholder:item.placeholder];
                return inputCell;
                
            } else {
                [valueMoreCell setTitle:item.title value:item.value placeholder:item.placeholder];
                return valueMoreCell;
            }
        }
        default: {
            inputCell.userInteractionEnabled = NO;
            return inputCell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    JHVoucherGroupItem *group = _groupList[indexPath.section];
    JHVoucherCellItem *item = group.cellItems[indexPath.row];

    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self __showCouponType];
        }
        
    } else {
        if ([item.key isEqualToString:@"timeType"]) {
            [self __showTimeType];
        } else if (![item.key isEqualToString:@"usableDays"]) {
            [self.view endEditing:YES];
            self.datePicker.tag = indexPath.row;
            [self.datePicker show];
        
        }
    }
}


#pragma mark - 选择代金券类型

- (void)__showCouponType {
    [self.view endEditing:YES];
    __block JHVoucherCellItem *item = _groupList[0].cellItems[0];
    __weak typeof(self) weakSelf = self;
    
    [LEEAlert actionsheet].config
    .LeeContent(@"选择代金券类型")
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = @"满减";
        action.titleColor = kColor222;
        action.font = [UIFont fontWithName:kFontNormal size:17];
        action.borderColor = [UIColor colorWithHexString:@"E7E8E9"];
        action.backgroundHighlightColor = kColorCellHighlight;
        action.clickBlock = ^{
            item.value = @"满减";
            [_createModel configGroupList];
            [weakSelf.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
            
        };
    })
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = @"每满减";
        action.titleColor = kColor222;
        action.font = [UIFont fontWithName:kFontNormal size:17];
        action.borderColor = [UIColor colorWithHexString:@"E7E8E9"];
        action.backgroundHighlightColor = kColorCellHighlight;
        action.clickBlock = ^{
            item.value = @"每满减";
            [_createModel configGroupList];
            [weakSelf.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];

        };
    })
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = @"折扣券";
        action.titleColor = kColor222;
        action.font = [UIFont fontWithName:kFontNormal size:17];
        action.borderColor = [UIColor colorWithHexString:@"E7E8E9"];
        action.backgroundHighlightColor = kColorCellHighlight;
        action.clickBlock = ^{
            item.value = @"折扣券";
            [_createModel configGroupList];
            [weakSelf.tableView reloadSection:0 withRowAnimation:UITableViewRowAnimationNone];
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = kColor222;
        action.font = [UIFont fontWithName:kFontNormal size:17];
        action.borderColor = [UIColor colorWithHexString:@"E7E8E9"];
        action.backgroundHighlightColor = kColorCellHighlight;
    })
    .LeeActionSheetCancelActionSpaceColor([UIColor colorWithHexStr:@"f6f7f8"]) // 设置取消按钮间隔的颜色
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadii(CornerRadiiMake(10, 10, 0, 0))   // 指定整体圆角半径
#warning TODO:jiang  注释两行
   // .LeeActionSheetHeaderCornerRadii(CornerRadiiZero()) // 指定头部圆角半径
   // .LeeActionSheetCancelActionCornerRadii(CornerRadiiZero()) // 指定取消按钮圆角半径
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        return kScreenWidth;
    })
    .LeeActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
    .LeeShow();
}

#pragma mark - 选择时间类型
- (void)__showTimeType {
    [self.view endEditing:YES];
    __block JHVoucherCellItem *item = _groupList[1].cellItems[1];
    __weak typeof(self) weakSelf = self;
    
    [LEEAlert actionsheet].config
    .LeeContent(@"选择时间类型")
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = @"有效期";
        action.titleColor = kColor222;
        action.font = [UIFont fontWithName:kFontNormal size:17];
        action.borderColor = [UIColor colorWithHexString:@"E7E8E9"];
        action.backgroundHighlightColor = kColorCellHighlight;
        action.clickBlock = ^{
            item.value = @"有效期";
            [_createModel configGroupList];
            _groupList = _createModel.groupList;
            [weakSelf.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        };
    })
    .LeeAddAction(^(LEEAction * _Nonnull action) {
        action.title = @"有效时间";
        action.titleColor = kColor222;
        action.font = [UIFont fontWithName:kFontNormal size:17];
        action.borderColor = [UIColor colorWithHexString:@"E7E8E9"];
        action.backgroundHighlightColor = kColorCellHighlight;
        action.clickBlock = ^{
            item.value = @"有效时间";
            [_createModel configGroupList];
            _groupList = _createModel.groupList;
            [weakSelf.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeCancel;
        action.title = @"取消";
        action.titleColor = kColor222;
        action.font = [UIFont fontWithName:kFontNormal size:17];
        action.borderColor = [UIColor colorWithHexString:@"E7E8E9"]; //分割线颜色
        action.backgroundHighlightColor = kColorCellHighlight;
    })
    .LeeActionSheetCancelActionSpaceColor([UIColor colorWithHexStr:@"f6f7f8"]) // 设置取消按钮间隔的颜色
    .LeeActionSheetBottomMargin(0.0f) // 设置底部距离屏幕的边距为0
    .LeeCornerRadii(CornerRadiiMake(10, 10, 0, 0))   // 指定整体圆角半径
    #warning TODO:jiang  注释两行
    //.LeeActionSheetHeaderCornerRadii(CornerRadiiZero()) // 指定头部圆角半径
   // .LeeActionSheetCancelActionCornerRadii(CornerRadiiZero()) // 指定取消按钮圆角半径
    .LeeConfigMaxWidth(^CGFloat(LEEScreenOrientationType type) {
        return kScreenWidth;
    })
    .LeeActionSheetBackgroundColor([UIColor whiteColor]) // 通过设置背景颜色来填充底部间隙
    .LeeShow();
}

@end
