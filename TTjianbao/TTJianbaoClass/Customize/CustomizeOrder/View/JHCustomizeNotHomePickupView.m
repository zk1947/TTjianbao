//
//  JHCustomizeNotHomePickupView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/1/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCustomizeNotHomePickupView.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoUtil.h"
#import "JHUIFactory.h"
#import "JHCustomizeOrderModel.h"
#import "JHWebViewController.h"
#import "UIImage+JHColor.h"
#import "JHCustomizeHomPickupSendExpressView.h"
#import "JHQRViewController.h"
#import "JHQYChatManage.h"
#import "OrderMode.h"
#import "JHNewOrderListViewController.h"

@interface JHCustomizeNotHomePickupView ()<UITextFieldDelegate,UITextViewDelegate,STPickerSingleDelegate>
{
    NSInteger selectedIndex;
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView * titleView;
@property(nonatomic,strong) UIView * adressView;
@property(nonatomic,strong) JHCustomizeHomPickupSendExpressView * expressView;
@property(nonatomic,strong) JHPickerView *picker;
@property(nonatomic,strong) NSMutableArray <JHCustomizeSendExpressModel*>*dataList;
@property (strong, nonatomic)  UILabel* userName;
@property (strong, nonatomic)  UILabel *address;
@property (strong, nonatomic)  UILabel *userPhoneNum;
@property(nonatomic, strong) UIView *homePickupView;
@property(nonatomic, strong) UIView *remindView;
@property(nonatomic, strong) UILabel *remindLabel;
@property(nonatomic, strong) UILabel *selectTimeLabel;
@property(nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UILabel *addressLabel;
@property(nonatomic, strong) UILabel *userPhoneNumLabel;

@end

@implementation JHCustomizeNotHomePickupView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initScrollview];
    }
    return self;
}
-(void)initScrollview{
    
    self.contentScroll=[[UIScrollView alloc]init];
    self.contentScroll.showsHorizontalScrollIndicator = NO;
    self.contentScroll.showsVerticalScrollIndicator = YES;
    self.contentScroll.backgroundColor =[CommHelp toUIColorByStr:@"#f7f7f7"];
    self.contentScroll.scrollEnabled=YES;
    self.contentScroll.alwaysBounceVertical=YES;
    [self addSubview:self.contentScroll];
    [self.contentScroll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.bottom.equalTo(self).offset(0);
        make.left.right.equalTo(self);
    }];
    
    [self initTitleView];
    //自行邮寄
    [self initCustomizeAdressView];
    //上门预约取件
    [self initHomePickupView];
    
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
///自行邮寄
-(void)initCustomizeAdressView{
    
    _adressView = [[UIView alloc]init];
    _adressView.backgroundColor=[UIColor whiteColor];
    _adressView.userInteractionEnabled=YES;
    _adressView.layer.cornerRadius = 8;
    _adressView.layer.masksToBounds=YES;
    [self.contentScroll addSubview:_adressView];
    
    [_adressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
    }];
    
    UILabel *descriptionTitleLabel = [[UILabel alloc]init];
    descriptionTitleLabel.text = @"自行邮寄原料";
    descriptionTitleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    descriptionTitleLabel.backgroundColor = [UIColor clearColor];
    descriptionTitleLabel.textColor = kColor333;
    descriptionTitleLabel.numberOfLines = 1;
    descriptionTitleLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    descriptionTitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_adressView addSubview:descriptionTitleLabel];
    [descriptionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_adressView).offset(10);
        make.left.equalTo(_adressView).offset(10);
        make.width.equalTo(_adressView);
    }];
    UILabel *descriptionConentLabel = [[UILabel alloc]init];
    descriptionConentLabel.text = @"请您自行联系物流公司，将原料邮寄到平台并填写发货信息";
    descriptionConentLabel.font = [UIFont fontWithName:kFontNormal size:12];
    descriptionConentLabel.backgroundColor = [UIColor clearColor];
    descriptionConentLabel.textColor = kColor333;
    descriptionConentLabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
    descriptionConentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_adressView addSubview:descriptionConentLabel];
    [descriptionConentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptionTitleLabel.mas_bottom).offset(10);
        make.left.equalTo(_adressView.mas_left).offset(10);
        make.right.equalTo(_adressView.mas_right).offset(-10);
    }];
    JHCustomLine *line = [JHUIFactory createLine];
    [_adressView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(descriptionConentLabel.mas_bottom).offset(15);
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"平台收货信息";
    title.font = [UIFont fontWithName:kFontMedium size:15];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = kColor333;
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_adressView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(1);
        make.left.equalTo(_adressView).offset(10);
        make.width.equalTo(_adressView);
        make.height.offset(40);
    }];
    
    UIView * adressInfoView = [UIView new];
    adressInfoView.backgroundColor = [UIColor whiteColor];
    [_adressView addSubview:adressInfoView ];
    [adressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(0);
        make.left.right.equalTo(_adressView);
    }];
    
    UIImageView *addressLogo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_location_logo"]];
    addressLogo.backgroundColor=[UIColor clearColor];
    addressLogo.contentMode = UIViewContentModeScaleAspectFit;
    [addressLogo setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [addressLogo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [adressInfoView addSubview:addressLogo];
    
    [addressLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(adressInfoView).offset(-5);
        make.left.equalTo(adressInfoView).offset(10);
    }];
    
    _userName=[[UILabel alloc]init];
    _userName.text=@"";
    _userName.font=[UIFont systemFontOfSize:14];
    _userName.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _userName.numberOfLines = 1;
    _userName.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _userName.lineBreakMode = NSLineBreakByWordWrapping;
    [adressInfoView addSubview:_userName];
    
    _userPhoneNum=[[UILabel alloc]init];
    _userPhoneNum.text=@"";
    _userPhoneNum.font=[UIFont systemFontOfSize:14];
    _userPhoneNum.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _userPhoneNum.numberOfLines = 1;
    _userPhoneNum.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _userPhoneNum.lineBreakMode = NSLineBreakByWordWrapping;
    [adressInfoView addSubview:_userPhoneNum];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLogo.mas_right).offset(10);
        make.top.equalTo(adressInfoView).offset(6);
    }];
    
    [_userPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userName);
        make.left.equalTo(_userName.mas_right).offset(10);
    }];
    
    _address=[[UILabel alloc]init];
    _address.text=@"";
    _address.font=[UIFont systemFontOfSize:12];
    _address.backgroundColor=[UIColor clearColor];
    _address.textColor=[CommHelp toUIColorByStr:@"#333333"];
    _address.numberOfLines = 2;
    _address.lineBreakMode = NSLineBreakByTruncatingTail;
    _address.textAlignment = UIControlContentHorizontalAlignmentCenter;
    [adressInfoView addSubview:_address];
    
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName.mas_bottom).offset(10);
        make.left.equalTo(_userName);
        make.right.equalTo(adressInfoView).offset(-10);
        make.bottom.equalTo(adressInfoView).offset(-16);
    }];
    
    UIImageView *bottomImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_fenline"]];
    bottomImage.backgroundColor=[UIColor clearColor];
    [_adressView addSubview:bottomImage];
    
    [bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(adressInfoView.mas_bottom);
        make.left.right.equalTo(_adressView).offset(0);
        make.height.offset(4);
    }];
    
    //填写发货信息
    _expressView = [[JHCustomizeHomPickupSendExpressView alloc]init];
    _expressView.backgroundColor=[UIColor whiteColor];
    _expressView.userInteractionEnabled=YES;
    [_adressView addSubview:_expressView];
    [_expressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_adressView).offset(0);
        make.top.equalTo(bottomImage.mas_bottom).offset(10);
    }];
    JH_WEAK(self)
    _expressView.buttonHandle = ^(id obj) {
        JH_STRONG(self)
        [self scanCode];
    };
    _expressView.chooseExpressHandle = ^(id obj) {
        JH_STRONG(self)
        [self.picker show];
    };

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(320, 44) radius:22];
    [button setBackgroundImage:nor_image forState:UIControlStateNormal];
    [button setTitleColor:kColor333 forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:kFontMedium size:15];
    [button setTitle:@"提交发货信息" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_adressView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_expressView.mas_bottom).offset(12);
        make.left.equalTo(_adressView.mas_left).offset(18);
        make.right.equalTo(_adressView.mas_right).offset(-18);
        make.height.offset(44);
        make.bottom.equalTo(_adressView.mas_bottom).offset(-12);
    }];
    UIView *submitBtnView = [[UIView alloc]init];
    [submitBtnView addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(submitBtnViewAction)]];
    submitBtnView.backgroundColor = RGBA(255, 255, 255, 0.7);
    [button addSubview:submitBtnView];
    [submitBtnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(button);
    }];
    
    _expressView.textFieldString = ^(id obj) {
        NSString *text = obj;
        if (text.length > 0) {
            submitBtnView.hidden = YES;
        }else{
            submitBtnView.hidden = NO;
        }
    };
}

///上门预约取件
- (void)initHomePickupView{
    UIView *homePickupView = [[UIView alloc]init];
    self.homePickupView = homePickupView;
    homePickupView.backgroundColor = [UIColor whiteColor];
    homePickupView.userInteractionEnabled = YES;
    homePickupView.layer.cornerRadius = 8;
    homePickupView.layer.masksToBounds = YES;
    [self.contentScroll addSubview:homePickupView];
    [homePickupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_adressView.mas_bottom).offset(10);
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.bottom.equalTo(self.contentScroll).offset(-30);
    }];
    //温馨提示
    UIView *remindView = [[UIView alloc]init];
    self.remindView = remindView;
    remindView.backgroundColor = [CommHelp toUIColorByStr:@"#F5F6FA"];
    remindView.layer.cornerRadius = 5;
    [homePickupView addSubview:remindView];
    [remindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(homePickupView).offset(0);
        make.left.equalTo(homePickupView.mas_left).offset(10);
        make.right.equalTo(homePickupView.mas_right).offset(-10);
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

    //上门取件预约
    UIView *reservationView = [[UIView alloc]init];
    reservationView.backgroundColor = UIColor.whiteColor;
    [homePickupView addSubview:reservationView];
    [reservationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remindView.mas_bottom).offset(10);
        make.left.equalTo(homePickupView).offset(0);
        make.right.equalTo(homePickupView).offset(0);
        make.bottom.equalTo(homePickupView.mas_bottom);
    }];
    
    UILabel *title = [[UILabel alloc]init];
    title.text = @"上门取件预约";
    title.font = [UIFont fontWithName:kFontMedium size:15];
    title.textColor = kColor333;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [reservationView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(reservationView).offset(10);
        make.top.equalTo(reservationView.mas_top).offset(12);
    }];
    //取件时间
    UIView *timeView = [[UIView alloc]init];
    [reservationView addSubview:timeView];
    [timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(12);
        make.left.right.equalTo(reservationView).offset(0);
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
    
    _selectTimeLabel = [[UILabel alloc]init];
    _selectTimeLabel.text = @"";
    _selectTimeLabel.font = [UIFont fontWithName:kFontNormal size:13];
    _selectTimeLabel.textColor = [CommHelp toUIColorByStr:@"#B3B3B3"];
    _selectTimeLabel.textAlignment = NSTextAlignmentRight;
    _selectTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [timeView addSubview:_selectTimeLabel];
    [_selectTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(timeView);
        make.right.equalTo(timeView.mas_right).offset(-10);
        make.left.equalTo(timeTitle.mas_right).offset(20);
    }];
    
    //取件地址
    UIView *addressView = [[UIView alloc]init];
    [reservationView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(timeView.mas_bottom);
        make.left.right.equalTo(reservationView).offset(0);
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
    _userNameLabel.textColor = [CommHelp toUIColorByStr:@"#B3B3B3"];
    _userNameLabel.numberOfLines = 1;
    _userNameLabel.textAlignment = NSTextAlignmentRight;
    _userNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [addressView addSubview:_userNameLabel];
    _userPhoneNumLabel = [[UILabel alloc]init];
    _userPhoneNumLabel.text = @"";
    _userPhoneNumLabel.font = [UIFont fontWithName:kFontNormal size:12];
    _userPhoneNumLabel.textColor = [CommHelp toUIColorByStr:@"#B3B3B3"];
    _userPhoneNumLabel.numberOfLines = 1;
    _userPhoneNumLabel.textAlignment = NSTextAlignmentRight;
    _userPhoneNumLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [addressView addSubview:_userPhoneNumLabel];
    [_userPhoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(addressTitle);
        make.right.equalTo(addressView.mas_right).offset(-10);
    }];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_userPhoneNumLabel.mas_left).offset(-8);
        make.centerY.equalTo(addressTitle);
    }];
    
    _addressLabel = [[UILabel alloc]init];
    _addressLabel.text = @"";
    _addressLabel.font = [UIFont fontWithName:kFontNormal size:12];
    _addressLabel.textColor = [CommHelp toUIColorByStr:@"#B3B3B3"];
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
    
    //联系客服 按钮
    UIButton *customerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customerBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [customerBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    [customerBtn addTarget:self action:@selector(clickCustomerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [customerBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [customerBtn setBackgroundColor:[UIColor whiteColor]];
    customerBtn.layer.cornerRadius = 22.0;
    customerBtn.layer.borderColor = [kColor222 colorWithAlphaComponent:0.5].CGColor;
    customerBtn.layer.borderWidth = 0.5f;
    [reservationView addSubview:customerBtn];
    [customerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom).offset(12);
        make.left.equalTo(reservationView.mas_left).offset(18);
        make.right.equalTo(reservationView.mas_right).offset(-18);
        make.height.offset(44);
        make.bottom.equalTo(reservationView.mas_bottom).offset(-12);
    }];
    UIImageView *notSupportIcon = [[UIImageView alloc] init];
    notSupportIcon.image = [UIImage imageNamed:@"customize_homePickerup_notSupport_icon"];
    [homePickupView addSubview:notSupportIcon];
    [notSupportIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(107, 66));
        make.right.equalTo(remindView.mas_right).offset(-3);
        make.top.equalTo(remindView.mas_bottom).offset(3);

    }];
}
- (void)clickCustomerBtnAction:(UIButton* )sender{
    [JHGrowingIO trackEventId:@"dz_lxkef_click" variables:@{@"orderId":self.orderId,@"orderType":self.orderMode.orderStatus}];
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
- (JHPickerView *)picker {
    if (!_picker) {
        _picker = [[JHPickerView alloc] init];
        _picker.widthPickerComponent = 300;
        _picker.heightPicker = 240 + UI.bottomSafeAreaHeight;
        [_picker setDelegate:self];
    }
    return _picker;
}
- (void)submitBtnViewAction{
    if (self.expressView.textField.text.length == 0){
        [self makeToast:@"请填写单号" duration:1.0 position:CSToastPositionCenter];
    };
}
-(void)onClickBtnAction:(UIButton*)sender{
    [_expressView.textField resignFirstResponder];
    
    if (self.expressView.textField.text.length == 0){
        [self makeToast:@"请填写单号" duration:1.0 position:CSToastPositionCenter];
        return;
    };
    [JHGrowingIO trackEventId:@"dz_tjfh_click" variables:@{@"orderId":self.orderId,@"orderType":self.orderMode.orderStatus}];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    JHCustomizeSendExpressModel *expressModel = self.dataList[selectedIndex];
    dic[@"expressCompany"] = expressModel.com;
    dic[@"expressNumber"] = self.expressView.textField.text;
    dic[@"orderId"] = self.orderId;
    NSString *url;
    if (self.isSeller) {
        url = FILE_BASE_STRING(@"/orderCustomize/auth/sellerSend");
    }
    else{
        url = FILE_BASE_STRING(@"/orderCustomize/auth/buyerSend");
    }
    __block BOOL specificVC = false;
    [HttpRequestTool postWithURL:url Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
       
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];
        //发货成功跳列表页面
        for (UIViewController *controller in self.viewController.navigationController.viewControllers) {
            if ([controller isKindOfClass:[JHNewOrderListViewController class]]) {
                JHNewOrderListViewController *revise =(JHNewOrderListViewController *)controller;
                [self.viewController.navigationController popToViewController:revise animated:YES];
                specificVC = true;
                break;
            }
        }
        if (!specificVC) {
            [self.viewController.navigationController popViewControllerAnimated:YES];
        }
        
    } failureBlock:^(RequestModel *respondObject) {
       
        [JHKeyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
    }];
    
    
}
- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    if (![pickerSingle isKindOfClass:[JHPickerView class]]) {
        return;
    }
    selectedIndex = [pickerSingle.pickerView selectedRowInComponent:1];
    self.expressView.expressCompany.text= self.dataList[selectedIndex].name;
}
-(void)scanCode{
    JHQRViewController *vc = [[JHQRViewController alloc] init];
    vc.titleString = @"扫描运单号";
    MJWeakSelf
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController *obj) {
        weakSelf.expressView.textField.text = scanString;
        [obj.navigationController popViewControllerAnimated:YES];
    };
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

-(void)setModel:(JHCustomizeSendOrderModel *)model{
    
    _model = model;
    self.userName.text= _model.receiveName;
    self.userPhoneNum.text= _model.receivePhone;
    self.address.text= _model.receiveAddress;
    
    self.dataList = [_model.expressTypes mutableCopy];
    NSMutableArray *muArray = [NSMutableArray array];
    for (JHCustomizeSendExpressModel *m in self.dataList) {
        [muArray addObject:m.name];
    }
    self.picker.arrayData = muArray;
    self.expressView.expressCompany.text= self.dataList[0].name;
    
    //疫情温馨提示
    if (model.keepEpidemicWarnDesc.length > 0) {
        [self.remindView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_homePickupView).offset(12);
        }];
        self.remindLabel.text = model.keepEpidemicWarnDesc;
        [self.remindLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.remindView.mas_top).offset(7);
            make.bottom.equalTo(self.remindView.mas_bottom).offset(-7);
        }];
    }
    self.selectTimeLabel.text = model.expressReserveDate;
    self.userPhoneNumLabel.text = model.expressReservePhone;
    self.userNameLabel.text = model.expressReserveName;
    self.addressLabel.text = model.expressReserveAddress;
    
}

@end
