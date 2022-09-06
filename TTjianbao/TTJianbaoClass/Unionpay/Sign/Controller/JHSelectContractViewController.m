//
//  JHSelectContractViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/4/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
// 银联签约 - 选择签约类型 ： 个人商户 & 企业商户

#import "JHSelectContractViewController.h"
#import "JHUnionPayModel.h"
#import "JHMerchantTypeCell.h"
#import "JHMerchantTypeModel.h"
#import "UserInfoRequestManager.h"
#import "User.h"
#import "JHIdentyUserInfoViewController.h"
#import "JHUnionPayManager.h"
#import "CommAlertView.h"
#import "RSA.h"
#import "JHRSAKey.h"
#import "PanNavigationController.h"

@interface JHSelectContractViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *safeImageView;       ///顶部安全图标
@property (nonatomic, strong) UILabel *titleLabel;              ///标题
@property (nonatomic, strong) UILabel *descLabel;               ///描述
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) JHUnionPayTypeModel *selectModel;  ///选中的model

@property (nonatomic, strong) UIButton *signButton;             ///签约按钮

@end

@implementation JHSelectContractViewController

#pragma mark -
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kColorF5F6FA;
    [self initNav];
    [self configUI];
    [self loadData];
    [self setDefaultIndex:kCustomerTypePersonal];
    ///刚进来需要获取用户之前填写的签约信息
    [self getSignInfo];
}

///禁止侧滑
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    nav.isForbidDragBack = YES; //禁止全屏侧滑
}

///打开侧滑
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    PanNavigationController *nav = (PanNavigationController *)self.navigationController;
    nav.isForbidDragBack = NO; //禁止全屏侧滑
}

- (void)initNav {
//    [self initToolsBar];
    self.title = JHLocalizedString(@"signContractTitle");
//    [self.navbar setTitle:JHLocalizedString(@"signContractTitle")];
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0, 0, 44, 44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)configUI {
    _safeImageView = [UIImageView jh_imageViewAddToSuperview:self.view];
    _titleLabel = [UILabel jh_labelWithFont:18 textColor:HEXCOLOR(0x333333) textAlignment:NSTextAlignmentCenter addToSuperView:self.view];
    
    _descLabel = [UILabel jh_labelWithFont:12 textColor:HEXCOLOR(0x666666) textAlignment:NSTextAlignmentLeft addToSuperView:self.view];
    _descLabel.numberOfLines = 0;
    
    _signButton = [UIButton jh_buttonWithTitle:JHLocalizedString(@"beginSign") fontSize:18.f textColor:HEXCOLOR(0x333333) target:self action:@selector(beginToSign) addToSuperView:self.view];
    _signButton.backgroundColor = HEXCOLOR(0xFEE100);

    [_safeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.jhNavView.mas_bottom).offset(40);
        make.size.mas_equalTo(CGSizeMake(90, 104));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(25);
        make.top.equalTo(self.safeImageView.mas_bottom).offset(20);
        make.leading.trailing.equalTo(self.view);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(234.5, 51));
    }];
    
    [_signButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(44);
        make.bottom.equalTo(self.view).offset(-(UI.bottomSafeAreaHeight + 30));
    }];
        
    [_signButton layoutIfNeeded];
    _signButton.layer.cornerRadius = _signButton.height/2.f;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(18.5);
        make.leading.trailing.equalTo(self.view);
        make.bottom.equalTo(self.signButton.mas_top).offset(-10);
    }];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [_tableView registerClass:[JHMerchantTypeCell class] forCellReuseIdentifier:kMerchantTypeIdentifer];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHMerchantTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kMerchantTypeIdentifer];
    JHUnionPayTypeModel *model = self.dataArray[indexPath.row];
    cell.icon = model.icon;
    cell.title = model.title;
    cell.desc = model.desc;
    cell.cellStyle = JHMerchantTypeCellStyleBorder;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHUnionPayTypeModel *model = self.dataArray[indexPath.row];
    _selectModel = model;  ///记录选中的数据
    if ([self isNeedResetUserInfo]) {///重置用户信息
        [[JHUnionPayManager shareManager] resetUserInfo];
    }
}

#pragma mark -
#pragma mark - Button Action

- (void)beginToSign {
    NSLog(@"--- beginToSign ---");
    if (!_selectModel) {
        [UITipView showTipStr:JHLocalizedString(@"haveNotSelectCustomerType")];
        return;
    }
    ///签约用户信息  --- 实名认证
    [JHUnionPayManager shareManager].unionpayModel.customerType = _selectModel.customerType;
    JHIdentyUserInfoViewController *vc = [[JHIdentyUserInfoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)backActionButton:(UIButton *)sender {
    if ([JHUnionPayManager shareManager].unionpayModel == nil) {
        [self popTolastPage];
    }
    else {
        @weakify(self);
        [self showAlertView:^{
            @strongify(self);
            [JHUnionPayManager shareManager].unionpayModel = nil;
            [self popTolastPage];
        }];
    }
}

#pragma mark -
#pragma mark - Data

- (void)loadData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JHUnionpayType" ofType:@"plist"];
    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *listArray = [JHUnionPayTypeModel mj_objectArrayWithKeyValuesArray:dict[@"list"]];
    _dataArray = [NSMutableArray arrayWithArray:listArray];
    _selectModel = [self.dataArray firstObject];
    _safeImageView.image = [UIImage imageNamed:dict[@"icon"]];
    _titleLabel.text = dict[@"title"];
    _descLabel.text = dict[@"desc"];
    [self.tableView reloadData];
}

///获取签约信息
- (void)getSignInfo {
    @weakify(self);
    [JHUnionPayManager getUnionSignAllInfoWithQueryType:1 completeBlock:^(NSDictionary * _Nonnull dataDic, BOOL success) {
        @strongify(self);
        if (success) {
            JHUnionPayModel *model = [JHUnionPayModel mj_objectWithKeyValues:dataDic];
            [[JHUnionPayManager shareManager] cofigSignInfo:model];
            [self setDefaultIndex:model.customerType];
        }
        else {
            [UITipView showTipStr:dataDic[@"errorMessage"]];
        }
    }];
}

#pragma mark -
#pragma mark - Private Method

///展示提示框 提示用户退出丢失信息
- (void)showAlertView:(void(^)(void))block {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:JHLocalizedString(@"sign_contractWillCleanAllDataWhenQuit") cancleBtnTitle:JHLocalizedString(@"sure") sureBtnTitle:JHLocalizedString(@"cancel")];
    [JHKeyWindow addSubview:alert];
    alert.cancleHandle = ^{
        if (block) {
            block();
        }
    };
}

- (void)setDefaultIndex:(NSString *)type {
    ///00：企业   02:个人
    NSInteger index = 0;
    if ([type isNotBlank]) {
        index = ([type intValue] == 0)?1:0;
    }
    else {
        index = 0;
    }
    _selectModel = [self.dataArray objectAtIndex:index];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)popTolastPage {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 判断是否需要重置用户签约信息
- (BOOL)isNeedResetUserInfo {
    JHUnionPayModel *payModel = [JHUnionPayManager shareManager].unionpayModel;
    JHCustomerType selType = [_selectModel.customerType intValue];
    JHCustomerType payType = [payModel.customerType intValue];
    if (payModel) {
        if (selType == JHCustomerTypePersonal &&
            payType == JHCustomerTypeCompany) {
            return YES;
        }
        if (selType == JHCustomerTypeCompany &&
            payType == JHCustomerTypePersonal) {
            return YES;
        }
        return NO;
    }
    return NO;
}

@end
