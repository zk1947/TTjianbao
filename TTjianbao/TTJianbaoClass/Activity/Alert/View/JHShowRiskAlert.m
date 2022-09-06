//
//  JHShowRiskAlert.m
//  TTjianbao
//
//  Created by mac on 2019/10/5.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHShowRiskAlert.h"
#import "JHWebViewController.h"
#import "TTjianbaoHeader.h"

@interface JHShowRiskAlert ()
@property (nonatomic, strong)UIView *backView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIButton *protocolBtn;
@property (nonatomic, strong)UIButton *okBtn;
@property (nonatomic, strong)UIButton *closeBtn;
@property (nonatomic, strong)UILabel *priceLabel;



@end

@implementation JHShowRiskAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLORA(0x000000, 0.5);
        
        [self addSubview:self.backView];
        
    }
    return self;
}


- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 4;
        _backView.layer.masksToBounds = YES;
    }
    
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:17];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.text = @"风险提示";
    }
    
    return _titleLabel;
}
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _contentLabel.textColor = HEXCOLOR(0xFF4200);
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByClipping;
        _contentLabel.text = @"翡翠原石属于特殊商品，交易后不\n退不换，请谨慎购买！\n进入直播间视为已知晓风险！";
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _contentLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.font = [UIFont fontWithName:kFontBoldDIN size:35];
        _priceLabel.textColor = HEXCOLOR(0xFF4200);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _priceLabel;
}


- (UIButton *)protocolBtn {
    if (!_protocolBtn) {
        _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_protocolBtn setTitle:@" 同意平台原石交易协议" forState:UIControlStateNormal];
        [_protocolBtn setImage:[UIImage imageNamed:@"icon_check_risk_selected"] forState:UIControlStateNormal];
        [_protocolBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        [_protocolBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [_protocolBtn setTitleColor:HEXCOLOR(0x235E96) forState:UIControlStateSelected];
        _protocolBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_protocolBtn addTarget:self action:@selector(protocolAction) forControlEvents:UIControlEventTouchUpInside];
        _protocolBtn.selected = YES;
        
    }
    
    return _protocolBtn;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:@"×" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    }
    
    return _closeBtn;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_okBtn setTitle:@"我已知晓风险" forState:UIControlStateNormal];
        _okBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        [_okBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _okBtn.backgroundColor = kGlobalThemeColor;
        _okBtn.layer.cornerRadius = 22;
        _okBtn.layer.masksToBounds = YES;
        [_okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

- (void)okAction {
    if (self.okBtn.tag == 1) {
        [self reCatuAction];
    }
    [self closeAction];
}

- (void)closeAction {

    [self removeFromSuperview];
}

- (void)protocolAction {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/rockAgreement.html");
    vc.titleString = @"原石交易协议";
    [JHRouterManager.jh_getViewController.navigationController pushViewController:vc animated:YES];
}

- (void)style1 {
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.contentLabel];
    [self.backView addSubview:self.protocolBtn];
    [self.backView addSubview:self.okBtn];
    [self.backView addSubview:self.closeBtn];
    self.okBtn.tag = 0;

    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
        make.width.equalTo(@(ScreenW-70*2));
        //            make.height.equalTo(@(300));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.backView).offset(27);
        make.height.equalTo(@(18));
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
    }];
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(5);
        make.height.equalTo(@(35));
        
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.protocolBtn.mas_bottom).offset(10);
        make.height.equalTo(@(44));
        make.leading.equalTo(self.backView).offset(25);
        make.trailing.equalTo(self.backView).offset(-25);
        make.bottom.equalTo(self.backView).offset(-10);
        
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self.backView);
        make.height.width.equalTo(@44);
    }];
    
    
}

- (void)style2WithPrice:(NSString *)string {
    [self.backView addSubview:self.titleLabel];
    self.titleLabel.text = @"您本周购买原石已消费";
    self.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
    [self.backView addSubview:self.okBtn];
    [self.backView addSubview:self.closeBtn];
    [self.backView addSubview:self.priceLabel];
    self.priceLabel.text = string;
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName:kFontNormal size:15];
    label.textColor = self.priceLabel.textColor;
    label.text = @"￥";
    [self.backView addSubview:label];
    
    UILabel *yuan = [UILabel new];
       yuan.font = [UIFont fontWithName:kFontNormal size:15];
       yuan.textColor = self.priceLabel.textColor;
       yuan.text = @"元";
       [self.backView addSubview:yuan];
    
    UILabel *des = [UILabel new];
    des.font = [UIFont fontWithName:kFontNormal size:15];
    des.textColor = HEXCOLOR(0x333333);
    des.text = @"超过了等级消费限额";
    [self.backView addSubview:des];
    
    UILabel *des1 = [UILabel new];
    des1.font = [UIFont fontWithName:kFontNormal size:13];
    des1.textColor = HEXCOLOR(0x666666);
    des1.text = @"若想提升等级额度";
    [self.backView addSubview:des1];
    
    [self.okBtn setTitle:@"重新评估收藏等级" forState:UIControlStateNormal];
    self.okBtn.tag = 1;
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
        make.width.equalTo(@(ScreenW-70*2));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.backView).offset(27);
        make.height.equalTo(@(18));
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLabel).offset(-5);
        make.trailing.equalTo(self.priceLabel.mas_leading);
        
    }];
    
    [yuan mas_makeConstraints:^(MASConstraintMaker *make) {
           make.bottom.equalTo(self.priceLabel).offset(-5);
           make.leading.equalTo(self.priceLabel.mas_trailing);
           
       }];
    
    [des mas_makeConstraints:^(MASConstraintMaker *make) {
          make.centerX.equalTo(self.backView);
          make.top.equalTo(self.priceLabel.mas_bottom).offset(5);
      }];
    
    [des1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(des.mas_bottom).offset(20);
    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(des1.mas_bottom).offset(10);
        make.height.equalTo(@(44));
        make.leading.equalTo(self.backView).offset(25);
        make.trailing.equalTo(self.backView).offset(-25);
        make.bottom.equalTo(self.backView).offset(-10);
        
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self.backView);
        make.height.width.equalTo(@44);
    }];
    
}

- (void)reCatuAction {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/riskTtest.html");
    [JHRouterManager.jh_getViewController.navigationController pushViewController:vc animated:YES];
}
@end
