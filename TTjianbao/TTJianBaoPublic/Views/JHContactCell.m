//
//  JHContactCell.m
//  TTjianbao
//
//  Created by YJ on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHContactCell.h"
#import "TTJianBaoColor.h"
#import "UIImageView+WebCache.h"

#define HEADER_WIDHT   40

@interface JHContactCell ()

@property (strong, nonatomic) UIImageView *headerImageView;
@property (strong, nonatomic) UILabel *nameLabel;

@end

@implementation JHContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIView *lineView = [[UIView alloc] init];
        lineView.backgroundColor = LINE_COLOR;
        [self.contentView addSubview:lineView];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.bottom.offset(0);
            make.left.offset(15 + HEADER_WIDHT + 10);
            make.right.offset(0);
            make.height.mas_equalTo(0.5);
        }];
        
    }
    return self;
}

- (void)setModel:(JHContactUserInfoModel *)model
{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:kDefaultAvatarImage];
    self.nameLabel.text = model.name;
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView)
    {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.layer.backgroundColor = USELECTED_COLOR.CGColor;
        _headerImageView.layer.cornerRadius = HEADER_WIDHT/2;
        _headerImageView.clipsToBounds = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_headerImageView];
        
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.offset(15);
            make.centerY.equalTo(self);
            make.width.mas_equalTo(HEADER_WIDHT);
            make.height.mas_equalTo(HEADER_WIDHT);
        }];
    }
    return _headerImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = B_COLOR;
        _nameLabel.font = [UIFont fontWithName:kFontNormal size:16];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make)
        {
            make.left.mas_equalTo(self.headerImageView.mas_right).offset(10);
            make.right.offset(-15);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(HEADER_WIDHT);
        }];
    }
    return _nameLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
