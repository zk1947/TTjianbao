//
//  JHC2CCourierCompanyTableCell.m
//  TTjianbao
//
//  Created by hao on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CCourierCompanyTableCell.h"

@interface JHC2CCourierCompanyTableCell ()
@property (nonatomic, strong) UIImageView *selIcon;

@end

@implementation JHC2CCourierCompanyTableCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selIcon];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.selIcon.mas_left).offset(-15);
    }];
    [self.selIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.right.equalTo(self).offset(-15);
    }];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.selIcon.image = [UIImage imageNamed:@"recycle_piublish_price_selected"];
    } else {
        self.selIcon.image = [UIImage imageNamed:@"recycle_piublish_price_normal"];
    }

}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        _titleLabel.text = @"快递公司";
    }
    return _titleLabel;
}
- (UIImageView *)selIcon {
    if (!_selIcon) {
        _selIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        _selIcon.image = [UIImage imageNamed:@"recycle_piublish_price_normal"];
    }
    return _selIcon;
}
@end
