//
//  JHNewStoreHomeGoosTitleTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeGoosTitleTableViewCell.h"

@interface JHNewStoreHomeGoosTitleTableViewCell ()
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@end

@implementation JHNewStoreHomeGoosTitleTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    self.contentView.backgroundColor = HEXCOLOR(0xF5F5F8);

    /// 标题
    _titleLabel           = [[UILabel alloc] init];
    _titleLabel.textColor = HEXCOLOR(0xB38A50);
    _titleLabel.font      = [UIFont fontWithName:kFontNormal size:14.f];
    _titleLabel.text      = @"精选商品";
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(9.f);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.height.mas_equalTo(20.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    _leftImageView = [[UIImageView alloc] init];
    _leftImageView.image = [UIImage imageNamed:@"jh_newStore_goodsLeft"];
    [self.contentView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLabel.mas_left).offset(-10.f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.mas_equalTo(33.f);
        make.height.mas_equalTo(4.f);
    }];
    
    _rightImageView = [[UIImageView alloc] init];
    _rightImageView.image = [UIImage imageNamed:@"jh_newStore_goodsRight"];
    [self.contentView addSubview:_rightImageView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(10.f);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.mas_equalTo(33.f);
        make.height.mas_equalTo(4.f);
    }];
}






@end
