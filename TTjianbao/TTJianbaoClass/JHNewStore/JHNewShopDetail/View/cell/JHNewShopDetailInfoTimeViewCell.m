//
//  JHNewShopDetailInfoTimeViewCell.m
//  TTjianbao
//
//  Created by user on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopDetailInfoTimeViewCell.h"
#import "JHNewShopDetailInfoModel.h"

@interface JHNewShopDetailInfoTimeViewCell ()
@property (nonatomic, strong) UILabel     *titleNameLabel;
@property (nonatomic, strong) UILabel     *openShopTimeLabel;
@property (nonatomic, strong) UIButton    *shopQualificationBtn;
@property (nonatomic, strong) UIImageView *logoImageView;
@end

@implementation JHNewShopDetailInfoTimeViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.contentView.layer.cornerRadius = 6.f;
    self.contentView.layer.masksToBounds = YES;
    self.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.layer.cornerRadius = 6.f;
    self.layer.masksToBounds = YES;

    _titleNameLabel           = [[UILabel alloc] init];
    _titleNameLabel.textColor = kColor222;
    _titleNameLabel.font      = [UIFont fontWithName:kFontMedium size:16.f];
    _titleNameLabel.text      = @"店铺认证信息";
    [self.contentView addSubview:_titleNameLabel];
    [_titleNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(10.f);
        make.height.mas_equalTo(22.f);
    }];
    
    _openShopTimeLabel           = [[UILabel alloc] init];
    _openShopTimeLabel.textColor = kColor222;
    _openShopTimeLabel.font      = [UIFont fontWithName:kFontNormal size:14.f];
//    _openShopTimeLabel.text      = @"开店时间：2019年3月";
    [self.contentView addSubview:_openShopTimeLabel];
    [_openShopTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleNameLabel.mas_left);
        make.top.equalTo(self.titleNameLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(20.f);
    }];
    
    _shopQualificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shopQualificationBtn setTitle:@"商家资质 >" forState:UIControlStateNormal];
    [_shopQualificationBtn setTitleColor:HEXCOLOR(0x2F66A0) forState:UIControlStateNormal];
    _shopQualificationBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
    [_shopQualificationBtn addTarget:self action:@selector(_shopQualificationBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shopQualificationBtn];
    [_shopQualificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleNameLabel.mas_left);
        make.top.equalTo(self.openShopTimeLabel.mas_bottom).offset(10.f);
        make.height.mas_equalTo(20.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10.f);
    }];
    
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.image = [UIImage imageNamed:@"newStore_shopDetail_infoLogo"];
    [self.contentView addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(self.contentView);
        make.width.height.mas_equalTo(63.f);
    }];
}

- (void)_shopQualificationBtnAction:(UIButton *)btn {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)setShopHeaderInfoModel:(JHNewShopDetailInfoModel *)shopHeaderInfoModel {
    _shopHeaderInfoModel = shopHeaderInfoModel;
//    _openShopTimeLabel.text = @"开店时间：2019年3月";
        _openShopTimeLabel.text = [NSString stringWithFormat:@"开店时间：%@",NONNULL_STR(shopHeaderInfoModel.openTime)];

}

@end
