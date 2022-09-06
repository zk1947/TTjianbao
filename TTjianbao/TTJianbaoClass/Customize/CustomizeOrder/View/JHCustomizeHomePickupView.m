//
//  JHCustomizeHomePickupView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCustomizeHomePickupView.h"
#import "JHCustomizeSendOrderModel.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoUtil.h"
#import "JHUIFactory.h"
#import "UIImage+JHColor.h"
#import "AdressManagerViewController.h"
#import "JHQYChatManage.h"
#import "JHSpecialDatePickerView.h"
#import "UIView+Toast.h"
#import "OrderMode.h"

@interface JHCustomizeHomePickupView ()<UITextViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, strong) UIScrollView *contentScroll;
@property(nonatomic, strong) UIView *titleView;
@property(nonatomic, strong) UIView *remindView;
@property(nonatomic, strong) UILabel *remindLabel;
@property(nonatomic, strong) UIView *descriptionView;
@property(nonatomic, strong) NSMutableAttributedString *attrString;
@property(nonatomic, strong) UITextView *descriptionTextview;
@property(nonatomic, strong) UIView *reservationView;
@property(nonatomic, strong) UIView *timeView;
@property(nonatomic, strong) UITapGestureRecognizer *timeViewTap;
@property(nonatomic, strong) UIImageView *indicator;
@property(nonatomic, strong) UITextField *selectTimeTextField;//选择的时间
@property(nonatomic, strong) UIView *addressView;
@property(nonatomic, strong) UITapGestureRecognizer *addressViewTap;
@property(nonatomic, strong) UIImageView *indicator2;
@property(nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UILabel *addressLabel;
@property(nonatomic, strong) UILabel *userPhoneNumLabel;
@property(nonatomic, strong) UIButton *submitInfoBtn;//底部按钮
@property(nonatomic, strong) UIView *submitBtnView;

@end

@implementation JHCustomizeHomePickupView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initScrollview];
    }
    return self;
}
-(void)initScrollview{
    
    self.contentScroll = [[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor = [CommHelp toUIColorByStr:@"#f7f7f7"];
    self.contentScroll.scrollEnabled = YES;
    self.contentScroll.alwaysBounceVertical = YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initTitleView];
    [self initDescriptionView];
    [self initReservationView];
    
}
-(void)initTitleView{
    _titleView = [[UIView alloc]init];
    _titleView.backgroundColor = [CommHelp toUIColorByStr:@"#FFF7D1"];
    [self.contentScroll addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentScroll);
        make.height.offset(37);
        make.width.offset(ScreenW);

    }];
    UILabel *title = [[UILabel alloc]init];
    title.text = @"请您根据以下信息将原料邮寄到平台";
    title.font = [UIFont fontWithName:kFontNormal size:12];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [CommHelp toUIColorByStr:@"#DB9018"];
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_titleView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_titleView);
    }];
    
}
///提示信息，客服电话等
- (void)initDescriptionView{
    _descriptionView = [[UIView alloc]init];
    _descriptionView.backgroundColor = UIColor.whiteColor;
    _descriptionView.layer.cornerRadius = 8;
    _descriptionView.layer.masksToBounds=YES;
    [self.contentScroll addSubview:_descriptionView];
    [_descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = kColor333;
    titleLabel.text = @"免费上门取件";
    titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [_descriptionView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descriptionView.mas_top).offset(12);
        make.left.equalTo(_descriptionView.mas_left).offset(10);
    }];
    UIImageView *redIcon = [[UIImageView alloc] init];
    redIcon.image = [UIImage imageNamed:@"customize_orderPaySuccess_homePickup_PTTJ_Icon"];
    [_descriptionView addSubview:redIcon];
    [redIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(48, 15));
        make.left.equalTo(titleLabel.mas_right).offset(4);
        make.centerY.equalTo(titleLabel);
    }];

    //客服电话
    _descriptionTextview = [[UITextView alloc] init];
    _descriptionTextview.delegate = self;
    _descriptionTextview.editable = NO;
    _descriptionTextview.scrollEnabled = NO;
    _descriptionTextview.textContainerInset = UIEdgeInsetsZero;
    _descriptionTextview.textContainer.lineFragmentPadding = 0;
    _descriptionTextview.linkTextAttributes = @{NSForegroundColorAttributeName:[CommHelp toUIColorByStr:@"#2F66A0"]};
    [_descriptionView addSubview:_descriptionTextview];
    [_descriptionTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(15);
        make.left.equalTo(_descriptionView.mas_left).offset(10);
        make.right.equalTo(_descriptionView.mas_right).offset(-10);
    }];
    
    //温馨提示
    UIView *remindView = [[UIView alloc]init];
    self.remindView = remindView;
    remindView.backgroundColor = [CommHelp toUIColorByStr:@"#F5F6FA"];
    remindView.layer.cornerRadius = 5;
    [_descriptionView addSubview:remindView];
    [remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descriptionTextview.mas_bottom).offset(0);
        make.left.equalTo(_descriptionView.mas_left).offset(10);
        make.right.equalTo(_descriptionView.mas_right).offset(-10);
        make.bottom.equalTo(_descriptionView.mas_bottom).offset(-15);
    }];
    UIImageView *remindIcon = [[UIImageView alloc] init];
    remindIcon.image = [UIImage imageNamed:@"customize_orderPaySuccess_remindIcon"];
    [remindView addSubview:remindIcon];
    [remindIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.equalTo(remindView.mas_top).offset(5);
        make.left.equalTo(remindView.mas_left).offset(8);
    }];
    UILabel *remindLabel = [[UILabel alloc] init];
    self.remindLabel = remindLabel;
    remindLabel.textColor = kColor999;
    remindLabel.numberOfLines = 0;
    remindLabel.text = @"";
    remindLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [remindView addSubview:remindLabel];
    [remindLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remindView.mas_top).offset(0);
        make.bottom.equalTo(remindView.mas_bottom).offset(0);
        make.left.equalTo(remindIcon.mas_right).offset(4);
        make.right.equalTo(remindView.mas_right).offset(-10);
    }];
    remindView.hidden = YES;

}
///上门预约信息填写
- (void)initReservationView{
    _reservationView = [[UIView alloc]init];
    _reservationView.backgroundColor = UIColor.whiteColor;
    _reservationView.layer.cornerRadius = 8;
    _reservationView.layer.masksToBounds=YES;
    [self.contentScroll addSubview:_reservationView];
    [_reservationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descriptionView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.bottom.equalTo(self.contentScroll);
    }];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"上门取件预约";
    title.font = [UIFont fontWithName:kFontMedium size:15];
    title.textColor = kColor333;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_reservationView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_reservationView).offset(10);
        make.top.equalTo(_reservationView).offset(12);
    }];
    //取件时间
    UIView *timeView = [[UIView alloc]init];
    self.timeView = timeView;
    _timeViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTimeAction)];
    _timeViewTap.delegate = self;
    [timeView addGestureRecognizer:_timeViewTap];
    [_reservationView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(12);
        make.left.right.equalTo(_reservationView).offset(0);
        make.height.offset(44);
    }];
    JHCustomLine *line = [JHUIFactory createLine];
    [timeView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(timeView.mas_bottom).offset(0);
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    // >
    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    self.indicator = indicator;
    [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator.contentMode = UIViewContentModeScaleAspectFit;
    [timeView addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeView).offset(-15);
        make.centerY.equalTo(timeView);
    }];
    UILabel *timeTitle = [[UILabel alloc]init];
    timeTitle.text = @"取件时间";
    timeTitle.font = [UIFont fontWithName:kFontNormal size:13];
    timeTitle.textColor = kColor666;
    timeTitle.textAlignment = NSTextAlignmentLeft;
    timeTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [timeView addSubview:timeTitle];
    [timeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(timeView).offset(10);
        make.centerY.equalTo(timeView);
        make.width.offset(60);
    }];
    
    _selectTimeTextField = [[UITextField alloc]init];
//    _selectTimeTextField.placeholder = @"请选择上门取件时间";
    _selectTimeTextField.font = [UIFont fontWithName:kFontMedium size:13];
    _selectTimeTextField.textColor = kColor333;
    _selectTimeTextField.textAlignment = NSTextAlignmentRight;
    _selectTimeTextField.userInteractionEnabled = NO;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"请选择上门取件时间" attributes:
     @{NSForegroundColorAttributeName:kColor333,
       NSFontAttributeName:_selectTimeTextField.font}
     ];
    _selectTimeTextField.attributedPlaceholder = attrString;


    [timeView addSubview:_selectTimeTextField];
    [_selectTimeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeView);
        make.right.equalTo(timeView.mas_right).offset(-30);
        make.left.equalTo(timeTitle.mas_right).offset(20);
    }];

    
    
    //取件地址
    UIView *addressView = [[UIView alloc]init];
    self.addressView = addressView;
    _addressViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectaddressAction)];
    _addressViewTap.delegate = self;
    [addressView addGestureRecognizer:_addressViewTap];
    [_reservationView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeView.mas_bottom);
        make.left.right.equalTo(_reservationView).offset(0);
    }];
    // >
    UIImageView *indicator2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    self.indicator2 = indicator2;
    [indicator2 setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator2 setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator2.contentMode = UIViewContentModeScaleAspectFit;
    [addressView addSubview:indicator2];
    [indicator2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addressView).offset(-15);
        make.centerY.equalTo(addressView);
    }];
    UILabel *addressTitle = [[UILabel alloc]init];
    addressTitle.text = @"取件地址";
    addressTitle.font = [UIFont fontWithName:kFontNormal size:13];
    addressTitle.textColor = kColor666;
    addressTitle.textAlignment = NSTextAlignmentLeft;
    addressTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [addressView addSubview:addressTitle];
    [addressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressView).offset(10);
        make.top.equalTo(addressView).offset(16);
        make.width.offset(60);
    }];
    
    _userNameLabel = [[UILabel alloc]init];
    _userNameLabel.text = @"";
    _userNameLabel.font = [UIFont fontWithName:kFontNormal size:14];
    _userNameLabel.textColor = kColor333;
    _userNameLabel.numberOfLines = 1;
    _userNameLabel.textAlignment = NSTextAlignmentRight;
    _userNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [addressView addSubview:_userNameLabel];
    _userPhoneNumLabel = [[UILabel alloc]init];
    _userPhoneNumLabel.text = @"";
    _userPhoneNumLabel.font = [UIFont fontWithName:kFontNormal size:12];
    _userPhoneNumLabel.textColor = kColor333;
    _userPhoneNumLabel.numberOfLines = 1;
    _userPhoneNumLabel.textAlignment = NSTextAlignmentRight;
    _userPhoneNumLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [addressView addSubview:_userPhoneNumLabel];
    [_userPhoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressTitle);
        make.right.equalTo(addressView.mas_right).offset(-30);
    }];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_userPhoneNumLabel.mas_left).offset(-8);
        make.centerY.equalTo(addressTitle);
    }];
    
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.text = @"";
    _addressLabel.font = [UIFont fontWithName:kFontNormal size:12];
    _addressLabel.textColor = kColor333;
    _addressLabel.numberOfLines = 0;;
    _addressLabel.textAlignment = NSTextAlignmentRight;
    [addressView addSubview:_addressLabel];
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userNameLabel.mas_bottom).offset(6);
        make.left.equalTo(addressTitle.mas_right).offset(20);
        make.right.equalTo(_userPhoneNumLabel);
        make.bottom.equalTo(addressView.mas_bottom).offset(-12);
    }];

    JHCustomLine *line2 = [JHUIFactory createLine];
    [addressView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.equalTo(addressView.mas_bottom).offset(0);
    }];
    
    //提交预约信息 按钮
    UIButton *submitInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitInfoBtn = submitInfoBtn;
    submitInfoBtn.tag = 1000;
    submitInfoBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [submitInfoBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    [submitInfoBtn addTarget:self action:@selector(clicksubmitInfoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_reservationView addSubview:submitInfoBtn];
    [submitInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom).offset(12);
        make.left.equalTo(_reservationView.mas_left).offset(18);
        make.right.equalTo(_reservationView.mas_right).offset(-18);
        make.height.offset(44);
        make.bottom.equalTo(_reservationView.mas_bottom).offset(-12);
    }];
    
    UIView *submitBtnView = [[UIView alloc]init];
    self.submitBtnView = submitBtnView;
    [submitBtnView addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(submitBtnViewAction)]];
    submitBtnView.backgroundColor = RGBA(255, 255, 255, 0.7);
    [submitInfoBtn addSubview:submitBtnView];
    [submitBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(submitInfoBtn);
    }];

}
#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"telphone"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006230666"]];
        return NO;
    }
    return YES;
}

#pragma mark - Action
- (void)submitBtnViewAction{
    if (_selectTimeTextField.text.length == 0){
        [self makeToast:@"请选择预约时间" duration:1.0 position:CSToastPositionCenter];
    };
}
//选择上门预约时间
- (void)selectTimeAction{
    @weakify(self);
    JHSpecialDatePickerView *dateView = [[JHSpecialDatePickerView alloc]initWithDateStyle:JHDatePickerViewDateTypeYearMonthDayHourMode completeBlock:^(NSString *dateString) {
        @strongify(self);
        self.selectTimeTextField.text = dateString;
        if (self.selectTimeTextField.text.length > 0) {
            self.submitBtnView.hidden = YES;
        }else{
            self.submitBtnView.hidden = NO;
        }
    }];
    [dateView show];

}
- (void)selectaddressAction{
    AdressManagerViewController *address=[AdressManagerViewController new];
    @weakify(self);
    address.selectedBlock = ^(AdressMode *model) {
      @strongify(self);
        self.userNameLabel.text = model.receiverName;
        self.userPhoneNumLabel.text = model.phone;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",model.province, model.city, model.county, model.detail];
    };
    [self.viewController.navigationController  pushViewController:address animated:YES];
}
- (void)clicksubmitInfoBtnAction:(UIButton *)sender{
    if(sender.tag == 1000){//未预约 -> 提交用户信息
        
        if(self.selectTimeTextField.text.length <= 0){
            [self makeToast:@"请选择预约时间" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        if((_userPhoneNumLabel.text.length<=0) || (_userNameLabel.text.length<=0) || (_addressLabel.text.length<=0)){
            [self makeToast:@"请选择预约取件地址" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        [JHGrowingIO trackEventId:@"dz_tjyy_click" variables:@{@"orderId":self.orderId,@"orderType":self.orderMode.orderStatus}];
        NSDictionary *dict = @{
            @"expressReserveAddress":self.addressLabel.text,
            @"expressReserveDate":self.selectTimeTextField.text,
            @"expressReserveName":self.userNameLabel.text,
            @"expressReservePhone":self.userPhoneNumLabel.text,
            @"expressReserveStatus":@"0",
            @"orderId":self.orderId,
        };
        [SVProgressHUD show];
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderCustomize/auth/saveCustomizeExpress") Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [self appointmentSuccessful];
            [self makeToast:@"预约成功！客服将与您电话核对信息，请保持手机畅通" duration:1.5 position:CSToastPositionCenter];

        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [self makeToast:@"预约失败，请检查网络并重新预约" duration:1.0 position:CSToastPositionCenter];

        }];
        
    }else if(sender.tag == 1001){//已预约 -> 联系客服
        [JHGrowingIO trackEventId:@"dz_ggyy_click" variables:@{@"orderId":self.orderId,@"orderType":self.orderMode.orderStatus}];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"在线客服" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[JHQYChatManage shareInstance] showChatWithViewcontroller:[JHRootController currentViewController]];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"电话客服" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006230666"]];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self.viewController presentViewController:alert animated:YES completion:nil];
    }
}
//数据处理
#pragma mark - model
- (void)setSendOrderModel:(JHCustomizeSendOrderModel *)sendOrderModel{
    NSString *phone1 = sendOrderModel.platformServiceDialTelStr;
    NSString *phone2 = sendOrderModel.platformServiceTelStr;
    NSString *time = sendOrderModel.platformServiceWorkTimeStr;
    NSString *str = [NSString stringWithFormat:@"平台客服(%@)会在工作日%@期间与您联系，向您核对信息并预约上门取件 ，请保持手机畅通；\n如需联系客服，请拨打%@",phone1,time,phone2];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:13],NSForegroundColorAttributeName:[CommHelp toUIColorByStr:@"#333333"]}];
    [attrString addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontMedium size:13], NSForegroundColorAttributeName:[CommHelp toUIColorByStr:@"#FF4200"]} range:[[attrString string] rangeOfString:phone1]];
    [attrString addAttributes:@{NSForegroundColorAttributeName:[CommHelp toUIColorByStr:@"#FF4201"]} range:[[attrString string] rangeOfString:time]];
    [attrString addAttribute:NSLinkAttributeName value:@"telphone://" range:[[attrString string] rangeOfString:phone2]];
    _descriptionTextview.attributedText = attrString;

    
    //疫情温馨提示
    if (sendOrderModel.keepEpidemicWarnDesc.length > 0) {
        [self.remindView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_descriptionTextview.mas_bottom).offset(12);
        }];
        self.remindLabel.text = sendOrderModel.keepEpidemicWarnDesc;
        [self.remindLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.remindView.mas_top).offset(7);
            make.bottom.equalTo(self.remindView.mas_bottom).offset(-7);
        }];
        self.remindView.hidden = NO;
    }
    
    //预约状态 0 未预约 1 已预约 2 预约成功 3 不支持 4发货成功
    if ([sendOrderModel.expressReserveStatus intValue] == 0) {
        self.submitInfoBtn.tag = 1000;
        UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(320, 44) radius:22];
        [self.submitInfoBtn setBackgroundImage:nor_image forState:UIControlStateNormal];
        [self.submitInfoBtn setTitle:@"提交预约信息" forState:UIControlStateNormal];
        
        _selectTimeTextField.text = sendOrderModel.expressReserveDate;
        _userPhoneNumLabel.text = sendOrderModel.expressReservePhone;
        _userNameLabel.text = sendOrderModel.expressReserveName;
        _addressLabel.text = sendOrderModel.expressReserveAddress;

    }else if([sendOrderModel.expressReserveStatus intValue]==1 || [sendOrderModel.expressReserveStatus intValue]==2 || [sendOrderModel.expressReserveStatus intValue]==4){

        [self appointmentSuccessful];
        //数据
        _selectTimeTextField.text = sendOrderModel.expressReserveDate;
        _userPhoneNumLabel.text = sendOrderModel.expressReservePhone;
        _userNameLabel.text = sendOrderModel.expressReserveName;
        _addressLabel.text = sendOrderModel.expressReserveAddress;

    }
    
}

- (void)appointmentSuccessful{
    self.submitBtnView.hidden = YES;
    self.timeViewTap.enabled = NO;
    self.addressViewTap.enabled = NO;
    self.indicator.hidden = YES;
    self.indicator2.hidden = YES;
    [self.selectTimeTextField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeView.mas_right).offset(-10);
    }];
    [self.userPhoneNumLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressView.mas_right).offset(-10);
    }];

    self.submitInfoBtn.tag = 1001;
    [self.submitInfoBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.submitInfoBtn setTitle:@"更改预约 联系客服" forState:UIControlStateNormal];
    [self.submitInfoBtn setBackgroundColor:[UIColor whiteColor]];
    self.submitInfoBtn.layer.cornerRadius = 22.0;
    self.submitInfoBtn.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
    self.submitInfoBtn.layer.borderWidth = 0.5f;
}
@end
