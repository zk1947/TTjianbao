//
//  JHBusinessFansPassBottonView.m
//  TTjianbao
//
//  Created by user on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansPassBottonView.h"

@implementation JHBusinessFansPassBottonView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xFFFFFF);
    }
    return self;
}

- (void)setupViews {
    if (self.isApplying) {
        UILabel *nameLabel              = [[UILabel alloc] init];
        nameLabel.textColor             = HEXCOLOR(0x999999);
        nameLabel.textAlignment         = NSTextAlignmentCenter;
        nameLabel.font                  = [UIFont fontWithName:kFontNormal size:12.f];
        nameLabel.text                  = @"ⓘ 已经提交成功";
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(12.f);
            make.right.equalTo(self.mas_right).offset(-12.f);
            make.top.equalTo(self.mas_top).offset(15.f);
            make.height.mas_equalTo(17.f);
        }];
        
        UILabel *sunNameLabel           = [[UILabel alloc] init];
        sunNameLabel.textColor             = HEXCOLOR(0x999999);
        sunNameLabel.textAlignment         = NSTextAlignmentCenter;
        sunNameLabel.font                  = [UIFont fontWithName:kFontNormal size:12.f];
        sunNameLabel.text                  = @"平台将在5个工作日审核完成，请耐心等待";
        [self addSubview:sunNameLabel];
        [sunNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(12.f);
            make.right.equalTo(self.mas_right).offset(-12.f);
            make.top.equalTo(nameLabel.mas_bottom).offset(5.f);
            make.height.mas_equalTo(17.f);
        }];
    } else {
        UILabel *nameLabel              = [[UILabel alloc] init];
        nameLabel.textColor             = HEXCOLOR(0x999999);
        nameLabel.textAlignment         = NSTextAlignmentCenter;
        nameLabel.font                  = [UIFont fontWithName:kFontNormal size:12.f];
        nameLabel.text                  = @"ⓘ 每周一次";
        [self addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(12.f);
            make.right.equalTo(self.mas_right).offset(-12.f);
            make.top.equalTo(self.mas_top).offset(20.f);
            make.height.mas_equalTo(20.f);
        }];

        _nextButton                     = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"审核通过，重新申请" forState:UIControlStateNormal];
        [_nextButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _nextButton.titleLabel.font     = [UIFont fontWithName:kFontNormal size:15.f];
        [_nextButton addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.layer.cornerRadius  = 22.5f;
        _nextButton.layer.masksToBounds = YES;
        _nextButton.layer.borderWidth   = 0.5f;
        _nextButton.layer.borderColor   = HEXCOLOR(0x333333).CGColor;
        [self addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameLabel.mas_bottom).offset(10.f);
            make.left.equalTo(self.mas_left).offset(40.f);
            make.right.equalTo(self.mas_right).offset(-40.f);
            make.height.mas_equalTo(45.f);
        }];
    }
}

- (void)bottomBtnClick:(UIButton *)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
