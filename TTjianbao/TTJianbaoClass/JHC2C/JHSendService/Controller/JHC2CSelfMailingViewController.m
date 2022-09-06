//
//  JHC2CSelfMailingViewController.m
//  TTjianbao
//
//  Created by hao on 2021/6/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#import "JHC2CSelfMailingViewController.h"
#import "JHC2CCourierCompanyView.h"
#import "JHC2CSendPackageView.h"
#import "JHQRViewController.h"
#import <IQKeyboardManager.h>
#import "UIImage+JHColor.h"
#import "JHC2CSendServiceViewModel.h"
#import "JHC2CSendServiceModel.h"
#import "JHC2CSendServiceManager.h"
#import "JHRefundDetailBusiness.h"

@interface JHC2CSelfMailingViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView *contentScrollView;
//收件地址
@property (nonatomic, strong) UIView *addressInfoView;
@property (nonatomic, strong) UILabel *addressTitleLabel;
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UIImageView *addressLogoImg;
@property (nonatomic, strong) UILabel *addressLabel;//取件地址
@property (nonatomic, strong) UILabel *nameLabel;//联系方式
@property (nonatomic, strong) UIButton *addressCopyBtn;
//快递公司
@property (nonatomic, strong) UIView *logisticsInfoView;
@property (nonatomic, strong) UILabel *logisticsTitleLabel;
@property (nonatomic, strong) UIView *logisticsView;
@property (nonatomic, strong) UILabel *logisticsTextLabel;
@property (nonatomic, strong) UILabel *logisticsLabel;//快递公司
@property (nonatomic, strong) JHC2CCourierCompanyView *courierView;
//快递单号
@property (nonatomic, strong) UILabel *orderNumTitleLabel;
@property (nonatomic, strong) UITextField *enterNumTF;//快递单号
@property (nonatomic, strong) UIButton *scanBtn;//扫描
//包装
@property (nonatomic, strong) JHC2CSendPackageView *packageView;
@property (nonatomic, strong) UIButton *submitBtn;

@property (nonatomic, strong) JHC2CSendServiceViewModel *selfMailingViewModel;
@property (nonatomic, strong) JHC2CSendServiceModel *selfMailingModel;
///选择的快递公司编码
@property (nonatomic, copy) NSString *selectCompanyCode;

@end

@implementation JHC2CSelfMailingViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"集市自助寄出页",
        @"order_id":self.orderId
    } type:JHStatisticsTypeSensors];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat topHeight = 0;
    if (self.orderStatus == 1) {
        self.title = @"自助寄出";
        topHeight = UI.statusAndNavBarHeight;
    }
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(topHeight, 0, 60 + UI.bottomSafeAreaHeight, 0));
    }];
    //收件地址
    [self addBuyerAddressInfoView];
    //快递公司
    [self addLogisticsInfoView];
    //快递单号
    [self addOrderNumberInfoView];
    //物流包装
    [self addPackageInfoView];
    //底部提交
    [self addBottomInfoView];
    
    //选择快递公司事件
    [self clickLogisticsAction];

    [self.contentScrollView jh_addTapGesture:^{
        [self.enterNumTF resignFirstResponder];
    }];
    [self loadData];
    [self configData];
}

#pragma mark - UI
///收件地址
- (void)addBuyerAddressInfoView{
    [self.contentScrollView addSubview:self.addressInfoView];
    [self.addressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView).offset(10);
        make.left.equalTo(self.contentScrollView).offset(12);
        make.right.equalTo(self.contentScrollView).offset(-12);
        make.width.offset(kScreenWidth-24);
    }];
    [self.addressInfoView addSubview:self.addressTitleLabel];
    [self.addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressInfoView).offset(10);
        make.left.equalTo(self.addressInfoView).offset(12);
    }];
    [self.addressInfoView addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitleLabel.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.addressInfoView);
    }];

    //图标
    [self.addressView addSubview:self.addressLogoImg];
    [self.addressLogoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.addressView).offset(12);
        make.centerY.equalTo(self.addressView);
        make.size.mas_equalTo(CGSizeMake(24, 27));
    }];
    //地址
    [self.addressView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressView).offset(10);
        make.left.equalTo(self.addressLogoImg.mas_right).offset(8);
        make.right.equalTo(self.addressView).offset(-80);
    }];
    //联系方式
    [self.addressView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(4);
        make.left.right.equalTo(self.addressLabel);
        make.bottom.equalTo(self.addressView).offset(-10);
    }];
    //复制
    [self.addressView addSubview:self.addressCopyBtn];
    [self.addressCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressView).offset(-12);
        make.centerY.equalTo(self.addressView);
    }];
}

///快递公司
- (void)addLogisticsInfoView{
    [self.contentScrollView addSubview:self.logisticsInfoView];
    [self.logisticsInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressInfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScrollView).offset(12);
        make.right.equalTo(self.contentScrollView).offset(-12);
    }];
    [self.logisticsInfoView addSubview:self.logisticsTitleLabel];
    [self.logisticsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsInfoView).offset(10);
        make.left.equalTo(self.logisticsInfoView).offset(12);
    }];
    [self.logisticsInfoView addSubview:self.logisticsView];
    [self.logisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsTitleLabel.mas_bottom).offset(0);
        make.left.right.equalTo(self.logisticsInfoView).offset(0);
        make.height.mas_equalTo(40);
    }];
    [self.logisticsView addSubview:self.logisticsTextLabel];
    [self.logisticsTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticsView).offset(12);
        make.centerY.equalTo(self.logisticsView);
        make.width.mas_equalTo(130);
    }];
    //快递
    [self.logisticsView addSubview:self.logisticsLabel];
    [self.logisticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.logisticsView).offset(-25);
        make.left.equalTo(self.logisticsTextLabel.mas_right).offset(20);
        make.centerY.equalTo(self.logisticsView);
    }];
    UIImageView *logisticsNextImg = [[UIImageView alloc] init];
    logisticsNextImg.image = JHImageNamed(@"c2c_next_icon");
    [self.logisticsView addSubview:logisticsNextImg];
    [logisticsNextImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.logisticsView).offset(-10);
        make.centerY.equalTo(self.logisticsView);
    }];
    UIView *line = [UIView new];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.logisticsInfoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsView.mas_bottom).offset(0);
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
    }];
}

///快递单号
- (void)addOrderNumberInfoView{
    [self.logisticsInfoView addSubview:self.orderNumTitleLabel];
    [self.orderNumTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsView.mas_bottom).offset(10);
        make.left.equalTo(self.logisticsInfoView).offset(12);
    }];
    //添加快递单号输入框
    [self.logisticsInfoView  addSubview:self.enterNumTF];
    [self.enterNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNumTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.logisticsInfoView).offset(12);
        make.bottom.equalTo(self.logisticsInfoView).offset(-10);
        make.right.equalTo(self.logisticsInfoView).offset(-60);
    }];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"您还没有输入快递单号" attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x666666),NSFontAttributeName:[UIFont fontWithName:kFontNormal size:13]}];
    self.enterNumTF.attributedPlaceholder = attrString;

    //单号扫描
    [self.logisticsInfoView  addSubview:self.scanBtn];
    [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.enterNumTF);
        make.right.equalTo(self.logisticsInfoView).offset(-10);
        make.size.mas_offset(CGSizeMake(23, 21));
    }];
}

///包装说明信息
- (void)addPackageInfoView{
    [self.contentScrollView addSubview:self.packageView];
    [self.packageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsInfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScrollView).offset(12);
        make.right.equalTo(self.contentScrollView).offset(-12);
        make.bottom.equalTo(self.contentScrollView).offset(-45);
    }];
}

///确认提交
- (void)addBottomInfoView{
    [self.view addSubview:self.submitBtn];
    [self.submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(37);
        make.right.equalTo(self.view).offset(-37);
        make.bottom.equalTo(self.view.mas_bottom).offset(-8-UI.bottomSafeAreaHeight);
        make.height.mas_equalTo(44);
    }];
}


#pragma mark - LoadData
- (void)loadData{
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"appointmentSource"] = @(self.appointmentSource);
    dicData[@"businessType"] = @1;//0 回收 1 C2C
    dicData[@"orderCode"] = self.orderCode;
    dicData[@"orderId"] = @([self.orderId integerValue]);
    dicData[@"productId"] = @([self.productId integerValue]);
    [self.selfMailingViewModel.selfMailingCommand execute:dicData];
}

- (void)configData{
    @weakify(self)
    //自助寄出信息
    [self.selfMailingViewModel.selfMailingSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //绑定数据
        [self bindViewModel:x params:nil];
    }];
    
    //确认提交
    [self.selfMailingViewModel.confirmSelfMailingSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.cancelWorkOrder == 1) {
            NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
            dicData[@"orderId"] = self.orderId;
            dicData[@"flag"] = [NSString stringWithFormat:@"%ld",(long)self.customerFlag];
            dicData[@"workOrderId"] = self.workOrderId;
            [JHRefundDetailBusiness requestRefundCancelWorkOrderWithParams:dicData Completion:^(RequestModel * _Nonnull respondObject, NSError * _Nullable error) {
                if (!error) {
                    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
                    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
                    //撤销成功监听
                    [self.selfMailingSuccessSubject sendNext:@{@"isDelete":@"NO"}];
                   
                }else{
                    JHTOAST(@"撤销失败");
                }
            }];
        }else{
            JHTOAST(@"预约成功");
            [self.navigationController popViewControllerAnimated:YES];
            //监听预约成功回调
            [self.selfMailingSuccessSubject sendNext:@YES];
        }
        
    }];
    
    
}

- (void)bindViewModel:(id)dataModel params:(NSDictionary *)parmas{
    self.selfMailingModel = (JHC2CSendServiceModel *)dataModel;

    //地址
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",self.selfMailingModel.receiveInfo.receiveProvince, self.selfMailingModel.receiveInfo.receiveCity, self.selfMailingModel.receiveInfo.receiveCounty, self.selfMailingModel.receiveInfo.receiveAddress];
    self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",self.selfMailingModel.receiveInfo.receiveName, self.selfMailingModel.receiveInfo.receiveMobile];
    
    //包装说明图
    self.packageView.packageModel = self.selfMailingModel.packageDescription;

}


#pragma mark - Action
///复制地址
- (void)clickAddressCopyBtnAction:(UIButton *)sender{
    [self.enterNumTF resignFirstResponder];
    NSString *addressInfo = [NSString stringWithFormat:@"%@\n%@",self.addressLabel.text, self.nameLabel.text];
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = addressInfo;
    if (pab == nil) {
        JHTOAST(@"复制失败");
    } else {
        JHTOAST(@"已复制");
    }
}

///选择快递
- (void)clickLogisticsAction{
    [self.logisticsView jh_addTapGesture:^{
        [self.enterNumTF resignFirstResponder];
        //赋值
        [self.courierView show];
        self.courierView.expressCompanyListData = self.selfMailingModel.expressCompanyList;
        @weakify(self);
        self.courierView.selectCompleteBlock = ^(NSInteger selectIndex) {
            @strongify(self);
            self.logisticsTextLabel.text = @"快递公司";
            JHC2CExpressCompanyListModel *listModel = self.selfMailingModel.expressCompanyList[selectIndex];
            self.logisticsLabel.text = listModel.expressCompanyName;
            self.selectCompanyCode = listModel.expressCompanyCode;
        };
    }];
}

///快递号扫描
- (void)clickScanBtnAction:(UIButton *)sender{
    @weakify(self);
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    vc.titleString = @"扫描快递单号";
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
        @strongify(self);
        self.enterNumTF.text = scanString;
        
        [obj.navigationController popViewControllerAnimated:YES];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
///确认提交
- (void)clickSubmitBtnAction:(UIButton *)sender{
    [self.enterNumTF resignFirstResponder];
    if ([self.logisticsLabel.text isEqualToString:@"请选择"]) {
        JHTOAST(@"请选择快递公司");
        return;
    }
    if (self.enterNumTF.text.length <= 0) {
        JHTOAST(@"请输入快递单号");
        return;
    }
    //提交预约信息
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"appointmentSource"] = @(self.appointmentSource);
    dicData[@"orderId"] = @([self.orderId integerValue]);//订单ID
    dicData[@"orderCode"] = self.orderCode;//订单编号
    dicData[@"productId"] = @([self.productId integerValue]);
    dicData[@"productName"] = self.productName;
    //地址信息
    dicData[@"receiveCity"] = self.selfMailingModel.receiveInfo.receiveCity;
    dicData[@"receiveCounty"] = self.selfMailingModel.receiveInfo.receiveCounty;
    dicData[@"receiveAddress"] = [JHC2CSendServiceManager trimmingCharactersInSetOfString:self.selfMailingModel.receiveInfo.receiveAddress];
    dicData[@"receiveProvince"] = self.selfMailingModel.receiveInfo.receiveProvince;
    dicData[@"receiveName"] = [JHC2CSendServiceManager trimmingCharactersInSetOfString:self.selfMailingModel.receiveInfo.receiveName];
    dicData[@"receiveMobile"] = self.selfMailingModel.receiveInfo.receiveMobile;
    //快递公司
    dicData[@"expressCompanyCode"] = self.selectCompanyCode;
    dicData[@"expressCompanyName"] = self.logisticsLabel.text;
    dicData[@"expressNumber"] = self.enterNumTF.text;
    [self.selfMailingViewModel.confirmSelfMailingCommand execute:dicData];
}

#pragma mark - Delegate
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];

    if ([string isEqualToString:filtered]) {
        if (textField == self.enterNumTF) {
            // 这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
            if (range.length == 1 && string.length == 0) {
                return YES;
            }  else if (self.enterNumTF.text.length >= 30) {
                self.enterNumTF.text = [textField.text substringToIndex:30];
                return NO;
            }
        }
        return YES;
    }
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.enterNumTF resignFirstResponder];
    return NO;
}



#pragma mark - Lazy
- (UIScrollView *)contentScrollView{
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = YES;
        _contentScrollView.scrollEnabled = YES;
        _contentScrollView.alwaysBounceVertical = YES;
        _contentScrollView.backgroundColor = HEXCOLOR(0xF5F6FA);
    }
    return _contentScrollView;
}
- (UIView *)addressInfoView{
    if (!_addressInfoView) {
        _addressInfoView = [[UIView alloc] init];
        _addressInfoView.backgroundColor = UIColor.whiteColor;
        _addressInfoView.layer.cornerRadius = 5;
        _addressInfoView.layer.masksToBounds = YES;
    }
    return _addressInfoView;
}
- (UILabel *)addressTitleLabel{
    if (!_addressTitleLabel) {
        _addressTitleLabel = [[UILabel alloc] init];
        _addressTitleLabel.textColor = HEXCOLOR(0x333333);
        _addressTitleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _addressTitleLabel.text = @"收件地址";
    }
    return _addressTitleLabel;
}
- (UIView *)addressView{
    if (!_addressView) {
        _addressView = [[UIView alloc] init];
        _addressView.backgroundColor = UIColor.whiteColor;
    }
    return _addressView;
}

- (UIImageView *)addressLogoImg{
    if (!_addressLogoImg) {
        _addressLogoImg = [[UIImageView alloc] init];
        _addressLogoImg.image = JHImageNamed(@"recycle_orderDetail_address_icon");
    }
    return _addressLogoImg;
}
- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = HEXCOLOR(0x333333);
        _addressLabel.font = [UIFont fontWithName:kFontNormal size:14];
    }
    return _addressLabel;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0x666666);
        _nameLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _nameLabel;
}
- (UIButton*)addressCopyBtn{
    if (!_addressCopyBtn) {
        _addressCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressCopyBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_addressCopyBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        _addressCopyBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_addressCopyBtn addTarget:self action:@selector(clickAddressCopyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressCopyBtn;
}
- (UIView *)logisticsInfoView{
    if (!_logisticsInfoView) {
        _logisticsInfoView = [[UIView alloc] init];
        _logisticsInfoView.backgroundColor = UIColor.whiteColor;
        _logisticsInfoView.layer.cornerRadius = 5;
        _logisticsInfoView.layer.masksToBounds = YES;
    }
    return _logisticsInfoView;
}
- (UILabel *)logisticsTitleLabel{
    if (!_logisticsTitleLabel) {
        _logisticsTitleLabel = [[UILabel alloc] init];
        _logisticsTitleLabel.textColor = HEXCOLOR(0x333333);
        _logisticsTitleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _logisticsTitleLabel.text = @"选择快递公司";
    }
    return _logisticsTitleLabel;
}
- (UIView *)logisticsView{
    if (!_logisticsView) {
        _logisticsView = [[UIView alloc] init];
        _logisticsView.backgroundColor = UIColor.whiteColor;
    }
    return _logisticsView;
}
- (UILabel *)logisticsTextLabel{
    if (!_logisticsTextLabel) {
        _logisticsTextLabel = [[UILabel alloc] init];
        _logisticsTextLabel.textColor = HEXCOLOR(0x666666);
        _logisticsTextLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _logisticsTextLabel.text = @"您还没有选择快递公司";
    }
    return _logisticsTextLabel;
}
- (UILabel *)logisticsLabel{
    if (!_logisticsLabel) {
        _logisticsLabel = [[UILabel alloc] init];
        _logisticsLabel.textColor = HEXCOLOR(0x333333);
        _logisticsLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _logisticsLabel.text = @"请选择";
        _logisticsLabel.textAlignment = NSTextAlignmentRight;
    }
    return _logisticsLabel;
}
- (JHC2CCourierCompanyView *)courierView{
    if (!_courierView) {
        _courierView = [[JHC2CCourierCompanyView alloc] init];
    }
    return _courierView;
}

- (UILabel *)orderNumTitleLabel{
    if (!_orderNumTitleLabel) {
        _orderNumTitleLabel = [[UILabel alloc] init];
        _orderNumTitleLabel.textColor = HEXCOLOR(0x333333);
        _orderNumTitleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _orderNumTitleLabel.text = @"请输入快递单号";
    }
    return _orderNumTitleLabel;
}

- (UITextField *)enterNumTF{
    if (!_enterNumTF) {
        _enterNumTF = [[UITextField alloc] init];
        _enterNumTF.placeholder = @"您还没有输入快递单号";
        _enterNumTF.textColor = HEXCOLOR(0x333333);
        _enterNumTF.font = [UIFont fontWithName:kFontNormal size:13];
        _enterNumTF.keyboardType = UIKeyboardTypeASCIICapable;
        _enterNumTF.textAlignment = NSTextAlignmentLeft;
        _enterNumTF.delegate = self;
    }
    return _enterNumTF;
}
- (UIButton *)scanBtn{
    if (!_scanBtn) {
        _scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scanBtn setBackgroundImage:JHImageNamed(@"c2c_scan_iocn") forState:UIControlStateNormal];
        [_scanBtn addTarget:self action:@selector(clickScanBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanBtn;
}
- (JHC2CSendPackageView *)packageView{
    if (!_packageView) {
        _packageView = [[JHC2CSendPackageView alloc] init];
        _packageView.backgroundColor = UIColor.whiteColor;
        _packageView.layer.cornerRadius = 5;
        _packageView.layer.masksToBounds = YES;
    }
    return _packageView;
}
- (UIButton *)submitBtn{
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitBtn setTitle:@"确认提交" forState:UIControlStateNormal];
        _submitBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        [_submitBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_submitBtn setBackgroundImage:[UIImage gradientThemeImageSize:CGSizeMake(kScreenWidth-74, 44) radius:22] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(clickSubmitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (JHC2CSendServiceViewModel *)selfMailingViewModel{
    if (!_selfMailingViewModel) {
        _selfMailingViewModel = [[JHC2CSendServiceViewModel alloc] init];
    }
    return _selfMailingViewModel;
}
- (RACSubject *)selfMailingSuccessSubject{
    if (!_selfMailingSuccessSubject) {
        _selfMailingSuccessSubject = [[RACSubject alloc] init];
    }
    return _selfMailingSuccessSubject;
}
@end
