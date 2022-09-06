//
//  JHC2CRulerAlertView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/10/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CRulerAlertView.h"


@interface JHC2CRulerAlertView()<UITextFieldDelegate>

@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) UILabel * titleLbl;

@property(nonatomic, strong) UIButton * sureBtn;

@property(nonatomic, strong) UIScrollView * scView;

@property(nonatomic, strong) UILabel * desLbl;

@property(nonatomic, strong) NSTimer * timer;

@property(nonatomic, assign) NSInteger  second;
@end

@implementation JHC2CRulerAlertView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:UIScreen.mainScreen.bounds]) {
        self.backgroundColor = HEXCOLORA(0x000000, 0.4);
        [self setItemsAndLayout];
        self.second = 5;
    }
    return self;
}


- (void)setItemsAndLayout{
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(260, 334));
    }];
    
    [self.backView addSubview:self.titleLbl];
    [self.backView addSubview:self.sureBtn];
    [self.backView addSubview:self.scView];
    [self.scView addSubview:self.desLbl];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(25);
        make.centerX.equalTo(@0);
    }];
    [self.scView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
        make.left.right.equalTo(@0);
        make.bottom.equalTo(self.sureBtn.mas_top).offset(-16);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0).offset(-20);
        make.size.mas_equalTo(CGSizeMake(213, 40));
        make.centerX.equalTo(@0);
    }];
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.right.equalTo(@0).inset(20);
        make.width.equalTo(@220);
        make.bottom.equalTo(@0);
    }];
    
    @weakify(self);
    [RACObserve(self.sureBtn, enabled) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        BOOL enable = [x boolValue];
        self.sureBtn.layer.borderWidth = enable ? 0 : 0.5;
    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^{
        @strongify(self);
        [self refershTimer];
    } repeats:YES];
}

- (void)sureActionWithSender:(UIButton*)sender{
    [self removeFromSuperview];
}

- (void)refershTimer{
    self.second-- ;
    NSString *str = [NSString stringWithFormat:@"我知道了(%lds)", self.second];
    [self.sureBtn setTitle:str forState:UIControlStateDisabled];
    if (self.second < 1) {
        self.sureBtn.enabled = YES;
        [self.timer invalidate];
    }
}


- (void)setForDetailVC:(BOOL)forDetailVC{
    _forDetailVC = forDetailVC;
    if (forDetailVC) {
        self.desLbl.text = @"宝友集市为文玩闲置交易平台，买卖双方主体均为宝友个人，天天鉴宝为双方交易提供技术服务，为保证买卖双方利益，请您仔细阅读下方交易时的注意事项：\n1、交易过程中请仔细阅读每个页面的平台公示及温馨提示，有疑问可咨询官方在线客服，避免因不理解规则而产生交易问题；\n2、宝友集市为买卖双方自由交易，商品详情及交易问题请优先与交易方沟通，协商调解不成的可请求平台予以协调，但平台只针对双方证据进行结果认定；\n3、买卖双方都因遵守宝友集市交易规则，出现恶意违规情况平台有权对用户进行禁止交易、封禁账号等处罚；\n4、受宝友集市个人交易属性影响，所有商品均不支持平台品控及七天无理由退货；\n详情规则可在确认订单页查看《宝友集市交易协议》";
        self.titleLbl.text = @"用户须知";
    }
}

- (UIView*)backView{
    if (!_backView) {
        UIView *btn = [UIView new];
        btn.backgroundColor = HEXCOLOR(0xFFFFFF);
        btn.layer.cornerRadius = 8;
        _backView = btn;
    }
    return _backView;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(15);
        label.textColor = HEXCOLOR(0x333333);
        label.text = @"发布须知";
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UILabel *)desLbl{
    if (!_desLbl) {
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0x333333);
        label.text = @"天天鉴宝用户在“宝友集市”发布商品及信息，不得违反国家相关法律法规及宝友集市的相关要求，出现下列违规情况，平台有权依据违规情况对卖家进行禁止发布、禁止交易及封禁账号等处罚：\n1、 发布宝友集市不允许售卖的品类；\n不允许售卖品类：翡翠、和田玉、蜜蜡、南红、绿松、珍珠彩宝\n2、来源违法及国家明令禁止买卖的物品：\n3、商品详情违规。商品详情为与商品本身无关的广告或信息、盗图、图片与实物不符、私留联系方式等均视为违规；\n4、交易违规。售卖假货、短期内大规模操纵或干扰交易、利用其他平台进行商品倒卖、多次无理由关闭交易等；\n5、诱导买家进行违规操作（如诱导买家提前收货、脱离平台交易等）；\n具体可查看下方《天天鉴宝商品及信息发布细则》";
        _desLbl = label;
    }
    return _desLbl;
}
- (UIButton *)sureBtn{
    if (!_sureBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = YES;
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFD70F)] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFFFFF)] forState:UIControlStateDisabled];
        [btn setTitle:@"我知道了(5s)" forState:UIControlStateDisabled];
        btn.enabled = NO;
        [btn setTitle:@"我知道了" forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(15);
        [btn setTitleColor:HEXCOLOR(0xBDBFC2) forState:UIControlStateDisabled];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(sureActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
        _sureBtn = btn;
    }
    return _sureBtn;
}

- (UIScrollView *)scView{
    if (!_scView) {
        _scView = [UIScrollView new];
    }
    return  _scView;
}
@end
