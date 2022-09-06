//
//  JHRecycleGoodsDetailInfoTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoodsDetailInfoTableViewCell.h"
#import "JHRecycleGoodsInfoViewModel.h"

@interface JHRecycleGoodsDetailInfoTableViewCell ()
@property (nonatomic, strong) UILabel     *statusLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *userNameLabel;
@property (nonatomic, strong) UILabel     *goodNameLabel;
@end

@implementation JHRecycleGoodsDetailInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
    self.backgroundColor = HEXCOLOR(0xffffff);
    /// 状态
    _statusLabel               = [[UILabel alloc] init];
    _statusLabel.textColor     = HEXCOLOR(0xFFFFFF);
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.font          = [UIFont fontWithName:kFontNormal size:16.f];
    _statusLabel.backgroundColor = HEXCOLOR(0xF23730);
    [self.contentView addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(41.f);
    }];
    
    /// 名称
    _goodNameLabel               = [[UILabel alloc] init];
    _goodNameLabel.textColor     = HEXCOLOR(0x333333);
    _goodNameLabel.textAlignment = NSTextAlignmentLeft;
    _goodNameLabel.font          = [UIFont fontWithName:kFontBoldDIN size:14.f];
    [self.contentView addSubview:_goodNameLabel];
    [_goodNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusLabel.mas_bottom).offset(10.f);
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.height.mas_equalTo(24.f);
    }];
    
    /// 头像
    _iconImageView = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    _iconImageView.layer.cornerRadius  = 16.f;
    _iconImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodNameLabel.mas_bottom).offset(10.f);
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.width.height.mas_equalTo(32.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12.f);
    }];
    
    
    /// 用户名称
    _userNameLabel               = [[UILabel alloc] init];
    _userNameLabel.textColor     = HEXCOLOR(0x222222);
    _userNameLabel.textAlignment = NSTextAlignmentLeft;
    _userNameLabel.font          = [UIFont fontWithName:kFontMedium size:14.f];
    _userNameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.contentView addSubview:_userNameLabel];
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(8.f);
        make.height.mas_equalTo(20.f);
    }];
}
 
- (void)setViewModel:(id)viewModel {
    JHRecycleGoodsInfoShowViewModel *infoViewModel = viewModel;
    if (!isEmpty(infoViewModel.productPrice)) {
        self.statusLabel.text = infoViewModel.productPrice;
        [self.statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(41.f);
        }];
    } else {
        self.statusLabel.text = @"";
        [self.statusLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0.f);
        }];
    }
    
    if (!isEmpty(infoViewModel.productName)) {
        self.goodNameLabel.text = infoViewModel.productName;
        [self.goodNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusLabel.mas_bottom).offset(10.f);
            make.height.mas_equalTo(24.f);
        }];
    } else {
        self.goodNameLabel.text = @"";
        [self.goodNameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.statusLabel.mas_bottom).offset(0.f);
            make.height.mas_equalTo(0.f);
        }];
    }
    
    if (!isEmpty(infoViewModel.customerImg)) {
        [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:infoViewModel.customerImg] placeholder:kDefaultAvatarImage];
    }
    
    if (!isEmpty(infoViewModel.customerName)) {
        self.userNameLabel.text = infoViewModel.customerName;
    } else {
        self.userNameLabel.text = @"";
    }
}

@end
