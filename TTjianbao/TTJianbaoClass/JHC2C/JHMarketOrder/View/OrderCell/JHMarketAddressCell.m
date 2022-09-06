//
//  JHMarketAddressCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketAddressCell.h"
#import "JHMarketOrderModel.h"
@interface JHMarketAddressCell()
/** 背景色视图*/
@property (nonatomic, strong) UIView *backView;
/** logo*/
@property (nonatomic, strong) UIImageView *addressImageView;
/** 名字*/
@property (nonatomic, strong) UILabel *nameLabel;
/** 地址*/
@property (nonatomic, strong) UILabel *addressLabel;
/** 条形*/
@property (nonatomic, strong) UIImageView *lineImageView;
@end

@implementation JHMarketAddressCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXCOLOR(0xf5f6fa);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHMarketOrderModel *)model {
    _model = model;
    if (!model) {
        return;
    }
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", NONNULL_STR(model.shippingPerson), NONNULL_STR(model.shippingPhone)];
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", NONNULL_STR(model.shippingProvince), NONNULL_STR(model.shippingCity), NONNULL_STR(model.shippingCounty), NONNULL_STR(model.shippingAddress)];
}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.lineImageView];
    [self.backView addSubview:self.addressImageView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.addressLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.backView);
        make.left.mas_equalTo(self.backView);
        make.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(4);
    }];
    
    [self.addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView);
        make.left.mas_equalTo(self.backView).offset(13);
        make.width.mas_equalTo(16);
        make.bottom.mas_equalTo(self.lineImageView.mas_top);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addressImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.backView.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.addressImageView.mas_centerY).offset(-2);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.addressImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.backView.mas_right).offset(-10);
        make.top.mas_equalTo(self.addressImageView.mas_centerY).offset(2);
        make.bottom.mas_equalTo(self.lineImageView.mas_top).offset(-10);
    }];
    
    
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEXCOLOR(0xffffff);
        _backView.layer.cornerRadius = 5;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)addressImageView {
    if (_addressImageView == nil) {
        _addressImageView = [[UIImageView alloc] init];
        _addressImageView.image = [UIImage imageNamed:@"order_confirm_location_logo"];
        _addressImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _addressImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0x333333);
        _nameLabel.font = [UIFont fontWithName:kFontNormal size:14];
        _nameLabel.text = @"";
    }
    return _nameLabel;
}

- (UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.textColor = HEXCOLOR(0x333333);
        _addressLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _addressLabel.text = @"";
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

- (UIImageView *)lineImageView {
    if (_lineImageView ==nil) {
        _lineImageView = [[UIImageView alloc] init];
        _lineImageView.image = [UIImage imageNamed:@"order_confirm_fenline"];
    }
    return _lineImageView;
}

@end
