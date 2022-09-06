//
//  JHC2CClassMenuSubCollectionViewCell.m
//  TTjianbao
//
//  Created by hao on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CClassMenuSubCollectionViewCell.h"
#import "TTjianbaoHeader.h"
#import "JHNewStoreTypeTableCellViewModel.h"

@interface JHC2CClassMenuSubCollectionViewCell ()
@end

@implementation JHC2CClassMenuSubCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.textColor = HEXCOLOR(0xFFA319);
    } else {
        self.titleLabel.textColor = HEXCOLOR(0x666666);
    }
}

- (void)setViewModel:(JHNewStoreTypeTableCellViewModel *)viewModel{
    _viewModel = viewModel;
    self.titleLabel.text = viewModel.cateName;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _titleLabel.textColor = HEXCOLOR(0x666666);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
