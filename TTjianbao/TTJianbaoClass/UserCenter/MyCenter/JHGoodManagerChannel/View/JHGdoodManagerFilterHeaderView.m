//
//  JHGdoodManagerFilterHeaderView.m
//  TTjianbao
//
//  Created by user on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGdoodManagerFilterHeaderView.h"

@interface JHGdoodManagerFilterHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JHGdoodManagerFilterHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xFFFFFF);
    self.contentView.backgroundColor = HEXCOLOR(0xFFFFFF);
    
    _titleLabel               = [[UILabel alloc] init];
    _titleLabel.textColor     = HEXCOLOR(0x333333);
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.font          = [UIFont fontWithName:kFontMedium size:14.f];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.left.equalTo(self.contentView.mas_left).offset(18.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-7.f);
    }];
}

- (void)setViewModel:(NSString *)viewModel {
    self.titleLabel.text = viewModel;
}

@end
