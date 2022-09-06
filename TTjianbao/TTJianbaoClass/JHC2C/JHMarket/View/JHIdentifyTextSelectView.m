//
//  JHIdentifyTextSelectView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/6/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIdentifyTextSelectView.h"
@interface JHIdentifyTextSelectView ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITextField *otherTF;

@end
@implementation JHIdentifyTextSelectView

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
- (void)reasonbtnClick:(UIButton *)btn {
    for (UIButton *tmp in self.contentView.subviews) {
        if(![tmp isKindOfClass:[UIButton class]]) continue;
        tmp.selected = NO;
    };
    btn.selected = YES;
    JHAppraisalAttrValuesModel *value = self.model.attrValues[btn.tag];
    self.model.selectedAttrValues = @[value];
}
- (void)setupData {
    if (self.model == nil) return;
    NSArray *titles = [self.model.attrValues valueForKeyPath:@"name"];
    UIButton *tempBtn;
    for (int i = 0; i < titles.count; i++) {
        NSString *title = titles[i];
        UILabel *tmpLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
        tmpLabel.text = title;
        UIButton *btn = [UIButton jh_buttonWithTitle:@"" fontSize:13 textColor:HEXCOLOR(0xFF333333) target:self action:@selector(reasonbtnClick:) addToSuperView:self.contentView];
        btn.tag = i;
        [btn setBackgroundImage:[UIImage imageNamed:@"recycle_piublish_price_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"recycle_piublish_price_selected"] forState:UIControlStateSelected];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i == 0) {
                make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(20);
            }else {
                make.top.mas_equalTo(tempBtn.mas_bottom).mas_offset(10);
            }
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(20);
        }];
        
        [tmpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(btn);
            make.left.mas_equalTo(self.titleLabel);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(100);
        }];
        tempBtn = btn;
    }
    
    [self.otherTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tempBtn.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(self.titleLabel);
        make.height.mas_equalTo(46);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
    }];
    
    @weakify(self)
    [RACObserve(self.otherTF, text) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.model.otherDesc = x;
    }];
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
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.height.equalTo(@20);
        make.width.equalTo(@84);
    }];
    
}
#pragma mark - Lazy
- (void)setModel:(JHAppraisalAttrsResultlModel *)model {
    _model = model;
    [self setupData];
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [UIView jh_viewWithColor:HEXCOLOR(0xFFFAFAFA) addToSuperview:self];
    }
    return _contentView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel jh_labelWithFont:14 textColor:HEXCOLOR(0xFF333333) addToSuperView:self.contentView];
        _titleLabel.text = @"请选择原因：";
    }
    return _titleLabel;
}
- (UITextField *)otherTF {
    if (!_otherTF) {
        _otherTF = [UITextField jh_textFieldWithFont:14 textAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0x333333) placeholderText:@" 请输入原因，必填，不超过20个汉字" placeholderColor:HEXCOLOR(0xFF999999) addToSupView:self.contentView];
        
        _otherTF.backgroundColor = [UIColor clearColor];
        _otherTF.layer.cornerRadius = 5.0f;
        _otherTF.layer.borderWidth = 1;
        //otherTF.titleLabel.font = [UIFont fontWithName:kFontNormal size:16.0f];
        _otherTF.layer.borderColor = HEXCOLOR(0xFFE6E6E6).CGColor;
        _otherTF.delegate = self;
        _otherTF.returnKeyType = UIReturnKeyDone;
        _otherTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _otherTF;
}
@end
