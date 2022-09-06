//
//  JHCustomerFeeEditToolView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerFeeEditToolView.h"
#import "JHCustomerFeeEditModel.h"
#import "IQKeyboardManager.h"
@interface JHCustomerFeeEditToolView ()

@property (nonatomic, weak) UITextField *maxTf;

@property (nonatomic, weak) UITextField *minTf;

@property (nonatomic, weak) UIView *toolView;

@end

@implementation JHCustomerFeeEditToolView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        [self addSelfSubViews];
        
        [[IQKeyboardManager sharedManager] setEnable:NO];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
        @weakify(self);
        [self jh_addTapGesture:^{
            @strongify(self);
            [self endEditing:YES];
        }];
    }
    return self;
}

-(void)addSelfSubViews
{
    _toolView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.size.mas_equalTo([self viewSize]);
    }];
    UIButton *button = [UIButton jh_buttonWithTitle:@"确定" fontSize:12 textColor:RGB515151 target:self action:@selector(makeSureMethod) addToSuperView:_toolView];
    [button setBackgroundImage:JHImageNamed(@"customize_price_makesure") forState:UIControlStateNormal];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54, 26));
        make.right.equalTo(self.toolView).offset(-5);
        make.centerY.equalTo(self.toolView);
    }];
    
    _minTf = [self textFieldWithPlaceholder:@"最低价"];
    [_minTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolView).offset(20);
    }];
    
    _maxTf = [self textFieldWithPlaceholder:@"最高价"];
    [_maxTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minTf.mas_right).offset(65);
    }];
    
    UILabel *label1 = [UILabel jh_labelWithText:@"元 ~" font:15 textColor:RGB515151 textAlignment:1 addToSuperView:self.toolView];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minTf);
        make.right.centerY.equalTo(self.maxTf);
    }];
    
    UILabel *label2 = [UILabel jh_labelWithText:@"元" font:15 textColor:RGB515151 textAlignment:1 addToSuperView:self.toolView];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.maxTf.mas_right).offset(15);
        make.centerY.equalTo(self.maxTf);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_minTf becomeFirstResponder];
    });
}

-(void)makeSureMethod
{
    NSInteger min = self.minTf.text.integerValue;
    NSInteger max = self.maxTf.text.integerValue;
    if(![self.minTf hasText] || ![self.minTf hasText] || (min == max))
    {
        JHTOAST(@"请输入正确金额");
    }
    else if(_callBalckBlock)
    {
        if(min < max)
        {
            _callBalckBlock(self.minTf.text,self.maxTf.text);
        }
        else
        {
            _callBalckBlock(self.maxTf.text,self.minTf.text);
        }
    }
    
}

-(void)setModel:(JHCustomerFeeEditModel *)model
{
    _model = model;
    
    _minTf.text = @(_model.minPrice).stringValue;
    
    _maxTf.text = @(_model.maxPrice).stringValue;
}

- (UITextField*)textFieldWithPlaceholder:(NSString *)placeholder
{
    UIView *bgView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self.toolView];
    [bgView jh_cornerRadius:4 borderColor:RGB(199, 199, 199) borderWidth:1];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([self textFieldHeight]);
        make.centerY.equalTo(self.toolView);
    }];
    
    UITextField* textField = [[UITextField alloc] init];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.font = JHFont(15);
    textField.textColor = RGB515151;
    textField.placeholder = placeholder;
    [bgView addSubview:textField];
    [textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if([textField.text hasPrefix:@"0"] && textField.text.length > 1)
        {
            textField.text = [textField.text substringFromIndex:1];
        }
    }];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
    return textField;
}

-(CGSize)textFieldHeight
{
    return CGSizeMake(109 + (ScreenW - 375.0)/2.0, 38);
}

- (CGSize)viewSize
{
    return CGSizeMake(ScreenW, 58);
}

#pragma mark -------- 键盘 --------
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:0.3 animations:^{
        [self.toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-keyboardRect.size.height);
        }];
        [self layoutIfNeeded];
    }];
    
}

-(void)keyboardWillHide
{
    [self removeFromSuperview];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
