//
//  JHLabelAndTFView.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLabelAndTFView.h"
#import "JHLine.h"

@interface JHLabelAndTFView()
@property (nonatomic, strong) UILabel *userNamelabel;
@property (nonatomic, strong) UITextField *accountTF;
@property (nonatomic, strong) JHCustomLine *line;

@end

@implementation JHLabelAndTFView

- (instancetype)initWithLabel:(NSString *)lbStr TFPlaceHolder:(NSString *)tfPlaceHoldStr TFText:(NSString *)tfStr {
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        
        [self addSubview:self.userNamelabel];
        [self addSubview:self.accountTF];
        
        [self.userNamelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).offset(15);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(100.f);
        }];
        
        [self.accountTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.userNamelabel.mas_right).offset(10);
            make.right.mas_equalTo(self);
            make.centerY.mas_equalTo(self);
            make.top.bottom.mas_equalTo(self);
        }];
        
        _line = [[JHCustomLine alloc] init];;
        [self addSubview:_line];
        
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.height.mas_equalTo(.5f);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        self.userNamelabel.text = lbStr;
        self.accountTF.placeholder = tfPlaceHoldStr;
        self.accountTF.text = tfStr;
    }
    return  self;
}

- (void)setLabelAlignmentStyle:(AlignmentStyleType)alignmentStyleType {
    switch (alignmentStyleType) {
        case AlignmentStyleTypeDefault:
            self.userNamelabel.textAlignment = NSTextAlignmentLeft;
            break;
        case AlignmentStyleTypeRight:
            self.userNamelabel.textAlignment = NSTextAlignmentRight;
            break;
        default:
            break;
    }
}

- (NSString *)getTFText {
    return self.accountTF.text;
}

- (void)setTFEnabled:(Boolean)TFEnabled {
    _TFEnabled = TFEnabled;
    self.accountTF.userInteractionEnabled = _TFEnabled;
}

- (void)setIsShowLine:(Boolean)isShowLine {
    _isShowLine = isShowLine;
    self.line.hidden = !_isShowLine;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    _accountTF.keyboardType = _keyboardType;
}

- (UILabel *)userNamelabel {
    if (!_userNamelabel) {
        _userNamelabel = [[UILabel alloc] init];
        _userNamelabel.numberOfLines = 1;
        [_userNamelabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        _userNamelabel.textAlignment = UIControlContentHorizontalAlignmentCenter;
        _userNamelabel.lineBreakMode = NSLineBreakByWordWrapping;
        _userNamelabel.font=[UIFont systemFontOfSize:15.f];
        _userNamelabel.textColor = HEXCOLOR(0x333333);
    }
    return _userNamelabel;
}

- (UITextField *)accountTF {
    if (!_accountTF) {
        _accountTF = [[UITextField alloc]init];
        _accountTF.backgroundColor = [UIColor clearColor];
        _accountTF.tag=1;
        _accountTF.tintColor = HEXCOLOR(0xfee200);
        _accountTF.returnKeyType = UIReturnKeyDone;
        _accountTF.userInteractionEnabled = YES;
        _accountTF.font = [UIFont systemFontOfSize:16.f];
    }
    return _accountTF;
}

@end
