//
//  JHUserAuthVerificationView.m
//  TTjianbao
//
//  Created by wangjianios on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHUserAuthVerificationView.h"
#import "UIView+JHGradient.h"

@interface JHUserAuthVerificationView ()

@property (nonatomic, weak) UITextField *codeTf;

@property (nonatomic, weak) UILabel *codeLabel;

@property (nonatomic, copy) dispatch_block_t completeBlock;

@end


@implementation JHUserAuthVerificationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews {
    
    UIView *whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [whiteView jh_cornerRadius:8];
    [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(260, 247));
    }];
    
    UIButton *closeButton = [UIButton jh_buttonWithImage:@"my_center_user_auth_close" target:self action:@selector(removeFromSuperview) addToSuperView:whiteView];
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(44);
        make.right.top.equalTo(whiteView);
    }];
    
    UILabel *label = [UILabel jh_labelWithBoldText:@"安全验证" font:18 textColor:RGB515151 textAlignment:1 addToSuperView:whiteView];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(whiteView).offset(32);
        make.centerX.equalTo(whiteView);
    }];
    
    UILabel *label2 = [UILabel jh_labelWithText:@"输入验证码查看证件信息" font:13 textColor:RGB515151 textAlignment:1 addToSuperView:whiteView];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(15);
        make.centerX.equalTo(whiteView);
        make.height.mas_equalTo(20);
    }];
    
    _codeTf = [UITextField jh_textFieldWithFont:20 textAlignment:1 textColor:RGB515151 addToSupView:whiteView];
    _codeTf.keyboardType = UIKeyboardTypeNumberPad;
    [_codeTf jh_cornerRadius:4 borderColor:RGB(211, 211, 211) borderWidth:1];
    [_codeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(whiteView).offset(20);
        make.top.equalTo(label2.mas_bottom).offset(17);
        make.size.mas_equalTo(CGSizeMake(122, 36));
    }];
    
    _codeLabel = [UILabel jh_labelWithText:@"7439" font:20 textColor:RGB515151 textAlignment:1 addToSuperView:whiteView];
    _codeLabel.backgroundColor = RGB(211,211,211);
    [_codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.equalTo(self.codeTf);
        make.left.equalTo(self.codeTf.mas_right).offset(10.f);
        make.right.equalTo(whiteView).offset(-20);
    }];
    
    UIButton *changeButton = [UIButton jh_buttonWithTitle:@"看不清？换一张" fontSize:12 textColor:RGB153153153 target:self action:@selector(getRangeCodeStr) addToSuperView:whiteView];
    [changeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.codeLabel.mas_bottom).offset(5);
        make.centerX.width.equalTo(self.codeLabel);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *button = [UIButton jh_buttonWithTitle:@"确定" fontSize:15 textColor:RGB515151 target:self action:@selector(doneMethod) addToSuperView:whiteView];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(whiteView).offset(-20);
        make.centerX.equalTo(whiteView);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    [button jh_cornerRadius:20];
    [button jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFED73A), HEXCOLOR(0xFECB33)] locations:@[@0, @1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    
    [self getRangeCodeStr];
}

- (void)getRangeCodeStr {
    int num = arc4random() % 10000;
    self.codeLabel.text = [NSString stringWithFormat:@"%.4d",num];
}

- (void)doneMethod {
    if([self.codeLabel.text isEqualToString:self.codeTf.text]) {
        if(_completeBlock) {
            _completeBlock();
        }
        [self removeFromSuperview];
    }
    else {
        JHTOAST(@"验证码错误");
        [self getRangeCodeStr];
    }
}

+ (void)showWithCompleteBlock:(dispatch_block_t)completeBlock {
    JHUserAuthVerificationView *view = [JHUserAuthVerificationView new];
    [JHKeyWindow addSubview:view];
    view.frame = JHKeyWindow.bounds;
    view.completeBlock = completeBlock;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
