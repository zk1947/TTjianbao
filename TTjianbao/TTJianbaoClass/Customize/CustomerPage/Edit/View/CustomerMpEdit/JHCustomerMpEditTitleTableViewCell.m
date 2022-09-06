//
//  JHCustomerMpEditTitleTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerMpEditTitleTableViewCell.h"
#import "UIView+Toast.h"

@interface JHCustomerMpEditTitleTableViewCell ()<UITextFieldDelegate>
@end

@implementation JHCustomerMpEditTitleTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _textField = [[UITextField alloc] init];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.font          = [UIFont fontWithName:kFontNormal size:18.f];
    _textField.delegate      = self;
    _textField.placeholder   = @"请输入代表作名称（10字以内）";
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.contentView.mas_top);
        make.height.mas_equalTo(25.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
    }];
    [_textField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"textFieldDidBeginEditing");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

//- (void)textFiledDidChange:(UITextField *)textField {
//    int length = [self convertToInt:textField.text];
//    /// 如果输入框中的文字大于10，就截取前10个作为输入框的文字
//    if (length > 10) {
//        textField.text = [textField.text substringToIndex:10];
//    }
//}
//]
//- (int)convertToInt:(NSString *)strtemp {
//    //判断中英混合的的字符串长度
//    int strlength = 0;
//    for (int i=0; i< [strtemp length]; i++) {
//        int a = [strtemp characterAtIndex:i];
//        if( a > 0x4e00 && a < 0x9fff) { //判断是否为中文
//            strlength += 1;
//        } else {
//            strlength += 1;
//        }
//    }
//    return strlength;
//}


- (void)textFiledDidChange:(UITextField *)textField {
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > 10) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:10];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:10];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 10)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}














//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField.text.length > 11) {
//        return NO;
//    }
//    return YES;
//}



///// 限制10个
//- (void)textFieldDidChange:(UITextField *)textField {
//    NSString *toBeString = textField.text;
//    //获取高亮部分
//    UITextRange *selectedRange = [textField markedTextRange];
//    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
//
//    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
//    if (!position) {
//        if (toBeString.length > 20) {
//            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:10];
//            if (rangeIndex.length == 1) {
//                textField.text = [toBeString substringToIndex:10];
//            }  else {
//                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 10 - 1 )];
//                textField.text = [toBeString substringWithRange:rangeRange];
//            }
//        }
//    }
//}



@end
