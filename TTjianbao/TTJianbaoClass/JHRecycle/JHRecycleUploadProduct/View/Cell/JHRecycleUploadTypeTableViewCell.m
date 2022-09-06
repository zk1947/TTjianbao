//
//  JHRecycleUploadTypeTableViewCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleUploadTypeTableViewCell.h"

@interface JHRecycleUploadTypeTableViewCell()

/// 底部圆角白色view
@property(nonatomic, strong) UIView * backView;

/// 左侧商品icon
@property(nonatomic, strong) UIImageView * iconImageView;

/// title
@property(nonatomic, strong) UILabel * nameLbl;

/// 右侧箭头icon
@property(nonatomic, strong) UIImageView * arrowIconImageView;


@end

@implementation JHRecycleUploadTypeTableViewCell

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
    self.contentView.backgroundColor = HEXCOLOR(0xF5F5F5);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.nameLbl];
    [self.backView addSubview:self.arrowIconImageView];

}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0).offset(12);
        make.right.equalTo(@0).offset(-12);
        make.bottom.equalTo(@9).offset(-9);
    }];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@0).offset(15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
    }];
    [self.arrowIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@0).offset(-15);
        make.size.mas_equalTo(CGSizeMake(7, 10));
    }];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.layer.cornerRadius = 5;
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        UIImageView *view = [UIImageView new];
        _iconImageView = view;
    }
    return _iconImageView;
}

- (UIImageView *)arrowIconImageView{
    if (!_arrowIconImageView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_arrow"]];
        _arrowIconImageView = view;
    }
    return _arrowIconImageView;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(14);
        label.textColor = HEXCOLOR(0x222222);
        _nameLbl = label;
    }
    return _nameLbl;
}

@end
