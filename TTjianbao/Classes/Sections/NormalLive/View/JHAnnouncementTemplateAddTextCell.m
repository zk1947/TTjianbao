//
//  JHAnnouncementTemplateAddTextCell.m
//  TTjianbao
//
//  Created by Donto on 2020/7/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnnouncementTemplateAddTextCell.h"

@interface JHAnnouncementTemplateAddTextCell ()


@property (nonatomic, strong) UIView *textFieldView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation JHAnnouncementTemplateAddTextCell

- (void)addSelfSubViews  {
    
    UIView *textFieldView = [UIView new];
    textFieldView.layer.cornerRadius = 22;
    textFieldView.layer.borderColor = kColorF5F6FA.CGColor;
    textFieldView.layer.borderWidth = 0.5;
    
    UITextField *textField = [UITextField new];
    textField.placeholder = @"每行上限20字，最多5行";
    textField.textColor = kColor333;
    textField.font = [UIFont systemFontOfSize:14];
    [textField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    _textField = textField;
    
    UIButton *addButton = [self generateButton:@"加行"];
    [addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    _addButton = addButton;
    
    UIButton *deleteButton = [self generateButton:@"删除"];
    _deleteButton = deleteButton;
    [deleteButton addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
   
    [self.contentView addSubview:textFieldView];
    [self.contentView addSubview:textField];
    [self.contentView addSubview:addButton];
    [self.contentView addSubview:deleteButton];
    
    [textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(5);
        make.right.mas_equalTo(-103);
        make.height.mas_equalTo(44);
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textFieldView).offset(22);
        make.top.height.equalTo(textFieldView);
        make.right.equalTo(textFieldView).offset(-22);
     }];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(textFieldView.mas_right).offset(2);
        make.top.equalTo(textField);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(44);
    }];
    
    [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addButton.mas_right);
        make.top.equalTo(textField);
        make.width.mas_equalTo(48);
        make.height.mas_equalTo(44);
    }];

}

#pragma mark -- Actions

- (void)addAction {
    if ([_delegate respondsToSelector:@selector(addLine:)]) {
        [_delegate addLine:self];
    }
}

- (void)deleteAction {
    if ([_delegate respondsToSelector:@selector(deleteLine:)]) {
        [_delegate deleteLine:self];
    }
}

- (void)textFieldDidChanged:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(editingLine:changedText:)]) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
        }
        [_delegate editingLine:self changedText:textField.text];
    }
}

- (void)setIsFirst:(BOOL)isFirst {
    _isFirst = isFirst;
    _deleteButton.hidden = isFirst;
}

- (void)setIsLast:(BOOL)isLast {
    _isLast = isLast;
    _addButton.hidden = isLast;
}

- (void)setOnlyOneLine:(BOOL)onlyOneLine {
    _onlyOneLine = onlyOneLine;
    _deleteButton.hidden = onlyOneLine;
}

- (UIButton *)generateButton:(NSString *)title {
    UIButton *button = [UIButton new];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:kColorTopicTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    return button;
}

@end
