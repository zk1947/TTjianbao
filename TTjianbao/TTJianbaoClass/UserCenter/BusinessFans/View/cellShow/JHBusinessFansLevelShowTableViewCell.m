//
//  JHBusinessFansLevelShowTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansLevelShowTableViewCell.h"

@interface JHBusinessFansLevelShowTableViewCell ()
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UILabel     *gradeLable;
@property (nonatomic, strong) UILabel     *subNameLabel;
@property (nonatomic, strong) UIView      *lineView;
@end

@implementation JHBusinessFansLevelShowTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _nameLabel                          = [[UILabel alloc] init];
    _nameLabel.textColor                = HEXCOLOR(0x333333);
    _nameLabel.textAlignment            = NSTextAlignmentLeft;
    _nameLabel.font                     = [UIFont fontWithName:kFontNormal size:14.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.top.equalTo(self.contentView.mas_top).offset(20.f);
        make.height.mas_equalTo(20.f);
    }];

    _subNameLabel                       = [[UILabel alloc] init];
    _subNameLabel.textColor             = HEXCOLOR(0x333333);
    _subNameLabel.textAlignment         = NSTextAlignmentRight;
    _subNameLabel.font                  = [UIFont fontWithName:kFontNormal size:14.f];
    [self.contentView addSubview:_subNameLabel];
    [_subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12.f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.width.mas_equalTo(59.f);
        make.height.mas_equalTo(20.f);
    }];


    _gradeLable                     = [[UILabel alloc] init];
    _gradeLable.textAlignment       = NSTextAlignmentRight;
    _gradeLable.font                = [UIFont fontWithName:kFontNormal size:14.f];
    [self.contentView addSubview:_gradeLable];
    [_gradeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.subNameLabel.mas_left).offset(-5.f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.width.mas_equalTo(101.f);
        make.height.mas_equalTo(30.f);
    }];

    _lineView                    = [[UIView alloc] init];
    _lineView.backgroundColor    = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.right.equalTo(self.contentView.mas_right).offset(-12.f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.f);
        make.height.mas_equalTo(1.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setIsLastLine:(BOOL)isLastLine {
    _isLastLine = isLastLine;
    _lineView.hidden = isLastLine;
}

- (void)setShowModel:(JHBusinessFansSettingLevelMsgListModel *)showModel {
    _showModel = showModel;
    _nameLabel.text = [NSString stringWithFormat:@"粉丝等级Lv.%@",NONNULL_STR(showModel.levelType)];
    _gradeLable.text = [NSString stringWithFormat:@"%@",showModel.levelExp];
    _subNameLabel.text = @"<=经验值";
}
@end
