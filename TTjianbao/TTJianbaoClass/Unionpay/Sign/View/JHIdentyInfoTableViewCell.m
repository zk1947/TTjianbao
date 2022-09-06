//
//  JHIdentyInfoTableViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHIdentyInfoTableViewCell.h"
#import "TTjianbao.h"
#import "UIView+CornerRadius.h"
#import "UIInputTextField.h"


struct YDTextFieldInfo {
    NSInteger length;
    NSInteger number;
};
typedef struct YDTextFieldInfo TextFieldInfo;

//static const NSInteger maxLength = 30; //最大输入字符数（中文两个字符，英文数字1个字符）

@interface JHIdentyInfoTableViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) NSString *recordText;
@property (nonatomic, assign) BOOL isHaveDian;   ///有无小数点


@end


@implementation JHIdentyInfoTableViewCell

- (void)setCorners:(NSInteger)maxLineCount indexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    if (maxLineCount == 1) {
        [self yd_setCornerRadius:4.f corners:UIRectCornerAllCorners];
        return;
    }
    if (_indexPath.row == 0) {
        [self yd_setCornerRadius:4.f corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    }
    if (_indexPath.row == maxLineCount - 1) {
        [self yd_setCornerRadius:4.f corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    }
}

- (void)setListModel:(JHUnionPayUserListModel *)listModel {
    if (!listModel) {
        return;
    }
    _listModel = listModel;
    _leftLabel.text = _listModel.title;
    _textField.placeholder = _listModel.placeholder;
    _textField.keyboardType = _listModel.keyboardType;
    if ([_listModel.inputTextString isNotBlank]) {
        _textField.text = _listModel.inputTextString;
    }
}

- (void)setInputText:(NSString *)inputText {
    if (!inputText) {
        return;
    }
    _inputText = inputText;
    _textField.text = _inputText;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    _textAlignment = textAlignment;
    _textField.textAlignment = _textAlignment;
}

- (void)setIsNeedShowArrow:(BOOL)isNeedShowArrow {
    _isNeedShowArrow = isNeedShowArrow;
    
    if (isNeedShowArrow) {
        _textField.rightViewMode = UITextFieldViewModeAlways;

    } else {
        _textField.rightViewMode = UITextFieldViewModeNever;
    }
}

- (void)setIsUserEnabled:(BOOL)isUserEnabled {
    _isUserEnabled = isUserEnabled;
    _textField.userInteractionEnabled = _isUserEnabled;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _isUserEnabled = YES;
        _isNeedShowArrow = NO;
        _textAlignment = NSTextAlignmentLeft;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _leftLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontMedium size:15] textColor:HEXCOLOR(0x333333)];
    [self.contentView addSubview:_leftLabel];
    _textField = [[UITextField alloc] initWithFrame:CGRectZero];
    _textField.font = [UIFont fontWithName:kFontNormal size:15];
    _textField.delegate = self;
    _textField.textAlignment = _textAlignment;
    _textField.textColor = HEXCOLOR(0x999999);
    _textField.returnKeyType = UIReturnKeyDone;
    _textField.clearButtonMode = UITextFieldViewModeNever;//清除键
    [self.contentView addSubview:_textField];
    
    [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"store_icon_seller_more_arrow"]];
    _arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _textField.rightView = _arrowImageView;
    _textField.rightViewMode = UITextFieldViewModeNever; //UITextFieldViewModeAlways;
    
    //sd_layout布局
    
    _leftLabel.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .centerYEqualToView(self.contentView)
    .heightIs(40)
    .autoWidthRatio(0);
    [_leftLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _textField.sd_layout
    .leftSpaceToView(_leftLabel, 20)
    .rightSpaceToView(self.contentView, 10)
    .centerYEqualToView(self.contentView)
    .heightIs(40);
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if ([self.delegate respondsToSelector:@selector(infoTableViewCellDidEndEditing:dataType:)]) {
        [self.delegate infoTableViewCellDidEndEditing:self.textField dataType:self.listModel.dataType];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.listModel.dataType != JHDataTypePublicAccountAmount) {
        return YES;
    }
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */

    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.isHaveDian = YES;
    }
    else {
        self.isHaveDian = NO;
    }

    if (string.length > 0) {
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        NSLog(@"single = %c",single);
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.')) {
            [UITipView showTipStr:@"您的输入格式不正确"];
            return NO;
        }
        // 只能有一个小数点
        if (self.isHaveDian && single == '.') {
            [UITipView showTipStr:@"最多只能输入一个小数点"];
            return NO;
        }

        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }

        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    [UITipView showTipStr:@"第二个字符需要是小数点"];
                    return NO;
                }
            }
            else {
                if (![string isEqualToString:@"."]) {
                    [UITipView showTipStr:@"第二个字符需要是小数点"];
                    return NO;
                }
            }
        }

        // 小数点后最多能输入两位
        if (self.isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    [UITipView showTipStr:@"小数点后最多有两位小数"];
                    return NO;
                }
            }
        }
        
        return YES;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldChanged:(UITextField *)field {
    
    NSString *changeText = field.text;
    
    //不支持系统表情的输入
    if ([NSString isStringContainsEmoji:changeText]) {
        NSLog(@"不支持输入表情");
        self.textField.text = _recordText;
        return;
    }
    
    UITextRange *selectedRange = [field markedTextRange];
    UITextPosition *position = [field positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
    if (!position) {
        NSInteger maxNum = _listModel.maxInputLength;
        if (self.textField.text.length > maxNum) {
            self.textField.text = [self.textField.text substringToIndex:maxNum];
        }
    }
    _recordText = changeText;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoTableViewCellTextChanged:dataType:)]) {
        [self.delegate infoTableViewCellTextChanged:self.textField dataType:self.listModel.dataType];
    }
}


//判断中英混合的的字符串长度及字符个数
- (TextFieldInfo)getInfoWithText:(NSString *)text maxLength:(NSInteger)maxLength {
    
    int length = 0;
    int singleNum = 0;
    int totalNum = 0;
    char *p = (char *)[text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i = 0; i < [text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*p) {
            length++;
            if (length <= maxLength) {
                totalNum++;
            }
        } else {
            if (length <= maxLength) {
                singleNum++;
            }
        }
        p++;
    }
    
    TextFieldInfo fieldInfo;
    fieldInfo.length = length;
    fieldInfo.number = (totalNum - singleNum) / 2 + singleNum;
    return fieldInfo;
}




@end
