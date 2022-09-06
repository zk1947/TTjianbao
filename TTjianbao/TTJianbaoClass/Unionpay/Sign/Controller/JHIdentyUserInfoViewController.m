//
//  JHIdentyUserInfoViewController.m
//  TTjianbao
//
//  Created by lihui on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHIdentyUserInfoViewController.h"
#import "JHIdentyInfoTableViewCell.h"
#import "JHIdentyPhotoInfoTableViewCell.h"
#import "JHUnionPayModel.h"
#import "JHIdentyBusinessViewController.h"
#import "JHIdentyAccountViewController.h"
#import "JHUnionPayManager.h"
#import "CommHelp.h"
#import "TTjianbao.h"
#import "RSA.h"
#import "JHRSAKey.h"

@interface JHIdentyUserInfoViewController () <UITableViewDelegate, UITableViewDataSource,JHIdentyInfoTableViewCellDelegate>

@property (nonatomic, strong) JHUnionPayUserInfoModel *infoModel;
//@property (nonatomic, strong) JHUnionPayModel *userInfo;   ///记录用户填写的用户信息

@end

@implementation JHIdentyUserInfoViewController

- (instancetype)init {
    self= [super init];
    if (self) {
        _infoModel = [[JHUnionPayUserInfoModel alloc] init];
//        _userInfo = [JHUnionPayManager shareManager].unionpayModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    ///当前流程是1
    [self setCurrentSelectIndex:0];
    [self loadUserListData];
}

- (void)registerCell {
    [self.tableView registerClass:[JHIdentyInfoTableViewCell class] forCellReuseIdentifier:kIdentyInfoCellIdentifer];

    [self.tableView registerClass:[JHIdentyPhotoInfoTableViewCell class] forCellReuseIdentifier:kIdentyPhotoInfoCellIdentifer];
}

#pragma mark - 下一步点击事件
- (void)nextStep {
    NSString *message = [JHUnionPayManager getTipStringWithPageType:JHSignContractPageTypeAccunt];
    if ([message isNotBlank]) {
        [UITipView showTipStr:message];
        return;
    }
    
    if (self.customerType == JHCustomerTypeCompany) {
        ///企业认证：跳转到营业信息页面
        [self enterBusinessPage];
    }
    else {
        [self enterBankAccountPage];
    }
}

///营业信息填写
- (void)enterBusinessPage {
    JHIdentyBusinessViewController *vc = [[JHIdentyBusinessViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

///银行卡信息  & 开户行填写界面
- (void)enterBankAccountPage {
    JHIdentyAccountViewController *vc = [[JHIdentyAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.infoModel == nil) {
        return 0;
    }
    if (section == 0) {
        return self.infoModel.listArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ///底部展示图片的cell
        JHIdentyPhotoInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentyPhotoInfoCellIdentifer];
        cell.dataArray = self.infoModel.photoArray;
        cell.clomnCount = 2;
        return cell;
    }

    ///上面的身份信息填写：姓名 身份证号 邮箱 手机号 家庭住址
    JHIdentyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentyInfoCellIdentifer];
    cell.delegate = self;
    JHUnionPayUserListModel *model = self.infoModel.listArray[indexPath.row];
    [cell setCorners:self.infoModel.listArray.count indexPath:indexPath];
    cell.listModel = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 289;
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

#pragma mark - JHIdentyInfoTableViewCellDelegate

- (void)infoTableViewCellTextChanged:(UITextField *)textfield dataType:(JHDataType)dataType {
    NSString *changeText = textfield.text;
    switch (dataType) {
        case JHDataTypeLegalName:  ///输入姓名
            [JHUnionPayManager shareManager].unionpayModel.legalName = changeText;
            break;
        case JHDataTypeIdNumber:  ///输入身份证号
            [JHUnionPayManager shareManager].unionpayModel.legalIdcardNo = changeText;
            break;
        case JHDataTypeEmail:  ///输入邮箱
            [JHUnionPayManager shareManager].unionpayModel.legaEmail = changeText;
            break;
        case JHDataTypePhone:  ///输入手机号
            [JHUnionPayManager shareManager].unionpayModel.legalMobile = changeText;
            break;
        case JHDataTypeLegalHomeAddress:  ///输入家庭地址
            [JHUnionPayManager shareManager].unionpayModel.legalHomeAddr = changeText;
            break;
        default:
            break;
    }
}

///结束输入
- (void)infoTableViewCellDidEndEditing:(UITextField *)textfield dataType:(JHDataType)dataType {
    if (self.customerType == JHCustomerTypePersonal &&
        dataType == JHDataTypeLegalName) {
        ///如果是个人 银行开户行名称 就是本人名字
        [JHUnionPayManager shareManager].unionpayModel.bankAcctName = [JHUnionPayManager shareManager].unionpayModel.legalName;///个人商家的开户行名称
    }
}

#pragma mark -
#pragma mark -  Data

- (void)loadUserListData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JHIdentyUserList" ofType:@"plist"];
    NSDictionary *dict =[NSDictionary dictionaryWithContentsOfFile:filePath];
    NSString *key = nil;
    if (self.customerType == JHCustomerTypeCompany) {///企业商家
        key = @"company";
    }
    else {
        key = @"personal";
    }
    
    JHUnionPayUserInfoModel *model = [JHUnionPayUserInfoModel mj_objectWithKeyValues:dict[key]];
    JHUnionPayModel *payModel = [JHUnionPayManager shareManager].unionpayModel;
    if (payModel) {
        [model.listArray enumerateObjectsUsingBlock:^(JHUnionPayUserListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *str = [JHUnionPayManager getuserInfoByDataType:obj.dataType];
            obj.inputTextString = str;
        }];
    }
    ///回显图片
    [model.photoArray firstObject].selectPhoto = [JHUnionPayManager shareManager].idCardProsPic;
    model.photoArray[1].selectPhoto = [JHUnionPayManager shareManager].idCardConsPic;
    [model.photoArray lastObject].selectPhoto = [JHUnionPayManager shareManager].idCardHandlePic;
    
    _infoModel = model;
    [self.tableView reloadData];
}

@end
