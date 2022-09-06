//
//  JHNewStoreSearchResultFilterMenuView.m
//  TTjianbao
//
//  Created by hao on 2021/8/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSearchResultFilterMenuView.h"

@interface JHNewStoreSearchResultFilterMenuView ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) CGFloat beganPointX;
@property (nonatomic, strong) UIView *serviceView;
@property (nonatomic, assign) NSInteger serviceIndex;
@property (nonatomic, strong) UIView *priceView;
@property (nonatomic, strong) UITextField *lowTextField;
@property (nonatomic, strong) UITextField *highTextField;
@property (nonatomic, assign) BOOL isFilteredInfo;

@end

@implementation JHNewStoreSearchResultFilterMenuView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        [self initSubviews];

    }
    return self;
}

#pragma mark - UI
- (void)initSubviews{
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.width.mas_equalTo(ScreenWidth-45);
        make.left.equalTo(self).offset(ScreenWidth);
    }];
    
    self.serviceIndex = 0;
    //服务
    [self setupServiceView];
    //价格
    [self setupPriceView];
    //底部按钮
    [self setupBottomView];
    
    UIView *shadowView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self];
    [shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(45);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBackView)];
    [shadowView addGestureRecognizer:tap];
    
}
- (void)setupServiceView{
    //服务
    [self.bgView addSubview:self.serviceView];
    [self.serviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(60);
        make.top.equalTo(self.bgView).offset(UI.topSafeAreaHeight+13);
    }];
    UILabel *titleLabel = [UILabel jh_labelWithText:@"服务" font:13 textColor:HEXCOLOR(0x333333) textAlignment:NSTextAlignmentLeft addToSuperView:self.serviceView];
    titleLabel.font = JHBoldFont(13);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serviceView).offset(18);
        make.top.equalTo(self.serviceView);
    }];
//    NSArray *serviceBtnArray = @[@"商家直发",@"平台鉴定"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"平台鉴定" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF7F7F8)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF7F7F8)] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFD70F)] forState:UIControlStateSelected];
    [btn jh_cornerRadius:15];
    btn.titleLabel.font = JHFont(13);
    btn.tag = 100;
    [btn addTarget:self action:@selector(clickServiceBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.serviceView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(12);
        make.size.mas_equalTo(CGSizeMake(90, 30));
        make.left.equalTo(self.serviceView).offset(18 );
    }];
    
}

- (void)setupPriceView{
    //价格
    [self.bgView addSubview:self.priceView];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bgView);
        make.height.mas_equalTo(60);
        make.top.equalTo(self.serviceView.mas_bottom).offset(20);
    }];
    UILabel *titleLabel = [UILabel jh_labelWithText:@"价格区间" font:13 textColor:HEXCOLOR(0x333333) textAlignment:NSTextAlignmentLeft addToSuperView:self.priceView];
    titleLabel.font = JHBoldFont(13);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceView).offset(18);
        make.top.equalTo(self.priceView);
    }];

    [self.priceView addSubview:self.lowTextField];
    [self.lowTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceView).offset(18);
        make.size.mas_offset(CGSizeMake((ScreenWidth-45-3*18)/2, 30));
        make.top.equalTo(titleLabel.mas_bottom).offset(12);
    }];
    UIView *line = [UIView new];
    line.backgroundColor = HEXCOLOR(0x999999);
    [self.priceView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lowTextField.mas_right).offset(5);
        make.size.mas_offset(CGSizeMake(8, 1));
        make.centerY.equalTo(self.lowTextField);
    }];

    [self.priceView addSubview:self.highTextField];
    [self.highTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceView).offset(-18);
        make.size.mas_offset(CGSizeMake((ScreenWidth-45-3*18)/2, 30));
        make.top.equalTo(self.lowTextField);
    }];
    
    
}

- (void)setupBottomView{
    NSArray *bottomArray = @[@"重置",@"确定"];
    for (int i = 0; i < bottomArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:bottomArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font = JHFont(13);
        btn.tag = 200+i;
        [btn addTarget:self action:@selector(clickBottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgView).offset(-UI.bottomSafeAreaHeight);
            make.size.mas_equalTo(CGSizeMake((ScreenWidth-45)/bottomArray.count, 44));
            make.left.equalTo(self.bgView).offset(((ScreenWidth-45)/bottomArray.count)*i);
        }];
        if (i == 0) {
            [btn setBackgroundColor:HEXCOLOR(0xF7F7F8)];
        } else {
            [btn setBackgroundColor:HEXCOLOR(0xFEE100)];
        }

    }
}

#pragma mark - LoadData


#pragma mark - Action
- (void)tapBackView{
    [self keyboardHide];
    [self dismiss];
}
- (void)keyboardHide {
    [self endEditing:YES];
}

///筛选点击
- (void)clickServiceBtnAction:(UIButton *)sender{
    [self keyboardHide];
    self.isFilteredInfo = YES;
    sender.selected = !sender.selected;
    //平台鉴定
    self.serviceIndex = sender.selected ? 1 : 0;

}
///底部按钮重置、确定
- (void)clickBottomBtnAction:(UIButton *)sender{
    NSInteger index = sender.tag - 200;
    //重置
    if (index == 0) {
        if (self.serviceIndex > 0 || self.lowTextField.text.length > 0 || self.highTextField.text.length > 0) {
            [self clearHistory];
            if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewSelectedOfService:lowPrice:highPrice:isFilteredInfo:)]) {
                [self.delegate filterViewSelectedOfService:self.serviceIndex lowPrice:self.lowTextField.text highPrice:self.highTextField.text isFilteredInfo:self.isFilteredInfo];
            }
        }
    }
    //确定
    else {
        [self dismiss];
    }
    
}
///清除历史
- (void)clearHistory{
    int count = 2;
    for (int i = 0; i < count; i++) {
        UIButton *selectBtn = [self viewWithTag:100+i];
        selectBtn.selected = NO;
    }
    self.serviceIndex = 0;
    self.lowTextField.text = @"";
    self.highTextField.text = @"";
}

- (void)show {
    if (self.serviceIndex > 0 || self.lowTextField.text.length > 0 || self.highTextField.text.length > 0) {
        self.isFilteredInfo = YES;
    }else {
        self.isFilteredInfo = NO;
    }
    self.hidden = NO;
    [self.bgView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(45);
        }];
        [self.bgView.superview layoutIfNeeded];
    }];

}

- (void)dismiss {
    if (self.lowTextField.text.length > 0 &&  self.highTextField.text.length > 0 && [self.lowTextField.text integerValue] > [self.highTextField.text integerValue]) {
        NSString *exchangeStr = self.lowTextField.text;
        self.lowTextField.text = self.highTextField.text;
        self.highTextField.text = exchangeStr;
    }
    [self.bgView updateConstraintsIfNeeded];
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = RGBA(0, 0, 0, 0.0);
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(ScreenWidth);
        }];
        [self.bgView.superview layoutIfNeeded];

    } completion:^(BOOL finished) {
        self.hidden = YES;
        if (self.delegate && [self.delegate respondsToSelector:@selector(filterViewSelectedOfService:lowPrice:highPrice:isFilteredInfo:)]) {
            [self.delegate filterViewSelectedOfService:self.serviceIndex lowPrice:self.lowTextField.text highPrice:self.highTextField.text isFilteredInfo:self.isFilteredInfo];
        }
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self keyboardHide];
    //获取触摸开始的坐标
    CGPoint beganPoint = [[touches anyObject] locationInView:self];
    self.beganPointX = beganPoint.x;

}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint endedPoint = [[touches anyObject] locationInView:self];
    
    //向右滑动隐藏
    if (endedPoint.x - self.beganPointX > 100) {
        [self keyboardHide];
        [self dismiss];
    }

}


#pragma mark - Delegate
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.isFilteredInfo = YES;

    int lengthInt = (int)range.length;
    int locationInt = (int)range.location;
    if (locationInt-lengthInt < 9-1) {//最多8位
        return YES;
    }
    
    return NO;
}


#pragma mark - Lazy
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}
- (UIView *)serviceView{
    if (!_serviceView) {
        _serviceView = [UIView new];
        _serviceView.backgroundColor = UIColor.whiteColor;
    }
    return _serviceView;
}
- (UIView *)priceView{
    if (!_priceView) {
        _priceView = [UIView new];
        _priceView.backgroundColor = UIColor.whiteColor;
    }
    return _priceView;
}
- (UITextField *)lowTextField{
    if (!_lowTextField) {
        _lowTextField = [UITextField new];
        _lowTextField.placeholder = @"最低价";
        _lowTextField.font = JHFont(13);
        _lowTextField.textAlignment = NSTextAlignmentCenter;
        _lowTextField.textColor = HEXCOLOR(0x333333);
        _lowTextField.backgroundColor = HEXCOLOR(0xF7F7F8);
        _lowTextField.delegate = self;
        [_lowTextField jh_cornerRadius:15];
        _lowTextField.keyboardType = UIKeyboardTypeNumberPad;
        _lowTextField.attributedPlaceholder=[[NSAttributedString alloc]initWithString:_lowTextField.placeholder attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xBDBFC2)}];
    }
    return _lowTextField;
}
- (UITextField *)highTextField{
    if (!_highTextField) {
        _highTextField = [UITextField new];
        _highTextField.placeholder = @"最高价";
        _highTextField.font = JHFont(13);
        _highTextField.textAlignment = NSTextAlignmentCenter;
        _highTextField.textColor = HEXCOLOR(0x333333);
        _highTextField.backgroundColor = HEXCOLOR(0xF7F7F8);
        _highTextField.delegate = self;
        [_highTextField jh_cornerRadius:15];
        _highTextField.keyboardType = UIKeyboardTypeNumberPad;
        _highTextField.attributedPlaceholder=[[NSAttributedString alloc]initWithString:_highTextField.placeholder attributes:@{NSForegroundColorAttributeName:HEXCOLOR(0xBDBFC2)}];
    }
    return _highTextField;
}
@end
