//
//  JHC2CKeyBoardView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CKeyBoardView.h"
#import "IQKeyboardManager.h"

@interface JHC2CKeyBoardView()
@property(nonatomic, strong) UIView * inputView;
@property(nonatomic, strong) UITextField * priceTFd;
@end

@implementation JHC2CKeyBoardView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:UIScreen.mainScreen.bounds];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = HEXCOLORA(0x000000, 0.4);
    [self addSubview:self.inputView];
    [self.inputView addSubview:self.priceTFd];
}

- (void)layoutItems{
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(@0);
        make.height.mas_equalTo(210);
    }];
    [self.priceTFd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(@0).inset(20);
        make.height.mas_equalTo(50);
    }];

}

- (UIView *)inputView{
    if (!_inputView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _inputView = view;
    }
    return _inputView;
}
- (UITextField *)priceTFd{
    if (!_priceTFd) {
        UITextField *tfd = [UITextField new];
        tfd.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        tfd.autocorrectionType = UITextAutocorrectionTypeNo;
        tfd.spellCheckingType = UITextSpellCheckingTypeNo;
        tfd.returnKeyType = UIReturnKeyDone;
        tfd.inputAccessoryView = [UIView new];
        _priceTFd = tfd;
    }
    return _priceTFd;
}

@end
