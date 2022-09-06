//
//  JHSearchView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSearchView.h"

@interface JHSearchView ()
{
    JHSearchShowType showType;
}

@property (nonatomic, strong) JHTextField* searchField;
@property (nonatomic, strong) UIButton* rightButton;
@property (nonatomic, strong) UIButton* forbiddenView;
@end

@implementation JHSearchView

- (void)dealloc
{
    DDLogInfo(@"JHSearchView~~~dealloc");
}

- (instancetype)initWithShow:(JHSearchShowType)type
{
    if(self = [super init])
    {
        showType = type;
        [self resetSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLOR(0xFFFFFF);
        CGFloat rightButtonWidth = 50;
        self.searchField = [[JHTextField alloc] init];
        self.searchField.delegate = self;
        [self addSubview:_searchField];
        [_searchField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 15, 5, 10 + rightButtonWidth + 15));
        }];
        
        //搜索框右侧按钮
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(pressRightButton) forControlEvents:UIControlEventTouchUpInside];
        _rightButton.backgroundColor = [UIColor clearColor];
        [self addSubview:_rightButton];
        //订制化
        [_rightButton setTitle:@"全部" forState:UIControlStateNormal];
        _rightButton.layer.borderColor = kGlobalThemeColor.CGColor;
        _rightButton.layer.borderWidth = 1;
        _rightButton.layer.cornerRadius = 15.0;
        _rightButton.layer.masksToBounds = YES;
        _rightButton.titleLabel.font =JHFont(12);
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self).offset(5);
            make.size.mas_equalTo(CGSizeMake(rightButtonWidth, 30));
        }];
    }
    
    return self;
}

- (void)resetSubviews
{
    if(showType >= JHSearchShowTypeRightCancel)
    {
        CGFloat rightButtonWidth = 26;
        _searchField.backgroundColor = HEXCOLOR(0xF5F6FA);
        _searchField.font = JHFont(13);
        _searchField.textColor = RGB515151;
        _searchField.placeholder = @"搜索话题";
        [_searchField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(5, 0, 5, 15 + rightButtonWidth + 15));
        }];
        //搜索框右侧按钮
        if(showType == JHSearchShowTypeRightFinish)
            [_rightButton setTitle:@"完成" forState:UIControlStateNormal];
        else
            [_rightButton setTitle:@"取消" forState:UIControlStateNormal];
        _rightButton.titleLabel.font =JHMediumFont(13);
        _rightButton.layer.borderColor = [UIColor clearColor].CGColor;
        _rightButton.layer.borderWidth = 0;
        _rightButton.layer.cornerRadius = 0;
        _rightButton.layer.masksToBounds = NO;
        [_rightButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self.searchField).offset(0);
            make.size.mas_equalTo(CGSizeMake(26, 18));
        }];
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    if(_searchField)
    {
        _searchField.placeholder = placeholder;
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    if(_searchField)
    {
        _searchField.text = _text;
    }
}
- (UIButton *)forbiddenView
{
    if(!_forbiddenView)
    {
        _forbiddenView = [UIButton buttonWithType:UIButtonTypeCustom];
        _forbiddenView.backgroundColor = [UIColor clearColor];
        _forbiddenView.origin = CGPointZero;
        [_forbiddenView addTarget:self action:@selector(dismissSearchKeyboard) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _forbiddenView;
}

- (void)forbiddenViewHidden:(BOOL)isHidden
{
    if(isHidden)
    {
        [_forbiddenView removeFromSuperview];
    }
    else
    {
        self.forbiddenView.origin = CGPointMake(0, self.bottom);
        self.forbiddenView.size = self.superview.size;
        [self.superview addSubview:_forbiddenView];
        [self.superview bringSubviewToFront:_forbiddenView];
    }
}

- (void)dismissSearchKeyboard
{
    [_searchField resignFirstResponder];
}

- (void)showSearchKeyboard
{
    [_searchField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    [self startSearchKeyword:textField.text];
    return YES;
}

/*
 区分直播间 发消息键盘 还是其他键盘
 YES 表示不是直播间发消息的键盘
 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self forbiddenViewHidden:NO];
    if([self.delegate respondsToSelector:@selector(searchViewBeginEditing:)])
    {
        [self.delegate searchViewBeginEditing:YES];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendOrderKeyBoard object:@(YES)];
    return YES;
}
/*
区分直播间 发消息键盘 还是其他键盘
 标志复原
*/
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self forbiddenViewHidden:YES];
    if([self.delegate respondsToSelector:@selector(searchViewBeginEditing:)])
    {
        [self.delegate searchViewBeginEditing:NO];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendOrderKeyBoard object:@(NO)];
    
    return YES;
}

- (void)textFieldChanged:(UITextField *)field
{
    NSString *changeText = field.text;
    if([self.delegate respondsToSelector:@selector(searchViewChangeText:)])
    {
        [self.delegate searchViewChangeText:changeText];
    }
}
//- (BOOL)becomeFirstResponder
//{
//    [self.forbiddenView addGestureRecognizer:_tap];
//    return [super becomeFirstResponder];
//}
//
//- (BOOL)resignFirstResponder
//{
//    [self.forbiddenView removeGestureRecognizer:_tap];
//    return [super resignFirstResponder];
//}

#pragma mark - events
- (void)pressRightButton
{
    _searchField.text = @"";
    if(showType == JHSearchShowTypeRightSearchAll)
    {
        [self startSearchKeyword:@""];
    }
    else
    {
        [self dismissSearchKeyboard];
        [self activeButtonEvents:showType keyword:nil];
    }
}

- (void)startSearchKeyword:(NSString*)keyword
{
    [self dismissSearchKeyboard];
    if(self.searchAction)
          self.searchAction(keyword ? : @"");
    else
        [self activeButtonEvents:JHSearchShowTypeRightSearchAll keyword:keyword ? : @""];
}

- (void)activeButtonEvents:(JHSearchShowType)type keyword:(NSString*)keyword
{
    if([self.delegate respondsToSelector:@selector(activeButtonEvents:keyword:)])
    {
        [self.delegate activeButtonEvents:type keyword:keyword];
    }
}

@end
