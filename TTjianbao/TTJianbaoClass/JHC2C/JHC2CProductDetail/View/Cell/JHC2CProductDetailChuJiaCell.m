//
//  JHC2CProductDetailChuJiaCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailChuJiaCell.h"


@interface JHC2CProductDetailChuJiaCell()

@property(nonatomic, strong) UIView * backView;
@property(nonatomic, strong) UIView * lineView;
@end

@implementation JHC2CProductDetailChuJiaCell

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

- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.nameLbl];
    [self.backView addSubview:self.priceLbl];
    [self.backView addSubview:self.timeLbl];
    
}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.right.equalTo(@0).inset(12);
        make.height.mas_equalTo(0.5);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0).offset(12);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(self.iconImageView.mas_right).offset(6);
        make.width.mas_lessThanOrEqualTo(60);
    }];
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@0).offset(-12);
    }];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
    }];
}

- (void)setIndexRow:(NSInteger)indexRow{
    _indexRow = indexRow;
    if (indexRow == 0) {
        self.nameLbl.textColor = HEXCOLOR(0xF23730);
        self.priceLbl.textColor = HEXCOLOR(0xF23730);
        self.timeLbl.textColor = HEXCOLOR(0xF23730);

    }else if(indexRow == 1){
        self.nameLbl.textColor = HEXCOLOR(0x999999);
        self.priceLbl.textColor = HEXCOLOR(0x999999);
        self.timeLbl.textColor = HEXCOLOR(0x999999);

    }else{
        self.nameLbl.textColor = HEXCOLOR(0x999999);
        self.priceLbl.textColor = HEXCOLOR(0x999999);
        self.timeLbl.textColor = HEXCOLOR(0x999999);

    }
}

#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}
- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.text = @"产品经理";
        label.textColor = HEXCOLOR(0x999999);
        _nameLbl = label;
    }
    return _nameLbl;
}

- (UILabel *)priceLbl{
    if (!_priceLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(12);
        label.text = @"成交 ¥1378";
        label.textColor = HEXCOLOR(0x333333);
        _priceLbl = label;
    }
    return _priceLbl;
}

- (UILabel *)timeLbl{
    if (!_timeLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.text = @"2020-10-10 10:29";
        label.textColor = HEXCOLOR(0x999999);
        _timeLbl = label;
    }
    return _timeLbl;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        view.layer.cornerRadius = 15;
        view.layer.masksToBounds = YES;
        _iconImageView = view;
    }
    return _iconImageView;
}

- (UIView *)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = HEXCOLOR(0xF0F0F0);
        _lineView = view;
    }
    return _lineView;
}
@end

