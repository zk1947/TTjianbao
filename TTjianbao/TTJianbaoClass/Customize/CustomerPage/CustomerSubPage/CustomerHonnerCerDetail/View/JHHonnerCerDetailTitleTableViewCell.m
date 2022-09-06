//
//  JHHonnerCerDetailTitleTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHHonnerCerDetailTitleTableViewCell.h"

@interface JHHonnerCerDetailTitleTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JHHonnerCerDetailTitleTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _titleLabel               = [[UILabel alloc] init];
    _titleLabel.textColor     = HEXCOLOR(0x333333);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(25.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
    }];
}

- (void)setViewModel:(NSString *)viewModel {
    self.titleLabel.text = NONNULL_STR(viewModel);
}

@end
