//
//  NTESTextInputView.m
//  TTjianbao
//
//  Created by chris on 16/3/28.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESTextInputView.h"
#import "UIView+NTES.h"
#import "NIMSDK/NIMSDK.h"
#import "UIView+Toast.h"
#import "PPStickerKeyboard.h"
#import "PPUtil.h"
#import "PPStickerDataManager.h"
#import "NTESGrowingInternalTextView.h"
#import "JHGrowingIO.h"

#define kPaddingLeft    (5.0)
#define kPaddingRight   (10.0)
#define kSendBtnWidth   (54.0)
#define kLengthWidth    (43.0)

@interface NTESTextInputView()<NTESGrowingTextViewDelegate,PPStickerKeyboardDelegate,UITextViewDelegate>
@property (nonatomic, strong) UIView *inputContainer;
@property (nonatomic, strong) UILabel *lengthLabel;
@property (nonatomic,   copy) NSString *inputText;

@property (nonatomic, strong) UIButton *keybordSwitchButton;//键盘切换
@property (nonatomic, strong) PPStickerKeyboard *stickerKeyboard;
@property (nonatomic, strong, readonly) NSString *plainText;
@property (nonatomic, assign) NTESTextInputViewType showType;//显示类型

@end

@implementation NTESTextInputView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //光标颜色
        [[UITextView appearance] setTintColor:kColorMain];
        [[UITextField appearance] setTintColor:kColorMain];
        _maxLength = 200;
        
        [self configUI];
        
        RAC(self.sendButton, enabled) =
        [RACSignal combineLatest:@[RACObserve(self, inputText)] reduce:^id (NSString *text) {
            if (![text isNotBlank]) {
                return @(NO);
            }
            return @(YES);
        }];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withType:(NTESTextInputViewType)showType{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //光标颜色
        [[UITextView appearance] setTintColor:kColorMain];
        [[UITextField appearance] setTintColor:kColorMain];
        _maxLength = 200;
        self.showType = showType;
        [self configUI];
        
//        RAC(self.sendButton, enabled) =
//        [RACSignal combineLatest:@[RACObserve(self, inputText)] reduce:^id (NSString *text) {
//            if (![text isNotBlank]) {
//                return @(NO);
//            }
//            return @(YES);
//        }];
    }
    return self;
}
- (void)configUI {
    if (!_inputContainer) {
        _inputContainer = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, 0, 0, 34.0)];
        _inputContainer.backgroundColor = kColorF5F6FA;
        _inputContainer.clipsToBounds = YES;
        _inputContainer.layer.cornerRadius = 17;
        [self addSubview:_inputContainer];
    }
    
    if (!_textView) {
        _textView = [[NTESGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, 0, 34.0)];
        _textView.font = [UIFont fontWithName:kFontNormal size:13];
        _textView.textColor = kColor333;
        //_textView.scrollEnabled = NO;
        _textView.textViewDelegate  = self;
        [_inputContainer addSubview:self.textView];
    }
    
    
    if (!_lengthLabel) {
        _lengthLabel = [ UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:10] textColor:kColor999];
        _lengthLabel.textAlignment = NSTextAlignmentRight;
        _lengthLabel.text = [NSString stringWithFormat:@"%d/%ld", 0, (long)_maxLength];
        [_inputContainer addSubview:_lengthLabel];
    }
    
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithTitle:@"发送" titleColor:kColor333];
        _sendButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_sendButton setTitleColor:kColor333 forState:UIControlStateNormal];
        [_sendButton setTitleColor:kColor999 forState:UIControlStateDisabled];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"icon_input_send_btn"] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage new] forState:UIControlStateDisabled];
        [_sendButton addTarget:self action:@selector(onSend:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.enabled = NO;
        [self addSubview:_sendButton];
    }
    
    float emojiWidth = 0;
    if (self.showType == NTESTextInputViewTypeEmoji) {
        if (!_keybordSwitchButton) {
            _keybordSwitchButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_keybordSwitchButton setImage:[UIImage imageNamed:@"emojiIcon"] forState:UIControlStateNormal];
            [_keybordSwitchButton setImage:[UIImage imageNamed:@"keybordIcon"] forState:UIControlStateSelected];
            [_keybordSwitchButton setBackgroundImage:[UIImage new] forState:UIControlStateDisabled];
            [_keybordSwitchButton addTarget:self action:@selector(changeKeyboardTo:) forControlEvents:UIControlEventTouchUpInside];
            _keybordSwitchButton.selected = NO;
            [self addSubview:_keybordSwitchButton];
        }
        emojiWidth = 35;
    }
    
    CGFloat containerWidth = self.width - kPaddingLeft - kPaddingRight - kSendBtnWidth - kPaddingLeft - emojiWidth;
    
    _inputContainer.left = kPaddingLeft;
    _inputContainer.width = containerWidth;
    _inputContainer.centerY = self.height * 0.5;
    
    _textView.left = kPaddingLeft;
    _textView.width = containerWidth - kLengthWidth - kPaddingLeft*2 ;
    _textView.centerY = _inputContainer.height * 0.5;
    
    _lengthLabel.frame = CGRectMake(containerWidth - kLengthWidth - kPaddingLeft, 0, kLengthWidth, 20);
    _lengthLabel.centerY = _inputContainer.height * 0.5;
    
    _sendButton.right = self.width - kPaddingRight;
    _sendButton.size = CGSizeMake(kSendBtnWidth, 26);
    _sendButton.centerY = self.height * 0.5;
    
    if (self.showType == NTESTextInputViewTypeEmoji) {
        _keybordSwitchButton.right = _sendButton.left - emojiWidth;
        _keybordSwitchButton.size = CGSizeMake(30, 30);
        _keybordSwitchButton.centerY = self.height * 0.5;
    }
    if (self.showType == NTESTextInputViewTypeEmoji) {
        if (!_textViewnew) {
            _textViewnew = [[NTESGrowingInternalTextView alloc] initWithFrame:CGRectMake(5, 0, containerWidth - kLengthWidth - kPaddingLeft*2, 34.0)];
            _textViewnew.backgroundColor = UIColor.clearColor;
            _textViewnew.font = [UIFont fontWithName:kFontNormal size:13];
            _textViewnew.textColor = kColor333;
            _textViewnew.delegate  = self;
            [_inputContainer addSubview:_textViewnew];
            
        }
        _textView.hidden = YES;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
}
- (void)changeKeyboardTo:(UIButton *)sender
{//keybordIcon emojiIcon
    sender.selected = !sender.selected;
    if(sender.selected){
        //键盘icon  显示emoji键盘
       
        _textViewnew.inputView = self.stickerKeyboard;         // 切换到自定义的表情键盘
//        [self.textView becomeFirstResponder];
       [_textViewnew reloadInputViews];
        [Growing track:JHtrackBusinessliveExpressionClick];
        
    }else{
        //emoji键盘icon  显示系统键盘
        _textViewnew.inputView = nil;                          // 切换到系统键盘
        [_textViewnew reloadInputViews];
    }
}
- (PPStickerKeyboard *)stickerKeyboard
{
    if (!_stickerKeyboard) {
        _stickerKeyboard = [[PPStickerKeyboard alloc] init];
        _stickerKeyboard.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), [self.stickerKeyboard heightThatFits]);
        _stickerKeyboard.delegate = self;
    }
    return _stickerKeyboard;
}
#pragma mark - NTESGrowingTextViewDelegate
- (void)willChangeHeight:(CGFloat)height
{
    CGFloat bottom = self.bottom;
    
    CGFloat topSpace = (self.height - _textView.height) / 2;
    CGFloat allHeight = topSpace*2 + height;
    
    self.height = allHeight;
    self.bottom = bottom;
    
    _inputContainer.height = height;
    _inputContainer.centerY = self.height * 0.5;
    
    _textView.height = height;
    _textView.centerY = _inputContainer.height * 0.5;
    
    _keybordSwitchButton.centerY = self.height * 0.5;
    _sendButton.centerY = self.height * 0.5;
    
    NSInteger lines = (NSInteger)_textView.height / _textView.font.lineHeight;
    _textView.scrollEnabled = lines > 4;
    
    if ([self.delegate respondsToSelector:@selector(willChangeHeight:)]) {
        [self.delegate willChangeHeight:height];
    }
}

- (BOOL)textViewShouldBeginEditing:(NTESGrowingTextView *)growingTextView {
    _lengthLabel.text = [NSString stringWithFormat:@"%d/%ld", 0, (long)_maxLength];
    return YES;
}

- (void)textViewDidEndEditing:(NTESGrowingTextView *)growingTextView {
    _textView.text = @"";
    self.inputText = @"";
}

- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)replacementText {
    if ([replacementText isEqualToString:@"\n"]) { //按回车关闭键盘
        if (self.showType == NTESTextInputViewTypeEmoji) {
            [self onSend:self.plainText];
        }else{
            [self onSend:_textView.text];
        }
        
        return NO;
    }
    
//    if (replacementText.length == 0) { //判断是不是删除键
//        return YES;
//    }
//
//    if (_textView.text.length > _maxLength) {
//        //输入的字符个数大于_maxLength，则无法继续输入，返回NO表示禁止输入
//        return NO;
//    }
    
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    UITextView *inputTextView = self.textViewnew;
    UITextRange *selectedRange = [inputTextView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [inputTextView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSAttributedString * newStr = self.textViewnew.attributedText;
    _lengthLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)newStr.length, (long)_maxLength];
    
    if (_textView.text.length > _maxLength ) {
        // 对超出的部分进行剪切
        _textViewnew.attributedText = [_textViewnew.attributedText attributedSubstringFromRange:NSMakeRange(0, _maxLength)];
        
        _lengthLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)newStr.length, (long)_maxLength];;
    }
    CGFloat width = textView.width;
    CGFloat height = textView.height;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    if (newSize.height>58) {
        newSize.height = 58;
    }
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmax(width, newSize.width), fmax(height, newSize.height));
    textView.frame= newFrame;
    if (textView.text.length>0) {
        self.sendButton.enabled = YES;
    }else{
        self.sendButton.enabled = NO;
    }
    [self willChangeHeight:newSize.height];
}
- (void)textViewDidChange_Growing:(NTESGrowingTextView *)growingTextView {
    
    UITextView *inputTextView = (UITextView *)growingTextView.textView;
    UITextRange *selectedRange = [inputTextView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [inputTextView positionFromPosition:selectedRange.start offset:0];
    //如果在变化中是高亮部分在变，就不计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    self.inputText = growingTextView.text;
    _lengthLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.inputText.length, (long)_maxLength];
    
    if (_textView.text.length > _maxLength ) {
        // 对超出的部分进行剪切
        _textView.text = [_textView.text substringToIndex:_maxLength];
        self.inputText = _textView.text;
        
        _lengthLabel.text = [NSString stringWithFormat:@"%ld/%ld", (long)self.inputText.length, (long)_maxLength];;
    }
}

- (void)didChangeHeight:(CGFloat)height {
    if ([self.delegate respondsToSelector:@selector(didChangeHeight:)]) {
        [self.delegate didChangeHeight:height];
    }
}

- (void)onSend:(id)sender
{
    NSString *text = @"";
    if (self.showType == NTESTextInputViewTypeEmoji) {
        if (!self.plainText.length) {
            return;
        }
        text = self.plainText;
    }else{
        if (!self.textView.text.length) {
            return;
        }
        text = self.textView.text;
    }

    
    //默认 检查敏感词
    if (!self.ignoreCheck) {
        NIMLocalAntiSpamCheckOption *option = [[NIMLocalAntiSpamCheckOption alloc] init];
        option.content = text;
        option.replacement = @"***";
        
        NSError *errer;
        NIMLocalAntiSpamCheckResult *result = [[NIMSDK sharedSDK].antispamManager checkLocalAntispam:option error: &errer];
        if (result.type == NIMAntiSpamResultLocalForbidden) {
            [[UIApplication sharedApplication].keyWindow makeToast:@"包含敏感词汇" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        if (result.type == NIMAntiSpamResultLocalReplace) {
            NSLog(@" ======== %@",result.content);
            text = result.content;
        }
    }
    
    if (text.length > _maxLength) {
        [UITipView showTipStr:[NSString stringWithFormat:@"不能超过%ld字", (long)_maxLength]];
        return;
    }
    
    self.textView.text = @"";
    self.inputText = @"";
    self.textViewnew.text = @"";
    _sendButton.enabled = NO;
    _lengthLabel.text = [NSString stringWithFormat:@"%d/%ld", 0, (long)_maxLength];
    
    if ([self.delegate respondsToSelector:@selector(didSendText:)]) {
        [self.delegate didSendText:text];
    }
}
#pragma mark - PPStickerKeyboardDelegate

- (void)stickerKeyboard:(PPStickerKeyboard *)stickerKeyboard didClickEmoji:(PPEmoji *)emoji
{
    if (!emoji) {
        return;
    }

    UIImage *emojiImage = [UIImage imageNamed:[@"Sticker.bundle" stringByAppendingPathComponent:emoji.imageName]];
    if (!emojiImage) {
        return;
    }

    NSRange selectedRange = self.textViewnew.selectedRange;
    NSString *emojiString = [NSString stringWithFormat:@"[%@]", emoji.emojiDescription];
    NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] initWithString:emojiString];
    [emojiAttributedString pp_setTextBackedString:[PPTextBackedString stringWithString:emojiString] range:emojiAttributedString.pp_rangeOfAll];

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textViewnew.attributedText];
    [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
    self.textViewnew.attributedText = attributedText;
    self.textViewnew.selectedRange = NSMakeRange(selectedRange.location + emojiAttributedString.length, 0);

    [self refreshTextUI];
//    [self textViewDidChange:self.textViewnew];
    [Growing track:JHtrackBusinessliveExpressionItemClick withVariable:@{@"expression_click_name":emoji.emojiDescription}];

}

- (void)stickerKeyboardDidClickDeleteButton:(PPStickerKeyboard *)stickerKeyboard
{
    [self.textViewnew deleteBackward];
    
}

- (void)refreshTextUI
{
    if (!self.textViewnew.text.length) {
        return;
    }

//    UITextRange *markedTextRange = [self.textView markedTextRange];
//    UITextPosition *position = [self.textView positionFromPosition:markedTextRange.start offset:0];
//    if (position) {
//        return;     // 正处于输入拼音还未点确定的中间状态
//    }

    NSRange selectedRange = self.textViewnew.selectedRange;

    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc] initWithString:self.plainText attributes:@{ NSFontAttributeName: [UIFont fontWithName:kFontNormal size:13], NSForegroundColorAttributeName: kColor333 }];

    // 匹配表情
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attributedComment font:[UIFont fontWithName:kFontNormal size:13]];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = PPStickerTextViewLineSpacing;
    [attributedComment addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:attributedComment.pp_rangeOfAll];

    NSUInteger offset = self.textViewnew.attributedText.length - attributedComment.length;
    self.textViewnew.attributedText = attributedComment;
    self.textViewnew.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
    [self textViewDidChange:self.textViewnew];
}
- (NSString *)plainText
{
    return [self.textViewnew.attributedText pp_plainTextForRange:NSMakeRange(0, self.textViewnew.attributedText.length)];
}
@end
