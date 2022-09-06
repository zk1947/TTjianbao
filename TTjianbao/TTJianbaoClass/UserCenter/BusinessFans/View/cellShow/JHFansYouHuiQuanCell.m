//
//  JHFansYouHuiQuanCell.m
//  TTjianbao
//
//  Created by Paros on 2021/11/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansYouHuiQuanCell.h"

@interface JHFansYouHuiQuanCell()

@property(nonatomic, strong) UIView * backView;

@property(nonatomic, strong) UIImageView * iconImageView;
@property(nonatomic, strong) UILabel * leftImagePriceLbl;
@property(nonatomic, strong) UILabel * leftImageRulerLbl;

@property(nonatomic, strong) UILabel * nameLbl;
@property(nonatomic, strong) UILabel * priceLbl;
@property(nonatomic, strong) UILabel * timeLbl;

@property(nonatomic, strong) UIImageView * selIconImageView;


@end

@implementation JHFansYouHuiQuanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    self.backView.layer.borderColor = selected ? HEXCOLOR(0xFFBC39).CGColor : HEXCOLOR(0xE8E8E8).CGColor;
    self.selIconImageView.hidden = !selected;
}

- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    [self.contentView addSubview:self.iconImageView];
    [self.backView addSubview:self.nameLbl];
    [self.backView addSubview:self.priceLbl];
    [self.backView addSubview:self.timeLbl];
    [self.backView addSubview:self.selIconImageView];

    [self.iconImageView addSubview:self.leftImagePriceLbl];
    [self.iconImageView addSubview:self.leftImageRulerLbl];
    
}
- (void)setModel:(JHFansCoupouModel *)model{
    _model = model;
    self.nameLbl.text = model.couponName;
    NSString *left = nil;
    NSString *bottom = nil;

    if ([model.ruleType isEqualToString:@"OD"]) {
        left = [NSString stringWithFormat:@"%ld折", model.price.integerValue];
        bottom = [NSString stringWithFormat:@"满%ld可用", model.ruleFrCondition.integerValue];

    }else if([model.ruleType isEqualToString:@"FR"]){
        left = [NSString stringWithFormat:@"￥%ld", model.price.integerValue];
        bottom = [NSString stringWithFormat:@"满%ld可用", model.ruleFrCondition.integerValue];

    }else{
        left = [NSString stringWithFormat:@"￥%ld", model.price.integerValue];
        bottom = [NSString stringWithFormat:@"每满%ld可用", model.ruleFrCondition.integerValue];
    }
    
    
    self.leftImagePriceLbl.text = left;
    self.leftImageRulerLbl.text = bottom;
    self.priceLbl.text = [NSString stringWithFormat:@"券ID：%@", model.couponId];
    self.timeLbl.text = model.effectiveTime.length ? model.effectiveTime : @"有效期至:";

}
- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.right.equalTo(@0).inset(25);
        make.bottom.equalTo(@0).offset(-10);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView).offset(-4);
        make.top.bottom.equalTo(self.backView);
        make.width.mas_equalTo(105.f);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(7);
        make.left.equalTo(@112);
        make.right.equalTo(@0).offset(-10);
    }];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl.mas_bottom).offset(7);
        make.left.equalTo(self.nameLbl);
        make.right.equalTo(@0).offset(-12);
    }];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0).offset(-7);
        make.left.equalTo(self.nameLbl);
        make.right.equalTo(@0).offset(-12);
    }];
    [self.selIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self.backView);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    
    [self.leftImagePriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.equalTo(@0).offset(20);
    }];
    [self.leftImageRulerLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftImagePriceLbl.mas_bottom);
        make.centerX.equalTo(@0);
    }];
}

#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        view.layer.cornerRadius = 5;
        view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.03].CGColor;
        view.layer.shadowOffset = CGSizeMake(0,2);
        view.layer.shadowOpacity = 1;
        view.layer.shadowRadius = 7;
        view.layer.borderWidth = 0.5;
        view.layer.borderColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0].CGColor;

        _backView = view;
    }
    return _backView;
}
- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(13);
        label.text = @"券名称券名称券名称";
        label.textColor = HEXCOLOR(0x333333);
        _nameLbl = label;
    }
    return _nameLbl;
}

- (UILabel *)priceLbl{
    if (!_priceLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(11);
        label.text = @"券ID：53097";
        label.textColor = HEXCOLOR(0x999999);
        _priceLbl = label;
    }
    return _priceLbl;
}

- (UILabel *)leftImagePriceLbl{
    if (!_leftImagePriceLbl) {
        UILabel *label = [UILabel new];
        label.font = JHBoldFont(23);
        label.text = @"9折";
        label.textColor = HEXCOLOR(0xffffff);
        _leftImagePriceLbl = label;
    }
    return _leftImagePriceLbl;
}

- (UILabel *)leftImageRulerLbl{
    if (!_leftImageRulerLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(10);
        label.text = @"满5000可用";
        label.textColor = HEXCOLOR(0xffffff);
        _leftImageRulerLbl = label;
    }
    return _leftImageRulerLbl;
}

- (UILabel *)timeLbl{
    if (!_timeLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(11);
        label.text = @"有效期至:2021.10.09";
        label.textColor = HEXCOLOR(0x999999);
        _timeLbl = label;
    }
    return _timeLbl;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"fans_leftback"];
        _iconImageView = view;
    }
    return _iconImageView;
}

- (UIImageView *)selIconImageView{
    if (!_selIconImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"fans_sel"];
        _selIconImageView = view;
        view.hidden = YES;
    }
    return _selIconImageView;
}



@end

