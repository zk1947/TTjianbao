//
//  JHAlertTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/4/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAlertTableViewCell.h"

@interface JHAlertTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *alertLabel;

@end

@implementation JHAlertTableViewCell

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    _iconImageView.image = [UIImage imageNamed:_iconName];
}

- (void)setMessage:(NSString *)message {
    _message = message;
    _alertLabel.text = _message?:@"";
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_union_pay_alert"]];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:iconImageView];
    _iconImageView = iconImageView;
    
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.text = @"";
    alertLabel.font = [UIFont fontWithName:kFontMedium size:12];
    alertLabel.numberOfLines = 0;
    _alertLabel = alertLabel;
    [self.contentView addSubview:_alertLabel];
    
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(16);
    }];
    
    [_alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImageView.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(15);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
