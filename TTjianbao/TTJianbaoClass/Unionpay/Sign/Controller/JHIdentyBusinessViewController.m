//
//  JHIdentyBusinessViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHIdentyBusinessViewController.h"
#import "JHIdentyInfoTableViewCell.h"
#import "JHIdentyPhotoInfoTableViewCell.h"
#import "JHAlertTableViewCell.h"
#import "JHIdentyAccountViewController.h"
#import "STPickerArea.h"
#import "JHProviceModel.h"
#import "JHUnionPayManager.h"

@interface JHIdentyBusinessViewController () <STPickerAreaDelegate, UITableViewDelegate, UITableViewDataSource, JHIdentyInfoTableViewCellDelegate>

@property (nonatomic, strong) JHUnionPayUserInfoModel *infoModel;
@property (nonatomic, copy) NSString *selectDistinct;           ///选择地区字符串

@end

@implementation JHIdentyBusinessViewController

- (instancetype)init {
    self= [super init];
    if (self) {
        _infoModel = [[JHUnionPayUserInfoModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ///获取个人信息的流程线数据
    [self loadUserListData];
    [self setCurrentSelectIndex:1];
}

- (void)registerCell {
    
    [self.tableView registerClass:[JHAlertTableViewCell class] forCellReuseIdentifier:kJHAlertTableViewCellIdentifer];

    [self.tableView registerClass:[JHIdentyInfoTableViewCell class] forCellReuseIdentifier:kIdentyInfoCellIdentifer];

    [self.tableView registerClass:[JHIdentyPhotoInfoTableViewCell class] forCellReuseIdentifier:kIdentyPhotoInfoCellIdentifer];
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.infoModel == nil) {
        return 0;
    }
    if (section == 1) {
        return self.infoModel.listArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ///上面的身份信息填写：姓名 身份证号 邮箱 手机号
        JHIdentyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentyInfoCellIdentifer];
        cell.delegate = self;
        JHUnionPayUserListModel *model = self.infoModel.listArray[indexPath.row];
        [cell setCorners:self.infoModel.listArray.count indexPath:indexPath];
        if (model.dataType == JHDataTypeAccountProvince) {
            ///营业地区 需要选择地区 带箭头
            cell.isNeedShowArrow = YES;
            cell.isUserEnabled = NO;
            cell.inputText = [self.selectDistinct isNotBlank] ? self.selectDistinct : nil;
        }
        cell.listModel = model;
        return cell;
    }

    if (indexPath.section == 2) {
        ///底部展示图片的cell
        JHIdentyPhotoInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentyPhotoInfoCellIdentifer];
        cell.dataArray = self.infoModel.photoArray;
        cell.clomnCount = 1;
        return cell;
    }
    
    ///底部展示图片的cell
    JHAlertTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJHAlertTableViewCellIdentifer];
    cell.message = self.infoModel.alert;
    cell.iconName = @"icon_union_pay_alert_yellow";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JHUnionPayUserListModel *model = self.infoModel.listArray[indexPath.row];
    if (model.dataType == JHDataTypeAccountProvince) {
        [self.view endEditing:YES];
        ///营业地区
        [self.pickerView show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 44;
    }
    if (indexPath.section == 2) {
        return 203;
    }
    return self.infoModel.alertHeight;
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
    switch (dataType) {
        case JHDataTypeAccountShopName: ///营业名称
            [JHUnionPayManager shareManager].unionpayModel.shopName = changeText;
            break;
        case JHDataTypeShopDetailAddress:  ///详细地址
            [JHUnionPayManager shareManager].unionpayModel.shopAddrExt = changeText;
            break;
        case JHDataTypeSocialUniformCode:  /// 社会统一代码
            [JHUnionPayManager shareManager].unionpayModel.shopLic = changeText;
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark - 选择地区相关
#pragma mark - STPickerAreaDelegate

- (void)pickerArea:(STPickerArea *)pickerArea province:(JHProviceModel *)province city:(JHCityModel *)city area:(JHAreaModel *)area {
    NSLog(@"province:--- %@\n city:%@\n area:%@\n", province.provinceName, city.cityName, area.districtName);
    self.selectDistinct = [NSString stringWithFormat:@"%@-%@-%@", province.provinceName, city.cityName, area.districtName];
    [self.tableView reloadData];

    [JHUnionPayManager shareManager].unionpayModel.shopProvince = self.selectDistinct;
    [JHUnionPayManager shareManager].unionpayModel.shopProvinceId = province.provinceId;
    [JHUnionPayManager shareManager].unionpayModel.shopCityId = city.cityId;
    [JHUnionPayManager shareManager].unionpayModel.shopCountryId = area.districtId;
}

#pragma mark - Action Method

- (void)nextStep {
    NSString *message = [JHUnionPayManager getTipStringWithPageType:JHSignContractPageTypeBusiness];
    if ([message isNotBlank]) {
        [UITipView showTipStr:message];
        return;
    }

    ///跳转到对公账户认证的界面
    JHIdentyAccountViewController *vc = [[JHIdentyAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - Data

- (void)loadUserListData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JHUserBusiness" ofType:@"plist"];
    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:filePath];
    JHUnionPayUserInfoModel *model = [JHUnionPayUserInfoModel mj_objectWithKeyValues:dict[@"company"]];
    [model.photoArray firstObject].selectPhoto = [JHUnionPayManager shareManager].accoLicensePic;
    JHUnionPayModel *payModel = [JHUnionPayManager shareManager].unionpayModel;
    if (payModel) {
        [model.listArray enumerateObjectsUsingBlock:^(JHUnionPayUserListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = [JHUnionPayManager getuserInfoByDataType:obj.dataType];
            obj.inputTextString = str;
        }];
    }
    ///营业执照  用于信息回显
    [model.photoArray firstObject].selectPhoto = [JHUnionPayManager shareManager].accoLicensePic;
    
    _infoModel = model;
    [self.tableView reloadData];
}

@end
