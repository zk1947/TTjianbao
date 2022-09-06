//
//  JHMarketDetailCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketDetailCell.h"
#import "JHMarketOrderModel.h"
#import "UIImage+JHWebImage.h"
#import "JHWebViewController.h"
@interface JHMarketDetailCell()
/** 背景色视图*/
@property (nonatomic, strong) UIView *backView;
/** 标签*/
@property (nonatomic, strong) UILabel *tagLabel;
/** 头像*/
@property (nonatomic, strong) UIImageView *iconImageView;
/** 名字*/
@property (nonatomic, strong) UILabel *nameLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
/** 图片*/
@property (nonatomic, strong) UIImageView *productImageView;
/** 标题*/
@property (nonatomic, strong) UILabel *productTitleLabel;
/** 真品*/
@property (nonatomic, strong) UIImageView *appraisalImageView;
/** 查看报告*/
@property (nonatomic, strong) UIButton *reportButton;
@end
@implementation JHMarketDetailCell

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
    switch (self.model.marketOrderCategory.integerValue) {
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
            break;
    }
    
    switch (self.model.appraisalResult.integerValue) {
        case 0:
            self.appraisalImageView.image = [UIImage imageNamed:@"c2c_class_apprise_q_true"];
            break;
        case 1:
            self.appraisalImageView.image = [UIImage imageNamed:@"c2c_class_apprise_q_false"];
            break;
        case 2:
            self.appraisalImageView.image = [UIImage imageNamed:@"c2c_class_apprise_q_question"];
            break;
        case 3:
            self.appraisalImageView.image = [UIImage imageNamed:@"c2c_class_apprise_q_art"];
            break;
        default:
            self.appraisalImageView.image = [UIImage imageNamed:@""];
            break;
    }
    
    if (self.model.appraisalResult.integerValue < 4) {
        self.reportButton.hidden = NO;
    } else {
        self.reportButton.hidden = YES;
    }
    
    
    
    [self.iconImageView jh_setAvatorWithUrl:self.model.customerImg.small];
    self.nameLabel.text = self.model.customerName;
    [self.productImageView jh_setImageWithUrl:self.model.goodsUrl.small];
    self.productTitleLabel.text = self.model.goodsName;
}

//查看报告
- (void)seeAppriseCer {
    NSString *customerId = self.isBuyer ? self.model.customerId : [UserInfoRequestManager sharedInstance].user.customerId;
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/report/reportGraphic.html?customerId=%@&productSn=%@"), customerId, self.model.goodsCode];
    [self.viewController.navigationController pushViewController:webView animated:YES];}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.tagLabel];
    [self.backView addSubview:self.iconImageView];
    [self.backView addSubview:self.nameLabel];
    [self.backView addSubview:self.lineView];
    [self.backView addSubview:self.productImageView];
    [self.backView addSubview:self.productTitleLabel];
    [self.backView addSubview:self.appraisalImageView];
    [self.backView addSubview:self.reportButton];
    
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
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-10);
    }];
    
    [self.productTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.backView.mas_right).offset(-10);
    }];

    [self.appraisalImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.productImageView);
        make.right.mas_equalTo(self.backView.mas_right).offset(-10);
        make.width.height.mas_equalTo(55);
    }];
    
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.bottom.mas_equalTo(self.productImageView);
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
        _tagLabel.text = @"";
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
        _nameLabel.text = @"";
    }
    return _nameLabel;
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

- (UIImageView *)appraisalImageView {
    if (_appraisalImageView == nil) {
        _appraisalImageView = [[UIImageView alloc] init];
        _appraisalImageView.image = kDefaultAvatarImage;
    }
    return _appraisalImageView;
}

- (UIButton *)reportButton {
    if (_reportButton == nil) {
        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportButton setTitle:@"查看报告" forState:UIControlStateNormal];
        [_reportButton setTitleColor:HEXCOLOR(0x408ffe) forState:UIControlStateNormal];
        _reportButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_reportButton addTarget:self action:@selector(seeAppriseCer) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}

@end
