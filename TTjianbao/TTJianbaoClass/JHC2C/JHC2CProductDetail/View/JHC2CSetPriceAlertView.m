//
//  JHC2CSetPriceAlertView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSetPriceAlertView.h"
#import "YYLabel.h"
#import "JHC2CProductDetailBusiness.h"
#import "JHWebViewController.h"
#import "JHC2CSureMoneyModel.h"
#import "JHC2CProoductDetailModel.h"
#import "IQKeyboardManager.h"


@interface JHC2CSetPriceAlertView()<UITextFieldDelegate>

@property(nonatomic, strong) UIButton * backViewBtn;

@property(nonatomic, strong) UIButton * closeBtn;

@property(nonatomic, strong) UILabel * titleLbl;

//@property(nonatomic, strong) UILabel * lingXianTitleLbl;

@property(nonatomic, strong) NSString * lingXianAppend;

@property(nonatomic, strong) UILabel * lingXianLbl;
//加价幅度:¥100
@property(nonatomic, strong) UILabel * centerLbl;
@property(nonatomic, strong) UILabel * centerBottomLbl;

@property(nonatomic, strong) UIButton * addBtn;

@property(nonatomic, strong) UIButton * minesBtn;
@property(nonatomic, strong) UIButton * sureBtn;

@property(nonatomic, strong) UITextField * numTextField;

@property(nonatomic, strong) YYLabel * rulerLbl;

@property(nonatomic, strong) UIButton * cancleBtn;

/// 基准价格 分
@property(nonatomic) NSInteger price;

/// 当前展示价格 分
@property(nonatomic) NSInteger currentPrice;

/// 当前展示价格 分
@property(nonatomic) NSInteger  minAddPrice;

@end

@implementation JHC2CSetPriceAlertView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:UIScreen.mainScreen.bounds]) {
        self.backgroundColor = HEXCOLORA(0x000000, 0.4);
        self.lingXianAppend = @"当前领先价：";
    }
    return self;
}
- (void)setModel:(JHC2CProoductDetailModel *)model{
    _model = model;
}

- (void)setAuModel:(JHC2CAuctionRefershModel *)model{
    _auModel = model;
    BOOL hasPrice = [model.buyerPrice isNotBlank];
    NSString *orignPrice = hasPrice ? model.buyerPrice : model.startPrice;
    self.price = orignPrice.integerValue;
    self.minAddPrice = model.bidIncrement.integerValue;
    self.currentPrice = orignPrice.integerValue;
    self.currentPrice += self.minAddPrice;
    if([model.expectedPrice isNotBlank] && self.type != JHC2CSetPriceAlertView_ChuJia){
        self.currentPrice = model.expectedPrice.integerValue;
    }
    [self refreshPrice];
}

- (void)setAuModelB2C:(JHB2CAuctionRefershModel *)model{
    _auModelB2C = model;
    BOOL hasPrice = [model.buyerPrice isNotBlank];
    NSString *orignPrice = hasPrice ? model.buyerPrice : model.startPrice;
    self.price = orignPrice.integerValue;
    self.minAddPrice = model.bidIncrement.integerValue;
    self.currentPrice = orignPrice.integerValue;
    self.currentPrice += self.minAddPrice;
    if([model.expectedPrice isNotBlank] && self.type != JHC2CSetPriceAlertView_ChuJia){
        self.currentPrice = model.expectedPrice.integerValue;
    }
    [self refreshPrice];
}



- (void)refresWithType:(JHC2CSetPriceAlertViewType)type{
    _type = type;
    [self addSubview:self.backViewBtn];
    [self.backViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
    }];
    
    switch (type) {
        case JHC2CSetPriceAlertView_First:
        {
            [self.backViewBtn addSubview:self.closeBtn];
            [self.backViewBtn addSubview:self.titleLbl];
            [self.backViewBtn addSubview:self.centerLbl];
            [self.backViewBtn addSubview:self.centerBottomLbl];

            [self.backViewBtn addSubview:self.lingXianLbl];
            self.lingXianAppend = @"您的最高预期价：";
            [self.backViewBtn addSubview:self.addBtn];
            [self.backViewBtn addSubview:self.minesBtn];
            [self.backViewBtn addSubview:self.sureBtn];
            
            [self.backViewBtn addSubview:self.rulerLbl];
            [self.backViewBtn addSubview:self.numTextField];
            self.centerLbl.hidden = YES;
            [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.equalTo(@0).inset(20);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@0).offset(30);
                make.centerX.equalTo(@0);
            }];
            [self.lingXianLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLbl.mas_bottom).offset(11);
                make.centerX.equalTo(@0);
            }];

            [self.minesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lingXianLbl.mas_bottom).offset(15);
                make.size.mas_equalTo(CGSizeMake(63, 63));
                make.left.equalTo(@0).offset(31);
            }];
            [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lingXianLbl.mas_bottom).offset(15);
                make.size.mas_equalTo(CGSizeMake(63, 63));
                make.right.equalTo(@0).offset(-31);
            }];

            [self.centerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.minesBtn);
                make.left.equalTo(self.minesBtn.mas_right);
                make.right.equalTo(self.addBtn.mas_left);
            }];
            [self.numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.minesBtn);
                make.left.equalTo(self.minesBtn.mas_right).offset(20);
                make.right.equalTo(self.addBtn.mas_left).offset(-20);
            }];
            [self.centerBottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.centerLbl.mas_bottom).offset(5);
                make.centerX.equalTo(self.centerLbl);
            }];
            [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.centerLbl.mas_bottom).offset(35);
                make.size.mas_equalTo(CGSizeMake(314, 44));
                make.centerX.equalTo(@0);
                make.bottom.equalTo(@0).offset(-64);
            }];
            
            [self.rulerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@0).offset(-20);
                make.centerX.equalTo(@0);
            }];
            self.titleLbl.text = @"设置代理出价";
            [self.sureBtn setTitle:@"设置代理出价" forState:UIControlStateNormal];
            

//            属性值：立即出价、设置代理出价、支付保证金
        }
            break;
        case JHC2CSetPriceAlertView_SetDelegate:
        {
            [self.backViewBtn addSubview:self.closeBtn];
            [self.backViewBtn addSubview:self.titleLbl];
            [self.backViewBtn addSubview:self.centerLbl];
            [self.backViewBtn addSubview:self.centerBottomLbl];

//            [self.backViewBtn addSubview:self.lingXianTitleLbl];
            [self.backViewBtn addSubview:self.lingXianLbl];
            self.lingXianAppend = @"您的最高预期价：";
            [self.backViewBtn addSubview:self.addBtn];
            [self.backViewBtn addSubview:self.minesBtn];
            [self.backViewBtn addSubview:self.sureBtn];
            [self.backViewBtn addSubview:self.cancleBtn];

            [self.backViewBtn addSubview:self.rulerLbl];
            [self.backViewBtn addSubview:self.numTextField];
            self.centerLbl.hidden = YES;
            [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.equalTo(@0).inset(20);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@0).offset(30);
                make.centerX.equalTo(@0);
            }];
//            [self.lingXianTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.titleLbl.mas_bottom).offset(11);
//                make.left.equalTo(@0).offset(118);
//            }];
            [self.lingXianLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLbl.mas_bottom).offset(11);
                make.centerX.equalTo(@0);
            }];

            [self.minesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lingXianLbl.mas_bottom).offset(15);
                make.size.mas_equalTo(CGSizeMake(63, 63));
                make.left.equalTo(@0).offset(31);
            }];
            [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lingXianLbl.mas_bottom).offset(15);
                make.size.mas_equalTo(CGSizeMake(63, 63));
                make.right.equalTo(@0).offset(-31);
            }];

            [self.centerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.minesBtn);
                make.left.equalTo(self.minesBtn.mas_right);
                make.right.equalTo(self.addBtn.mas_left);
            }];
            [self.numTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.minesBtn);
                make.left.equalTo(self.minesBtn.mas_right).offset(20);
                make.right.equalTo(self.addBtn.mas_left).offset(-20);
            }];
            [self.centerBottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.centerLbl.mas_bottom).offset(5);
                make.centerX.equalTo(self.centerLbl);
            }];
            [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.centerLbl.mas_bottom).offset(35);
                make.size.mas_equalTo(CGSizeMake(314, 44));
                make.centerX.equalTo(@0);
            }];
            [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.sureBtn.mas_bottom).offset(10);
                make.size.mas_equalTo(CGSizeMake(314, 44));
                make.centerX.equalTo(@0);
                make.bottom.equalTo(@0).offset(-64);
            }];

            [self.rulerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@0).offset(-20);
                make.centerX.equalTo(@0);
            }];
            self.titleLbl.text = @"设置代理出价";
            [self.sureBtn setTitle:@"设置代理出价" forState:UIControlStateNormal];
            
            //埋点

        }
            break;
        case JHC2CSetPriceAlertView_ChuJia:
        {
            [self.backViewBtn addSubview:self.closeBtn];
            [self.backViewBtn addSubview:self.titleLbl];
            [self.backViewBtn addSubview:self.centerLbl];
            [self.backViewBtn addSubview:self.centerBottomLbl];

//            [self.backViewBtn addSubview:self.lingXianTitleLbl];
            [self.backViewBtn addSubview:self.lingXianLbl];
            
            [self.backViewBtn addSubview:self.addBtn];
            [self.backViewBtn addSubview:self.minesBtn];
            [self.backViewBtn addSubview:self.sureBtn];
            
            [self.backViewBtn addSubview:self.rulerLbl];

            [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.equalTo(@0).inset(20);
                make.size.mas_equalTo(CGSizeMake(20, 20));
            }];
            [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@0).offset(30);
                make.centerX.equalTo(@0);
            }];
//            [self.lingXianTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.equalTo(self.titleLbl.mas_bottom).offset(11);
//                make.left.equalTo(@0).offset(118);
//            }];
            [self.lingXianLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLbl.mas_bottom).offset(11);
                make.centerX.equalTo(@0);
            }];

            [self.minesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lingXianLbl.mas_bottom).offset(15);
                make.size.mas_equalTo(CGSizeMake(63, 63));
                make.left.equalTo(@0).offset(31);
            }];
            [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lingXianLbl.mas_bottom).offset(15);
                make.size.mas_equalTo(CGSizeMake(63, 63));
                make.right.equalTo(@0).offset(-31);
            }];

            [self.centerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.minesBtn);
                make.left.equalTo(self.minesBtn.mas_right);
                make.right.equalTo(self.addBtn.mas_left);
            }];
            [self.centerBottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.centerLbl.mas_bottom).offset(5);
                make.centerX.equalTo(self.centerLbl);
            }];
            [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.centerLbl.mas_bottom).offset(35);
                make.size.mas_equalTo(CGSizeMake(314, 44));
                make.centerX.equalTo(@0);
                make.bottom.equalTo(@0).offset(-64);
            }];
            
            [self.rulerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(@0).offset(-20);
                make.centerX.equalTo(@0);
            }];

        }
            break;
        default:
            break;
    }
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
//    self.currentPrice = self.basePrice;
    
}

- (void)regionActionWithSender{
    [self.numTextField resignFirstResponder];
}

- (void)refreshPrice{
    [self checkButtonStatus];
    
    NSString *mainStr = [NSString stringWithFormat:@"%@",[CommHelp getPriceWithInterFen:self.currentPrice]];
    
    NSMutableAttributedString *attstrMain1 = [[NSMutableAttributedString alloc] initWithString:mainStr attributes:
                                             @{NSForegroundColorAttributeName:HEXCOLOR(0x222222),
                                               NSFontAttributeName : JHMediumFont(37)
                                             }];
    NSMutableAttributedString *attstrMain2 = [[NSMutableAttributedString alloc] initWithString:@"￥" attributes:
                                          @{NSForegroundColorAttributeName:HEXCOLOR(0x222222),
                                                                   NSFontAttributeName : JHMediumFont(17)
                                          }];

    [attstrMain2 appendAttributedString:attstrMain1];

    self.centerLbl.attributedText =  attstrMain2;
    self.numTextField.attributedText =  attstrMain2;
    NSInteger bidIncrement = self.fromB2C ? self.auModelB2C.bidIncrement.integerValue : self.auModel.bidIncrement.integerValue;
    self.centerBottomLbl.text = [NSString stringWithFormat:@"加价幅度￥%@",[CommHelp getPriceWithInterFen:bidIncrement]];

    NSString *lastStr = @"";
    if (self.type == JHC2CSetPriceAlertView_ChuJia) {
        NSString *lingXianStr = [self.auModel.buyerPrice isNotBlank] ?  self.auModel.buyerPrice : self.auModel.startPrice;
        if (self.fromB2C) {
            lingXianStr = [self.auModelB2C.buyerPrice isNotBlank] ?  self.auModelB2C.buyerPrice : self.auModelB2C.startPrice;
        }
        lastStr = [NSString stringWithFormat:@"￥%@",[CommHelp getPriceWithInterFen:lingXianStr.integerValue]];
    }else{
        lastStr = [NSString stringWithFormat:@"￥%@",[CommHelp getPriceWithInterFen:self.currentPrice]];
    }
    
    NSMutableAttributedString *attstr = [[NSMutableAttributedString alloc] initWithString:self.lingXianAppend attributes:
                                             @{NSForegroundColorAttributeName:HEXCOLOR(0x333333),
                                               NSFontAttributeName : JHFont(14)
                                             }];
    NSMutableAttributedString *attstr1 = [[NSMutableAttributedString alloc] initWithString:lastStr attributes:
                                          @{NSForegroundColorAttributeName:HEXCOLOR(0xFF4200),
                                                                   NSFontAttributeName : JHMediumFont(14)
                                          }];
    [attstr appendAttributedString:attstr1];
    self.lingXianLbl.attributedText = attstr;
}


- (void)addActionWithSender:(UIButton*)sender{
    if (self.numTextField.isFirstResponder) {
        [self.numTextField resignFirstResponder];
        return;
    }
    self.currentPrice += self.minAddPrice;
    if (self.currentPrice >= 1000000000) {
        self.currentPrice = 1000000000;
    }
    [self refreshPrice];
}

- (void)nimesActionWithSender:(UIButton*)sender{
    if (self.numTextField.isFirstResponder) {
        [self.numTextField resignFirstResponder];
        return;
    }
    self.addBtn.enabled = YES;
    self.currentPrice -= self.minAddPrice;
    [self refreshPrice];
}

- (void)checkButtonStatus{
    if (self.price + self.minAddPrice >= self.currentPrice) {
        self.minesBtn.enabled = NO;
    }else{
        self.minesBtn.enabled = YES;
    }
    if (self.currentPrice >= 1000000000) {
        self.addBtn.enabled = NO;
    }else{
        self.addBtn.enabled = YES;
    }
}



- (void)sureActionWithSender:(UIButton*)sender{
    BOOL isAgent = self.isAgent == 1;
    
    if (!self.fromB2C) {
        if (self.type == JHC2CSetPriceAlertView_First) {
            //埋点
            NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
            parDic[@"page_position"] = @"集市拍卖出价弹层页";
            parDic[@"commodity_id"] = self.productID;
            parDic[@"button_name"] = @"设置代理出价";
            [JHAllStatistics jh_allStatisticsWithEventId:@"bidLayerClick" params:parDic type:JHStatisticsTypeSensors];

        }else if (self.type == JHC2CSetPriceAlertView_SetDelegate) {
            NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
            parDic[@"page_position"] = @"集市拍卖出价弹层页";
            parDic[@"commodity_id"] = self.productID;
            parDic[@"button_name"] = @"设置代理出价";
            [JHAllStatistics jh_allStatisticsWithEventId:@"bidLayerClick" params:parDic type:JHStatisticsTypeSensors];
        }else{
            //埋点
            NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
            parDic[@"page_position"] = @"集市拍卖出价弹层页";
            parDic[@"commodity_id"] = self.productID;
            parDic[@"button_name"] = @"立即出价";
            [JHAllStatistics jh_allStatisticsWithEventId:@"bidLayerClick" params:parDic type:JHStatisticsTypeSensors];
        }
    }
    
    if (self.fromB2C) {
        //埋点
        NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];

        parDic[@"bid_price"] = [NSNumber numberWithInteger:self.currentPrice/100];
        parDic[@"inc_price"] = [NSNumber numberWithInteger:self.auModelB2C.bidIncrement.integerValue/100];
        NSString *original_price = [self.auModelB2C.buyerPrice isNotBlank] ?  self.auModelB2C.buyerPrice : self.auModelB2C.startPrice;
        parDic[@"original_price"] = [NSNumber numberWithInteger:original_price.integerValue/100];
        parDic[@"commodity_id"] = self.productID;
        parDic[@"page_position"] = @"商城拍卖商品详情页";
        [JHAllStatistics jh_allStatisticsWithEventId:@"bidButtonClick" params:parDic type:JHStatisticsTypeSensors];
        
        [JHStoreDetailBusiness requestB2CSetPriceProductSn:self.productSnB2C
                                                  andPrice:[NSNumber numberWithInteger:self.currentPrice].stringValue
                                                isDelegate:isAgent
                                                completion:^(NSError * _Nullable error) {
            if (!error) {
                NSString *tip  = isAgent ? @"设置代理价格成功" : @"出价成功";
                [SVProgressHUD showSuccessWithStatus:tip];
            }else{
                JHTOAST(error.localizedDescription);
            }
            [self removeFromSuperview];
        }];
    }else{
        [JHC2CProductDetailBusiness requestC2CSetPriceProductSn:self.model.productSn
                                                       andPrice:[NSNumber numberWithInteger:self.currentPrice].stringValue
                                                     isDelegate:isAgent
                                                     completion:^(NSError * _Nullable error) {
            if (!error) {
                [NSNotificationCenter.defaultCenter postNotificationName:@"JHC2CProductDetailControllerNeedRefreshData" object:nil];
                NSString *tip  = isAgent ? @"设置代理价格成功" : @"出价成功";
                [SVProgressHUD showSuccessWithStatus:tip];
            }else{
                [NSNotificationCenter.defaultCenter postNotificationName:@"JHC2CProductDetailControllerNeedRefreshData" object:nil];
                JHTOAST(error.localizedDescription);
            }
            [self removeFromSuperview];
        }];
    }
}

- (void)cancleDelegateActionWithSender:(UIButton*)sender{
    if (self.fromB2C) {
        [JHStoreDetailBusiness requestB2CCancleSetPriceProductSn:self.productSnB2C
                                                      completion:^(NSError * _Nullable error) {
                    
            if (!error) {
                [SVProgressHUD showSuccessWithStatus:@"取消代理价格成功"];
            }else{
                JHTOAST(error.localizedDescription);
            }
            [self removeFromSuperview];
        }];
    }else{
        [JHC2CProductDetailBusiness requestC2CCancleSetPriceProductSn:self.model.productSn completion:^(NSError * _Nullable error) {
            if (!error) {
                [NSNotificationCenter.defaultCenter postNotificationName:@"JHC2CProductDetailControllerNeedRefreshData" object:nil];
                [SVProgressHUD showSuccessWithStatus:@"取消代理价格成功"];
            }else{
                [NSNotificationCenter.defaultCenter postNotificationName:@"JHC2CProductDetailControllerNeedRefreshData" object:nil];
                [SVProgressHUD showErrorWithStatus:@"取消代理价格失败"];
            }
            [self removeFromSuperview];
        }];
    }
}



- (void)closeActionWithSender{
    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeActionWithSender];
}

- (void)change:(UITextField*)sender{
}

#pragma mark -- <UITextFieldDelegate>
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL num = ([self isNum:string] || [string isEqualToString:@""]);
    if (num) {
        NSString *str = [textField.text stringByReplacingOccurrencesOfString:@"￥" withString:@""];
        if ([string isEqualToString:@""]) {
            NSString *text = textField.text;
            if ([text containsString:@"."]) {
                textField.text = [text componentsSeparatedByString:@"."].firstObject;
            }else{
                NSInteger tem = self.currentPrice/1000;
                self.currentPrice = tem * 100;
                [self refreshPrice];
            }
        }else{
            if (str.length < 7) {
                str = [str stringByAppendingString:string];
                self.currentPrice = str.integerValue * 100;
            }
            [self refreshPrice];
        }
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString *text = textField.text;
    textField.text = [text componentsSeparatedByString:@"."].firstObject;
}

- (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}
- (UIButton *)backViewBtn{
    if (!_backViewBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = HEXCOLOR(0xFFFFFF);
        btn.layer.cornerRadius = 8;
        [btn addTarget:self action:@selector(regionActionWithSender) forControlEvents:UIControlEventTouchUpInside];
        _backViewBtn = btn;
    }
    return _backViewBtn;
}


- (UIButton *)closeBtn{
    if (!_closeBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"orderPopView_closeIcon"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeActionWithSender) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = btn;
    }
    return _closeBtn;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(17);
        label.textColor = HEXCOLOR(0x333333);
        label.text = @"宝贝很抢手  请立即出价";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UILabel *)lingXianLbl{
    if (!_lingXianLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(14);
        label.textColor = HEXCOLOR(0xFF4200);
        label.text = @"￥1000";
        _lingXianLbl = label;
    }
    return _lingXianLbl;
}
//- (UILabel *)lingXianTitleLbl{
//    if (!_lingXianTitleLbl) {
//        UILabel *label = [UILabel new];
//        label.font = JHFont(14);
//        label.textColor = HEXCOLOR(0x333333);
//        label.text = @"当前领先价：";
//        _lingXianTitleLbl = label;
//    }
//    return _lingXianTitleLbl;
//}

- (UIButton *)addBtn{
    if (!_addBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"c2c_pd_jia_a"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"c2c_pd_jia_b"] forState:UIControlStateDisabled];

        [btn addTarget:self action:@selector(addActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _addBtn = btn;
    }
    return _addBtn;
}

- (UIButton *)minesBtn{
    if (!_minesBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"c2c_pd_jian_a"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"c2c_pd_jian_b"] forState:UIControlStateDisabled];
        btn.enabled = NO;
        [btn addTarget:self action:@selector(nimesActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _minesBtn = btn;
    }
    return _minesBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = HEXCOLOR(0xFFD70F);
        [btn setTitle:@"立即出价" forState:UIControlStateNormal];
        btn.titleLabel.font = JHMediumFont(16);
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sureActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn = btn;
    }
    return _sureBtn;
}

- (UILabel *)centerBottomLbl{
    if (!_centerBottomLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.textColor = HEXCOLOR(0x999999);
        label.text = @"您将出价￥1000";
        _centerBottomLbl = label;
    }
    return _centerBottomLbl;
}


- (UILabel *)centerLbl{
    if (!_centerLbl) {
        UILabel *label = [UILabel new];
        label.textAlignment = 1;
        label.font = JHMediumFont(37);
        label.textColor = HEXCOLOR(0x222222);
        label.text = @"￥1000";
        [label setAdjustsFontSizeToFitWidth:YES];

        _centerLbl = label;
    }
    return _centerLbl;
}

- (void)jumpRuler{
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/biddingRule.html");
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
}

- (void)yinSiRuler{
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/privacyAgreement.html");
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
    
}

- (void)daiLiRuler{
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/proxyBidding.html");
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
    
}


- (YYLabel *)rulerLbl{
    if (!_rulerLbl) {
        YYLabel *label = [YYLabel new];
        
        NSString *baseStr = _isAgent == 0 ? @"出价即表示同意《天天鉴宝参拍须知》" : @"出价即表示同意《天天鉴宝代理出价协议》";
        
        NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString: baseStr];

        [text setAttributes:@{NSFontAttributeName: JHFont(11), NSForegroundColorAttributeName: HEXCOLOR(0x222222)}];
        if (_isAgent == 0) {
            NSRange range1 = [baseStr rangeOfString:@"《天天鉴宝参拍须知》"];
            @weakify(self);
            [text setTextHighlightRange:range1 color:HEXCOLOR(0x007AFF) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @strongify(self);
                [self jumpRuler];
            }];
        }else{
            NSRange range1 = [baseStr rangeOfString:@"《天天鉴宝代理出价协议》"];
            @weakify(self);
            [text setTextHighlightRange:range1 color:HEXCOLOR(0x007AFF) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                @strongify(self);
                [self daiLiRuler];
            }];
        }

        label.attributedText = text;
        _rulerLbl = label;
    }
    return _rulerLbl;
}


- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = HEXCOLOR(0xFFFFFF);
        [btn setTitle:@"取消代理出价" forState:UIControlStateNormal];
        btn.titleLabel.font = JHMediumFont(16);
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = HEXCOLOR(0xE6E6E6).CGColor;
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cancleDelegateActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _cancleBtn = btn;
    }
    return _cancleBtn;
}





- (UITextField *)numTextField{
    if (!_numTextField) {
        UITextField *tfd = [UITextField new];
        tfd.keyboardType = UIKeyboardTypeNumberPad;
        tfd.autocorrectionType = UITextAutocorrectionTypeNo;
        tfd.spellCheckingType = UITextSpellCheckingTypeNo;
        tfd.returnKeyType = UIReturnKeyDone;
//        tfd.inputAccessoryView = [UIView new];
        tfd.tintColor = HEXCOLOR(0xFFD70F);
        tfd.delegate = self;
        tfd.placeholder = @"0.00";
        tfd.backgroundColor = HEXCOLOR(0xF5F6FA);
        tfd.textAlignment = 1;
        tfd.font = JHBoldFont(37);
        [tfd setAdjustsFontSizeToFitWidth:YES];
        tfd.layer.cornerRadius = 4;
        _numTextField = tfd;
        [tfd addTarget:self action:@selector(change:) forControlEvents:UIControlEventAllEditingEvents];
    }
    return _numTextField;
}

@end
