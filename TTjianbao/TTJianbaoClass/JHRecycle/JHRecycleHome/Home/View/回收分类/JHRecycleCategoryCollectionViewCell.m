//
//  JHRecycleCategoryCollectionViewCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/4/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleCategoryCollectionViewCell.h"
#import "JHRecycleHomeModel.h"
#import "UIView+JHGradient.h"
#import "JHAnimatedImageView.h"

@interface JHRecycleCategoryCollectionViewCell()
@property (nonatomic, strong) UIImageView         *iconImageView;
@property (nonatomic, strong) UIImageView         *logoImageView;
@property (nonatomic, strong) UILabel             *titleLabel;
@property (nonatomic, strong) UILabel             *subTitleLabel;
@property (nonatomic, strong) UIView              *lineView;
@property (nonatomic, strong) JHAnimatedImageView *animationImage;
@end

@implementation JHRecycleCategoryCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
}
#pragma mark  - 设置UI
- (void)setupUI{
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.animationImage];
    [self.contentView addSubview:self.lineView];


    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14.f);
        make.left.mas_equalTo(self.contentView.mas_left).offset(11.f);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top).offset(4.f);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(6.f);
        make.right.lessThanOrEqualTo(self.contentView.mas_right).offset(-7.f);
        make.height.mas_equalTo(21.f);
    }];
    
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(4.f);
        make.size.mas_equalTo(CGSizeMake(4.5f, 9.f));
    }];
    
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.mas_equalTo(self.iconImageView.mas_right).offset(6.f);
        make.right.equalTo(self.contentView.mas_right).offset(-1.f);
        make.height.mas_equalTo(16.f);
    }];
    
    [self.animationImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.iconImageView);
        make.height.mas_equalTo(13.f);
    }];
    
    self.lineView.hidden = YES;
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-0.25f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(37.f);
        make.width.mas_equalTo(0.5f);
    }];
}
#pragma mark  - 懒加载

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
    }
    return _iconImageView;
}

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [UIImageView new];
        _logoImageView.image = [UIImage imageNamed:@"jh_newStore_homeNavRight"];
    }
    return _logoImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEXCOLOR(0x222222);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    }
    return _titleLabel;
}


- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = HEXCOLOR(0x666666);
        _subTitleLabel.font = [UIFont fontWithName:kFontNormal size:11];
    }
    return _subTitleLabel;
}

- (JHAnimatedImageView *)animationImage {
    if (!_animationImage) {
        _animationImage   = [[JHAnimatedImageView alloc] init];
    }
    return _animationImage;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView   = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xE6E6E6);
    }
    return _lineView;
}

- (void)bindViewModel:(id)dataModel indexRow:(NSInteger)indexRow {
    NSDictionary *dict = dataModel;
    [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:dict[@"icon"]] placeholder:kDefaultNewStoreCoverImage];
    self.titleLabel.text = dict[@"title"];
    self.subTitleLabel.text = dict[@"desc"];
    [self.animationImage jh_setImageWithUrl:dict[@"iconTag"] placeholder:nil];
    if (indexRow == 0) {
        self.lineView.hidden = NO;
    } else {
        self.lineView.hidden = YES;
    }
}


@end
