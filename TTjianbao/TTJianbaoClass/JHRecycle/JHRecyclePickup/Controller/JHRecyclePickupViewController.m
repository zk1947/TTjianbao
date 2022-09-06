//
//  JHRecyclePickupViewController.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePickupViewController.h"
#import "JHRecycleGoToAppointmentView.h"
#import "JHRecycleAppointmentSuccessView.h"
#import "UIImage+JHColor.h"
#import "UIButton+ImageTitleSpacing.h"
#import "JHRecyclePickupViewModel.h"


@interface JHRecyclePickupViewController ()
@property (nonatomic, strong) JHRecycleGoToAppointmentView *goToAppointmentView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UIButton *agreementBtn;
@property (nonatomic, strong) UIButton *appointmentBtn;
@property (nonatomic, strong) JHRecycleAppointmentSuccessView *appointmentSuccessView;
@property (nonatomic, strong) JHRecyclePickupViewModel *pickupViewModel;
@property (nonatomic, strong) id pickInfo;
@end

@implementation JHRecyclePickupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约上门取件";
    if (self.reservationStatus == 1) {
        [self setupAppointmentSuccessView];
    }else{
        [self setupGoToAppointmentView];
    }
   
}

#pragma mark - UI
///未预约
- (void)setupGoToAppointmentView{
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"回收预约上门编辑页"
    } type:JHStatisticsTypeSensors];
    
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"productType"] = @([self.productTypeId integerValue]);//分类ID
    dicData[@"goodsTypeId"] = @([self.goodsTypeId integerValue]);//商品分类ID
    dicData[@"imageType"] = @"m";//图片类型
    [self.pickupViewModel.goToAppointmentCommand execute:dicData];

    @weakify(self)
    //刷新数据
    [self.pickupViewModel.goToAppointmentSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.view addSubview:self.goToAppointmentView];
        [self.goToAppointmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
            make.bottom.equalTo(self.view).offset(-60-UI.bottomSafeAreaHeight);
            make.left.right.equalTo(self.view);
        }];
        [self setupFooterView];

        self.pickInfo = x;
        //绑定数据
        [self.goToAppointmentView bindViewModel:x params:nil];
       
    }];
    
    //提交预约成功
    [self.pickupViewModel.appointmentSubmitSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.goToAppointmentView.hidden = YES;
        self.footerView.hidden = YES;
        [self setupAppointmentSuccessView];
        //预约成功监听
        [self.appointmentSuccessSubject sendNext:@YES];
    }];
    
    
}
- (void)setupFooterView{
    UIView *footerView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.view];
    self.footerView = footerView;
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goToAppointmentView.mas_bottom).offset(0);
        make.height.mas_equalTo(60);
        make.left.right.equalTo(self.view);
    }];
    
    [footerView addSubview:self.chooseBtn];
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footerView).offset(12);
        make.centerY.equalTo(footerView);
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

///已预约
- (void)setupAppointmentSuccessView{
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"回收预约上门编辑完成页"
    } type:JHStatisticsTypeSensors];
    
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"orderId"] = self.orderId;//订单ID
    [self.pickupViewModel.appointmentSuccessCommand execute:dicData];

    @weakify(self)
    //刷新数据
    [self.pickupViewModel.appointSuccessSubject subscribeNext:^(id  _Nullable x) {
       @strongify(self)
       [self.view addSubview:self.appointmentSuccessView];
       [self.appointmentSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
           make.left.right.bottom.equalTo(self.view);
       }];
       //绑定数据
       [self.appointmentSuccessView bindViewModel:x params:nil];
    }];

}

#pragma mark - LoadData


#pragma mark - Action
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
    if (self.goToAppointmentView.startTime.length <= 0) {
        JHTOAST(@"请选择上门取件时间");
        return;
    }
    if (self.goToAppointmentView.nameLabel.text.length <= 0) {
        JHTOAST(@"请选择取件地址");
        return;
    }

    JHRecyclePickupGoToAppointmentModel *goToAppointmentModel = self.pickInfo;
    //提交预约信息
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"orderId"] = @([self.orderId integerValue]);//订单ID
    dicData[@"orderCode"] = self.orderCode;//订单编号
    dicData[@"preorderEndTime"] = self.goToAppointmentView.endTime;
    dicData[@"preorderStartTime"] = self.goToAppointmentView.startTime;
    dicData[@"name"] = self.goToAppointmentView.pickupAddressModel.name;
    dicData[@"logisticsCode"] = [goToAppointmentModel.logisticsInfo[0] logisticsCode];
    //地址信息
    dicData[@"city"] = self.goToAppointmentView.pickupAddressModel.city;
    dicData[@"county"] = self.goToAppointmentView.pickupAddressModel.county;
    dicData[@"detail"] = self.goToAppointmentView.pickupAddressModel.detail;
    dicData[@"province"] = self.goToAppointmentView.pickupAddressModel.province;
    dicData[@"pickupName"] = self.goToAppointmentView.pickupAddressModel.receiverName;
    dicData[@"phone"] = self.goToAppointmentView.pickupAddressModel.phone;
    dicData[@"sellerAddressId"] = @([self.goToAppointmentView.pickupAddressModel.sellerAddressId integerValue]);//用户收货地址id
    //如果AddressMode有值说明更换了地址，要是用该地址
    if (self.goToAppointmentView.addressModel.phone.length > 0) {
        dicData[@"city"] = self.goToAppointmentView.addressModel.city;
        dicData[@"county"] = self.goToAppointmentView.addressModel.county;
        dicData[@"detail"] = self.goToAppointmentView.addressModel.detail;
        dicData[@"province"] = self.goToAppointmentView.addressModel.province;
        dicData[@"pickupName"] = self.goToAppointmentView.addressModel.receiverName;
        dicData[@"phone"] = self.goToAppointmentView.addressModel.phone;
        dicData[@"sellerAddressId"] = @([self.goToAppointmentView.addressModel.ID integerValue]);//用户收货地址id
    }
    [self.pickupViewModel.appointmentSubmitCommand execute:dicData];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickAppointmentNow" params:@{
        @"appoint_time":[NSString stringWithFormat:@"%@-%@",self.goToAppointmentView.startTime, self.goToAppointmentView.endTime],
        @"page_position":@"appointmentPickUp"
    } type:JHStatisticsTypeSensors];
}

#pragma mark - Delegate


#pragma mark - Lazy
- (JHRecycleGoToAppointmentView *)goToAppointmentView{
    if (!_goToAppointmentView) {
        _goToAppointmentView = [[JHRecycleGoToAppointmentView alloc] init];
    }
    return _goToAppointmentView;
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
- (JHRecycleAppointmentSuccessView *)appointmentSuccessView{
    if (!_appointmentSuccessView) {
        _appointmentSuccessView = [[JHRecycleAppointmentSuccessView alloc] init];
    }
    return _appointmentSuccessView;
}
- (JHRecyclePickupViewModel *)pickupViewModel{
    if (!_pickupViewModel) {
        _pickupViewModel = [[JHRecyclePickupViewModel alloc] init];
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
