//
//  JHC2CProductDetailDaiJianDingCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailDaiJianDingCell.h"
#import "UIButton+ImageTitleSpacing.h"


@interface JHC2CProductDetailDaiJianDingCell()

@property(nonatomic, strong) UIImageView * backImageView;

@property(nonatomic, strong) UILabel * titleLbl;
@property(nonatomic, strong) UILabel * sub1Lbl;
@property(nonatomic, strong) UILabel * sub2Lbl;
@property(nonatomic, strong) UILabel * sub3Lbl;

@property(nonatomic, strong) UIImageView * titleImageView;
@property(nonatomic, strong) UIImageView * sub1ImageView;
@property(nonatomic, strong) UIImageView * sub2ImageView;
@property(nonatomic, strong) UIImageView * sub3ImageView;

@end

@implementation JHC2CProductDetailDaiJianDingCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self setItems];
        [self layoutItems];
    }
    return self;
}

    
- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backImageView];
    
    [self.backImageView addSubview:self.jianDingBtn];
    [self.backImageView addSubview:self.titleLbl];
    [self.backImageView addSubview:self.sub1Lbl];
    [self.backImageView addSubview:self.sub2Lbl];
    [self.backImageView addSubview:self.sub3Lbl];
    
    [self.backImageView addSubview:self.titleImageView];
    [self.backImageView addSubview:self.sub1ImageView];
    [self.backImageView addSubview:self.sub2ImageView];
    [self.backImageView addSubview:self.sub3ImageView];
    
}

- (void)layoutItems{
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.bottom.equalTo(@0).offset(-15);
        make.left.right.equalTo(@0).inset(12);
    }];
    
    [self.jianDingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(@0).inset(12);
        make.size.mas_equalTo(CGSizeMake(86, 28));
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(18);
        make.left.equalTo(@0).offset(15);
    }];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.size.mas_equalTo(CGSizeMake(54, 16));
        make.left.equalTo(self.titleLbl.mas_right).offset(4);
    }];

    [self.sub1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.left.equalTo(self.titleLbl);
    }];
    [self.sub1Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sub1ImageView);
        make.left.equalTo(self.sub1ImageView.mas_right).offset(3);
    }];
    
    [self.sub2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sub1ImageView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.left.equalTo(self.titleLbl);
    }];
    [self.sub2Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sub2ImageView);
        make.left.equalTo(self.sub2ImageView.mas_right).offset(3);
    }];

    [self.sub3ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sub2ImageView.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(12, 12));
        make.left.equalTo(self.titleLbl);
    }];
    [self.sub3Lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sub3ImageView);
        make.left.equalTo(self.sub3ImageView.mas_right).offset(3);
        make.bottom.equalTo(@0).offset(-16);
    }];

}


#pragma mark -- <set and get>

- (UIImageView *)backImageView{
    if (!_backImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_pd_bg_weijingdingcell"];
        view.layer.cornerRadius = 4;
        view.layer.masksToBounds = YES;
        view.userInteractionEnabled  = YES;
        _backImageView = view;
    }
    return _backImageView;
}

- (UIButton *)jianDingBtn{
    if (!_jianDingBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"鉴定该宝贝" forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x5A3B23) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(12);
        btn.layer.cornerRadius = 4;
        btn.backgroundColor = HEXCOLOR(0xFFF4E2);
        [btn setImage:[UIImage imageNamed:@"c2c_pd_bg_smallarrow"] forState:UIControlStateNormal];
        [btn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
        _jianDingBtn = btn;
    }
    return _jianDingBtn;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHBoldFont(16);
        label.text = @"图文鉴定，先鉴定后交易";
        label.textColor = HEXCOLOR(0x333340);
        _titleLbl = label;
    }
    return _titleLbl;
}
- (UILabel *)sub1Lbl{
    if (!_sub1Lbl) {
        UILabel *label = [UILabel new];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"快速 · 48小时内出具报告，真假一目了然" attributes: @{NSFontAttributeName: JHFont(12),NSForegroundColorAttributeName: HEXCOLOR(0x333340)}];
        [string addAttributes:@{NSForegroundColorAttributeName: HEXCOLOR(0x333340)} range:NSMakeRange(0, 2)];
        [string addAttributes:@{NSFontAttributeName: JHMediumFont(12), NSForegroundColorAttributeName: HEXCOLOR(0x333340)} range:NSMakeRange(0, 1)];
        label.attributedText = string;
        _sub1Lbl = label;
    }
    return _sub1Lbl;
}
- (UILabel *)sub2Lbl{
    if (!_sub2Lbl) {
        UILabel *label = [UILabel new];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"专业 · 三方鉴定师把关，客观公正" attributes: @{NSFontAttributeName: JHFont(12),NSForegroundColorAttributeName: HEXCOLOR(0x333340)}];
        [string addAttributes:@{NSForegroundColorAttributeName: HEXCOLOR(0x333340)} range:NSMakeRange(0, 2)];
        [string addAttributes:@{NSFontAttributeName: JHMediumFont(12), NSForegroundColorAttributeName: HEXCOLOR(0x333340)} range:NSMakeRange(0, 1)];
        label.attributedText = string;
        _sub2Lbl = label;
    }
    return _sub2Lbl;
}
- (UILabel *)sub3Lbl{
    if (!_sub3Lbl) {
        UILabel *label = [UILabel new];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"放心 · 超时未鉴定，自动退款" attributes: @{NSFontAttributeName: JHFont(12),NSForegroundColorAttributeName: HEXCOLOR(0x333340)}];
        [string addAttributes:@{NSForegroundColorAttributeName: HEXCOLOR(0x333340)} range:NSMakeRange(0, 2)];
        [string addAttributes:@{NSFontAttributeName: JHMediumFont(12), NSForegroundColorAttributeName: HEXCOLOR(0x333340)} range:NSMakeRange(0, 1)];
        label.attributedText = string;
        _sub3Lbl = label;
    }
    return _sub3Lbl;
}

- (UIImageView *)titleImageView{
    if (!_titleImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_pd_zhuanjia"];
        _titleImageView = view;
    }
    return _titleImageView;
}

- (UIImageView *)sub1ImageView{
    if (!_sub1ImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_pd_duihao"];
        _sub1ImageView = view;
    }
    return _sub1ImageView;
}
- (UIImageView *)sub2ImageView{
    if (!_sub2ImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_pd_duihao"];
        _sub2ImageView = view;
    }
    return _sub2ImageView;
}
- (UIImageView *)sub3ImageView{
    if (!_sub3ImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"c2c_pd_duihao"];
        _sub3ImageView = view;
    }
    return _sub3ImageView;
}

@end
