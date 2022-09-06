//
//  JHUnionPayFooter.m
//  TTjianbao
//
//  Created by lihui on 2020/4/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionPayFooter.h"

@interface JHUnionPayFooter ()

@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *messageLabel;  ///提示信息label

@end

@implementation JHUnionPayFooter

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    [_doneButton setTitle:_buttonTitle forState:UIControlStateNormal];
}

- (void)setInfoText:(NSString *)infoText {
    _infoText = infoText;
    _infoLabel.text = _infoText;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    _messageLabel.text = _message;
}

- (void)initViews {
    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.backgroundColor = HEXCOLOR(0xFEE100);
    [_doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _doneButton.titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:18.f];
    [self addSubview:_doneButton];
    [_doneButton addTarget:self action:@selector(nextStep:) forControlEvents:UIControlEventTouchUpInside];
    
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.text = @"本操作将严格保护您的隐私安全，请放心操作";
    _infoLabel.font = [UIFont fontWithName:kFontNormal size:12];
    _infoLabel.textColor = HEXCOLOR(0x999999);
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_infoLabel];
    
    _messageLabel = [[UILabel alloc] init];
    _messageLabel.text = @"";
    _messageLabel.font = [UIFont fontWithName:kFontMedium size:12];
    _messageLabel.textColor = HEXCOLOR(0xFF7875);
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_messageLabel];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self).offset(-12-UI.bottomSafeAreaHeight);
    }];
    
    [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self.infoLabel.mas_top).offset(-12);
        make.height.mas_equalTo(44);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self);
        make.bottom.equalTo(self.doneButton.mas_top).offset(-10);
    }];
    
    [_doneButton layoutIfNeeded];
    _doneButton.layer.cornerRadius = _doneButton.height/2;
    _doneButton.layer.masksToBounds = YES;
}

#pragma mark -
#pragma mark - button action method

- (void)nextStep:(UIButton *)sender {
    if (self.doneBlock) {
        self.doneBlock();
    }
}

@end
