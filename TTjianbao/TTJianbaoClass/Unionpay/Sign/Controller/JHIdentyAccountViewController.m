//
//  JHIdentyAccountViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHIdentyAccountViewController.h"
#import "JHIdentyInfoTableViewCell.h"
#import "JHIdentyPhotoInfoTableViewCell.h"
#import "JHAlertTableViewCell.h"
#import "JHIdentyPublicAccountViewController.h"
#import "JHWebViewController.h"
#import "JHUnionPayManager.h"
#import "RSA.h"
#import "JHRSAKey.h"
#import "JHSelectbankBranchViewController.h"
#import "JHUnionSignSelectTimeView.h"
#import "JHUnionPaySectionHeader.h"
#import "TTjianbaoMarcoKeyword.h"

#define SECTION_HEADER_HEIGHT  29.f

@interface JHIdentyAccountViewController () <JHIdentyInfoTableViewCellDelegate, UITableViewDelegate, UITableViewDataSource, STPickerSingleDelegate, STPickerAreaDelegate>

@property (nonatomic, strong) JHUnionPayUserInfoModel *infoModel;

@property (nonatomic, copy) NSString *selectSubBranch; ///选择的所属支行
@property (nonatomic, copy) NSString *stockholderEndDate; ///选择控股股东有效期
@property (nonatomic, copy) NSString *benificiaryEndDate; ///选择受益人有效期
@property (nonatomic, copy) NSArray *bankBranchList;   ///支行列表
@property (nonatomic, strong) dispatch_group_t group;   ///上传图片资料的线程组


@end

@implementation JHIdentyAccountViewController

- (instancetype)init {
    self= [super init];
    if (self) {
        _infoModel = [[JHUnionPayUserInfoModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger index = (self.customerType == JHCustomerTypeCompany) ? 2 : 1;
    [self setCurrentSelectIndex:index];
    [self loadUserListData];
}

- (void)registerCell {
    
    [self.tableView registerClass:[JHAlertTableViewCell class] forCellReuseIdentifier:kJHAlertTableViewCellIdentifer];

    [self.tableView registerClass:[JHIdentyInfoTableViewCell class] forCellReuseIdentifier:kIdentyInfoCellIdentifer];

    [self.tableView registerClass:[JHIdentyPhotoInfoTableViewCell class] forCellReuseIdentifier:kIdentyPhotoInfoCellIdentifer];
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.infoModel == nil) {
        return 0;
    }
    if (section == JHIdentyAccountSectionTypeBank) {
        return self.infoModel.listArray.count;
    }
    if (section == JHIdentyAccountSectionTypeStockhplder) {///控股股东信息
        return self.infoModel.legalArray.count;
    }
    if (section == JHIdentyAccountSectionTypeBeneficiary) {///受益人信息
        return self.infoModel.beneficArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == JHIdentyAccountSectionTypeAlert ||
        indexPath.section == JHIdentyAccountSectionTypeMessage) {
        JHAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJHAlertTableViewCellIdentifer];
        if (indexPath.section == 0) {
            cell.message = self.infoModel.alert;
            cell.iconName = @"icon_union_pay_alert_yellow";
        }
        else {
            cell.message = self.infoModel.message;
            cell.iconName = @"icon_union_pay_alert_blue";
        }
        return cell;
    }
    
    if (indexPath.section == JHIdentyAccountSectionTypePhoto) {
        ///底部展示图片的cell
        JHIdentyPhotoInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentyPhotoInfoCellIdentifer];
        cell.dataArray = self.infoModel.photoArray;
        cell.clomnCount = (self.customerType == JHCustomerTypeCompany) ? 1 : 2;
        return cell;
    }

    ///上面的身份信息填写：姓名 身份证号 邮箱 手机号
    JHIdentyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentyInfoCellIdentifer];
    NSArray *listArray = [self currentListModel:indexPath];
    JHUnionPayUserListModel *model = listArray[indexPath.row];
    [cell setCorners:listArray.count indexPath:indexPath];
    cell.delegate = self;
    cell.listModel = model;
    NSString *str = [self cellInputText:model.dataType];
    cell.inputText = [str isNotBlank] ? str : @"";
    
    if (model.dataType == JHDataTypeBankAccoProvince ||
        model.dataType == JHDataTypeBankAccoSubBranch ||
        model.dataType == JHDataTypeStockholderIdEndDate ||
        model.dataType == JHDataTypeBeneficiaryIdEndDate) {
        ///省份 or 所属支行 显示箭头 并且不可编辑
        cell.isNeedShowArrow = YES;
        cell.isUserEnabled = NO;
    }
    else {
        cell.isNeedShowArrow = NO;
        cell.isUserEnabled = YES;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == JHIdentyAccountSectionTypeStockhplder && self.infoModel.legalArray.count > 0) {
        NSString *str = @"如果控股股东非自然人,请联系工作人员进行线下签约";
        JHUnionPaySectionHeader *header = [[JHUnionPaySectionHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenW, SECTION_HEADER_HEIGHT)];
        header.message = str;
        return header;
    }
    if (section == JHIdentyAccountSectionTypeBeneficiary && self.infoModel.beneficArray.count > 0) {
        NSString *str = @"请提交一位受益人信息";
        JHUnionPaySectionHeader *header = [[JHUnionPaySectionHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenW, SECTION_HEADER_HEIGHT)];
        header.message = str;
        return header;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == JHIdentyAccountSectionTypeStockhplder && self.infoModel.legalArray.count > 0) {
        return SECTION_HEADER_HEIGHT;
    }
    if (section == JHIdentyAccountSectionTypeBeneficiary && self.infoModel.beneficArray.count > 0) {
        return SECTION_HEADER_HEIGHT;
    }
    return CGFLOAT_MIN;
}

- (NSString *)cellInputText:(JHDataType)dataType {
    JHUnionPayModel *model = [JHUnionPayManager shareManager].unionpayModel;
    switch (dataType) {
        case JHDataTypeBankAccountName:///公司名称
            {
                if ([model.bankAcctName isNotBlank]) {
                    return model.bankAcctName;
                }
                return nil;
            }
            break;
        case JHDataTypeBankCardNumber:///银行卡号
            {
                if ([model.bankAcctNo isNotBlank]) {
                    return model.bankAcctNo;
                }
                return nil;
            }
            break;
        case JHDataTypeBankAccoProvince:///开户地区
            {
                if ([model.bankAcctProvince isNotBlank]) {
                    return model.bankAcctProvince;
                }
                return nil;
            }
            break;
        case JHDataTypeBankAccoSubBranch:///所属支行
            {
                if ([model.bankBranchName isNotBlank]) {
                    return model.bankBranchName;
                }
                return nil;
            }
            break;
        case JHDataTypeBankPhone:///银行预留手机号
            {
                if ([model.bankPhone isNotBlank]) {
                    return model.bankPhone;
                }
                return nil;
            }
            break;
        case JHDataTypeStockholderName:///控股股东姓名
            {
                if ([model.shareholderName isNotBlank]) {
                    return model.shareholderName;
                }
                return nil;
            }
            break;
        case JHDataTypeStockholderId:///控股股东证件号码
            {
                if ([model.shareholderCertno isNotBlank]) {
                    return model.shareholderCertno;
                }
                return nil;
            }
            break;
        case JHDataTypeStockholderIdEndDate: ///控股股东有效期
            {
                if ([model.shareholderCertExpire isNotBlank]) {
                    if ([model.shareholderCertExpire isEqualToString:kUnionPayForeverTimeKey]) {
                        return @"长期";
                    }
                    return model.shareholderCertExpire;
                }
                return nil;
            }
            break;
        case JHDataTypeBeneficiaryName:///受益人姓名
            {
                if ([model.bnfName isNotBlank]) {
                    return model.bnfName;
                }
                return nil;
            }
            break;
        case JHDataTypeBeneficiaryId:///受益人身份证号
            {
                if ([model.bnfCertno isNotBlank]) {
                    return model.bnfCertno;
                }
                return nil;
            }
            break;
        case JHDataTypeBeneficiaryIdEndDate: ///受益人有效期
            {
                if ([model.bnfCertExpire isNotBlank]) {
                    if ([model.bnfCertExpire isEqualToString:kUnionPayForeverTimeKey]) {
                        return @"长期";
                    }
                    return model.bnfCertExpire;
                }
                return nil;
            }
            break;
        case JHDataTypeBeneficiaryAddress:///受益人
            {
                if ([model.bnfHomeAddr isNotBlank]) {
                    return model.bnfHomeAddr;
                }
                return nil;
            }
            break;
        default:
            return nil;
            break;
    }
}

- (NSArray *)currentListModel:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case JHIdentyAccountSectionTypeStockhplder:
            return self.infoModel.legalArray.copy;
            break;
        case JHIdentyAccountSectionTypeBeneficiary:
            return self.infoModel.beneficArray.copy;
            break;
        default:
            return self.infoModel.listArray.copy;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    NSArray *listArray = [self currentListModel:indexPath];
    JHUnionPayUserListModel *model = listArray[indexPath.row];
    if (model.dataType == JHDataTypeBankAccoProvince) {
        ///开户地区
        [self.pickerView show];
        return;
    }
    if (model.dataType == JHDataTypeBankAccoSubBranch) {
        ///所属支行
        [self enterBankBranch];
    }
    if (model.dataType == JHDataTypeStockholderIdEndDate ||
        model.dataType == JHDataTypeBeneficiaryIdEndDate) {
        [self showTimePicker:model.dataType];
    }
}

- (void)showTimePicker:(JHDataType)dataType {
    @weakify(self);
    JHUnionSignSelectTimeView *dateView = [[JHUnionSignSelectTimeView alloc] initWithDateStyle:JHDatePickerViewDateTypeYearMonthDayMode completeBlock:^(NSString * _Nonnull dateString) {
        @strongify(self);
        [self configEndDate:dataType timeString:dateString];
    } longDateBlock:^(NSString * _Nonnull timeString) {
        @strongify(self);
        [self configEndDate:dataType timeString:timeString];
    }];
    
    [dateView show];
}

- (void)configEndDate:(JHDataType)dataType timeString:(NSString *)timeString {
    NSString *time = [timeString isEqualToString:kUnionPayForeverTimeKey] ? @"长期" : timeString;
    if (dataType == JHDataTypeStockholderIdEndDate) {
        self.stockholderEndDate = time;
        [JHUnionPayManager shareManager].unionpayModel.shareholderCertExpire = timeString;
    }
    else {
        self.benificiaryEndDate = time;
        [JHUnionPayManager shareManager].unionpayModel.bnfCertExpire = timeString;
    }
    [self.tableView reloadData];
}

- (void)enterBankBranch {
    ///二级地区为空 不执行跳转
    JHCityModel *city = [JHUnionPayManager shareManager].accoCity;
    if (city == nil) {
        [UITipView showTipStr:JHLocalizedString(@"selectBankAccoProvince")];
        return;
    }
    JHSelectbankBranchViewController *vc = [[JHSelectbankBranchViewController alloc] init];
    vc.cityModel = city;
    @weakify(self);
    vc.bankBranchBlock = ^(JHUnionPaySubBankModel * _Nonnull branchInfo) {
        @strongify(self);
        ///所属支行
        [self.tableView reloadData];
        [JHUnionPayManager shareManager].unionpayModel.bankBranchName = branchInfo.bankBranchName;
        [JHUnionPayManager shareManager].unionpayModel.bankNo = branchInfo.code;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == JHIdentyAccountSectionTypeAlert) {
        return self.infoModel.alertHeight;
    }
    if (indexPath.section == JHIdentyAccountSectionTypePhoto) {
        return 203;
    }
    if (indexPath.section == JHIdentyAccountSectionTypeMessage) {
        if (self.customerType == JHCustomerTypeCompany) {
            return self.infoModel.messageHeight;
        }
        return 0;
    }
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 15)];
    footer.backgroundColor = kColorF5F6FA;
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

- (void)infoTableViewCellTextChanged:(UITextField *)textfield dataType:(JHDataType)dataType {
    NSString *changeText = textfield.text;
    JHUnionPayModel *model = [JHUnionPayManager shareManager].unionpayModel;
    switch (dataType) {
        case JHDataTypeBankAccountName: ///开户名称
            model.bankAcctName = changeText;
            break;
        case JHDataTypeBankCardNumber: ///银行卡号
            model.bankAcctNo = changeText;
            break;
        case JHDataTypeBankPhone:  ///银行预留手机号
            model.bankPhone = changeText;
            break;
        case JHDataTypeStockholderName:  ///控股股东姓名
            model.shareholderName = changeText;
            break;
        case JHDataTypeStockholderId:   ///控股股东证件号码
            model.shareholderCertno = changeText;
            break;
        case JHDataTypeBeneficiaryName:  ///受益人姓名
            model.bnfName = changeText;
            break;
        case JHDataTypeBeneficiaryId:  ///受益人证件号码
            model.bnfCertno = changeText;
            break;
        case JHDataTypeBeneficiaryAddress:  ///受益人证件号码
            model.bnfHomeAddr = changeText;
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - 选择地区相关
#pragma mark - STPickerAreaDelegate

- (void)pickerArea:(STPickerArea *)pickerArea province:(JHProviceModel *)province city:(JHCityModel *)city area:(JHAreaModel *)area {
    ///选择开户行地区后需要将之前选择的所属支行信息置空
    [JHUnionPayManager shareManager].unionpayModel.bankBranchName = @"";
    [JHUnionPayManager shareManager].unionpayModel.bankNo = @"";
    [self.tableView reloadData];
    
    NSString *selectDistinct = [NSString stringWithFormat:@"%@-%@-%@", province.provinceName, city.cityName, area.districtName];
    [JHUnionPayManager shareManager].unionpayModel.bankAcctProvince = selectDistinct;
    [JHUnionPayManager shareManager].accoProvince = province;
    [JHUnionPayManager shareManager].accoCity = city;
    [JHUnionPayManager shareManager].accoArea = area;
}

#pragma mark - 下一步点击事件
- (void)nextStep {
    JHSignContractPageType type = (self.customerType == JHCustomerTypeCompany) ? JHSignContractPageTypeBankAccoInfo : JHSignContractPageTypeBankCardInfo;
    NSString *message = [JHUnionPayManager getTipStringWithPageType:type];
    if ([message isNotBlank]) {
        [UITipView showTipStr:message];
        return;
    }
    ///提交档案资料前提交图片信息到阿里云
    [self uploadImageSources];
}

#pragma mark - 进入对公账户认证界面
- (void)enterPublicIdentyPage {
    JHIdentyPublicAccountViewController *vc = [[JHIdentyPublicAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 进入h5签约界面
- (void)entersignH5Page {
    if (![[JHUnionPayManager shareManager].requestInfoUrl isNotBlank]) {
        [UITipView showTipStr:JHLocalizedString(@"signUrlIsBlank")];
        return;
    }
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.isNeedPoptoRoot = YES;
    vc.urlString = [JHUnionPayManager shareManager].requestInfoUrl;
    vc.titleString = JHLocalizedString(@"signContractTitle");
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - Data

- (void)uploadImageSources {
    [SVProgressHUD show];
    [[JHUnionPayManager shareManager] uploadSignContractImg:self.customerType CompleteBlock:^(NSString * _Nonnull idCardFront, NSString * _Nonnull idCardBack, NSString * _Nonnull idCardHandle, NSString * _Nonnull bankCardFront, NSString * _Nonnull bankCardBack, NSString * _Nonnull license, NSString * _Nonnull proofMertial) {
        JHUnionPayModel *model = [JHUnionPayManager shareManager].unionpayModel;
        model.cardProsPicUrl = idCardFront;
        model.cardConsPicUrl = idCardBack;
        model.personCardPicUrl = idCardHandle;
        if (self.customerType == JHCustomerTypeCompany) {
            model.licensePicUrl = license;
            model.openAccountPicUrl = proofMertial;
        }
        else {
            model.bankCardProsPicUrl = bankCardFront;
            model.bankCardConsPicUrl = bankCardBack;
        }
        
        [self submitSignContract];
    }];
}

///提交信息到后台
- (void)submitSignContract {
    NSDictionary *params = [[JHUnionPayManager shareManager] configParams];
    @weakify(self);
    [JHUnionPayManager submitSignContract:params completeBlock:^(id  _Nullable respObj, BOOL hasError) {
        [SVProgressHUD dismiss];
        @strongify(self);
        if (!hasError) {
            [UITipView showTipStr:JHLocalizedString(@"submitDataSuccess")];
            RequestModel *responseObj = (RequestModel *)respObj;
            [JHUnionPayManager shareManager].requestInfoUrl = responseObj.data[@"requestInfoUrl"];
            if (self.customerType == JHCustomerTypeCompany) {
                [self enterPublicIdentyPage];
            }
            else {
                [self entersignH5Page];
            }
        }
    }];
}

- (void)loadUserListData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JHUserAccount" ofType:@"plist"];
    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *key = nil;
    if (self.customerType == JHCustomerTypeCompany) {///企业商家
        key = @"company";
    }
    else {
        key = @"personal";
    }
    if (key == nil) {
        return;
    }
    JHUnionPayUserInfoModel *model = [JHUnionPayUserInfoModel mj_objectWithKeyValues:dict[key]];
    JHUnionPayModel *payModel = [JHUnionPayManager shareManager].unionpayModel;
    if (payModel) {
        [model.listArray enumerateObjectsUsingBlock:^(JHUnionPayUserListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = [JHUnionPayManager getuserInfoByDataType:obj.dataType];
            obj.inputTextString = str;
        }];
        [model.legalArray enumerateObjectsUsingBlock:^(JHUnionPayUserListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = [JHUnionPayManager getuserInfoByDataType:obj.dataType];
            obj.inputTextString = str;
        }];
        [model.beneficArray enumerateObjectsUsingBlock:^(JHUnionPayUserListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = [JHUnionPayManager getuserInfoByDataType:obj.dataType];
            obj.inputTextString = str;
        }];
    }
    if (self.customerType == JHCustomerTypeCompany) {
        [model.photoArray firstObject].selectPhoto = [JHUnionPayManager shareManager].proofMaterialPic;
    }else {
        ///回显图片
        [model.photoArray firstObject].selectPhoto = [JHUnionPayManager shareManager].bankCardProsPic;
        [model.photoArray lastObject].selectPhoto = [JHUnionPayManager shareManager].bankCardConsPic;
    }
    _infoModel = model;

    [self.tableView reloadData];
}

@end
