//
//  JHC2CProductDetailJianDingStatuView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailJianDingStatuView.h"
#import "UIButton+ImageTitleSpacing.h"


@interface JHC2CProductDetailJianDingStatuView()
@property(nonatomic) JHC2CProductDetailJianDingType  type;
@property(nonatomic, strong) UIImageView * backView;

@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UILabel * statuLbl;
@property(nonatomic, strong) UIButton * jianDingBtn;

@property(nonatomic, strong) NSTimer * timer;

@end

@implementation JHC2CProductDetailJianDingStatuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    [self addSubview:self.backView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.titleLbl];
    [self.backView addSubview:self.statuLbl];
    [self.backView addSubview:self.jianDingBtn];
    [self refreshStatusType:JHC2CProductDetailJianDingType_NotJianDing];
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.right.equalTo(@0).inset(12);
        make.height.mas_equalTo(34);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0).offset(8);
        make.centerY.equalTo(@0);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(self.iconImageView.mas_right).offset(6);
    }];
    [self.statuLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@0).offset(-8);
    }];
    [self.jianDingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(@0).inset(3);
        make.width.equalTo(@86);
    }];
}

- (void)refreshStatusType:(JHC2CProductDetailJianDingType)type{
    self.type = type;
    self.backView.image = [UIImage imageNamed:[self getBGImageName]];
    self.iconImageView.image = [UIImage imageNamed:[self getTextImageName]];
    self.titleLbl.font = [self getDetailTextFont];
    self.statuLbl.font = [self getResultTextFont];
    self.titleLbl.text = [self getDetailText];
    self.statuLbl.text = [self getResultText];
    self.titleLbl.textColor = [self getDetailTextColor];
    self.statuLbl.textColor = [self getResultTextColor];
    
    self.statuLbl.hidden = type == JHC2CProductDetailJianDingType_NotJianDing;
    self.jianDingBtn.hidden = !self.statuLbl.isHidden;

}
- (void)goJianDing{
    
    if (self.goJianDingBlock) {
        self.goJianDingBlock();
    }
}

#pragma mark -- <set and get>


- (UIImageView *)backView{
    if (!_backView) {
        UIImageView *view = [[UIImageView alloc] init];
        view.userInteractionEnabled = YES;
        _backView = view;
    }
    return _backView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [[UIImageView alloc] init];
        _iconImageView = view;
    }
    return _iconImageView;
}
- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        _titleLbl = label;
    }
    return _titleLbl;
}
- (UILabel *)statuLbl{
    if (!_statuLbl) {
        UILabel *label = [UILabel new];
        _statuLbl = label;
    }
    return _statuLbl;
}
- (UIButton *)jianDingBtn{
    if (!_jianDingBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"鉴定该宝贝" forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(13);
        [btn setTitleColor:HEXCOLOR(0x5A3B23) forState:UIControlStateNormal];
        btn.backgroundColor = HEXCOLOR(0xFFE5C2);
        [btn setImage:[UIImage imageNamed:@"c2c_pd_bg_smallarrow"] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 4;
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -6, 0, 6);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 58, 0, -58);
        [btn addTarget:self action:@selector(goJianDing) forControlEvents:UIControlEventTouchUpInside];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:8];

        _jianDingBtn = btn;
    }
    return _jianDingBtn;
}



- (NSString*)getBGImageName{
    NSArray* arr = @[@"c2c_pd_bg_weijianding", @"c2c_pd_bg_zhen", @"c2c_pd_bg_cunyi", @"c2c_pd_bg_gongyipin", @"c2c_pd_bg_gongyipin"];
    return arr[self.type];
}
- (NSString*)getTextImageName{
    NSArray* arr = @[@"c2c_pd_jian", @"c2c_pd_real", @"c2c_pd_yi", @"c2c_pd_gongyipin", @"c2c_pd_fang"];
    return arr[self.type];
}
- (NSString*)getDetailText{
    NSArray* arr = @[@"图文鉴定，先鉴定后交易", @"宝贝已通过平台图文鉴定", @"宝贝已通过平台图文鉴定", @"宝贝已通过平台图文鉴定", @"宝贝已通过平台图文鉴定"];
    return arr[self.type];
}
- (NSString*)getResultText{
    NSArray* arr = @[@"鉴定该宝贝", @"鉴定为真", @"鉴定存疑", @"工艺品", @"仿品"];
    return arr[self.type];
}


- (UIFont*)getResultTextFont{
    NSArray* arr = @[JHFont(14), JHMediumFont(14), JHFont(14), JHFont(14), JHFont(14)];
    return arr[self.type];
}
- (UIFont*)getDetailTextFont{
    NSArray* arr = @[JHFont(14), JHFont(14), JHFont(14),JHFont(14),JHFont(14)];
    return arr[self.type];
}
- (UIColor*)getResultTextColor{
    NSArray* arr = @[HEXCOLOR(0x5A3B23), HEXCOLOR(0xD92621), HEXCOLOR(0x333333), HEXCOLOR(0x515E6E), HEXCOLOR(0x515E6E)];
    return arr[self.type];
}
- (UIColor*)getDetailTextColor{
    NSArray* arr = @[HEXCOLOR(0xFFE6BE), HEXCOLOR(0x684B00), HEXCOLOR(0x575757), HEXCOLOR(0x606F81), HEXCOLOR(0x606F81)];
    return arr[self.type];
}
@end
