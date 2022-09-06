//
//  JHBusinessFansGradeEditTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessFansGradeEditTableViewCell.h"
//#import "UIView+Toast.h"

@interface JHBusinessFansGradeEditTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UITextField *gradeTextField;
@property (nonatomic, strong) UILabel     *subNameLabel;
@property (nonatomic, strong) UIView      *lineView;
@end

@implementation JHBusinessFansGradeEditTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _nameLabel                          = [[UILabel alloc] init];
    _nameLabel.textColor                = HEXCOLOR(0x333333);
    _nameLabel.textAlignment            = NSTextAlignmentLeft;
    _nameLabel.font                     = [UIFont fontWithName:kFontNormal size:14.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.top.equalTo(self.contentView.mas_top).offset(20.f);
        make.height.mas_equalTo(20.f);
    }];

    _subNameLabel                       = [[UILabel alloc] init];
    _subNameLabel.textColor             = HEXCOLOR(0x333333);
    _subNameLabel.textAlignment         = NSTextAlignmentRight;
    _subNameLabel.font                  = [UIFont fontWithName:kFontNormal size:14.f];
    [self.contentView addSubview:_subNameLabel];
    [_subNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12.f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.width.mas_equalTo(59.f);
        make.height.mas_equalTo(20.f);
    }];


    _gradeTextField                     = [[UITextField alloc] init];
    _gradeTextField.placeholder         = @"输入经验值";
    _gradeTextField.textAlignment       = NSTextAlignmentCenter;
    _gradeTextField.delegate            = self;
    _gradeTextField.layer.borderWidth   = 0.5f;
    _gradeTextField.layer.borderColor   = HEXCOLOR(0xBDBFC2).CGColor;
    _gradeTextField.layer.cornerRadius  = 2.f;
    _gradeTextField.layer.masksToBounds = YES;
    _gradeTextField.font                = [UIFont fontWithName:kFontNormal size:14.f];
    _gradeTextField.keyboardType        = UIKeyboardTypeNumberPad;
    [self.contentView addSubview:_gradeTextField];
    [_gradeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.subNameLabel.mas_left).offset(-5.f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.width.mas_equalTo(101.f);
        make.height.mas_equalTo(30.f);
    }];

    _lineView                    = [[UIView alloc] init];
    _lineView.backgroundColor            = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.right.equalTo(self.contentView.mas_right).offset(-12.f);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.f);
        make.height.mas_equalTo(1.f);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];

    _subNameLabel.text                  = @"<=经验值";
    [_gradeTextField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setIsLastLine:(BOOL)isLastLine {
    _isLastLine = isLastLine;
    _lineView.hidden = isLastLine;
}

- (void)setTextFieldText:(NSString *)str {
    if (isEmpty(str)) {
        self.gradeTextField.userInteractionEnabled = YES;
    } else {
        self.gradeTextField.text = str;
        self.gradeTextField.userInteractionEnabled = NO;
    }
}

- (void)setModel:(JHBusinessFansLevelMsgListApplyModel *)model {
    _model = model;
    _nameLabel.text = [NSString stringWithFormat:@"粉丝等级Lv.%@",NONNULL_STR(model.levelType)];
    if (model.levelExp > 0) {
        _gradeTextField.text = [NSString stringWithFormat:@"%ld",model.levelExp];
        if (self.changeBlock) {
            self.changeBlock();
        }
    }
}

#pragma mark - textField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.model.levelExp = [textField.text longValue];
    if (self.changeBlock) {
        self.changeBlock();
    }
    NSInteger lastIndex = [self.model.levelType integerValue] - 1;
    if (lastIndex >= 1) {
        JHBusinessFansLevelMsgListApplyModel *lastModel = self.levelArray[lastIndex - 1];
        if ([textField.text longValue] < lastModel.levelExp) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"经验值不能低于上一级经验值" duration:1.f position:CSToastPositionCenter];
            return;
        }
    }
}

- (void)textFiledDidChange:(UITextField *)textField {
    NSString *toBeString = textField.text;
    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];

    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
        if (toBeString.length > 9) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:9];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:9];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 9)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.text.length >9) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"最大支持9位数" duration:1.f position:CSToastPositionCenter];
    }
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString *)number {
    BOOL res = YES;
    NSCharacterSet *tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}



@end
