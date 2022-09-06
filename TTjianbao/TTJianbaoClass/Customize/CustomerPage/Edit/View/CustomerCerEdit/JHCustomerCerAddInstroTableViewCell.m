//
//  JHCustomerCerAddInstroTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerCerAddInstroTableViewCell.h"
#import "NSObject+Cast.h"
#import "UILabel+TextAlignment.h"
#import "UIView+Toast.h"

@interface JHCustomerCerAddInstroTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UILabel  *subTitleLabel;
@property (nonatomic, assign) NSInteger index;
@end

@implementation JHCustomerCerAddInstroTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _titleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 75.f, 21.f)];
    _titleLabel.textColor     = HEXCOLOR(0x333333);
    _titleLabel.font          = [UIFont fontWithName:kFontNormal size:15.f];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15.f);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(75.f);
        make.height.mas_equalTo(21.f);
    }];
    
    
    _subTitleLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 75.f, 21.f)];
    _subTitleLabel.textColor     = HEXCOLOR(0x999999);
    _subTitleLabel.font          = [UIFont fontWithName:kFontNormal size:15.f];
    _subTitleLabel.hidden        = YES;
    [self.contentView addSubview:_subTitleLabel];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.contentView.mas_top).offset(5.f);
        make.height.mas_equalTo(21.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
    }];
        
    
    _textField = [[UITextField alloc] init];
    _textField.textAlignment = NSTextAlignmentLeft;
    _textField.font          = [UIFont fontWithName:kFontNormal size:15.f];
    _textField.delegate      = self;
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5.f);
        make.right.equalTo(self.contentView.mas_right).offset(-15.f);
        make.top.equalTo(self.contentView.mas_top).offset(5.f);
        make.height.mas_equalTo(21.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5.f);
    }];
    
    [_textField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.addInstroBlock) {
        self.addInstroBlock(textField.text, self.index);
    }
}

//- (void)textFiledDidChange:(UITextField *)textField {
////    int length = [self convertToInt:textField.text];
//    /// 如果输入框中的文字大于10，就截取前10个作为输入框的文字
//
//    switch (self.index) {
//        case JHCerEditCellStyle_Prize: { /// 奖项
//            if (textField.text.length > 100) {
//                textField.text = [textField.text substringToIndex:100];
//            }
//        }
//            break;
//        case JHCerEditCellStyle_Owner: { /// 持证人
//            if (textField.text.length > 10) {
//                textField.text = [textField.text substringToIndex:10];
//            }
//        }
//            break;
//        case JHCerEditCellStyle_Business: { /// 发证机构
//            if (textField.text.length > 20) {
//                textField.text = [textField.text substringToIndex:20];
//            }
//        }
//            break;
//        default:
//            break;
//    }
//
//    if (self.addInstroBlock) {
//        self.addInstroBlock(textField.text, self.index);
//    }
//}

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
    
    switch (self.index) {
        case JHCerEditCellStyle_Prize: { /// 奖项
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > 100) {
                    NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:100];
                    if (rangeIndex.length == 1) {
                        textField.text = [toBeString substringToIndex:100];
                    } else {
                        NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 100)];
                        textField.text = [toBeString substringWithRange:rangeRange];
                    }
                }
            }
        }
            break;
        case JHCerEditCellStyle_Owner: { /// 持证人
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
            break;
        case JHCerEditCellStyle_Business: { /// 发证机构
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > 20) {
                    NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:20];
                    if (rangeIndex.length == 1) {
                        textField.text = [toBeString substringToIndex:20];
                    } else {
                        NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 20)];
                        textField.text = [toBeString substringWithRange:rangeRange];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
    
    if (self.addInstroBlock) {
        self.addInstroBlock(textField.text, self.index);
    }
}









//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (self.addInstroBlock) {
//        self.addInstroBlock(textField.text, self.index);
//    }
//    switch (self.index) {
//        case JHCerEditCellStyle_Prize: { /// 奖项
//            if (textField.text.length > 100) {
//                return NO;
//            }
//        }
//            break;
//        case JHCerEditCellStyle_Owner: { /// 持证人
//            if (textField.text.length > 10) {
//                return NO;
//            }
//        }
//            break;
//        case JHCerEditCellStyle_Business: { /// 发证机构
//            if (textField.text.length > 20) {
//                return NO;
//            }
//        }
//            break;
//        default:
//            break;
//    }
//    return YES;
//}

- (void)setViewModel:(id)viewModel {
    NSDictionary *dict = [NSDictionary cast:viewModel];
    if (dict) {
        self.titleLabel.text       = dict[@"title"];
        /// 两边对齐
        [self.titleLabel changeAlignmentBothSides];
        self.index = [dict[@"id"] integerValue];
        if ([dict[@"id"] integerValue] == JHCerEditCellStyle_Date) {
            if (!isEmpty(dict[@"value"])) {
                self.textField.hidden     = YES;
                self.subTitleLabel.hidden = NO;
                self.subTitleLabel.text   = dict[@"value"];
                self.subTitleLabel.textColor = HEXCOLOR(0x333333);
            } else {
                self.textField.hidden     = YES;
                self.subTitleLabel.hidden = NO;
                self.subTitleLabel.text   = dict[@"placeHolder"];
                self.subTitleLabel.textColor = HEXCOLOR(0x999999);
            }
        } else {
            self.textField.hidden                  = NO;
            self.subTitleLabel.hidden              = YES;
            NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString: dict[@"placeHolder"]];
            [placeHolder addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x999999) range:NSMakeRange(0, placeHolder.length)];
            self.textField.attributedPlaceholder = placeHolder;
        }
    }
}


@end
