//
//  JHPublishReportTureFalseCell.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHPublishReportTrueFalseCell.h"

@interface JHPublishReportTrueFalseCell ()

/// 真不估价
@property (nonatomic, weak) UIButton *trueNoPriceButton;

/// 真
@property (nonatomic, weak) UIButton *trueButton;

/// 伪
@property (nonatomic, weak) UIButton *falseButton;

@end

@implementation JHPublishReportTrueFalseCell

- (void)addSelfSubViews {
    UILabel *label = [UILabel jh_labelWithText:@"真伪" font:16 textColor:RGB(34,34,34) textAlignment:0 addToSuperView:self.contentView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    _trueNoPriceButton = [UIButton jh_buttonWithImage:JHImageNamed(@"order_pay_button") target:self action:@selector(selectedTrueNoPriceMethod) addToSuperView:self.contentView];
    [_trueNoPriceButton setImage:JHImageNamed(@"order_pay_button_select") forState:UIControlStateSelected];
    [_trueNoPriceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(label.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(26, 26));
    }];
    
    [[UILabel jh_labelWithText:@"真，不估价" font:14 textColor:RGB(34,34,34) textAlignment:0 addToSuperView:self.contentView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.trueNoPriceButton);
        make.left.equalTo(self.trueNoPriceButton.mas_right);
    }];
    
    _trueButton = [UIButton jh_buttonWithImage:JHImageNamed(@"order_pay_button") target:self action:@selector(selectedTrueMethod) addToSuperView:self.contentView];
    [_trueButton setImage:JHImageNamed(@"order_pay_button_select") forState:UIControlStateSelected];
    [_trueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(132);
        make.top.width.height.equalTo(self.trueNoPriceButton);
    }];
    
    [[UILabel jh_labelWithText:@"真，进行估价" font:14 textColor:RGB(34,34,34) textAlignment:0 addToSuperView:self.contentView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.trueButton);
        make.left.equalTo(self.trueButton.mas_right);
    }];
    
    _falseButton = [UIButton jh_buttonWithImage:JHImageNamed(@"order_pay_button") target:self action:@selector(selectedFalseMethod) addToSuperView:self.contentView];
    [_falseButton setImage:JHImageNamed(@"order_pay_button_select") forState:UIControlStateSelected];
    [_falseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(268);
        make.top.width.height.equalTo(self.trueNoPriceButton);
    }];
    
    [[UILabel jh_labelWithText:@"伪" font:14 textColor:RGB(34,34,34) textAlignment:0 addToSuperView:self.contentView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.falseButton);
        make.left.equalTo(self.falseButton.mas_right);
    }];
    
    [[UIImageView jh_imageViewWithImage:JHImageNamed(@"common_dotted_line") addToSuperview:self.contentView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    
    
}

- (void)setType:(NSInteger)type {
    _type = type;
    switch (_type) {
        case 1:
        {
            _trueNoPriceButton.selected = YES;
            _trueButton.selected = NO;
            _falseButton.selected = NO;
        }
            break;
            
        case 2:
        {
            _trueNoPriceButton.selected = NO;
            _trueButton.selected = YES;
            _falseButton.selected = NO;
        }
            break;
            
        default:{
            _trueNoPriceButton.selected = NO;
            _trueButton.selected = NO;
            _falseButton.selected = YES;
        }
            break;
    }
}

- (void)selectedTrueNoPriceMethod {
    if(_clickBlock) {
        _clickBlock(1);
    }
}

- (void)selectedTrueMethod {
    if(_clickBlock) {
        _clickBlock(2);
    }
}

- (void)selectedFalseMethod {
    if(_clickBlock) {
        _clickBlock(0);
    }
}

@end
