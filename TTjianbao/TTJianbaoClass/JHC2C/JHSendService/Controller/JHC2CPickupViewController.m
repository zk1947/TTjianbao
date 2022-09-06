//
//  JHC2CPickupViewController.m
//  TTjianbao
//
//  Created by hao on 2021/6/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CPickupViewController.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHUIFactory.h"
#import "AdressManagerViewController.h"
#import "AdressMode.h"
#import "UIImage+JHColor.h"
#import "JHC2CSendPackageView.h"
#import "JHC2CCourierCompanyView.h"
#import "JHC2CWriteOrderNumViewController.h"
#import "JHC2CSendServiceViewModel.h"
#import "JHC2CSendServiceModel.h"
#import "JHC2CSendServiceManager.h"

@interface JHC2CPickupViewController ()
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UIView *pickupInfoView;
//选择快递
@property (nonatomic, strong) UILabel *logisticsTitleLabel;
@property (nonatomic, strong) UIView *logisticsView;
@property (nonatomic, strong) UILabel *logisticsTextLabel;
@property (nonatomic, strong) UILabel *logisticsLabel;//快递公司
//取件地址
@property (nonatomic, strong) UILabel *addressTitleLabel;
@property (nonatomic, strong) UIView *addressView;
@property (nonatomic, strong) UILabel *addressTextLabel;
@property (nonatomic, strong) UIImageView *addressLogoImg;
@property (nonatomic, strong) UILabel *addressLabel;//取件地址
@property (nonatomic, strong) UILabel *nameLabel;//联系方式
@property (nonatomic, strong) UILabel *changeLabel;
//包装
@property (nonatomic, strong) JHC2CSendPackageView *packageView;
//提交预约
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UIButton *agreementBtn;
@property (nonatomic, strong) UIButton *appointmentBtn;
///选择快递弹窗
@property (nonatomic, strong) JHC2CCourierCompanyView *courierView;
///选择的快递公司编码
@property (nonatomic, copy) NSString *selectCompanyCode;
@property (nonatomic, strong) JHC2CSendServiceViewModel *pickupViewModel;
@property (nonatomic, strong) JHC2CSendServiceModel *pickupModel;

@property (nonatomic, strong) AdressMode *addressModel;//取件地址

@end

@implementation JHC2CPickupViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    if (self.fromStatus == 0) {//C2C
        [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
            @"page_name":@"集市预约上门编辑页",
            @"order_id":self.orderId
        } type:JHStatisticsTypeSensors];
    }
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat topHeight = 0;
    if (self.fromStatus == 1) {
        self.title = @"预约上门取件";
        topHeight = UI.statusAndNavBarHeight;
    }
    [self.view addSubview:self.contentScrollView];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(topHeight, 0, 60 + UI.bottomSafeAreaHeight, 0));
    }];
    
    //预约取件信息
    [self addPickupInfoView];
    //包装说明信息
    [self addPackageInfoView];
    //底部提交预约
    [self addBottomInfoView];
    
    //选择快递
    [self clickLogisticsAction];
    //选择地址
    [self clickAddressAction];
    
    [self loadData];
    [self configData];
}


#pragma mark - UI
///预约取件信息
- (void)addPickupInfoView{
    [self.contentScrollView addSubview:self.pickupInfoView];
    [self.pickupInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView).offset(10);
        make.left.equalTo(self.contentScrollView).offset(12);
        make.right.equalTo(self.contentScrollView).offset(-12);
        make.width.offset(kScreenWidth-24);
    }];
    
    //快递公司View
    [self.pickupInfoView addSubview:self.logisticsTitleLabel];
    [self.logisticsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickupInfoView).offset(10);
        make.left.equalTo(self.pickupInfoView).offset(12);
    }];
    [self.pickupInfoView addSubview:self.logisticsView];
    [self.logisticsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsTitleLabel.mas_bottom).offset(0);
        make.left.right.equalTo(self.pickupInfoView).offset(0);
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
    [self.pickupInfoView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsView.mas_bottom).offset(0);
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    //地址View
    [self.pickupInfoView addSubview:self.addressTitleLabel];
    [self.addressTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticsView.mas_bottom).offset(10);
        make.left.equalTo(self.pickupInfoView).offset(12);
    }];
    [self.pickupInfoView addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitleLabel.mas_bottom).offset(0);
        make.left.right.bottom.equalTo(self.pickupInfoView);
    }];
    [self.addressView addSubview:self.addressTextLabel];

    //图标
    [self.addressView addSubview:self.addressLogoImg];

    //地址
    [self.addressView addSubview:self.addressLabel];

    //联系方式
    [self.addressView addSubview:self.nameLabel];

    
    UIImageView *addressNextImg = [[UIImageView alloc] init];
    addressNextImg.image = JHImageNamed(@"c2c_next_icon");
    [self.addressView addSubview:addressNextImg];
    [addressNextImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressView).offset(-10);
        make.centerY.equalTo(self.addressView);
    }];
    
    [self.addressView addSubview:self.changeLabel];
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressView).offset(-25);
        make.centerY.equalTo(self.addressView);
    }];

    //接口返回
    [self updateAddressInfoView];
    
}
///包装说明信息
- (void)addPackageInfoView{
    [self.contentScrollView addSubview:self.packageView];
    [self.packageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickupInfoView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScrollView).offset(12);
        make.right.equalTo(self.contentScrollView).offset(-12);
        make.bottom.equalTo(self.contentScrollView).offset(-45);
    }];
    
}
///底部提交预约
- (void)addBottomInfoView{
    UIView *footerView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.view];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentScrollView.mas_bottom).offset(0);
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
    }];
    
    [footerView addSubview:self.chooseBtn];
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(13);
        make.centerY.equalTo(footerView);
        make.height.mas_equalTo(30);
    }];
    [footerView addSubview:self.agreementBtn];
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chooseBtn.mas_right).offset(2);
        make.centerY.equalTo(footerView);
    }];
    
    [footerView addSubview:self.appointmentBtn];
    [self.appointmentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(footerView).offset(-12);
        make.centerY.equalTo(footerView);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
}






#pragma mark - LoadData
- (void)loadData{
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"productId"] = @([self.productId integerValue]);
    dicData[@"businessType"] = self.fromStatus == 1 ? @0 : @1;//0 回收 1 C2C
    [self.pickupViewModel.pickupCommand execute:dicData];
}

- (void)configData{
    @weakify(self)
    //获取上门取件信息
    [self.pickupViewModel.pickupSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //绑定数据
        [self bindViewModel:x params:nil];
    }];
    
    //提交预约信息
    [self.pickupViewModel.appointmentSubmitSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHTOAST(@"预约成功");
        JHC2CWriteOrderNumViewController *writeVC = [[JHC2CWriteOrderNumViewController alloc] init];
        writeVC.fromStatus = 1;
        writeVC.orderId = self.orderId;
        writeVC.orderCode = self.orderCode;
        writeVC.productId = self.productId;
        writeVC.appointmentSource = self.appointmentSource;
        //预约成功监听传到下个页面
        writeVC.writeSuccessSubject = self.appointmentSuccessSubject;
        [self.navigationController pushViewController:writeVC animated:YES];
    }];
    
    
}
- (void)bindViewModel:(id)dataModel params:(NSDictionary *)parmas{
    self.pickupModel = (JHC2CSendServiceModel *)dataModel;
    //包装说明图
    self.packageView.packageModel = self.pickupModel.packageDescription;
   
    //地址
    if (self.pickupModel.deliverInfo.deliverMobile.length > 0) {
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",self.pickupModel.deliverInfo.deliverProvince, self.pickupModel.deliverInfo.deliverCity, self.pickupModel.deliverInfo.deliverCounty, self.pickupModel.deliverInfo.deliverAddress];
        self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",self.pickupModel.deliverInfo.deliverName, self.pickupModel.deliverInfo.deliverMobile];
    }

    [self updateAddressInfoView];
}




#pragma mark - Action
///选择快递公司
- (void)clickLogisticsAction{
    [self.logisticsView jh_addTapGesture:^{
        //赋值
        [self.courierView show];
        self.courierView.expressCompanyListData = self.pickupModel.expressCompanyList;
        @weakify(self);
        self.courierView.selectCompleteBlock = ^(NSInteger selectIndex) {
            @strongify(self);
            //选择完成后
            self.logisticsTextLabel.text = @"快递公司";
            JHC2CExpressCompanyListModel *listModel = self.pickupModel.expressCompanyList[selectIndex];
            self.logisticsLabel.text = listModel.expressCompanyName;
            self.selectCompanyCode = listModel.expressCompanyCode;
        };
        
    }];
}
///选择地址薄
- (void)clickAddressAction{
    [self.addressView jh_addTapGesture:^{
        @weakify(self);
        //修改地址/新增地址
        AdressManagerViewController *addressVC = [AdressManagerViewController new];
        addressVC.selectedBlock = ^(AdressMode *model) {
            @strongify(self);
            self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.province, model.city, model.county, model.detail];
            self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",model.receiverName, model.phone];
            self.addressModel = model;
            [self updateAddressInfoView];
        };
        [self.navigationController pushViewController:addressVC animated:YES];
        
    }];
}
///更新地址显示
- (void)updateAddressInfoView{
    if (self.addressLabel.text.length > 0) {
        self.changeLabel.text = @"修改";
        self.addressTextLabel.hidden = YES;
        //图标
        [self.addressLogoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.addressView).offset(12);
            make.centerY.equalTo(self.addressView);
            make.size.mas_equalTo(CGSizeMake(24, 27));
        }];
        //地址
        [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressView).offset(10);
            make.left.equalTo(self.addressLogoImg.mas_right).offset(8);
            make.right.equalTo(self.addressView).offset(-80);
        }];
        //联系方式
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressLabel.mas_bottom).offset(4);
            make.left.right.equalTo(self.addressLabel);
            make.bottom.equalTo(self.addressView).offset(-10);
        }];
    }else{
        self.changeLabel.text = @"新增地址";
        self.addressTextLabel.hidden = NO;
        [self.addressTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.addressView).offset(10);
            make.left.equalTo(self.addressView).offset(12);
            make.bottom.equalTo(self.addressView).offset(-10);

        }];
    }
}

///阅读按钮
- (void)clickChooseBtnAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.appointmentBtn.alpha = 1;
        self.appointmentBtn.userInteractionEnabled = YES;
    }else{
        self.appointmentBtn.alpha = 0.7;
        self.appointmentBtn.userInteractionEnabled = NO;
    }
}
///服务协议
- (void)clickAgreementBtnAction:(UIButton *)sender{
    [JHRouterManager pushWebViewWithUrl:H5_BASE_STRING(@"/jianhuo/app/agreement/sendServiceAgreement.html") title:@"寄件服务协议" controller:JHRootController];

}

///立即预约
- (void)clickAppointmentBtnAction:(UIButton *)sender{
    if ([self.logisticsLabel.text isEqualToString:@"请选择"]) {
        JHTOAST(@"请选择快递公司");
        return;
    }
    if (self.nameLabel.text.length <= 0) {
        JHTOAST(@"请选择取件地址");
        return;
    }
    
    //提交预约信息
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"appointmentSource"] = @(self.appointmentSource);
    dicData[@"businessType"] = self.fromStatus == 1 ? @0 : @1;//0 回收 1 C2C
    dicData[@"orderId"] = @([self.orderId integerValue]);//订单ID
    dicData[@"orderCode"] = self.orderCode;//订单编号
    dicData[@"productId"] = @([self.productId integerValue]);
    dicData[@"productName"] = self.productName;
    //地址信息
    dicData[@"deliverCity"] = self.pickupModel.deliverInfo.deliverCity;
    dicData[@"deliverCounty"] = self.pickupModel.deliverInfo.deliverCounty;
    dicData[@"deliverAddress"] = [JHC2CSendServiceManager trimmingCharactersInSetOfString:self.pickupModel.deliverInfo.deliverAddress];
    dicData[@"deliverProvince"] = self.pickupModel.deliverInfo.deliverProvince;
    dicData[@"deliverName"] = [JHC2CSendServiceManager trimmingCharactersInSetOfString:self.pickupModel.deliverInfo.deliverName];
    dicData[@"deliverMobile"] = self.pickupModel.deliverInfo.deliverMobile;
    dicData[@"sendAddressId"] = @(self.pickupModel.deliverInfo.sendAddressId);//用户收货地址id
    if (self.addressModel.phone.length > 0) {
        dicData[@"deliverCity"] = self.addressModel.city;
        dicData[@"deliverCounty"] = self.addressModel.county;
        dicData[@"deliverAddress"] = [JHC2CSendServiceManager trimmingCharactersInSetOfString:self.addressModel.detail];
        dicData[@"deliverProvince"] = self.addressModel.province;
        dicData[@"deliverName"] = [JHC2CSendServiceManager trimmingCharactersInSetOfString:self.addressModel.receiverName];
        dicData[@"deliverMobile"] = self.addressModel.phone;
        dicData[@"sendAddressId"] = @([self.addressModel.ID integerValue]);//地址id
    }
    //快递公司
    dicData[@"expressCompanyCode"] = self.selectCompanyCode;
    dicData[@"expressCompanyName"] = self.logisticsLabel.text;

    [self.pickupViewModel.appointmentSubmitCommand execute:dicData];
    

}

#pragma mark - Delegate
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
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
- (UIView *)pickupInfoView{
    if (!_pickupInfoView) {
        _pickupInfoView = [[UIView alloc] init];
        _pickupInfoView.backgroundColor = UIColor.whiteColor;
        _pickupInfoView.layer.cornerRadius = 5;
        _pickupInfoView.layer.masksToBounds = YES;
    }
    return _pickupInfoView;
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

- (UILabel *)addressTitleLabel{
    if (!_addressTitleLabel) {
        _addressTitleLabel = [[UILabel alloc] init];
        _addressTitleLabel.textColor = HEXCOLOR(0x333333);
        _addressTitleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _addressTitleLabel.text = @"取件地址";
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
- (UILabel *)addressTextLabel{
    if (!_addressTextLabel) {
        _addressTextLabel = [[UILabel alloc] init];
        _addressTextLabel.textColor = HEXCOLOR(0x555555);
        _addressTextLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _addressTextLabel.text = @"您还没有取件地址";
    }
    return _addressTextLabel;
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
- (UILabel *)changeLabel{
    if (!_changeLabel) {
        _changeLabel = [[UILabel alloc] init];
        _changeLabel.textColor = HEXCOLOR(0x333333);
        _changeLabel.font = [UIFont fontWithName:kFontNormal size:13];
    }
    return _changeLabel;
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

-(UIButton*)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBtn setTitle:@"阅读并同意" forState:UIControlStateNormal];
        [_chooseBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        _chooseBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_chooseBtn setImage:[UIImage imageNamed:@"common_check_box"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"common_checked_box"] forState:UIControlStateSelected];
        [_chooseBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        _chooseBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_chooseBtn addTarget:self action:@selector(clickChooseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBtn;
}
-(UIButton*)agreementBtn{
    if (!_agreementBtn) {
        _agreementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreementBtn setTitle:@"《寄件服务协议》" forState:UIControlStateNormal];
        _agreementBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_agreementBtn setTitleColor:HEXCOLOR(0x408FFE) forState:UIControlStateNormal];
        [_agreementBtn addTarget:self action:@selector(clickAgreementBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreementBtn;
}
- (UIButton *)appointmentBtn{
    if (!_appointmentBtn) {
        _appointmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_appointmentBtn setTitle:@"立即预约" forState:UIControlStateNormal];
        _appointmentBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        [_appointmentBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _appointmentBtn.contentEdgeInsets = UIEdgeInsetsMake(12, 20, 11, 20);
        [_appointmentBtn setBackgroundImage:[UIImage gradientThemeImageSize:CGSizeMake(100, 44) radius:22] forState:UIControlStateNormal];
        [_appointmentBtn addTarget:self action:@selector(clickAppointmentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _appointmentBtn.alpha = 0.7;
        _appointmentBtn.userInteractionEnabled = NO;
    }
    return _appointmentBtn;
}

- (JHC2CCourierCompanyView *)courierView{
    if (!_courierView) {
        _courierView = [[JHC2CCourierCompanyView alloc] init];
    }
    return _courierView;
}
- (JHC2CSendServiceViewModel *)pickupViewModel{
    if (!_pickupViewModel) {
        _pickupViewModel = [[JHC2CSendServiceViewModel alloc] init];
    }
    return _pickupViewModel;
}
- (RACSubject *)appointmentSuccessSubject{
    if (!_appointmentSuccessSubject) {
        _appointmentSuccessSubject = [[RACSubject alloc] init];
    }
    return _appointmentSuccessSubject;
}
@end
