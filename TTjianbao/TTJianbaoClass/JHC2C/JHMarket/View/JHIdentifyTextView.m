//
//  JHIdentifyTextView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/6/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentifyTextView.h"
@interface JHIdentifyTextView()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *deLabel;
@end

@implementation JHIdentifyTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
    
}

- (void)bindData {
    @weakify(self)
    [RACObserve(self.textField, text) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        JHAppraisalAttrValuesModel *att = [[JHAppraisalAttrValuesModel alloc] init];
        att.code = x;
        att.name = x;
        self.model.selectedAttrValues = @[att];
    }];
}

- (void)setupData {
    if (self.model == nil) return;
    self.titleLabel.text = [NSString stringWithFormat:@"%@", self.model.attrName];
    self.textField.placeholder = [NSString stringWithFormat:@"请输入%@", self.model.attrName];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length <= 0) return true;
    if (textField.text.length > 19) {
        return false;
    }
    return true;
}
- (void)setupUI {
    
}
- (void)layoutViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.width.mas_equalTo(@90);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_greaterThanOrEqualTo(@28);
    }];
    [self.deLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(0);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
        make.height.mas_equalTo(22);
        make.right.mas_equalTo(-10);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self.textField);
    }];
}
#pragma mark - Lazy
- (void)setModel:(JHAppraisalAttrsResultlModel *)model {
    _model = model;
    [self setupData];
    [self bindData];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}
- (UITextField *)textField {
    if (!_textField) {
        _textField = [UITextField jh_textFieldWithFont:14 textAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0x333333) placeholderText:@"" placeholderColor:HEXCOLOR(0xFF999999) addToSupView:self];
        
        _textField.backgroundColor = [UIColor clearColor];
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}
- (UIView *)line  {
    if (!_line) {
        _line = [UIView jh_viewWithColor:HEXCOLOR(0xFFEEEEEE) addToSuperview:self];
        
    }
    return _line;
}
- (UILabel *)deLabel {
    if (!_deLabel) {
        _deLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self];
        _deLabel.text = @":";
    }
    return _deLabel;
}
@end
