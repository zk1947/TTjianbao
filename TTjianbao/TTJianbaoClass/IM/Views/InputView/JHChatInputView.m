//
//  JHChatInputView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatInputView.h"
#import "PPStickerKeyboard.h"
#import "JHAttributeStringTool.h"
#import "NSAttributedString+PPAddition.h"
#import "PPStickerDataManager.h"
#import "JHChatTextView.h"
#import "JHChatEmotionView.h"

const static CGFloat mediaViewHeight = 220.f;
const static CGFloat emotionViewHeight = 220.f;
const static CGFloat TextViewHeight = 38.f;

@interface JHChatInputView()<UITextViewDelegate, JHChatEmotionKeyboardDelegate>

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *audioButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) JHChatTextView *msgTextView;
@property (nonatomic, strong) UIButton *emotionButton;
/// + 号
@property (nonatomic, strong) UIButton *mediaButton;
@property (nonatomic, strong) UIView *messageBar;
@property (nonatomic, strong) UIView *keyboardContent;
@property (nonatomic, strong) JHChatEmotionView *emotionView;
/// 键盘是否弹出
@property (nonatomic, assign) BOOL isKeyboardVisable;
@property (nonatomic, assign) BOOL isRecordCancel;
@property (nonatomic, assign) NSInteger textViewCurrentHeight;
@end

@implementation JHChatInputView

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self bindData];
        [self layoutViews];
        [self registerNotification];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
    [NSNotificationCenter.defaultCenter removeObserver:self];
}
#pragma mark - Public
/// 设置多媒体项
- (void)setupMedias : (NSArray<JHChatMediaModel *> *)mediaList {
    [self.mediaView setupMedias:mediaList];
}
- (void)setEditText : (NSString *)text {
    self.msgTextView.text = text;
    [self refreshTextUI];
    [self.msgTextView becomeFirstResponder];
}
- (void)hideKeyboard {
    [self.msgTextView resignFirstResponder];
    [self setupMessageKeyboardHeight:0 duration:0.25];
    self.mediaView.hidden = true;
    self.emotionView.hidden = true;
}
- (void)hideLine {
    self.lineView.hidden = true;
}
#pragma mark - Bind
- (void)bindData {

}
#pragma mark - Event
- (void)switchEmotionKeyboard : (UIButton *)sender {
    sender.selected = !sender.selected;
    self.emotionView.hidden = !sender.selected;
    self.mediaView.hidden = true;
    self.audioButton.selected = false;
    self.mediaButton.selected = false;
    
    [self setCustomKeyboardEnable:sender.selected height:mediaViewHeight];
    
    [self showTextView:true];
    [self setupTextViewHeight:self.textViewCurrentHeight];
}
- (void)switchMediaKeyboard : (UIButton *)sender{
    sender.selected = !sender.selected;
    self.emotionView.hidden = true;
    self.mediaView.hidden = !sender.selected;
    self.audioButton.selected = false;
    self.emotionButton.selected = false;
   
    [self setCustomKeyboardEnable:sender.selected height:mediaViewHeight];
    [self showTextView:true];
    [self setupTextViewHeight:self.textViewCurrentHeight];
}
- (void)recordAudio : (UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        if (self.delegate == nil) return;
        [self.delegate startRecordAudio];
    }else if (sender.state == UIGestureRecognizerStateEnded) {
        if (self.delegate == nil) return;
        if (self.isRecordCancel) {
            [self.delegate cancelledRecordAudio];
        }else {
            [self.delegate stopRecordAudio];
        }
    }else {
        CGPoint point = [sender locationInView:self];
        if (point.y <= -20 && self.isRecordCancel == false) {
            self.isRecordCancel = true;
            if (self.delegate == nil) return;
            [self.delegate changeRecordCancel:true];
        }else if (point.y >= 0 && self.isRecordCancel == true) {
            self.isRecordCancel = false;
            if (self.delegate == nil) return;
            [self.delegate changeRecordCancel:false];
        }
    }
}

- (void)didClickAudio : (UIButton *)sender{
    sender.selected = !sender.selected;
    
    self.mediaView.hidden = sender.selected;
    self.msgTextView.hidden = sender.selected;
    self.emotionView.hidden = sender.selected;
    self.recordButton.hidden = !sender.selected;
    
    self.mediaButton.selected = false;
    self.emotionButton.selected = false;
    [self setCustomKeyboardEnable:sender.selected height:0];
    
    if (sender.selected) {
        self.textViewCurrentHeight = self.msgTextView.bounds.size.height;
        [self setupTextViewHeight:TextViewHeight];
    }else {
        [self setupTextViewHeight:self.textViewCurrentHeight];
    }
}

- (void)didClickToolButton : (UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self didClickAudio:sender];
            break;
        case 1:
            [self switchEmotionKeyboard:sender];
            break;
        case 2:
            [self switchMediaKeyboard:sender];
            break;
        default:
            break;
    }
}
- (void)showTextView : (BOOL)isShow {
    self.msgTextView.hidden = !isShow;
    self.recordButton.hidden = isShow;
}
- (void)sendTextMessageWithText : (NSAttributedString *)text {
    if (self.delegate == nil) return;
    NSString *msg = [text pp_plainTextForRange:NSMakeRange(0, text.length)];
    JHMessage *message = [[JHMessage alloc] initWithText:msg];
    message.senderType = JHMessageSenderTypeMe;
    [self.delegate sendTextMessage:message];
}
- (void)resetToolButtonSelected {
    self.mediaButton.selected = false;
    self.audioButton.selected = false;
    self.emotionButton.selected = false;
}
#pragma mark -- emoji Delegate
- (void)emotionKeyboardDidClickSendButton:(JHChatEmotionView *)emotionKeyboard {
    if (self.msgTextView.attributedText.length <= 0) return;
    [self sendTextMessageWithText:self.msgTextView.attributedText];
    self.msgTextView.attributedText = nil;
}
- (void)emotionKeyboard:(PPStickerKeyboard *)emotionKeyboard didClickEmoji:(PPEmoji *)emoji
{
    if (!emoji) {
        return;
    }

    UIImage *emojiImage = [UIImage imageNamed:[@"Sticker.bundle" stringByAppendingPathComponent:emoji.imageName]];
    if (!emojiImage) {
        return;
    }
    self.placeholderLabel.hidden = true;
    
    NSRange selectedRange = self.msgTextView.selectedRange;
    NSString *emojiString = [NSString stringWithFormat:@"[%@]", emoji.emojiDescription];
    NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] initWithString:emojiString];
    [emojiAttributedString pp_setTextBackedString:[PPTextBackedString stringWithString:emojiString] range:emojiAttributedString.pp_rangeOfAll];

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.msgTextView.attributedText];
    [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
    self.msgTextView.attributedText = attributedText;
    self.msgTextView.selectedRange = NSMakeRange(selectedRange.location + emojiAttributedString.length, 0);
    
    [self refreshTextUI];
}

- (void)emotionKeyboardDidClickDeleteButton:(PPStickerKeyboard *)emotionKeyboard {
    [self.msgTextView deleteBackward];
    if (self.msgTextView.attributedText.length <= 0 || self.msgTextView.text.length <= 0) {
        self.placeholderLabel.hidden = false;
    }
}

- (void)refreshTextUI {
    if (!self.msgTextView.text.length) {
        return;
    }
    
    UIFont *font = [UIFont fontWithName:kFontNormal size:IMTextMessagefontSize]; //self.msgTextView.font;
    
    NSRange selectedRange = self.msgTextView.selectedRange;

    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc] initWithString:self.plainText attributes:@{ NSFontAttributeName: font, NSForegroundColorAttributeName: HEXCOLOR(0x333333)}];
    // 匹配表情
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attributedComment font:font];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedComment addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:attributedComment.pp_rangeOfAll];
    [attributedComment addAttribute:NSFontAttributeName value:font range:attributedComment.pp_rangeOfAll];
    NSUInteger offset = self.msgTextView.attributedText.length - attributedComment.length;
    attributedComment = [JHAttributeStringTool markAtBlue:attributedComment];
    self.msgTextView.attributedText = attributedComment;
    self.msgTextView.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
}
//表情匹配转化文字
- (NSString *)plainText {
    return [self.msgTextView.attributedText pp_plainTextForRange:NSMakeRange(0, self.msgTextView.attributedText.length)];
}
#pragma mark -- UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLabel.hidden = YES;
    UIToolbar *topView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    [textView setInputAccessoryView:topView];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.placeholderLabel.hidden = textView.text.length;
}
- (void)textViewDidChange:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length;
    CGFloat height = textView.contentSize.height;
    [self setupTextViewHeight:height];
}
- (void)textViewDidChangeSelection:(UITextView *)textView {
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ( (textView.text.length == 0 || textView.text == nil) && [text isEqualToString: @"\n"]){
        return NO;
    }
    if ([text isEqualToString: @"\n"]) {
        [self sendTextMessageWithText:textView.attributedText];
        textView.text = @"";
        return NO;
    }
    return YES;
}

#pragma mark - Keyboard
- (void)keyboardWillShow : (NSNotification *)notification {
    self.isKeyboardVisable = true;
    NSDictionary *userInfo = [notification userInfo];
    NSValue *keyboardValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [keyboardValue CGRectValue];
    CGFloat height = CGRectGetHeight(keyboardRect);
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [self resetToolButtonSelected];
    [self setupMessageKeyboardHeight:height - UI.bottomSafeAreaHeight duration:duration];
}
- (void)keyboardWillHide : (NSNotification *)notification {
    self.isKeyboardVisable = false;
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat height = 0;
    
    if (self.mediaButton.isSelected) {
        height = mediaViewHeight;
    }else if (self.emotionButton.isSelected) {
        height = emotionViewHeight;
    }

    [self setupMessageKeyboardHeight:height duration:duration];
}
- (void)setupMessageKeyboardHeight : (CGFloat) height duration : (double)duration{
    if (height == self.keyboardContent.bounds.size.height) return;
    [self.keyboardContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];

    [UIView animateWithDuration:duration animations:^{
        [self layoutIfNeeded];
        [self.superview layoutIfNeeded];
        [self.viewFrameChanged sendNext:nil];
    } completion: nil];
}
- (void)setCustomKeyboardEnable : (BOOL)enable height : (CGFloat)height {
    if (enable) {
        if (self.isKeyboardVisable) {
            [self.msgTextView resignFirstResponder];
        }else {
            [self setupMessageKeyboardHeight:height duration:0.25];
        }
    }else {
        [self.msgTextView becomeFirstResponder];
        self.msgTextView.hidden = false;
        self.recordButton.hidden = true;
    }
}
- (void)setupTextViewHeight : (CGFloat) height {
    CGFloat newHeight = height;
    if (newHeight == self.msgTextView.bounds.size.height) return;
    
    if (newHeight > 80) return;
    
    [self.msgTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(newHeight);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self layoutIfNeeded];

    } completion:nil];
}
#pragma mark - UI
- (void)setupUI {
    self.backgroundColor = HEXCOLOR(0xf8f8f8);
    self.userInteractionEnabled = true;
    self.textViewCurrentHeight = TextViewHeight;
    [self.messageBar addSubview:self.audioButton];
    [self.messageBar addSubview:self.recordButton];
    [self.messageBar addSubview:self.msgTextView];
    [self.messageBar addSubview:self.emotionButton];
    [self.messageBar addSubview:self.mediaButton];
    [self.msgTextView addSubview:self.placeholderLabel];
    [self addSubview:self.lineView];
    [self addSubview: self.messageBar];
    [self addSubview:self.keyboardContent];
    [self.keyboardContent addSubview:self.mediaView];
    [self.keyboardContent addSubview:self.emotionView];
}
- (void)registerNotification {
    //将要隐藏键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}
- (void)layoutViews {
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [self.messageBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(0);
        make.left.right.mas_equalTo(0);
    }];
    [self.keyboardContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageBar.mas_bottom).offset(0);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    [self.mediaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12, 20, 0, 20));
    }];
    [self.emotionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.msgTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.left.mas_equalTo(self.audioButton.mas_right).offset(10);
        make.right.mas_equalTo(self.emotionButton.mas_left).offset(-10);
        make.height.mas_equalTo(TextViewHeight);
    }];
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.msgTextView);
    }];
    [self.emotionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.size.mas_equalTo(self.audioButton);
        make.right.mas_equalTo(self.mediaButton.mas_left).offset(-15);
    }];
    [self.audioButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.bottom.mas_equalTo(self.emotionButton);
        make.left.mas_equalTo(12);
    }];
    [self.mediaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.emotionButton);
        make.size.mas_equalTo(self.audioButton);
        make.right.mas_equalTo(-12);
    }];
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.messageBar).offset(16);
        make.left.mas_equalTo(19);
    }];
}
#pragma mark - LAZY
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = HEXCOLOR(0xeeeeee);
    }
    return _lineView;
}
- (UIView *)messageBar {
    if (!_messageBar) {
        _messageBar = [[UIView alloc] initWithFrame:CGRectZero];
        _messageBar.backgroundColor = HEXCOLOR(0xf8f8f8);
    }
    return _messageBar;
}
- (UIView *)keyboardContent {
    if (!_keyboardContent) {
        _keyboardContent = [[UIView alloc] initWithFrame:CGRectZero];
        _keyboardContent.backgroundColor = HEXCOLOR(0xf8f8f8);
    }
    return _keyboardContent;
}
- (JHChatMediaView *)mediaView {
    if (!_mediaView) {
        _mediaView = [[JHChatMediaView alloc] initWithFrame:CGRectZero];
        _mediaView.hidden = true;
    }
    return _mediaView;
}
- (JHChatEmotionView *)emotionView
{
    if (!_emotionView) {
        _emotionView = [[JHChatEmotionView alloc] initWithFrame:CGRectZero];
        _emotionView.delegate = self;
        _emotionView.hidden = true;
        _emotionView.backgroundColor = HEXCOLOR(0xf8f8f8);
    }
    return _emotionView;
}
- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton jh_cornerRadius:8];
        _recordButton.backgroundColor = HEXCOLOR(0xffffff);
        [_recordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        _recordButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        [_recordButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        
        UILongPressGestureRecognizer *longPgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordAudio: )];
        longPgr.minimumPressDuration = 0.5;
        [_recordButton addGestureRecognizer:longPgr];
    }
    return _recordButton;
}
- (JHChatTextView *)msgTextView {
    if (!_msgTextView) {
        _msgTextView = [[JHChatTextView alloc] initWithFrame:CGRectZero];
        _msgTextView.delegate = self;
        _msgTextView.backgroundColor = HEXCOLOR(0xffffff);
        _msgTextView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _msgTextView.font = [UIFont fontWithName:kFontNormal size:IMTextMessagefontSize];
        _msgTextView.returnKeyType = UIReturnKeySend;
        [_msgTextView jh_cornerRadius:8];
    }
    return _msgTextView;
}
- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _placeholderLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _placeholderLabel.textColor = HEXCOLOR(0xcccccc);
        _placeholderLabel.text = @"请输入您要咨询的内容";
    }
    return _placeholderLabel;
}
- (UIButton *)getButtonWithImageName : (NSString *)imageName selectedImageName : (NSString *)selectedImageName tag : (NSInteger)tag {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = tag;
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(didClickToolButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
- (UIButton *)audioButton {
    if (!_audioButton) {
        _audioButton = [self getButtonWithImageName:@"IM_audio_icon" selectedImageName :@"IM_keyboard_icon" tag:0];
    }
    return _audioButton;
}
- (UIButton *)emotionButton {
    if (!_emotionButton) {
        _emotionButton = [self getButtonWithImageName:@"IM_emotion_icon" selectedImageName :@"IM_keyboard_icon" tag:1];
    }
    return _emotionButton;
}
- (UIButton *)mediaButton {
    if (!_mediaButton) {
        _mediaButton = [self getButtonWithImageName:@"IM_media_icon" selectedImageName :@"IM_media_icon" tag:2];
    }
    return _mediaButton;
}
- (RACSubject *) viewFrameChanged {
    if (!_viewFrameChanged){
        _viewFrameChanged = [RACSubject subject];
    }
    return _viewFrameChanged;
}
@end

