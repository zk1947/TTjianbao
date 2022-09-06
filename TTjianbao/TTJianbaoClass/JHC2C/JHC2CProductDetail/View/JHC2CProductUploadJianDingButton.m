//
//  JHC2CProductUploadJianDingButton.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductUploadJianDingButton.h"

@interface JHC2CProductUploadJianDingButton()

@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UILabel * sub1Lbl;
@property(nonatomic, strong) UILabel * sub2Lbl;

@property(nonatomic, strong) UILabel * finishTimeLbl;
@property(nonatomic, strong) UILabel * priceLbl;


@property(nonatomic, strong) UIImageView * titleImageView;
@property(nonatomic, strong) UIImageView * sub1ImageView;
@property(nonatomic, strong) UIImageView * sub2ImageView;

@property(nonatomic, strong) UIView * lineView;

@property(nonatomic, strong) UIView * youHuiQuanView;
@property(nonatomic, strong) YYLabel * youHuiLbl;


@end

@implementation JHC2CProductUploadJianDingButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    [self setBackgroundImage:[UIImage imageNamed:@"c2c_up_jianding_bg_unsel"] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"c2c_up_jianding_bg_sel"] forState:UIControlStateSelected];
    self.adjustsImageWhenHighlighted = NO;

    [self addSubview:self.titleLbl];
    [self addSubview:self.sub1Lbl];
    [self addSubview:self.sub2Lbl];
    [self addSubview:self.finishTimeLbl];
    [self addSubview:self.priceLbl];

    
    [self addSubview:self.titleImageView];
    [self addSubview:self.sub1ImageView];
    [self addSubview:self.sub2ImageView];
    [self addSubview:self.lineView];

    [self addSubview:self.youHuiQuanView];

}
- (void)refrshBtnTime:(NSString *)finishTime{
//    label.text = @"预计鉴定完成时间：明日10:00前";
    self.finishTimeLbl.text = [NSString stringWithFormat:@"预计鉴定完成时间：%@", finishTime];
}

- (void)refrshSave:(double)price{
    if (price >= 0) {
        self.youHuiQuanView.hidden = NO;
        self.youHuiLbl.text = price > 0 ? [NSString stringWithFormat:@"劵后%.2f",price]:@"劵后免费";
        [self.priceLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.youHuiQuanView.mas_left).offset(-10);
            make.centerY.equalTo(self.finishTimeLbl);
        }];
    }else{
        self.youHuiQuanView.hidden = YES;
        [self.priceLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@0).offset(-15);
            make.centerY.equalTo(self.finishTimeLbl);
        }];
    }
    
}

- (void)refrshPrice:(NSString *)price{
    NSString *allStr = [NSString stringWithFormat:@"￥%@/次",price];
    NSRange range = [allStr rangeOfString:price];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:allStr attributes: @{NSFontAttributeName: JHFont(13),NSForegroundColorAttributeName: HEXCOLOR(0x70331C)}];
    [string addAttributes:@{NSFontAttributeName: JHBoldFont(20),NSForegroundColorAttributeName: HEXCOLOR(0x70331C)} range:range];
    self.priceLbl.attributedText = string;
}

- (void)layoutItems{
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(22);
        make.left.equalTo(@0).offset(9);
    }];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.left.equalTo(self.titleLbl.mas_right).offset(5);
    }];
    [self.sub1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(14);
        make.left.equalTo(self.titleLbl);
    }];
    [self.sub1Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sub1ImageView);
        make.left.equalTo(self.sub1ImageView.mas_right).offset(9);
    }];
    [self.sub2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sub1ImageView.mas_bottom).offset(10);
        make.left.equalTo(self.titleLbl);
    }];
    [self.sub2Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sub2ImageView);
        make.left.equalTo(self.sub2ImageView.mas_right).offset(9);
    }];
    [self.finishTimeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLbl);
        make.bottom.equalTo(@0).offset(-10);
    }];
    [self.youHuiQuanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0).offset(-15);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self.finishTimeLbl);
    }];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.youHuiQuanView.mas_left).offset(-10);
        make.centerY.equalTo(self.finishTimeLbl);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0).inset(9);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.finishTimeLbl.mas_top).offset(-10);
    }];
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHBoldFont(16);
        label.text = @"专业图文鉴定";
        label.textColor = HEXCOLOR(0x3F3939);
        _titleLbl = label;
    }
    return _titleLbl;
}
- (UILabel *)sub1Lbl{
    if (!_sub1Lbl) {
        UILabel *label = [UILabel new];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"提升曝光，流量扶持优先展示"attributes: @{NSFontAttributeName: JHFont(13),NSForegroundColorAttributeName: HEXCOLOR(0x393836)}];
//        [string addAttributes:@{NSForegroundColorAttributeName: HEXCOLOR(0x333340)} range:NSMakeRange(0, 2)];
//        [string addAttributes:@{NSFontAttributeName: JHMediumFont(12), NSForegroundColorAttributeName: HEXCOLOR(0x333340)} range:NSMakeRange(0, 1)];
        label.attributedText = string;
        _sub1Lbl = label;
    }
    return _sub1Lbl;
}
- (UILabel *)sub2Lbl{
    if (!_sub2Lbl) {
        UILabel *label = [UILabel new];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"增强信任，宝贝更易出售"attributes: @{NSFontAttributeName: JHFont(13),NSForegroundColorAttributeName: HEXCOLOR(0x393836)}];
//        [string addAttributes:@{NSForegroundColorAttributeName: HEXCOLOR(0x333340)} range:NSMakeRange(0, 2)];
//        [string addAttributes:@{NSFontAttributeName: JHMediumFont(12), NSForegroundColorAttributeName: HEXCOLOR(0x333340)} range:NSMakeRange(0, 1)];
        label.attributedText = string;
        _sub2Lbl = label;
    }
    return _sub2Lbl;
}
- (UILabel *)finishTimeLbl{
    if (!_finishTimeLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.textColor = HEXCOLOR(0x393836);
        label.text = @"预计鉴定完成时间：明日10:00前";
        label.hidden = YES;
        _finishTimeLbl = label;
    }
    return _finishTimeLbl;
}

- (UILabel *)priceLbl{
    if (!_priceLbl) {
        UILabel *label = [UILabel new];
        _priceLbl = label;
    }
    return _priceLbl;
}


- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_up_fast"];
        _titleImageView = view;
    }
    return _titleImageView;
}

- (UIImageView *)sub1ImageView{
    if (!_sub1ImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_up_shandian"];
        _sub1ImageView = view;
    }
    return _sub1ImageView;
}
- (UIImageView *)sub2ImageView{
    if (!_sub2ImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_up_dunpai"];
        _sub2ImageView = view;
    }
    return _sub2ImageView;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _lineView = view;
    }
    return _lineView;
}

- (UIView *)youHuiQuanView{
    if (!_youHuiQuanView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.redColor;
        view.layer.cornerRadius = 8;
        view.hidden = YES;
        YYLabel *label = [YYLabel new];
        label.font = JHFont(11);
        label.textColor = HEXCOLOR(0xffffff);
        label.text = @"";
        label.textContainerInset = UIEdgeInsetsMake(0, 5, 0, 5);
        self.youHuiLbl = label;
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        _youHuiQuanView = view;
    }
    return _youHuiQuanView;
}
@end
