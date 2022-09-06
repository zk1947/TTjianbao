//
//  JHShopInfoHeaderTableCell.m
//  TTjianbao
//
//  Created by lihui on 2021/4/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHShopInfoHeaderTableCell.h"

@interface JHShopInfoHeaderTableCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation JHShopInfoHeaderTableCell

+ (CGFloat)cellHeight {
    return 90.;
}

- (void)title:(NSString *)title desc:(NSString *)desc {
    _titleLabel.text = [title isNotBlank] ? title : @"";
    [_iconImageView jh_setImageWithUrl:desc];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xF8F8F8);
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIView *whiteView = [[UIView alloc] init];
    whiteView.backgroundColor = kColorFFF;
    [self.contentView addSubview:whiteView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"店铺头像";
    titleLabel.font = [UIFont fontWithName:kFontNormal size:16.];
    titleLabel.textColor = kColor666;
    [whiteView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:kDefaultAvatarImage];
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [whiteView addSubview:icon];
    _iconImageView = icon;
    
    UIImageView *accImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_banckCard_arrow"]];
    accImage.contentMode = UIViewContentModeScaleAspectFit;
    [whiteView addSubview:accImage];
    
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(12);
        make.centerY.equalTo(whiteView);
    }];
    
    [accImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(whiteView).offset(-12);
        make.centerY.equalTo(whiteView);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(accImage.mas_left).offset(-8);
        make.centerY.equalTo(whiteView);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self layoutIfNeeded];
    _iconImageView.layer.cornerRadius = _iconImageView.height/2;
    _iconImageView.layer.masksToBounds = YES;
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
