//
//  JHC2CPaySureMoneyView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CPaySureMoneyView.h"
#import "JHWebViewController.h"

#import "JHC2CProoductDetailModel.h"

@interface JHC2CPaySureMoneyView()

@property(nonatomic, strong) UIButton * backViewBtn;

@property(nonatomic, strong) UIButton * closeBtn;

@property(nonatomic, strong) UILabel * topLbl;

@property(nonatomic, strong) UILabel * priceLbl;

@property(nonatomic, strong) YYLabel * titleLbl;

@property(nonatomic, strong) UILabel * noticeLbl;

@property(nonatomic, strong) UIButton * sureBtn;

@property(nonatomic, strong) UIButton * cancleBtn;

@property(nonatomic, strong) NSString * priceStr;

@end

@implementation JHC2CPaySureMoneyView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:UIScreen.mainScreen.bounds]) {
        self.backgroundColor = HEXCOLORA(0x000000, 0.4);
        
        [self addSubview:self.backViewBtn];
        [self.backViewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(@0);
        }];
        
        [self.backViewBtn addSubview:self.topLbl];
        [self.backViewBtn addSubview:self.priceLbl];

        [self.backViewBtn addSubview:self.closeBtn];
        [self.backViewBtn addSubview:self.titleLbl];
        [self.backViewBtn addSubview:self.sureBtn];
        [self.backViewBtn addSubview:self.cancleBtn];

        [self.backViewBtn addSubview:self.noticeLbl];


        [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).inset(15);
            make.right.equalTo(@0).inset(15);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [self.topLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0).offset(27);
            make.centerX.equalTo(@0);
        }];
        [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topLbl.mas_bottom).offset(5);
            make.centerX.equalTo(@0);
        }];
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLbl.mas_bottom).offset(15);
            make.left.right.equalTo(@0).inset(30);
            make.centerX.equalTo(@0);
        }];
        
        [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLbl.mas_bottom).offset(21);
            make.size.mas_equalTo(CGSizeMake(314, 44));
            make.centerX.equalTo(@0);
        }];
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sureBtn.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(314, 44));
            make.centerX.equalTo(@0);
        }];
        
        [self.noticeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.cancleBtn.mas_bottom).offset(20);
            make.bottom.equalTo(@0).offset(-20);
            make.left.right.equalTo(@0).inset(30);
        }];

    }
    return self;
}


- (void)setPriceStr:(NSString *)priceStr{
    _priceStr = priceStr;
    NSString *str = [NSString stringWithFormat:@"¥%@",priceStr];
    NSRange range =  [str rangeOfString:@"¥"];
    NSMutableAttributedString *attText  = [[NSMutableAttributedString alloc] initWithString:str
                                                                              attributes:@{NSFontAttributeName: JHBoldFont(44), NSForegroundColorAttributeName: HEXCOLOR(0x333333)}];
    [attText setAttributes:@{NSFontAttributeName: JHBoldFont(24), NSForegroundColorAttributeName: HEXCOLOR(0x333333)} range:range];
    self.priceLbl.attributedText = attText;
}

- (void)closeActionWithSender{
    [self removeFromSuperview];
}


- (void)setModel:(JHC2CProoductDetailModel *)model{
    [self setPriceStr:[CommHelp getPriceWithInterFen:model.auctionFlow.earnestMoney.integerValue]];
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_position"] = @"集市拍卖出价弹层页";
    parDic[@"commodity_id"] = self.productID;
    parDic[@"button_name"] = @"支付保证金";
    [JHAllStatistics jh_allStatisticsWithEventId:@"bidLayerClick" params:parDic type:JHStatisticsTypeSensors];
}

- (void)setModelB2C:(JHProductAuctionFlowModel *)modelB2C{
    [self setPriceStr:[CommHelp getPriceWithInterFen:modelB2C.earnestMoney]];
}

- (void)sureActionWithSender{
    [self closeActionWithSender];
    if (self.payBlock) {
        self.payBlock();
    }
}

- (void)rulerActionWithSender{
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = H5_BASE_STRING(@"/jianhuo/app/agreement/marginRule2.html");
    [JHRootController.currentViewController.navigationController pushViewController:webView animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self closeActionWithSender];
}

- (UIButton *)backViewBtn{
    if (!_backViewBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = HEXCOLOR(0xFFFFFF);
        btn.layer.cornerRadius = 8;
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

- (YYLabel *)titleLbl{
    if (!_titleLbl) {
        YYLabel *label = [YYLabel new];
        label.preferredMaxLayoutWidth = kScreenWidth - 60;
        label.numberOfLines = 0;
        NSString *baseStr = @"根据保证金规则，本次出价需要支付保证金。如违约，将按保证金规则进行赔付和处理。";
        
        NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString: baseStr];

        [text setAttributes:@{NSFontAttributeName: JHFont(13), NSForegroundColorAttributeName: HEXCOLOR(0x999999)}];
        
        NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:@"保证金规范" attributes:
                                   @{NSFontAttributeName : JHFont(13),
                                     NSForegroundColorAttributeName : HEXCOLOR(0x007AFF),
                                     NSUnderlineStyleAttributeName:  @(NSUnderlineStyleSingle)
                                   }];
        @weakify(self);
        [att setTextHighlightRange:NSMakeRange(0, 5) color:HEXCOLOR(0x007AFF) backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            @strongify(self);
            [self rulerActionWithSender];
        }];
        [text appendAttributedString:att];
        label.attributedText = text;
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UILabel *)topLbl{
    if (!_topLbl) {
        UILabel *label = [UILabel new];
        label.font = JHBoldFont(17);
        label.textColor = HEXCOLOR(0x333333);
        label.text = @"支付保证金";
        label.textAlignment = NSTextAlignmentCenter;
        _topLbl = label;
    }
    return _topLbl;
}

- (UILabel *)priceLbl{
    if (!_priceLbl) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        _priceLbl = label;
    }
    return _priceLbl;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = HEXCOLOR(0xFFD70F);
        [btn setTitle:@"支付保证金" forState:UIControlStateNormal];
        btn.titleLabel.font = JHMediumFont(16);
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sureActionWithSender) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn = btn;
    }
    return _sureBtn;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = HEXCOLOR(0xFFFFFF);
        [btn setTitle:@"取消" forState:UIControlStateNormal];
        btn.titleLabel.font = JHMediumFont(16);
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = HEXCOLOR(0xE6E6E6).CGColor;
        [btn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(closeActionWithSender) forControlEvents:UIControlEventTouchUpInside];
        _cancleBtn = btn;
    }
    return _cancleBtn;
}

- (UILabel *)noticeLbl{
    if (!_noticeLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(11);
        label.textColor = HEXCOLOR(0x999999);
        label.numberOfLines = 0;
        label.text = @"温馨提示：如您“竞拍成功后完成商品支付”或“竞拍失败后拍卖活动结束”，您支付的保证金会原路返回，请您放心参与~";
        _noticeLbl = label;
    }
    return _noticeLbl;
}

@end
