//
//  JHCustomeizeLogisticsDescTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomeizeLogisticsDescTableViewCell.h"

@interface JHCustomeizeLogisticsDescTableViewCell ()
@property (nonatomic, strong) UIView      *backView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *timeLabel;
@property (nonatomic, strong) UIImageView *logoImageView;
@end

@implementation JHCustomeizeLogisticsDescTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xF5F6FA);
    self.contentView.backgroundColor = HEXCOLOR(0xF5F6FA);
    
    _backView = [[UIView alloc] init];
    _backView.backgroundColor = HEXCOLOR(0xffffff);
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f));
    }];
    
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x333333);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [_backView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(30.f);
        make.right.equalTo(self.backView.mas_right).offset(-10.f);
        make.top.equalTo(self.backView.mas_top).offset(10.f);
        make.height.mas_equalTo(21.f);
    }];
    
    _logoImageView = [[UIImageView alloc] init];
    [_backView addSubview:_logoImageView];
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.nameLabel.mas_left).offset(-15.f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(10.f, 10.f));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = HEXCOLOR(0x979797);
    [_backView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.logoImageView);
        make.top.equalTo(self.logoImageView.mas_bottom);
        make.width.mas_equalTo(1.f);
        make.bottom.equalTo(self.backView.mas_bottom);
    }];
    
    _timeLabel               = [[UILabel alloc] init];
    _timeLabel.textColor     = HEXCOLOR(0x333333);
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    _timeLabel.font          = [UIFont fontWithName:kFontNormal size:11.f];
    [_backView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5.f);
        make.left.equalTo(self.logoImageView.mas_right).offset(10.f);
        make.right.equalTo(self.backView.mas_right).offset(-10.f);
        make.height.mas_equalTo(16.f);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-5.f);
    }];
    
}

/// TODO: data
- (void)setViewModel:(id)viewModel {
    self.logoImageView.image = [UIImage imageNamed:@"customize_trransport"];
    self.nameLabel.text = @"提交申请";
    self.timeLabel.text = @"2019-09-16 17:20";
}
@end
