//
//  JHGoodManagerListChooseItemCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2021/8/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListChooseItemCollectionViewCell.h"

@interface JHGoodManagerListChooseItemCollectionViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end
@implementation JHGoodManagerListChooseItemCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _titleLabel                  = [[UILabel alloc] init];
    _titleLabel.textColor        = HEXCOLOR(0x333333);
    _titleLabel.font             = [UIFont fontWithName:kFontNormal size:15.f];
    _titleLabel.textAlignment    = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(3.f);
        make.left.right.equalTo(self.contentView);
    }];

    _subTitleLabel               = [[UILabel alloc] init];
    _subTitleLabel.textColor     = HEXCOLOR(0x333333);
    _subTitleLabel.font          = [UIFont fontWithName:kFontNormal size:15.f];
    _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.right.equalTo(self.contentView);
    }];
}

- (void)setViewModel:(JHGoodManagerListTabChooseModel *)viewModel {
    self.titleLabel.text    = NONNULL_STR(viewModel.name);
    if ([viewModel.num longValue]>99999) {
        self.subTitleLabel.text = @"99999+";
    } else {
        self.subTitleLabel.text = NONNULL_STR(viewModel.num);
    }
    
    if (viewModel.isSelected) {
        self.titleLabel.font         = [UIFont fontWithName:kFontMedium size:15.f];
        self.titleLabel.textColor    = HEXCOLOR(0x333333);

        self.subTitleLabel.font      = [UIFont fontWithName:kFontBoldPingFang size:12.f];
        self.subTitleLabel.textColor = HEXCOLOR(0x333333);
    } else {
        self.titleLabel.font         = [UIFont fontWithName:kFontNormal size:15.f];
        self.titleLabel.textColor    = HEXCOLOR(0x666666);

        self.subTitleLabel.font      = [UIFont fontWithName:kFontMedium size:12.f];
        self.subTitleLabel.textColor = HEXCOLOR(0x666666);
    }
}


@end
