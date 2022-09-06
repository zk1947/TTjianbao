//
//  JHChatKeyBoardView.m
//  TTjianbao
//
//  Created by YJ on 2021/1/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatKeyBoardView.h"
#import "PPStickerKeyboard.h"
#import "TTJianBaoColor.h"
#import "PPStickerDataManager.h"
#import "NSAttributedString+PPAddition.h"
#import "JHChatConst.h"

#define CONTENT_FONT [UIFont fontWithName:kFontNormal size:15.0f]

@interface JHChatKeyBoardView ()<UITextViewDelegate,PPStickerKeyboardDelegate>

@property (strong, nonatomic) PPStickerKeyboard *stickerKeyboard;
@property (strong, nonatomic) UIView *bgView;
@property (nonatomic, strong) UIView  *contentView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *keyBoardBtn;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIButton *sendBtn;

@end

@implementation JHChatKeyBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.textView];
        [self.contentView addSubview:self.keyBoardBtn];
        [self.contentView addSubview:self.sendBtn];
        [self.contentView addSubview:self.photoBtn];

    }
    return self;
}

- (void)dismiss
{
    if ([self.textView isFirstResponder])
    {
        [self.textView resignFirstResponder];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    
    NSValue *rectValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [rectValue CGRectValue].size;

    CGRect newFrame = self.frame;
    newFrame.origin.y = ScreenH - SENDVIEW_HEIGHT - keyboardSize.height;
    
//    if ([self.delegate respondsToSelector:@selector(chatKeyBoardiewWithoriginY:resetFrame:)])
//    {
//        [self.delegate chatKeyBoardiewWithoriginY:newFrame.origin.y resetFrame:YES];
//    }
    
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardiewWithoriginY:keyBoardHeight:resetFrame:)])
    {
        [self.delegate chatKeyBoardiewWithoriginY:newFrame.origin.y keyBoardHeight:keyboardSize.height resetFrame:YES];
    }
    
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.frame = newFrame;
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{    
    CGRect newFrame = self.frame;
    newFrame.origin.y = ScreenH - SENDVIEW_HEIGHT - UI.bottomSafeAreaHeight;
    
//    if ([self.delegate respondsToSelector:@selector(chatKeyBoardiewWithoriginY:resetFrame:)])
//    {
//        [self.delegate chatKeyBoardiewWithoriginY:newFrame.origin.y resetFrame:NO];
//    }
    
    if ([self.delegate respondsToSelector:@selector(chatKeyBoardiewWithoriginY:keyBoardHeight:resetFrame:)])
    {
        [self.delegate chatKeyBoardiewWithoriginY:newFrame.origin.y keyBoardHeight:0 resetFrame:NO];
    }
    
    [UIView animateWithDuration:kAnimationTime animations:^{
        self.frame = newFrame;
    }];
}

- (UIView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[UIView alloc] initWithFrame:self.bounds];
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
    }
    return _contentView;
}

- (UIView *)bgView
{
    if(!_bgView)
    {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(10 + 10 + 5 + 40 *2, (SENDVIEW_HEIGHT - 38)/2, ScreenW - (10 + 10 + 5 + 40 *2) - 40 - 10*2, 38)];
        _bgView.layer.backgroundColor = USELECTED_COLOR.CGColor;
        _bgView.layer.cornerRadius = 38/2;
        _bgView.clipsToBounds = YES;
    }
    return _bgView;
}
- (UITextView *)textView
{
    if (!_textView)
    {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, ScreenW - (10 + 10 + 5 + 40 *2) - 40 - 10*2 - 5*2, 38)];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.textColor = B_COLOR;
        _textView.tintColor = YELLOW_COLOR;
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请输入文字...";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = LIGHTGRAY_COLOR;
        [placeHolderLabel sizeToFit];
        [_textView addSubview:placeHolderLabel];
        _textView.delegate = self;
        _textView.font = [UIFont fontWithName:kFontNormal size:15.0f];
        placeHolderLabel.font = [UIFont fontWithName:kFontNormal size:15.0f];
        [_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _textView;
}

- (UIButton *)keyBoardBtn
{
    if (!_keyBoardBtn)
    {
        _keyBoardBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, (SENDVIEW_HEIGHT - 40)/2, 40, 40)];
        _keyBoardBtn.selected = NO;
        [_keyBoardBtn setImage:[UIImage imageNamed:@"emojiIcon"] forState:UIControlStateNormal];
        [_keyBoardBtn addTarget:self action:@selector(clickKeyBoardBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keyBoardBtn;
}
- (void)clickKeyBoardBtn:(UIButton *)button
{
    if (button.selected)
    {
        //系统键盘
        button.selected = NO;
        [self.keyBoardBtn  setImage:[UIImage imageNamed:@"emojiIcon"] forState:UIControlStateNormal];
        
        self.textView.inputView = nil;
        [self.textView becomeFirstResponder];
        [self.textView reloadInputViews];
    }
    else
    {
        //自定义表情键盘
        button.selected = YES;
        
        [self.keyBoardBtn  setImage:[UIImage imageNamed:@"keybordIcon"] forState:UIControlStateNormal];
        self.textView.inputView = self.stickerKeyboard;         
        [self.textView becomeFirstResponder];
        [self.textView reloadInputViews];
    }
}

- (UIButton *)photoBtn
{
    if (!_photoBtn)
    {
        _photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(15 + 40 , (SENDVIEW_HEIGHT - 40)/2, 40, 40)];
        [_photoBtn setImage:[UIImage imageNamed:@"publish_album_icon"] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(clickPhotoBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

- (void)clickPhotoBtn
{    
    if (self.block)
    {
        self.block(YES);
    }
}

- (UIButton *)sendBtn
{
    if (!_sendBtn)
    {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenW - 40 - 10, 10, 40, 40)];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15.0f];
        [_sendBtn setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(clickSendBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0)
    {
        [self.sendBtn setTitleColor:B_COLOR forState:UIControlStateNormal];
    }
    else
    {
        [self.sendBtn setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
    }
}
- (void)clickSendBtn
{
    //NSString *text = self.textView.text;
    NSString *text = [self plainText];
    if (self.sendBlock && text.length > 0)
    {
        self.sendBlock(text);
        self.textView.text = nil;
    }
}

- (PPStickerKeyboard *)stickerKeyboard
{
    if (!_stickerKeyboard)
    {
        _stickerKeyboard = [[PPStickerKeyboard alloc] init];
        _stickerKeyboard.frame = CGRectMake(0, ScreenH -  [self.stickerKeyboard heightThatFits], ScreenW, [self.stickerKeyboard heightThatFits]);
        _stickerKeyboard.delegate = self;
    }
    return _stickerKeyboard;
}

- (void)stickerKeyboard:(PPStickerKeyboard *)stickerKeyboard didClickEmoji:(PPEmoji *)emoji
{
    if (!emoji)
    {
        return;
    }

    UIImage *emojiImage = [UIImage imageNamed:[@"Sticker.bundle" stringByAppendingPathComponent:emoji.imageName]];
    if (!emojiImage)
    {
        return;
    }

    NSRange selectedRange = self.textView.selectedRange;
    NSString *emojiString = [NSString stringWithFormat:@"[%@]", emoji.emojiDescription];
    if (emojiString.length > 0)
    {
        [self.sendBtn setTitleColor:B_COLOR forState:UIControlStateNormal];
    }
    else
    {
        [self.sendBtn setTitleColor:LIGHTGRAY_COLOR forState:UIControlStateNormal];
    }
    NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] initWithString:emojiString];
    
    [emojiAttributedString pp_setTextBackedString:[PPTextBackedString stringWithString:emojiString] range:emojiAttributedString.pp_rangeOfAll];

    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textView.attributedText];
    
    [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
    
    self.textView.attributedText = attributedText;
    
    self.textView.selectedRange = NSMakeRange(selectedRange.location + emojiAttributedString.length, 0);

    [self refreshTextUI];
    
}
- (void)refreshTextUI
{
    if (!self.textView.text.length)
    {
        return;
    }

    NSRange selectedRange = self.textView.selectedRange;

    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc] initWithString:self.plainText attributes:@
    { NSFontAttributeName: [UIFont fontWithName:kFontNormal size:15.0f], NSForegroundColorAttributeName: B_COLOR}];

    // 匹配表情
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attributedComment font:[UIFont fontWithName:kFontNormal size:15.0f]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedComment addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:attributedComment.pp_rangeOfAll];
    [attributedComment addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontNormal size:15.0f] range:attributedComment.pp_rangeOfAll];
    NSUInteger offset = self.textView.attributedText.length - attributedComment.length;
    self.textView.attributedText = attributedComment;
    self.textView.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
}

//表情匹配转化文字
- (NSString *)plainText
{
    return [self.textView.attributedText pp_plainTextForRange:NSMakeRange(0, self.textView.attributedText.length)];
}

- (void)stickerKeyboardDidClickDeleteButton:(PPStickerKeyboard *)stickerKeyboard
{
    [self.textView deleteBackward];
}

- (void)stickerKeyboardDidClickSendButton:(PPStickerKeyboard *)stickerKeyboard
{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
