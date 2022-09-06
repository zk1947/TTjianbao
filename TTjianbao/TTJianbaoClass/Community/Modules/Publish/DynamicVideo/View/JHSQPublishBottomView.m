//
//  JHSQPublishBottomView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQPublishBottomView.h"
#import "JHPublishTopicDetailModel.h"
#import "JHGrowingIO.h"

@interface JHSQPublishBottomView ()

@property (nonatomic, weak) UIButton *addPhotoButton;

@property (nonatomic, weak) UIButton *keybordSwitchButton;

@property (nonatomic, weak) UIButton *callUserListButton;

@property (nonatomic, weak) UIButton *doneButton;

@property (nonatomic, weak) UILabel *wordsNumberLabel;

@end


@implementation JHSQPublishBottomView

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addUI];
        self.backgroundColor = UIColor.redColor;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)addUI
{
    [[UIView jh_viewWithColor:APP_BACKGROUND_COLOR addToSuperview:self] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    
    _keybordSwitchButton = [UIButton jh_buttonWithImage:@"emojiIcon" target:self action:@selector(changeKeyboardTo:) addToSuperView:self];
    [_keybordSwitchButton setImage:[UIImage imageNamed:@"keybordIcon"] forState:UIControlStateSelected];
    [_keybordSwitchButton setBackgroundImage:[UIImage new] forState:UIControlStateDisabled];
    [_keybordSwitchButton addTarget:self action:@selector(changeKeyboardTo:) forControlEvents:UIControlEventTouchUpInside];
    _keybordSwitchButton.selected = NO;
    [self addSubview:_keybordSwitchButton];
    [_keybordSwitchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(7.f);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    _addPhotoButton = [UIButton jh_buttonWithImage:JHImageNamed(@"publish_album_icon") target:self action:@selector(addPhotosAction) addToSuperView:self];
    [_addPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(self.keybordSwitchButton);
        make.left.equalTo(self.keybordSwitchButton.mas_right).offset(7.0);
    }];
    
    _callUserListButton = [UIButton jh_buttonWithImage:JHImageNamed(@"icon_input_aite") target:self action:@selector(callUserListAction) addToSuperView:self];
    [_callUserListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.height.width.equalTo(self.addPhotoButton);
        make.left.equalTo(self.addPhotoButton.mas_right).offset(7.0);
    }];
}

-(void)setShowDoneButton:(BOOL)showDoneButton
{
    _showDoneButton = showDoneButton;
    if(_showDoneButton)
    {
        _doneButton = [UIButton jh_buttonWithTitle:@"完成" fontSize:15 textColor:UIColor.blackColor target:self action:@selector(dismissKeyBoardMethod) addToSuperView:self];
        _doneButton.hidden = YES;
        [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
    }
}

/// 字数限制 label
-(UILabel *)wordsNumberLabel {
    
    if(!_wordsNumberLabel) {
        _wordsNumberLabel = [UILabel jh_labelWithFont:11 textColor:RGB153153153 textAlignment:2 addToSuperView:self];
        [_wordsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(self.addPhotoButton);
        }];
    }
    return _wordsNumberLabel;
}

///字数限制
- (void)setWordsNumber:(NSInteger)wordsNumber {
    ///字数
    if(wordsNumber < 0)
    {
        wordsNumber = 0;
    }
    _wordsNumber = wordsNumber;
    NSInteger maxWordsNumber = 10000;
    _isGreaterMaxWords = (wordsNumber > maxWordsNumber);
    
    self.wordsNumberLabel.text = [NSString stringWithFormat:@"%@/%@",@(_wordsNumber),@(maxWordsNumber)];
    
    self.wordsNumberLabel.textColor = (wordsNumber > maxWordsNumber ? RGB(255, 66, 0) : RGB153153153);
}

- (void)dismissKeyBoardMethod
{
    // [self.superview endEditing:YES];
    if (self.completePlateBlock) {
        self.completePlateBlock();
    }
}

-(void)setHidePhotoButton:(BOOL)hidePhotoButton{
    
    _hidePhotoButton = hidePhotoButton;
    self.addPhotoButton.hidden = hidePhotoButton;
    
}
- (void)setHideCalluserButton:(BOOL)hideCalluserButton {
    _hideCalluserButton = hideCalluserButton;
    self.callUserListButton.hidden = hideCalluserButton;
}

-(void)addPhotosAction
{
    if(_addAlbumBlock)
    {
        _addAlbumBlock();
    }
}

- (void)callUserListAction {
    if(self.callUsetListBlock) {
        self.callUsetListBlock();
    }
}

+ (CGSize)viewSize
{
    return CGSizeMake(ScreenW, 44);
}

#pragma mark -------- 键盘 --------
- (void)keyboardWillShow:(NSNotification *)notification
{
    if(_showDoneButton)
    {
        _doneButton.hidden = NO;
    }
    
    CGSize size = [JHSQPublishBottomView viewSize];
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, keyboardRect.origin.y - size.height, size.width, size.height + 2);
    }];
    
}
- (void)keyboardWillHide:(NSNotification *)notification {
    if(_showDoneButton)
    {
        _doneButton.hidden = YES;
    }
    
    CGSize size = [JHSQPublishBottomView viewSize];
    NSDictionary* userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, ScreenH - UI.bottomSafeAreaHeight - size.height, size.width, size.height);
    }];
}

/// 改变键盘类型
- (void)changeKeyboardTo:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.keybordSwitchBlock) {
        self.keybordSwitchBlock(sender.selected);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

