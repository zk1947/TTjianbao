//
//  JHStoneBaseView.m
//  TTjianbao
//
//  Created by mac on 2019/11/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneBaseView.h"

@interface JHStoneBaseView ()

@end

@implementation JHStoneBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self makeUI];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeUI];
    }
    return self;
}


- (UIView *)backView {
    if (!_backView) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 4;
        _backView.layer.masksToBounds = YES;
    }
    
    return _backView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [JHUIFactory createLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontMedium size:15] textAlignment:NSTextAlignmentCenter];
    }
    
    return _titleLabel;
}


- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setTitle:@"×" forState:UIControlStateNormal];
        [_closeBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.titleLabel.font = [UIFont systemFontOfSize:25];
    }
    
    return _closeBtn;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
    
        _okBtn = [JHUIFactory createThemeBtnWithTitle:@"" cornerRadius:20 target:self action:@selector(okAction)];
        
    }
    return _okBtn;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
    
        _cancelBtn = [JHUIFactory createThemeTwoBtnWithTitle:@"" cornerRadius:20 target:self action:@selector(cancelAction)];
        
    }
    return _cancelBtn;
}


- (void)okAction {
    [self closeAction];
}

- (void)cancelAction {
    [self closeAction];
}

- (void)closeAction {
    [self hiddenAlert];
}

- (void)makeUI {
    self.backgroundColor = HEXCOLORA(0x000000, 0.3);
    [self addSubview:self.backView];
    [self.backView addSubview:self.titleLabel];
    [self.backView addSubview:self.okBtn];
    [self.backView addSubview:self.closeBtn];

    JHCustomLine *line = [JHUIFactory createLine];
    [self.backView addSubview:line];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-40);
        make.width.equalTo(@(ScreenW-58*2));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.backView).offset(0);
        make.height.equalTo(@(49));
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.height.offset(1);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];
    
    
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.trailing.equalTo(self.backView);
        make.height.width.equalTo(@44);
    }];
}


- (void)style1 {
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
        make.leading.equalTo(self.backView).offset(36);
        make.trailing.equalTo(self.backView).offset(-36);
        make.bottom.equalTo(self.backView).offset(-20);
        
    }];
    
}

- (void)style2 {

    [self.backView addSubview:self.cancelBtn];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backView).offset(25);
        make.width.equalTo(self.okBtn);
        make.trailing.equalTo(self.okBtn.mas_leading).offset(-10);
        make.top.bottom.equalTo(self.okBtn);

    }];
    
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.backView).offset(-25);
        make.bottom.equalTo(self.backView).offset(-20);
        make.height.equalTo(@(40));

    }];

    
}

- (void)showAlert {

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGRect rect = self.frame;
    self.mj_y = ScreenH;
    if (rect.size.width<ScreenW) {
        rect.origin.y = ScreenH - rect.size.height - 49;
        
    }else {
        rect.origin.y = ScreenH - rect.size.height;
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
    

}

- (void)showAlertWithView:(UIView *)view {

    [view addSubview:self];
    CGRect rect = self.frame;
    self.mj_y = ScreenH;
    if (rect.size.width<ScreenW) {
        rect.origin.y = ScreenH - rect.size.height - 49;
        
    }else {
        rect.origin.y = ScreenH - rect.size.height;
    }
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
    

}

- (void)hiddenAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end
