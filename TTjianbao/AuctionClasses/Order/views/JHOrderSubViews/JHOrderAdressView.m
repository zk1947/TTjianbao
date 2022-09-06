//
//  JHOrderAdressView.m
//  TTjianbao
//
//  Created by jiang on 2020/5/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderAdressView.h"
@interface JHOrderAdressView ()
@property (strong, nonatomic) UILabel  *userName;
@property (strong, nonatomic) UILabel  *address;
@property (strong, nonatomic) UILabel  *userPhoneNum;
@property (strong, nonatomic) UIButton *pasteButton;
@end

@implementation JHOrderAdressView
-(void)setSubViews{
    
    UIImageView *bottomImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_fenline"]];
    bottomImage.backgroundColor=[UIColor clearColor];
    [self addSubview:bottomImage];
    
    [bottomImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self).offset(0);
        make.height.offset(2);
    }];
    
    UIView * adressInfoView=[UIView new];
    adressInfoView.backgroundColor=[UIColor clearColor];
    [self addSubview:adressInfoView ];
    
    [adressInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self).offset(-10);
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
    _userName.textAlignment = NSTextAlignmentLeft;
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
        make.left.equalTo(addressLogo.mas_right).offset(7);
        make.top.equalTo(adressInfoView).offset(20);
        
    }];
    
    [_userPhoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_userName);
        make.left.equalTo(_userName.mas_right).offset(10);
        
    }];
    
    
    _pasteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pasteButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:11.f];
    [_pasteButton setTitle:@"复制" forState:UIControlStateNormal];
    [_pasteButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_pasteButton addTarget:self action:@selector(pasteButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    _pasteButton.layer.cornerRadius  = 10.f;
    _pasteButton.layer.masksToBounds = YES;
    _pasteButton.layer.borderWidth   = 0.5f;
    _pasteButton.layer.borderColor   = HEXCOLOR(0xFEE100).CGColor;
    _pasteButton.backgroundColor     = HEXCOLORA(0xFEE100, 0.2f);
    _pasteButton.hidden              = YES;
    [self addSubview:_pasteButton];
    [_pasteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(adressInfoView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-18.f);
        make.width.mas_equalTo(35.f);
        make.height.mas_equalTo(19.f);
    }];
    
    
    _address=[[UILabel alloc]init];
    _address.text=@"";
    _address.font=[UIFont systemFontOfSize:14];
    _address.backgroundColor=[UIColor clearColor];
    _address.textColor=[CommHelp toUIColorByStr:@"#222222"];
    _address.numberOfLines = 2;
    _address.lineBreakMode = NSLineBreakByTruncatingTail;
    _address.textAlignment = NSTextAlignmentLeft;
    [adressInfoView addSubview:_address];
    
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userName.mas_bottom).offset(10);
        make.left.equalTo(_userName);
        make.right.equalTo(self.pasteButton.mas_left).offset(-10);
    }];
    
   
}

- (void)pasteButtonClickAction:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString *str = [NSString stringWithFormat:@"%@ %@ %@",NONNULL_STR(_userName.text),NONNULL_STR(_userPhoneNum.text),NONNULL_STR(_address.text)];
    if (!isEmpty(str)) {
        [pasteboard setString:str];
        [UITipView showTipStr:@"复制成功"];
    } else {
        [UITipView showTipStr:@"复制失败"];
    }
}

- (void)setOrderMode:(JHOrderDetailMode *)orderMode {
    _orderMode          = orderMode;
    _pasteButton.hidden = !orderMode.directDelivery;
    _userName.text      = _orderMode.shippingReceiverName;
    _userPhoneNum.text  = _orderMode.shippingPhone;
    _address.text       = [NSString stringWithFormat:@"%@ %@ %@ %@",_orderMode.shippingProvince,_orderMode.shippingCity,_orderMode.shippingCounty,_orderMode.shippingDetail];
}

- (void)setCustomizeOrderMode:(JHCustomizeOrderModel *)customizeOrderMode {
    _customizeOrderMode = customizeOrderMode;
    _userName.text      = _customizeOrderMode.shippingReceiverName;
    _userPhoneNum.text  = _customizeOrderMode.shippingPhone;
    _address.text       = [NSString stringWithFormat:@"%@ %@ %@ %@",_customizeOrderMode.shippingProvince,_customizeOrderMode.shippingCity,_customizeOrderMode.shippingCounty,_customizeOrderMode.shippingDetail];
}

@end
