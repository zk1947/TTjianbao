//
//  JHBusinessCollegeTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/5/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessCollegeTableViewCell.h"

@interface JHBusinessCollegeTableViewCell ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIImageView *rightImageView;
@end

@implementation JHBusinessCollegeTableViewCell

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
    self.contentView.layer.cornerRadius = 5.f;
    self.contentView.layer.masksToBounds = YES;
    self.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.layer.cornerRadius = 5.f;
    self.layer.masksToBounds = YES;
    
    _iconImageView = [UIImageView jh_imageViewWithImage:@"xxxxx" addToSuperview:self.contentView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.size.mas_equalTo(CGSizeMake(50., 50.));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = kColor222;
    _nameLabel.font = [UIFont fontWithName:kFontNormal size:14.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(12.f);
    }];
    
    _rightImageView = [UIImageView jh_imageViewWithImage:@"icon_kind_right_arrow" addToSuperview:self.contentView];
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.size.mas_equalTo(CGSizeMake(5., 10.));
    }];
}

- (void)setViewModel:(NSString *)imageName text:(NSString *)text {
    self.iconImageView.image = [UIImage imageNamed:imageName];
    self.nameLabel.text = text;
}

@end
