//
//  JHBusinessFansSettingMissionViewController.m
//  TTjianbao
//
//  Created by user on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansSettingMissionViewController.h"
#import "JHBusinessFansBottomView.h"
#import "JHBusinessFansMissionEditTableViewCell.h"
#import "JHBusinessFansAlertView.h"
#import "JHBusinessFansSettingBusiness.h"
#import "JHBusinessFansSettingEquityViewController.h"

@interface JHBusinessFansSettingMissionViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) JHBusinessFansBottomView *bottomView;
@property (nonatomic, strong) UITableView              *missionTableView;
@property (nonatomic, strong) NSMutableArray           *dataSourceArray;
@end

@implementation JHBusinessFansSettingMissionViewController

- (void)dealloc {
    NSLog(@"++++ 任务设置 release");
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self loadData];
}

- (void)loadData {
    /// 先赋值
    [self.dataSourceArray removeAllObjects];
    [self.dataSourceArray addObjectsFromArray:self.setModel.taskCheckList];
    
//    /// 然后检查本地数据库
//    @weakify(self);
//    [self.business checkFansSettingInfoWithCountWithCompletion:^(BOOL success, JHBusinessFansSettingApplyModel * _Nullable infoModel) {
//        @strongify(self);
//        if (!success || !infoModel) { /// 表示没有
//            [JHDispatch ui:^{
//                [self.missionTableView reloadData];
//            }];
//            return;
//        } else {
//            /// 有
//            if (infoModel.taskCheckList.count >0) {
//                for (int i = 0; i < infoModel.taskCheckList.count; i++) {
//                    JHBusinessFansTaskCheckListApplyModel *applySettingModel = infoModel.taskCheckList[i];
//                    for (int j = 0; j< self.dataSourceArray.count; j++) {
//                        JHBusinessFansSettingTaskCheckListModel *settingModel = self.dataSourceArray[j];
//                        NSString *applySettingModelTaskId = [NSString stringWithFormat:@"%ld",applySettingModel.taskId];
//                        if ([applySettingModelTaskId isEqualToString:settingModel.taskId]) {
//                            settingModel.check = YES;
//                        } else {
//                            settingModel.check = NO;
//                        }
//                    }
//                }
//            } else {
//                [JHDispatch ui:^{
//                    [self.missionTableView reloadData];
//                }];
//                return;
//            }
//        }
//        [JHDispatch ui:^{
            [self.missionTableView reloadData];
//        }];
//    }];
}

- (void)setupViews {
    self.bottomView = [[JHBusinessFansBottomView alloc] init];
    [self.view addSubview:self.bottomView];
    CGFloat bottomHeight = UI.bottomSafeAreaHeight;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(bottomHeight +59.f);
    }];
    @weakify(self);
    [self.bottomView businessFansBtnAction:^(JHBusinessFansBottomBtnStyle style) {
        @strongify(self);
        if (style == JHCustomerDescBottomBtnStyle_up) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JHBUSINESSSETTINGPROCESS" object:@(0)];
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JHBUSINESSSETTINGPROCESS" object:@(2)];            
            JHBusinessFansSettingEquityViewController *vc = [[JHBusinessFansSettingEquityViewController alloc] init];
            vc.applyModel = self.applyModel;
            vc.business   = self.business;
            vc.setModel   = self.setModel;
            [self addChildViewController:vc];
            [self.view addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.equalTo(self.view);
            }];

        }
    }];
    
    [self.view addSubview:self.missionTableView];
    [self.missionTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (UITableView *)missionTableView {
    if (!_missionTableView) {
        _missionTableView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _missionTableView.dataSource                     = self;
        _missionTableView.delegate                       = self;
        _missionTableView.backgroundColor                = HEXCOLOR(0xFFFFFF);
        _missionTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _missionTableView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _missionTableView.estimatedSectionHeaderHeight   = 0.1f;
            _missionTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        [_missionTableView registerClass:[JHBusinessFansMissionEditTableViewCell class] forCellReuseIdentifier:NSStringFromClass([JHBusinessFansMissionEditTableViewCell class])];
        if ([_missionTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_missionTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_missionTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_missionTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _missionTableView;
}

#pragma mark - Delegate DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHBusinessFansMissionEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHBusinessFansMissionEditTableViewCell class])];
    if (!cell) {
        cell = [[JHBusinessFansMissionEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([JHBusinessFansMissionEditTableViewCell class])];
    }
    @weakify(self);
    cell.changeBlock = ^{
        @strongify(self);
        [self checkAllTextHasValueAndChangeNextBtnStatus];
    };
    cell.isLastLine = (indexPath.row == (self.dataSourceArray.count - 1))?YES:NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    JHBusinessFansSettingTaskCheckListModel *model = self.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHBusinessFansMissionEditTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.model.defaultFlag isEqualToString:@"1"]) {
        return;
    }
    [cell settingBtnClickAction];
}

#pragma mark - check value
- (void)checkAllTextHasValueAndChangeNextBtnStatus {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i< self.dataSourceArray.count; i++) {
        JHBusinessFansSettingTaskCheckListModel *model = self.dataSourceArray[i];
        if (model.check) {
            JHBusinessFansTaskCheckListApplyModel *applySettingModel = [[JHBusinessFansTaskCheckListApplyModel alloc] init];
            applySettingModel.check   = model.check;
            applySettingModel.taskDes = model.taskDes;
            applySettingModel.taskId  = [model.taskId integerValue];
            [array addObject:applySettingModel];
            self.applyModel.taskCheckList = array;
        }
    }
    if (self.applyModel.taskCheckList.count >0) {
        [self.bottomView setNextButtonStatus:YES];
    } else {
        [self.bottomView setNextButtonStatus:NO];
    }
}


@end



