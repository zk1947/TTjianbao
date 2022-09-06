//
//  JHGoodManagerListAlertInputTableViewCell.m
//  TTjianbao
//
//  Created by user on 2021/8/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodManagerListAlertInputTableViewCell.h"
#import "JHGoodManagerSingleton.h"

@interface JHGoodManagerListAlertInputTableViewCell ()<UITextFieldDelegate>
@property (nonatomic, strong) UILabel      *nameLabel;
@property (nonatomic, strong) UITextField  *textField;
@property (nonatomic, strong) UIView       *lineView;
@property (nonatomic, strong) NSDictionary *valueDictionary;
@end

@implementation JHGoodManagerListAlertInputTableViewCell

- (NSDictionary *)valueDictionary {
    if (!_valueDictionary) {
        _valueDictionary = [NSDictionary dictionary];
    }
    return _valueDictionary;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xffffff);
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
        
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x222222);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.height.mas_equalTo(21.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-14.f);
    }];
    
    
    _textField                             = [[UITextField alloc] init];
    _textField.textAlignment               = NSTextAlignmentLeft;
    _textField.font                        = [UIFont fontWithName:kFontNormal size:13.f];
    _textField.delegate                    = self;
    _textField.keyboardType                = UIKeyboardTypeDecimalPad;
    _textField.clearButtonMode             = UITextFieldViewModeWhileEditing;
    _textField.textColor                   = HEXCOLOR(0x333333);
//    NSMutableAttributedString *placeHolder = [[NSMutableAttributedString alloc]initWithString: @"请输入证书名称（20字以内）"];
//    [placeHolder addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x999999) range:NSMakeRange(0, placeHolder.length)];
//    _textField.attributedPlaceholder       = placeHolder;
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(97.f);
        make.right.equalTo(self.contentView.mas_right).offset(-2.f);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
        make.height.mas_equalTo(48.f);
    }];
    [_textField addTarget:self action:@selector(textFiledDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    /// 横划线
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.textField);
        make.top.equalTo(self.textField.mas_bottom);
        make.height.mas_equalTo(1.f);
    }];
}


#pragma mark - TextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.valueDictionary[@"num"] integerValue] == 0) {
        [JHGoodManagerSingleton shared].startAuctionPrice = textField.text;
    }
    else if ([self.valueDictionary[@"num"] integerValue] == 1) {
        [JHGoodManagerSingleton shared].addAuctionPrice = textField.text;
    }
    else if ([self.valueDictionary[@"num"] integerValue] == 2) {
        [JHGoodManagerSingleton shared].sureMoney = textField.text;
    }
}

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


- (void)setViewModel:(NSDictionary *)viewModel {
    self.valueDictionary = viewModel;
    if ([self.valueDictionary[@"num"] integerValue] == 2) {
        self.nameLabel.attributedText = nil;
        self.nameLabel.text = [NSString stringWithFormat:@"%@",viewModel[@"name"]];
    } else {
        NSMutableAttributedString *star = [[NSMutableAttributedString alloc] initWithString:viewModel[@"name"] attributes:@{
            NSFontAttributeName:[UIFont fontWithName:kFontMedium size:15.f],
            NSForegroundColorAttributeName:HEXCOLOR(0x222222)
        }];
        NSMutableAttributedString *end = [[NSMutableAttributedString alloc] initWithString:@" *" attributes:@{
            NSFontAttributeName:[UIFont fontWithName:kFontMedium size:15.f],
            NSForegroundColorAttributeName:HEXCOLOR(0xF23730)
        }];
        NSMutableAttributedString *commentString = [[NSMutableAttributedString alloc] init];
        [commentString appendAttributedString:star];
        [commentString appendAttributedString:end];

        self.nameLabel.text = nil;
        self.nameLabel.attributedText = commentString;
    }
    
    
    self.textField.placeholder = viewModel[@"placeholder"];
    if (!isEmpty(viewModel[@"value"])) {
        self.textField.text = viewModel[@"value"];
        
        if ([self.valueDictionary[@"num"] integerValue] == 0) {
            [JHGoodManagerSingleton shared].startAuctionPrice = self.textField.text;
        }
        else if ([self.valueDictionary[@"num"] integerValue] == 1) {
            [JHGoodManagerSingleton shared].addAuctionPrice = self.textField.text;
        }
        else if ([self.valueDictionary[@"num"] integerValue] == 2) {
            [JHGoodManagerSingleton shared].sureMoney = self.textField.text;
        }
    }
}




@end
