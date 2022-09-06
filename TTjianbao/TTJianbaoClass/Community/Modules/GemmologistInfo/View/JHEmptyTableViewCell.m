//
//  JHEmptyTableViewCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHEmptyTableViewCell.h"

@implementation JHEmptyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.emptyImageView];
        [self.contentView addSubview:self.emptyLabel];
        [self.contentView addSubview:self.emptyButton];
        self.emptyImageView.hidden = NO;
        self.emptyLabel.hidden = NO;
        self.emptyButton.hidden = YES;
        [self.emptyImageView setImage:[UIImage imageNamed:@"img_default_page"]];
        self.emptyLabel.text = @"暂无数据~";
        [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY).offset(-100);
            make.centerX.equalTo(self.mas_centerX);
        }];
        
        [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emptyImageView.mas_bottom).offset(10);
            make.centerX.equalTo(self.emptyImageView.mas_centerX);
        }];
        
        [self.emptyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emptyLabel.mas_bottom).offset(20);
            make.centerX.equalTo(self.emptyImageView.mas_centerX);
            make.width.mas_equalTo(102);
            make.height.mas_equalTo(36);
        }];
    }
    return self;
}

//按钮点击响应事件
- (void)buttonClickAction:(UIButton *)sender {
    if (self.buttonClickActionBlock) {
        self.buttonClickActionBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
  
}
- (UIImageView *)emptyImageView {
    if (_emptyImageView == nil) {
        _emptyImageView = [UIImageView new];
//        _emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _emptyImageView;
}

- (UILabel *)emptyLabel {
    if (_emptyLabel == nil) {
        _emptyLabel = [UILabel new];
        _emptyLabel.font = [UIFont systemFontOfSize:15];
        _emptyLabel.textColor = HEXCOLOR(0x999999);
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _emptyLabel;
}

- (UIButton *)emptyButton {
    if (_emptyButton == nil) {
        _emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_emptyButton setTitle:@"" forState:UIControlStateNormal];
        _emptyButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        [_emptyButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _emptyButton.layer.cornerRadius = 5;
        _emptyButton.clipsToBounds = YES;
        _emptyButton.backgroundColor = HEXCOLOR(0xffd70f);
        [_emptyButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emptyButton;
}

@end
