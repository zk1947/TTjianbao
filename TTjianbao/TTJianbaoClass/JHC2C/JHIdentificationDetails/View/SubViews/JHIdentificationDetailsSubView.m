//
//  JHIdentificationDetailsSubView.m
//  TTjianbao
//
//  Created by miao on 2021/6/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentificationDetailsSubView.h"

@interface JHIdentificationDetailsSubView ()

@end

@implementation JHIdentificationDetailsSubView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self p_drawSubViews];
        [self p_makeLayout];
        
    }
    return self;
}

- (void)p_drawSubViews {
    
    _identificationTitleLabel = [UILabel new];
    _identificationTitleLabel.font = JHFont(16);
    _identificationTitleLabel.textColor = HEXCOLOR(0x333333);
    _identificationTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_identificationTitleLabel];
    
    
    _identificationResultsLabel = [UILabel new];
    _identificationResultsLabel.font = _identificationTitleLabel.font;
    _identificationResultsLabel.textColor = HEXCOLOR(0x333333);
    _identificationResultsLabel.textAlignment = NSTextAlignmentLeft;
    _identificationResultsLabel.text = @"--";
    [self addSubview:_identificationResultsLabel];
    
}

- (void)p_makeLayout {
    
    [_identificationTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.bottom.equalTo(self);
        make.height.mas_equalTo(@17);
        make.width.mas_equalTo(@80);
    }];

    [_identificationResultsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_identificationTitleLabel.mas_right);
        make.right.equalTo(self).offset(-12);
        make.top.bottom.equalTo(_identificationTitleLabel);
    }];

}


@end
