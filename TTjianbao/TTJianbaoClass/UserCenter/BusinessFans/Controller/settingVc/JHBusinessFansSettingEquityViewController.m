//
//  JHBusinessFansSettingEquityViewController.m
//  TTjianbao
//
//  Created by user on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansSettingEquityViewController.h"
#import "JHBusinessFansBottomView.h"
#import "JHBusinessFansEquityEditTableViewCell.h"
#import "JHBusinessFansSettingMissionViewController.h"
#import "IQKeyboardManager.h"
#import "JHBusinessFansAlertView.h"
#import "JHFansYouHuiQuanController.h"

#import "JHShopCouponViewController.h"

@interface JHBusinessFansSettingEquityViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (nonatomic, strong) JHBusinessFansBottomView *bottomView;
@property (nonatomic, strong) UITableView              *equityTableView;
@property (nonatomic, strong) NSMutableArray           *dataSourceArray;
@property (nonatomic, strong) JHBusinessFansEquityEditTableViewCell *cell;
@end


@implementation JHBusinessFansSettingEquityViewController

- (void)dealloc {
    NSLog(@"++++ 权益设置 release");
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)loadData {

    if (self.setModel.levelRewardDTOList.count >0) {
        for (int i = 0 ; i< self.setModel.levelRewardDTOList.count; i++) {
            JHBusinessFansSettinglevelRewardDTOListModel *setModel = self.setModel.levelRewardDTOList[i];
            JHBusinessFansRewardConfigVoListApplyModel *applyModel = [[JHBusinessFansRewardConfigVoListApplyModel alloc] init];
            applyModel.levelType = setModel.levelType;
            applyModel.fansRewardConfigList = [setModel.rewardVos jh_map:^id _Nonnull(JHBusinessFansSettinglevelRewardVosModel * _Nonnull setSubModel, NSUInteger idx) {
                JHBusinessFansRewardConfigListApplyModel *applySubModel = [[JHBusinessFansRewardConfigListApplyModel alloc] init];
                applySubModel.rewardName = setSubModel.rewardName;
                applySubModel.rewardType = setSubModel.rewardType;
                return applySubModel;
            }];
            [self.dataSourceArray addObject:applyModel];
        }
        [self.equityTableView reloadData];
    } else {
        [self.dataSourceArray removeAllObjects];
        for (int i = 0 ; i< 10; i++) {
            JHBusinessFansRewardConfigVoListApplyModel *model = [[JHBusinessFansRewardConfigVoListApplyModel alloc] init];
            model.levelType = [NSString stringWithFormat:@"%d",i+1];
            [self.dataSourceArray addObject:model];
        }
        [JHDispatch ui:^{
            [self.equityTableView reloadData];
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self loadData];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)setupViews {
    self.bottomView = [[JHBusinessFansBottomView alloc] init];
    [self.view addSubview:self.bottomView];
    CGFloat bottomHeight = UI.bottomSafeAreaHeight;
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(bottomHeight +59.f);
    }];
    [self.bottomView renameBtns:@[@"上一步",@"提交"]];

    @weakify(self);
    [self.bottomView businessFansBtnAction:^(JHBusinessFansBottomBtnStyle style) {
        @strongify(self);
        if (style == JHCustomerDescBottomBtnStyle_up) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"JHBUSINESSSETTINGPROCESS" object:@(1)];
        } else {
            if ([self checkAllValueIfCorrect]) {
                /// 提交
                [SVProgressHUD show];
                self.applyModel.fansRewardConfigVoList = self.dataSourceArray;
                [JHBusinessFansSettingBusiness businessUploadFans:self.applyModel Completion:^(NSError * _Nullable error, BOOL isSuccess) {
                    [SVProgressHUD dismiss];
                    if (isSuccess) {
                        JHBusinessFansAlertView *alert = [[JHBusinessFansAlertView alloc]initWithTitle:@"提交成功" andDesc:@"平台将在5个工作日审核完成，请耐心等待！" cancleBtnTitle:@"我知道了"];
                        [self.business removeFansSettingInfo:self.applyModel completion:^(BOOL success) {
                            NSLog(@"删除本地粉丝设置 = %d",success);
                        }];
                        [alert addCloseBtn];
                        [[UIApplication sharedApplication].keyWindow addSubview:alert];
                        alert.cancleHandle = ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"JHBUSINESSFANSSETTINGSUCCESS" object:nil];
                        };
                    } else {
    //                    JHBusinessFansAlertView *alert = [[JHBusinessFansAlertView alloc] initWithTitle:@"" andDesc:error.localizedDescription cancleBtnTitle:@""];
    //                    [alert addCloseBtn];
    //                    [[UIApplication sharedApplication].keyWindow addSubview:alert];
                        [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:1.5f position:CSToastPositionCenter];
                    }
                }];
            }
        }
    }];
    
    [self.view addSubview:self.equityTableView];
    [self.equityTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
}

- (UITableView *)equityTableView {
    if (!_equityTableView) {
        _equityTableView                                = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _equityTableView.dataSource                     = self;
        _equityTableView.delegate                       = self;
        _equityTableView.backgroundColor                = HEXCOLOR(0xFFFFFF);
        _equityTableView.separatorStyle                 = UITableViewCellSeparatorStyleNone;
        _equityTableView.estimatedRowHeight             = 10.f;
        if (@available(iOS 11.0, *)) {
            _equityTableView.estimatedSectionHeaderHeight   = 0.1f;
            _equityTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets   = NO;
        }
        for (int i = 0; i<10; i++) {
            NSString *string = [NSString stringWithFormat:@"%@_%d",NSStringFromClass([JHBusinessFansEquityEditTableViewCell class]),i];
            [_equityTableView registerClass:[JHBusinessFansEquityEditTableViewCell class] forCellReuseIdentifier:string];
        }
        if ([_equityTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_equityTableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
        if ([_equityTableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_equityTableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        }
    }
    return _equityTableView;
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
    NSString *string = [NSString stringWithFormat:@"%@_%ld",NSStringFromClass([JHBusinessFansEquityEditTableViewCell class]),(long)indexPath.row];
    JHBusinessFansEquityEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[JHBusinessFansEquityEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.isLastLine = (indexPath.row == (self.dataSourceArray.count - 1))?YES:NO;
    JHBusinessFansRewardConfigVoListApplyModel *model = self.dataSourceArray[indexPath.row];
    @weakify(self);
    cell.changeBlock = ^{
        @strongify(self);
        [self checkAllTextHasValueAndChangeNextBtnStatus];
    };
    
    [cell  setShowYouHuiQuanBlock:^{
        @strongify(self);
        [self bottomAction:indexPath.row];
    }];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)bottomAction:(NSInteger)row{
    JHFansYouHuiQuanController * vc = [JHFansYouHuiQuanController new];
    [self.navigationController presentViewController:vc animated:NO completion:nil];
    @weakify(self);

    [vc setCreateCoup:^{
        @strongify(self);
        JHShopCouponViewController * vc = [JHShopCouponViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [vc setSeleBlock:^(JHFansCoupouModel * _Nonnull model) {
        @strongify(self);
        [self setData:row andcoupModel:model];
    }];
}

- (void)setData:(NSInteger)row andcoupModel:(JHFansCoupouModel*)coumodel{
    JHBusinessFansEquityEditTableViewCell *cell = [self.equityTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    cell.textFieldArray[0].text =  coumodel.couponId;
    [cell equityEditInfoCallBack];
    cell.codeLbl.text = [NSString stringWithFormat:@"券ID：%@",coumodel.couponId] ;
}



#pragma mark - check value
- (void)checkAllTextHasValueAndChangeNextBtnStatus {
    if ([self checkAllValueIfCorrect]) {
        [self.bottomView setNextButtonStatus:YES];
    } else {
        [self.bottomView setNextButtonStatus:NO];
    }
}

- (BOOL)checkAllValueIfCorrect {
    BOOL isOutsideAllTextHasValue = NO;
    BOOL isAllTextHasValue = NO;
    for (int i = 0; i< _dataSourceArray.count; i++) {
        JHBusinessFansRewardConfigVoListApplyModel *model = (JHBusinessFansRewardConfigVoListApplyModel *)_dataSourceArray[i];
        for (int j = 0; j<model.fansRewardConfigList.count; j++) {
            JHBusinessFansRewardConfigListApplyModel *subModel = (JHBusinessFansRewardConfigListApplyModel *)model.fansRewardConfigList[j];
            if ([subModel.rewardType isEqualToString:@"2"]) {
                isAllTextHasValue = YES;
                break;
            } else {
                if (!isEmpty(subModel.rewardType) && !isEmpty(subModel.rewardName)) {
                    isAllTextHasValue = YES;
                    break;
                } else {
                    isAllTextHasValue = NO;
                    continue;
                }
            }
        }
        if (!isAllTextHasValue) {
            isOutsideAllTextHasValue = NO;
            break;
        } else {
            isOutsideAllTextHasValue = YES;
        }
    }
    return isOutsideAllTextHasValue;
}


@end
