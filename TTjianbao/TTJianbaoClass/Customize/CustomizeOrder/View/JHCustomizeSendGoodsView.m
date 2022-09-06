//
//  JHCustomizeSendGoodsView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeSendGoodsView.h"
#import "TTjianbaoHeader.h"
#import "TTjianbaoUtil.h"
#import "JHUIFactory.h"
#import "JHCustomizeOrderModel.h"
#import "JHWebViewController.h"
#import "UIImage+JHColor.h"
#import "JHCustomizeSendExpressView.h"
#import "JHQRViewController.h"

@interface JHCustomizeSendGoodsView ()<UITextFieldDelegate,UITextViewDelegate,STPickerSingleDelegate>
{
    NSInteger selectedIndex;
}
@property(nonatomic,strong) UIScrollView * contentScroll;
@property(nonatomic,strong) UIView * titleView;
@property(nonatomic,strong) UIView * adressView;
@property(nonatomic,strong) JHCustomizeSendExpressView * expressView;
@property(nonatomic,strong) JHPickerView *picker;
@property(nonatomic,strong) NSMutableArray <JHCustomizeSendExpressModel*>*dataList;
@property (strong, nonatomic)  UILabel* userName;
@property (strong, nonatomic)  UILabel *address;
@property (strong, nonatomic)  UILabel *userPhoneNum;


@end

@implementation JHCustomizeSendGoodsView
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
        make.bottom.equalTo(self).offset(-70);
        make.left.right.equalTo(self);
    }];
    
    [self initTitleView];
    [self initCustomizeAdressView];
    [self initExpressView];
    [self initBottomView];
    
}
-(void)initTitleView{
    
    _titleView=[[UIView alloc]init];
    _titleView.backgroundColor=[CommHelp  toUIColorByStr:@"#FFEDE7"];
    _titleView.userInteractionEnabled=YES;
    _titleView.layer.cornerRadius = 8;
    _titleView.layer.masksToBounds =YES;
    [self.contentScroll addSubview:_titleView];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.top.equalTo(self.contentScroll).offset(10);
        make.height.offset(40);
        make.width.offset(ScreenW-20);
    }];
    
    UILabel * title=[[UILabel alloc]init];
    title.text=@"请您根据以下信息将原料邮寄到平台";
    title.font=[UIFont fontWithName:kFontNormal size:13];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColorMainRed;
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentRight;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_titleView addSubview:title];
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_titleView);
    }];
    
}
-(void)initCustomizeAdressView{
    
    _adressView=[[UIView alloc]init];
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
    
    UILabel  *title=[[UILabel alloc]init];
    title.text=@"平台收货信息";
    title.font=[UIFont fontWithName:kFontMedium size:15];
    title.backgroundColor=[UIColor clearColor];
    title.textColor=kColor333;
    title.numberOfLines = 1;
    title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    title.lineBreakMode = NSLineBreakByWordWrapping;
    [_adressView addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_adressView).offset(20);
        make.left.equalTo(_adressView).offset(10);
        make.width.equalTo(_adressView);
        
    }];
    
    UIView * adressInfoView=[UIView new];
    adressInfoView.backgroundColor=[UIColor whiteColor];
    [_adressView addSubview:adressInfoView ];
    
    [adressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(0);
        make.left.equalTo(_adressView);
        make.right.equalTo(_adressView).offset(-10);
        make.height.offset(100);
    }];
    
    UIImageView *addressLogo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_location_logo"]];
    addressLogo.backgroundColor=[UIColor clearColor];
    addressLogo.contentMode = UIViewContentModeScaleAspectFit;
    [addressLogo setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [addressLogo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [adressInfoView addSubview:addressLogo];
    
    [addressLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(adressInfoView).offset(0);
        make.left.equalTo(adressInfoView).offset(10);
    }];
    
    _userName=[[UILabel alloc]init];
    _userName.text=@"";
    _userName.font=[UIFont systemFontOfSize:14];
    _userName.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _userName.numberOfLines = 1;
    _userName.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _userName.lineBreakMode = NSLineBreakByWordWrapping;
    [adressInfoView addSubview:_userName];
    
    _userPhoneNum=[[UILabel alloc]init];
    _userPhoneNum.text=@"";
    _userPhoneNum.font=[UIFont systemFontOfSize:14];
    _userPhoneNum.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _userPhoneNum.numberOfLines = 1;
    _userPhoneNum.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _userPhoneNum.lineBreakMode = NSLineBreakByWordWrapping;
    [adressInfoView addSubview:_userPhoneNum];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLogo.mas_right).offset(5);
        make.centerY.equalTo(adressInfoView).offset(-15);
    }];
    
    [_userPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userName);
        make.left.equalTo(_userName.mas_right).offset(10);
    }];
    
    _address=[[UILabel alloc]init];
    _address.text=@"";
    _address.font=[UIFont systemFontOfSize:14];
    _address.backgroundColor=[UIColor clearColor];
    _address.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _address.numberOfLines = 2;
    _address.lineBreakMode = NSLineBreakByTruncatingTail;
    _address.textAlignment = UIControlContentHorizontalAlignmentCenter;
    [adressInfoView addSubview:_address];
    
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName.mas_bottom).offset(10);
        make.left.equalTo(_userName);
        make.right.equalTo(adressInfoView).offset(-10);
    }];
    
    UIImageView *bottomImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_fenline"]];
    bottomImage.backgroundColor=[UIColor clearColor];
    [_adressView addSubview:bottomImage];
    
    [bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(adressInfoView.mas_bottom);
        make.bottom.equalTo(_adressView);
        make.left.right.equalTo(_adressView).offset(0);
        make.height.offset(2);
    }];
    
}


-(void)initExpressView{
    
    _expressView=[[JHCustomizeSendExpressView alloc]init];
    _expressView.backgroundColor=[UIColor whiteColor];
    _expressView.userInteractionEnabled=YES;
    _expressView.layer.masksToBounds =YES;
    _expressView.layer.cornerRadius = 8;
    [self.contentScroll addSubview:_expressView];
    
    [_expressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentScroll).offset(10);
        make.right.equalTo(self.contentScroll).offset(-10);
        make.top.equalTo(_adressView.mas_bottom).offset(10);
          make.bottom.equalTo(self.contentScroll);
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

}
-(void)initBottomView{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *nor_image = [UIImage gradientThemeImageSize:CGSizeMake(320, 44) radius:22];
    [button setBackgroundImage:nor_image forState:UIControlStateNormal];
    [button setTitleColor:kColor333 forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont fontWithName:kFontMedium size:15];
    [button  setTitle:@"确认发货" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.contentScroll.mas_bottom).offset(10);
        make.width.offset(320);
        make.height.offset(44);
    }];
    
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
-(void)onClickBtnAction:(UIButton*)sender{
    
    if (self.expressView.textField.text.length == 0){
        [self makeToast:@"请填写单号" duration:1.0 position:CSToastPositionCenter];
        return;
    };
   
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
    [HttpRequestTool postWithURL:url Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
       
        [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
        [self.viewController.navigationController popViewControllerAnimated:YES];
        
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
    
}
@end
