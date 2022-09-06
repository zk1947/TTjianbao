//
//  JHHonnerCerDetailInfoTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHonnerCerDetailInfoTableViewCell.h"
#import "UILabel+TextAlignment.h"

@interface JHHonnerCerDetailInfoTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation JHHonnerCerDetailInfoTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _titleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 75.f, 21.f)];
    _titleLabel.textColor     = HEXCOLOR(0x333333);
    _titleLabel.font          = [UIFont fontWithName:kFontNormal size:15.f];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(75.f);
        make.height.mas_equalTo(21.f);
    }];

    _subTitleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 75.f, 21.f)];
    _subTitleLabel.textColor     = HEXCOLOR(0x333333);
    _subTitleLabel.font          = [UIFont fontWithName:kFontNormal size:15.f];
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.contentView.mas_top).offset(5.f);
        make.height.mas_equalTo(21.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
    }];
}

- (void)setViewModel:(NSString *)viewModel {
    self.titleLabel.text          = @"奖    项：";
    [self.titleLabel changeAlignmentBothSides];
    self.subTitleLabel.text = NONNULL_STR(viewModel);
}

@end
