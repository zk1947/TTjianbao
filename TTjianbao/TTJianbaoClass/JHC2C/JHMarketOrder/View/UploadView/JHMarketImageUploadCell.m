//
//  JHMarketImageUploadCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketImageUploadCell.h"
@interface JHMarketImageUploadCell()
/** +号*/
@property (nonatomic, strong) UIImageView *plusImageView;

@end
@implementation JHMarketImageUploadCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
//        self.contentView.backgroundColor = HEXCOLOR(0xffffff);
        [self configUI];
    }
    return self;
}

- (void)configUI {
    [self.contentView addSubview:self.plusView];
    [self.plusView addSubview:self.plusImageView];
    [self.plusView addSubview:self.plusLabel];
    
    [self.contentView addSubview:self.pictureImageView];
    [self.contentView addSubview:self.cancelButton];
    
    [self.plusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.plusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.plusView.mas_centerY).offset(5);
        make.centerX.mas_equalTo(self.plusView);
        make.width.height.mas_equalTo(28);
    }];
    
    [self.plusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.plusImageView.mas_bottom).offset(13);
        make.centerX.mas_equalTo(self.plusView);
    }];
    
    [self.pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.pictureImageView.mas_top).offset(10);
        make.left.mas_equalTo(self.pictureImageView.mas_right).offset(-10);
        make.width.height.mas_equalTo(20);
    }];
}

- (void)cancelButtonClickAction {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (UIImageView *)pictureImageView {
    if (_pictureImageView == nil) {
        _pictureImageView = [[UIImageView alloc] init];
        _pictureImageView.image = kDefaultCoverImage;
        _pictureImageView.layer.cornerRadius = 5;
        _pictureImageView.clipsToBounds = YES;
    }
    return _pictureImageView;
}

- (UIView *)plusView {
    if (_plusView == nil) {
        _plusView = [[UIView alloc] init];
        _plusView.layer.borderColor = HEXCOLOR(0xdddddd).CGColor;
        _plusView.layer.borderWidth = 1;
        _plusView.layer.cornerRadius = 5;
        _plusView.clipsToBounds = YES;
    }
    return _plusView;
}

- (UIImageView *)plusImageView {
    if (_plusImageView == nil) {
        _plusImageView = [[UIImageView alloc] init];
        _plusImageView.image = [UIImage imageNamed:@"c2c_upimage_plus"];
    }
    return _plusImageView;
}

- (UILabel *)plusLabel {
    if (_plusLabel == nil) {
        _plusLabel = [[UILabel alloc] init];
        _plusLabel.textColor = HEXCOLOR(0x999999);
        _plusLabel.font = [UIFont fontWithName:kFontNormal size:10];
        _plusLabel.text = @"";
    }
    return _plusLabel;
}

- (UIButton *)cancelButton {
    if (_cancelButton == nil) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"recycle_Arbitration_close"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
@end
