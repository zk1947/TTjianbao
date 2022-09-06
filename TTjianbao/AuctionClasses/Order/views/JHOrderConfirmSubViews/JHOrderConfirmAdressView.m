//
//  JHOrderConfirmAdressView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderConfirmAdressView.h"
#import "JHOrderViewModel.h"
#import "AddAdressViewController.h"
#import "AdressManagerViewController.h"
#import "JHGrowingIO.h"

@interface JHOrderConfirmAdressView ()
{
    UIView *adressInfoView;
    UIView *adressAddView;
}
@property (strong, nonatomic)  UILabel* userName;
@property (strong, nonatomic)  UILabel *address;
@property (strong, nonatomic)  UILabel *userPhoneNum;
@end
UIView *adressInfoView;
UIView *adressAddView;
@implementation JHOrderConfirmAdressView
-(void)setSubViews{
    
    
    self.userInteractionEnabled=YES;
    [self  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(tapAddressView:)]];
    UIImageView *bottomImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_fenline"]];
    bottomImage.backgroundColor=[UIColor clearColor];
    [self addSubview:bottomImage];
    
    [bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self).offset(0);
        make.height.offset(2);
    }];
    
    adressAddView=[UIView new];
    adressAddView.backgroundColor=[UIColor clearColor];
    adressAddView.layer.masksToBounds=YES;
    [self addSubview:adressAddView ];
    [adressAddView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIImageView *addLogo=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"address_add_icon"]];
    addLogo.backgroundColor=[UIColor clearColor];
    addLogo.contentMode = UIViewContentModeScaleAspectFit;
    [addLogo setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [addLogo setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [adressAddView addSubview:addLogo];
    
    [addLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(adressAddView);
        make.top.equalTo(adressAddView).offset(10);
    }];
    
    UILabel *_addAdressLabel=[[UILabel alloc]init];
    _addAdressLabel.text=@"您还没有收货地址哦！";
    _addAdressLabel.font=[UIFont systemFontOfSize:13];
    _addAdressLabel.backgroundColor=[UIColor clearColor];
    _addAdressLabel.textColor=[CommHelp toUIColorByStr:@"#999999"];
    _addAdressLabel.numberOfLines = 1;
    _addAdressLabel.textAlignment = NSTextAlignmentCenter;
    _addAdressLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [adressAddView addSubview:_addAdressLabel];
    
    [_addAdressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(adressAddView);
        make.top.equalTo(addLogo.mas_bottom).offset(10);
    }];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.backgroundColor=[UIColor clearColor];
    addBtn.layer.cornerRadius=15;
    addBtn.layer.masksToBounds=YES;
    addBtn.layer.borderColor = kColorMain.CGColor;
    addBtn.layer.borderWidth = 1.0;
    [addBtn setTitleColor:kColor333 forState:UIControlStateNormal];
    addBtn.titleLabel.font=[UIFont systemFontOfSize:12];
    [addBtn  setTitle:@"添加收货地址" forState:UIControlStateNormal];
    addBtn.contentMode=UIViewContentModeScaleAspectFit;
    addBtn.userInteractionEnabled=YES;
    [addBtn addTarget:self action:@selector(addAddressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [adressAddView addSubview:addBtn];
    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_addAdressLabel.mas_bottom).offset(20);
        make.centerX.equalTo(adressAddView);
        make.width.offset(106);
        make.height.offset(30);
    }];
    
    adressInfoView=[UIView new];
    adressInfoView.backgroundColor=[UIColor clearColor];
    adressInfoView.layer.masksToBounds=YES;
    [self addSubview:adressInfoView ];
    
    [adressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    indicator.backgroundColor=[UIColor clearColor];
    [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator.contentMode = UIViewContentModeScaleAspectFit;
    [adressInfoView addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(adressInfoView).offset(-15);
        make.centerY.equalTo(adressInfoView);
        
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
    _userName.font=[UIFont systemFontOfSize:13];
    _userName.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _userName.numberOfLines = 1;
    _userName.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _userName.lineBreakMode = NSLineBreakByWordWrapping;
    [adressInfoView addSubview:_userName];
    
    _userPhoneNum=[[UILabel alloc]init];
    _userPhoneNum.text=@"";
    _userPhoneNum.font=[UIFont systemFontOfSize:13];
    _userPhoneNum.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _userPhoneNum.numberOfLines = 1;
    _userPhoneNum.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _userPhoneNum.lineBreakMode = NSLineBreakByWordWrapping;
    [adressInfoView addSubview:_userPhoneNum];
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLogo.mas_right).offset(5);
        make.top.equalTo(adressInfoView).offset(20);
        
    }];
    
    [_userPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userName);
        make.left.equalTo(_userName.mas_right).offset(10);
        
    }];
    
    _address=[[UILabel alloc]init];
    _address.text=@"";
    _address.font=[UIFont systemFontOfSize:13];
    _address.backgroundColor=[UIColor clearColor];
    _address.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _address.numberOfLines = 2;
    _address.lineBreakMode = NSLineBreakByTruncatingTail;
    _address.textAlignment = UIControlContentHorizontalAlignmentCenter;
    [adressInfoView addSubview:_address];
    
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName.mas_bottom).offset(5);
        make.left.equalTo(_userName);
        make.right.equalTo(indicator.mas_left).offset(-20);
        
    }];
    [adressAddView  setHidden:YES];
    [adressInfoView  setHidden:YES];
    
    
}
-(void)setAddressMode:(AdressMode *)addressMode{
    
    _addressMode=addressMode;
    if (_addressMode.receiverName&&_addressMode.phone) {
        self.userName.text=_addressMode.receiverName;
        self.userPhoneNum.text=_addressMode.phone;
        self.address.text=[NSString stringWithFormat:@"%@ %@ %@ %@",_addressMode.province,_addressMode.city,_addressMode.county,_addressMode.detail];
        [JHOrderViewModel checkOrderAddress:_addressMode completion:^(RequestModel *respondObject, NSError *error) {
            if (error) {
                UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"提示" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style: UIAlertActionStyleDefault handler:nil]];
                [self.viewController presentViewController:alertVc animated:YES completion:nil];
            }
        }];
        [adressAddView  setHidden:YES];
        [adressInfoView  setHidden:NO];
        [JHGrowingIO trackEventId:JHTrackConfirmOrderAddressAlertShow variables:@{@"confirm_Order_AddressAlert_show":@"0"}];
    }
    else{
        [adressAddView  setHidden:NO];
        [adressInfoView  setHidden:YES];
        [JHGrowingIO trackEventId:JHTrackConfirmOrderAddressAlertShow variables:@{@"confirm_Order_AddressAlert_show":@"1"}];
        CommAlertView *addAlert=[[CommAlertView alloc]initWithTitle:@""
                                                            andDesc:@"您还没有收货地址哦，赶快设置一个吧!" cancleBtnTitle:@"取消" sureBtnTitle:@"去设置"];
        [[UIApplication sharedApplication].keyWindow addSubview:addAlert];
        JH_WEAK(self)
        addAlert.handle = ^{
            JH_STRONG(self)
            [JHGrowingIO trackEventId:JHTrackConfirmOrderAddressAlertSetAddressClick];
            [self pushAddAddressVC];
        };
        addAlert.cancleHandle = ^{
            [JHGrowingIO trackEventId:JHTrackConfirmOrderAddressAlertCancelClick];
        };
    }
}
-(void)addAddressButtonAction:(UIButton*)button{
    [JHGrowingIO trackEventId:JHTrackConfirmOrderAddAddressClick];
    [self pushAddAddressVC];
}
-(void)pushAddAddressVC{
    AddAdressViewController * vc=[[AddAdressViewController alloc]init];
    vc.fromType=2;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
-(void)tapAddressView:(UIGestureRecognizer*)tap{
    
    if (self.addressMode) {
        AdressManagerViewController *address=[AdressManagerViewController new];
        @weakify(self);
        address.selectedBlock = ^(AdressMode *model) {
          @strongify(self);
            self.addressMode = model;
        };
        [self.viewController.navigationController  pushViewController:address animated:YES];
    }
    else{
        AddAdressViewController *address=[AddAdressViewController new];
        [self.viewController.navigationController  pushViewController:address animated:YES];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
