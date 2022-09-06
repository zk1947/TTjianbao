//
//  JHRecycleGoodsDetailDescTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleGoodsDetailDescTableViewCell.h"

@interface JHRecycleGoodsDetailDescTableViewCell ()
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *descLabel;
@end

@implementation JHRecycleGoodsDetailDescTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    /// 名称
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x222222);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:14.f];
    _nameLabel.text          = @"商品描述";
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12.f);
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.height.mas_equalTo(20.f);
    }];
    
    /// 描述
    _descLabel               = [[UILabel alloc] init];
    _descLabel.textColor     = HEXCOLOR(0x666666);
    _descLabel.textAlignment = NSTextAlignmentLeft;
    _descLabel.font          = [UIFont fontWithName:kFontNormal size:13.f];
    _descLabel.numberOfLines = 0;
    [self.contentView addSubview:_descLabel];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10.f);
        make.left.equalTo(self.nameLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-12.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2.f);
    }];
}

- (void)setViewModel:(id)viewModel {
    NSString *descStr = viewModel;
    self.descLabel.text = NONNULL_STR(descStr);
}

@end
