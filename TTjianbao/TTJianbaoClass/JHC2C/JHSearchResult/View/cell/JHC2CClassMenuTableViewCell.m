//
//  JHC2CClassMenuTableViewCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CClassMenuTableViewCell.h"
#import "JHNewStoreTypeTableCellViewModel.h"

@interface JHC2CClassMenuTableViewCell ()
@end

@implementation JHC2CClassMenuTableViewCell

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
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(2);
        make.right.equalTo(self.contentView).offset(0);
    }];
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.titleLabel.textColor = HEXCOLOR(0xFFA319);
        self.contentView.backgroundColor = [UIColor whiteColor];
    } else {
        self.titleLabel.textColor = HEXCOLOR(0x333333);
        self.contentView.backgroundColor = HEXCOLOR(0xF5F6FA);
    }
}

- (void)setViewModel:(JHNewStoreTypeTableCellViewModel *)viewModel{
    _viewModel = viewModel;
    self.titleLabel.text = viewModel.cateName;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = JHFont(12);
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
