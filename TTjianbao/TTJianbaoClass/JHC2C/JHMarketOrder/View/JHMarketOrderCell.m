//
//  JHMarketOrderCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketOrderCell.h"
#import "JHMarketOrderButtonsView.h"
#import "JHMarketOrderModel.h"

@interface JHMarketOrderCell()
/** 背景色视图*/
@property (nonatomic, strong) UIView *backView;
/** 标签*/
@property (nonatomic, strong) UILabel *tagLabel;
/** 头像*/
@property (nonatomic, strong) UIImageView *iconImageView;
/** 名字*/
@property (nonatomic, strong) UILabel *nameLabel;
/** 状态*/
@property (nonatomic, strong) UILabel *statusLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
/** 图片*/
@property (nonatomic, strong) UIImageView *productImageView;
/** 标题*/
@property (nonatomic, strong) UILabel *productTitleLabel;
/** 时间*/
@property (nonatomic, strong) UILabel *timeLabel;
/** 价格*/
@property (nonatomic, strong) UILabel *priceLabel;
/** 按钮区域*/
@property (nonatomic, strong) JHMarketOrderButtonsView *buttonsView;
/** 提示框*/
@property (nonatomic, strong) UIImageView *alertImageView;
@end

@implementation JHMarketOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXCOLOR(0xf5f5f8);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)setIsBuyer:(BOOL)isBuyer {
    _isBuyer = isBuyer;
    self.buttonsView.isBuyer = isBuyer;
}

- (void)setModel:(JHMarketOrderModel *)model {
    _model = model;
    self.buttonsView.orderModel = model;
    if (model.buttonsVo.addExpressNoBtnFlag) {
        self.alertImageView.hidden = NO;
    } else {
        self.alertImageView.hidden = YES;
    }
    
    switch (model.marketOrderCategory.integerValue) {
        case 1:
            self.tagLabel.text = @"一口价";
            break;
        case 2:
            self.tagLabel.text = @"拍卖";
            break;
        case 3:
            self.tagLabel.text = @"鉴定服务";
            break;
        case 4:
            self.tagLabel.text = @"鉴定服务";
            break;
        case 5:
            self.tagLabel.text = @"保证金";
            break;
            
        default:
            self.tagLabel.text = @"";
            break;
    }
    
    [self.iconImageView jh_setAvatorWithUrl:model.customerImg.small];
    self.nameLabel.text = model.customerName;
    [self.productImageView jh_setImageWithUrl:model.goodsUrl.small];
    self.productTitleLabel.text = model.goodsName;
//    self.productTitleLabel.text = @"黑乎乎的返回数据粉红色的借款方式发动机上课返回到数据库粉红色的福建省电话费数据返回四大皆空发顺丰大开杀戒返回数据佛挡杀佛";
    self.statusLabel.text = model.orderStatusText;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.originOrderPrice];
    self.timeLabel.text = model.orderCreateTime;
}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.tagLabel];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.statusLabel];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.productImageView];
    [self.backView addSubview:self.productTitleLabel];
    [self.backView addSubview:self.timeLabel];
    [self.backView addSubview:self.priceLabel];
    [self.backView addSubview:self.buttonsView];
    [self.backView addSubview:self.alertImageView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(10);
        make.left.mas_equalTo(self.backView).offset(10);
        make.width.mas_equalTo(38);
        make.height.mas_equalTo(16);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagLabel.mas_right).offset(10);
        make.centerY.mas_equalTo(self.tagLabel);
        make.width.height.mas_equalTo(16);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(5);
        make.centerY.mas_equalTo(self.tagLabel);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.backView).offset(-10);
        make.centerY.mas_equalTo(self.tagLabel);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView).offset(10);
        make.right.mas_equalTo(self.backView);
        make.top.mas_equalTo(self.tagLabel.mas_bottom).offset(10);
        make.height.mas_offset(1);
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.lineView).offset(10);
        make.left.mas_equalTo(self.backView).offset(10);
        make.width.height.mas_equalTo(75);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.productImageView);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.productTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.priceLabel.mas_left).offset(-10);
    }];

    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.productImageView);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
    }];
    
    [self.buttonsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.left.mas_equalTo(self.backView).offset(10);
        make.height.mas_equalTo(30);
        make.bottom.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.alertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.buttonsView.mas_top);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(196, 59));
    }];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEXCOLOR(0xffffff);
        _backView.layer.cornerRadius = 8;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UILabel *)tagLabel {
    if (_tagLabel == nil) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = HEXCOLOR(0xfc4200);
        _tagLabel.font = [UIFont fontWithName:kFontNormal size:10];
        _tagLabel.text = @"拍卖";
        _tagLabel.layer.cornerRadius = 2;
        _tagLabel.layer.borderWidth = 0.5;
        _tagLabel.layer.borderColor = HEXCOLOR(0xfc4200).CGColor;
        _tagLabel.clipsToBounds = YES;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = kDefaultAvatarImage;
        _iconImageView.layer.cornerRadius = 8;
        _iconImageView.clipsToBounds = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = HEXCOLOR(0x333333);
        _nameLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _nameLabel.text = @"名字";
    }
    return _nameLabel;
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = HEXCOLOR(0xff4200);
        _statusLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _statusLabel.text = @"待买家付款";
    }
    return _statusLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xf5f6fa);
    }
    return _lineView;
}

- (UIImageView *)productImageView {
    if (_productImageView == nil) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.image = kDefaultCoverImage;
        _productImageView.layer.cornerRadius = 4;
        _productImageView.clipsToBounds = YES;
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _productImageView;
}

- (UILabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x999999);
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _timeLabel.text = @"";
    }
    return _timeLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEXCOLOR(0x333333);
        _priceLabel.font = [UIFont fontWithName:kFontNormal size:20];
        _priceLabel.text = @"";
        _priceLabel.textAlignment = NSTextAlignmentRight;
        [_priceLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _priceLabel;
}

- (UILabel *)productTitleLabel {
    if (_productTitleLabel == nil) {
        _productTitleLabel = [[UILabel alloc] init];
        _productTitleLabel.textColor = HEXCOLOR(0x333333);
        _productTitleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _productTitleLabel.text = @"";
        _productTitleLabel.numberOfLines = 2;
    }
    return _productTitleLabel;
}

- (JHMarketOrderButtonsView *)buttonsView {
    if (_buttonsView == nil) {
        _buttonsView = [[JHMarketOrderButtonsView alloc] init];
        @weakify(self);
        _buttonsView.reloadDataBlock = ^(BOOL iSdelete) {
            @strongify(self);
            if (self.reloadCellDataBlock) {
                self.reloadCellDataBlock(iSdelete);
            }
        };
        
        _buttonsView.payButtonClick = ^{
            @strongify(self);
            if (self.payButtonClick) {
                self.payButtonClick();
            }
        };
    }
    return _buttonsView;
}

- (UIImageView *)alertImageView{
    if (_alertImageView == nil) {
        _alertImageView = [[UIImageView alloc] init];
        _alertImageView.image = [UIImage imageNamed:@"c2c_market_alert_back"];
        
        UILabel *alertLabel = [[UILabel alloc] init];
        alertLabel.text = @"实际发货后，请填写物流单号，否则交易后钱款没法到账";
        alertLabel.textColor = HEXCOLOR(0x333333);
        alertLabel.font = [UIFont fontWithName:kFontNormal size:11];
        alertLabel.numberOfLines = 2;
        [_alertImageView addSubview:alertLabel];
        [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_alertImageView).offset(10);
            make.left.mas_equalTo(_alertImageView).offset(10);
            make.right.mas_equalTo(_alertImageView).offset(-10);
        }];
        _alertImageView.hidden = YES;
    }
    return _alertImageView;
}


@end

