//
//  JHIdentyPublicAccountViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/4/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHIdentyPublicAccountViewController.h"
#import "JHIdentyInfoTableViewCell.h"
#import "JHIdentyPhotoInfoTableViewCell.h"
#import "JHReLaunchCertTableViewCell.h"
#import "JHAlertTableViewCell.h"
#import "JHUnionPayManager.h"
#import "JHUnionPayModel.h"
#import "JHWebViewController.h"
#import "TTjianbao.h"
#import "CommAlertView.h"
#import "CommHelp.h"
#import "JHUnionPayFooter.h"

#define kFourHour  (4*60*60*1000)

@interface JHIdentyPublicAccountViewController () <JHIdentyInfoTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    NSString *_reCertString;
    NSString *_alertCertString;
    
}

@property (nonatomic, strong) JHUnionPayUserInfoModel *infoModel;
@property (nonatomic, strong) JHUnionPayFooter *footer;
@property (nonatomic, copy) NSArray *modelArray;
@property (nonatomic, copy) NSString *transAmt;
@property (nonatomic, assign) NSInteger reqCount;    ///对公认证请求的次数

@end

@implementation JHIdentyPublicAccountViewController

- (instancetype)init {
    self= [super init];
    if (self) {
        _infoModel = [[JHUnionPayUserInfoModel alloc] init];
        _reqCount = 0;
        _alertCertString = JHLocalizedString(@"unionPayMoneyAndIdentyCode");
        _reCertString = JHLocalizedString(@"reBeginWhenNotRecieveMoneyCount");
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configFooter];
    [self loadUserListData];
    [self setCurrentSelectIndex:3];
}

- (void)configFooter {
    _footer = [[JHUnionPayFooter alloc] initWithFrame:CGRectMake(0, ScreenH - 140 - UI.bottomSafeAreaHeight, self.tableView.width, 140 + UI.bottomSafeAreaHeight)];
    _footer.buttonTitle = JHLocalizedString(@"nextStep");
    _footer.infoText = JHLocalizedString(@"tableFooterInfoText");
    @weakify(self);
    _footer.doneBlock = ^{
        @strongify(self);
        [self nextStep];
    };
    [self.view addSubview:_footer];
}

- (void)registerCell {
    self.tableView.tableFooterView = nil;
    self.tableView.scrollEnabled = YES;
    [self.tableView registerClass:[JHReLaunchCertTableViewCell class] forCellReuseIdentifier:kReLanuchCertIdentifer];

    [self.tableView registerClass:[JHAlertTableViewCell class] forCellReuseIdentifier:kJHAlertTableViewCellIdentifer];
    
    [self.tableView registerClass:[JHIdentyInfoTableViewCell class] forCellReuseIdentifier:kIdentyInfoCellIdentifer];
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {  ///提示信息
        JHAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJHAlertTableViewCellIdentifer];
        cell.message = _alertCertString;
        cell.iconName = @"icon_union_pay_alert_yellow";
        return cell;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            JHIdentyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentyInfoCellIdentifer];
            [cell setCorners:self.infoModel.listArray.count indexPath:indexPath];
            cell.listModel = [[_modelArray lastObject] firstObject];
            cell.textAlignment = NSTextAlignmentRight;
            cell.delegate = self;
            return cell;
        }
        if (indexPath.row == 1) {
            JHReLaunchCertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReLanuchCertIdentifer];
            [cell setMessage:_reCertString rangeString:JHLocalizedString(@"reSendSignCertRequest")];
            @weakify(self);
            cell.rangeStringAction = ^{
              ///重新发起认证
                @strongify(self);
                [self reRequestCertification];
            };
            return cell;
        }
    }
    
    JHIdentyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentyInfoCellIdentifer];
    JHUnionPayUserListModel *model = _modelArray[0][indexPath.row];
    [cell setCorners:self.infoModel.listArray.count indexPath:indexPath];
    if (model.dataType != JHDataTypePublicAccountAmount) {
        cell.isUserEnabled = NO;
    }
    cell.textAlignment = NSTextAlignmentRight;
    cell.listModel = model;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CGFloat messageHeight = [_alertCertString getHeightWithFont:[UIFont fontWithName:kFontMedium size:12] constrainedToSize:CGSizeMake(ScreenW - 40, MAXFLOAT)];
        return messageHeight+30;
    }
    if (indexPath.section == 2 && indexPath.row == 1) {
        CGFloat messageHeight = [_reCertString getHeightWithFont:[UIFont fontWithName:kFontMedium size:12] constrainedToSize:CGSizeMake(ScreenW - 40, MAXFLOAT)];
        return messageHeight+30;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 15)];
    footer.backgroundColor = kColorF5F6FA;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 15;
}

- (void)infoTableViewCellTextChanged:(UITextField *)textfield dataType:(JHDataType)dataType {
    NSString *changeText = textfield.text;
    if (dataType == JHDataTypePublicAccountAmount) {
        _transAmt = changeText;
    }
}

#pragma mark - 下一步点击事件
- (void)nextStep {
    ///对公认证
    if (![self.transAmt isNotBlank]) {
        [UITipView showTipStr:@"请输入随机打款金额"];
        return;
    }
    [self requestCert];
}

#pragma mark -
#pragma mark - Data

#pragma mark - 发起对公认证

- (void)requestCert {
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    @weakify(self);
    [SVProgressHUD show];
    [JHUnionPayManager accountContract:customerId transAmt:self.transAmt completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [SVProgressHUD dismiss];
        RequestModel *responseObj = (RequestModel *)respObj;
        self.reqCount = [responseObj.data[@"regCount"] integerValue];
        if (!hasError) {
            if ([responseObj.data[@"registerStatus"] intValue] == 1000) {
                NSString *signUrl = responseObj.data[@"requestInfoUrl"];
                [JHUnionPayManager shareManager].requestInfoUrl = signUrl;
                if ([signUrl isNotBlank]) {
                    JHWebViewController *vc = [[JHWebViewController alloc] init];
                    vc.urlString = signUrl;
                    vc.isNeedPoptoRoot = YES;
                    vc.titleString = JHLocalizedString(@"signContractTitle");
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            else {
                NSString *message = responseObj.data[@"failRegisterMessage"];
                self.footer.message = message;
                [UITipView showTipStr:message?:@"对公认证失败，请重试"];
            }
        }
        else {
            [UITipView showTipStr:responseObj.message?:@"链接网络错误，请检查网络"];
        }
    }];
}

///重新发起认证的网络请求
- (void)reRequestCertification {
    NSString *currentTime = [CommHelp getNowTimeTimestamp];
    if ([JHUserDefaults valueForKey:kSignContractFourHourKey] != nil) {
        ///不为空 表示当前时间
        NSString *lastTime = [JHUserDefaults objectForKey:kSignContractFourHourKey];
        NSString *curTime = [CommHelp getNowTimeTimestamp];
         ///如果时间差超过 4小时 可以请求数据 否则不可以
        long long interval = [curTime longLongValue] - [lastTime longLongValue];
        if (interval < kFourHour) {
            CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:JHLocalizedString(@"requestPerFourHour") cancleBtnTitle:JHLocalizedString(@"iKnow")];
            [[UIApplication sharedApplication].keyWindow addSubview:alert];
            return;
        }
        else {
            ///大于4小时 可以发起请求 移除之前保存的时间
            [JHUserDefaults removeObjectForKey:kSignContractFourHourKey];
            [JHUserDefaults synchronize];
            [self sendCertRequest];
        }
    }
    else {
        ///时间是空的  没有调用过这个接口 记录时间 并调用接口
        [JHUserDefaults setValue:currentTime forKey:kSignContractFourHourKey];
        [JHUserDefaults synchronize];
        [self sendCertRequest];
    }
}

///发起重新认证
- (void)sendCertRequest {
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    [SVProgressHUD dismiss];
    [JHUnionPayManager accountContract:customerId completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        [SVProgressHUD dismiss];
        RequestModel *responseObj = (RequestModel *)respObj;
        if ([responseObj.message isNotBlank]) {
            [UITipView showTipStr:responseObj.message];
        }
    }];
}

- (void)loadUserListData {
    JHUnionPayModel *unionPayModel = [JHUnionPayManager shareManager].unionpayModel;
    
    JHUnionPayUserListModel *model = [[JHUnionPayUserListModel alloc] init];
    model.title = @"公司开户名称";
    model.placeholder = @"";
    model.dataType = JHDataTypeBankAccountName;
    model.inputTextString = unionPayModel ? unionPayModel.bankAcctName : nil;
    
    JHUnionPayUserListModel *model1 = [[JHUnionPayUserListModel alloc] init];
    model1.title = @"银行账号";
    model1.placeholder = @"";
    model1.dataType = JHDataTypeBankCardNumber;
    model1.inputTextString = unionPayModel ? unionPayModel.bankAcctNo : nil;
    
    JHUnionPayUserListModel *model2 = [[JHUnionPayUserListModel alloc] init];
    model2.title = @"打款金额";
    model2.placeholder = @"请输入对公账账户收到的打款金额";
    model2.dataType = JHDataTypePublicAccountAmount;
    model2.keyboardType = UIKeyboardTypeDecimalPad;
    model2.maxInputLength = 30;

    _modelArray = @[@[model, model1], @[model2]];
    [self.tableView reloadData];
}


@end

