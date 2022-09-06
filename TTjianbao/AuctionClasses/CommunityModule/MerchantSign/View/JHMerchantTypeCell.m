//
//  JHMerchantTypeCell.m
//  TTjianbao
//
//  Created by apple on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHMerchantTypeCell.h"
#import "JHMerchantTypeModel.h"

@interface JHMerchantTypeCell ()

@property (nonatomic, strong) UIView *maskBackGroundView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation JHMerchantTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xF5F6FA);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _cellStyle = JHMerchantTypeCellStyleNone;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    _maskBackGroundView = bgView;
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@""];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont fontWithName:kFontNormal size:18];
    _titleLabel.text = @"";
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.font = [UIFont fontWithName:kFontNormal size:12];
    _detailLabel.numberOfLines = 0;
    _detailLabel.textColor = HEXCOLOR(0x999999);
    _detailLabel.text = @"";
    
    UIImageView *rowImageView = [[UIImageView alloc] init];
    rowImageView.image = [UIImage imageNamed:@"icon_sign_back"];
    
    [self.contentView addSubview:_maskBackGroundView];
    [_maskBackGroundView addSubview:_iconImageView];
    [_maskBackGroundView addSubview:_titleLabel];
    [_maskBackGroundView addSubview:_detailLabel];
    [_maskBackGroundView addSubview:rowImageView];

    [_maskBackGroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
        make.top.equalTo(self.contentView).with.offset(11);
        make.bottom.equalTo(self.contentView).with.offset(0);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maskBackGroundView).with.offset(18);
        make.width.height.equalTo(@40);
        make.centerY.equalTo(self.contentView);
    }];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).with.offset(11.5);
        make.bottom.equalTo(self.iconImageView.mas_centerY);
        make.height.equalTo(@21);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.contentView).offset(-50);
        make.top.equalTo(self.iconImageView.mas_centerY);
    }];
    
    [rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.maskBackGroundView.mas_right).with.offset(-7);
        make.width.equalTo(@9);
        make.height.equalTo(@15);
        make.centerY.equalTo(self.iconImageView.mas_centerY);
    }];
    
    ///为背景切圆角
    [self layoutIfNeeded];
    _maskBackGroundView.layer.cornerRadius = 4.f;
    _maskBackGroundView.layer.masksToBounds = YES;
}

#pragma mark -
#pragma mark - Setting / Getting Method

- (void)setMerchantModel:(JHMerchantTypeModel *)merchantModel {
    _merchantModel = merchantModel;
    if (!_merchantModel) {
        return;
    }
    _iconImageView.image = [UIImage imageNamed:merchantModel.imgName];
    _titleLabel.text = _merchantModel.titleText;
    _detailLabel.text = _merchantModel.detailDescription;
}

- (void)setIcon:(NSString *)icon {
    _icon = icon;
    _iconImageView.image = [UIImage imageNamed:_icon];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = _title;
}

- (void)setDesc:(NSString *)desc {
    _desc = desc;
    _detailLabel.text = _desc;
}

- (void)setCellStyle:(JHMerchantTypeCellStyle)cellStyle {
    _cellStyle = cellStyle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (_cellStyle == JHMerchantTypeCellStyleNone) {
        return;
    }
    if (selected) {
        self.maskBackGroundView.backgroundColor = HEXCOLORA(0xFEE100, 0.2f);
        self.maskBackGroundView.layer.borderWidth = 1.f;
        self.maskBackGroundView.layer.borderColor = [HEXCOLOR(0xFEE100) CGColor];
    }
    else {
        self.maskBackGroundView.backgroundColor = [UIColor whiteColor];
        self.maskBackGroundView.layer.borderWidth = 1.f;
        self.maskBackGroundView.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}

@end
