//
//  JHInputTextView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "NOSUrlCode.h"
#import "JHInputTextView.h"

@interface JHInputTextView ()<UITextViewDelegate>

@property (nonatomic, weak) UITextView *inputTextView;

@property (nonatomic, weak) UIButton *sendButton;

@property (nonatomic, weak) UILabel *wordsNumberLabel;

///控件高度
@property (nonatomic, assign) CGFloat allHeight;

@property (nonatomic, weak) UIView *whiteView;

@end


@implementation JHInputTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        _maxWordsNumber = 200;
        _maxHeight = 50;
        @weakify(self);
        [self jh_addTapGesture:^{
            @strongify(self);
            [self endEditing:YES];
            [self removeFromSuperview];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self addSelfSubViews];
//        });
    }
    return self;
}

- (void)addSelfSubViews
{
    _whiteView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
    [_whiteView jh_addTapGesture:^{}];
    
    UIView *bgView = [UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:_whiteView];
    [bgView jh_cornerRadius:17];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.whiteView).insets(UIEdgeInsetsMake(12, 5, 12, 70));
    }];
    
    UITextView *inputTextView = [UITextView new];
    [bgView addSubview:inputTextView];
    inputTextView.delegate = self;
    inputTextView.returnKeyType = UIReturnKeySend;
    inputTextView.font = [UIFont systemFontOfSize:13];
    inputTextView.backgroundColor = UIColor.clearColor;
    [inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bgView).insets(UIEdgeInsetsMake(2, 10, 2, 53));
        make.height.mas_equalTo(30);
    }];
    _inputTextView = inputTextView;
    
    _wordsNumberLabel = [UILabel jh_labelWithFont:11 textColor:RGB153153153 textAlignment:2 addToSuperView:bgView];
    [_wordsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bgView).offset(-5);
        make.top.equalTo(bgView).offset(10);
    }];
    
    _sendButton = [UIButton jh_buttonWithTitle:@"发送" fontSize:12 textColor:UIColor.blackColor target:self action:@selector(sendMessage) addToSuperView:self.whiteView];
    [_sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.inputTextView);
        make.right.equalTo(self.whiteView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(54, 26));
    }];
    [_sendButton jh_cornerRadius:13];
    [self showSendButtonCanSend:NO];
    
    _allHeight = 58;
    
    @weakify(self);
    [[RACObserve(self.inputTextView, contentSize) map:^id _Nullable(id  _Nullable value) {
        CGSize size = [value CGSizeValue];
        CGFloat textHeight = abs((int)size.height);
        //一行高度过大
        ///最少一行 20      最多三行 50
        CGFloat height = MAX(20.f, MIN(textHeight, self.maxHeight));
        return @(height);
    }] subscribeNext:^(id  _Nullable x) {
        CGFloat height = [x floatValue];
        _allHeight = 28 + height;
        @strongify(self);
        [self.inputTextView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height);
        }];
    }];
    
    ///字数
    RAC(self.wordsNumberLabel, text) = [self.inputTextView.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        NSInteger num = value.length;
        @strongify(self);
        [self showSendButtonCanSend:(num > 0 && num <= self.maxWordsNumber)];
        return [NSString stringWithFormat:@"%@/%@",@(num),@(self.maxWordsNumber)];
    }] ;
    
    ///字色
    RAC(_wordsNumberLabel, textColor) = [self.inputTextView.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
        return value.length > self.maxWordsNumber ? RGB(255, 66, 0) : RGB153153153;
    }];
}

- (void)sendMessage
{
    if([_inputTextView hasText] && _inputTextViewBlock)
    {
        _inputTextViewBlock(_inputTextView.text);
    }
}
- (void)starInput
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_inputTextView becomeFirstResponder];
    });
}

- (void)showSendButtonCanSend:(BOOL)canSend
{
    _sendButton.enabled = canSend;
    [_sendButton setBackgroundImage:canSend ? JHImageNamed(@"publish_button") : nil forState:UIControlStateNormal];
    [_sendButton setTitleColor:canSend ? UIColor.blackColor : RGB153153153 forState:UIControlStateNormal];
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
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(-keyboardRect.size.height);
        }];
        [self layoutIfNeeded];
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:0.3 animations:^{
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
        }];
        [self layoutIfNeeded];
    }];
    
    [self removeFromSuperview];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self sendMessage];
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[self class]]) {
        return YES;
    }
    return NO;
}


@end
