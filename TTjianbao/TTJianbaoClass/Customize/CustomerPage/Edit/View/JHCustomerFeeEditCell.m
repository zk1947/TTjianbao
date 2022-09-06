//
//  JHCustomerFeeEditCell.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerFeeEditCell.h"

@interface JHCustomerFeeEditCell ()

@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, weak) UILabel *descLabel;

@property (nonatomic, weak) UIButton *button;

@end


@implementation JHCustomerFeeEditCell

- (void)addSelfSubViews {
    _iconView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_iconView jh_cornerRadius:8];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(14.f);
        make.left.equalTo(self.contentView).offset(10.f);
        make.width.height.mas_equalTo(45);
    }];
    
    _titleLabel = [UILabel jh_labelWithFont:15 textColor:RGB515151 addToSuperView:self.contentView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconView);
        make.right.equalTo(self.contentView).offset(-60);
        make.left.equalTo(self.iconView.mas_right).offset(10);
    }];
    
    _descLabel = [UILabel jh_labelWithFont:12 textColor:RGB153153153 addToSuperView:self.contentView];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconView);
        make.left.right.equalTo(self.titleLabel);
    }];
    
    _button = [UIButton jh_buttonWithTitle:@" 重置" fontSize:12 textColor:RGB153153153 target:self action:@selector(resetMethod) addToSuperView:self.contentView];
    _button.jh_imageName(@"common_reset");
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(37);
    }];
}

- (void)setModel:(JHCustomerFeeEditModel *)model {
    _model = model;
    
    [_iconView jh_setImageWithUrl:_model.img];
    _titleLabel.text = _model.name;
    _button.hidden = (_model.maxPrice <= 0);
    if(_model.maxPrice <= 0) {
        _descLabel.text = @"请输入价格";
    }
    else {
        _descLabel.text = [NSString stringWithFormat:@"%@~%@",@(_model.minPrice),@(_model.maxPrice)];
    }
    
    
//    if(_model.maxPrice)
//    _descLabel.text =
}
- (void)resetMethod {
    if(_resetBlock) {
        _resetBlock();
    }
}

+ (CGFloat)cellHeight {
    return 70;
}

@end
