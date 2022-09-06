//
//  JHEmojiManager_YYText.m
//  TTjianbao
//
//  Created by apple on 2020/11/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHEmojiManager_YYText.h"
#import "PPStickerKeyboard.h"
#import "PPUtil.h"
#import "PPStickerDataManager.h"
#import <YYKit.h>

@interface JHEmojiManager_YYText ()<PPStickerKeyboardDelegate>

@property (nonatomic, strong) PPStickerKeyboard *stickerKeyboard;
@property (nonatomic, strong) YYTextView *textViewnew; //表情键盘使用
@property (nonatomic, strong) UIFont *font;
@end

@implementation JHEmojiManager_YYText
+ (instancetype)sharedInstance
{
    static JHEmojiManager_YYText *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[JHEmojiManager_YYText alloc] init];
    });
    return sharedInstance;
}

-(void)setCurrentText:(id)text andType:(UIFont *)font{
    self.textViewnew = (YYTextView *)text;
    if (font) {
        self.font = font;
    }else{
        self.font = JHFont(15);
    }
}

- (void)changeKeyboardTo:(BOOL)isShow
{//keybordIcon emojiIcon
    if(isShow){
        //键盘icon  显示emoji键盘
        _textViewnew.inputView = self.stickerKeyboard;         // 切换到自定义的表情键盘
        
        [_textViewnew becomeFirstResponder];
       [_textViewnew reloadInputViews];
        
    }else{
        //emoji键盘icon  显示系统键盘
        _textViewnew.inputView = nil;                          // 切换到系统键盘
        
        [_textViewnew becomeFirstResponder];
        [_textViewnew reloadInputViews];
    }
}
- (PPStickerKeyboard *)stickerKeyboard
{
    if (!_stickerKeyboard) {
        _stickerKeyboard = [[PPStickerKeyboard alloc] init];
        _stickerKeyboard.frame = CGRectMake(0, 0, ScreenW, [self.stickerKeyboard heightThatFits]);
        _stickerKeyboard.delegate = self;
    }
    return _stickerKeyboard;
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

//    CGFloat emojiHeight = self.font.lineHeight;
//
//    // UIImage attachment
//    UIImage *image = emojiImage;
//    NSMutableAttributedString *emojiAttributed = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(emojiHeight, emojiHeight) alignToFont:self.font alignment:YYTextVerticalAlignmentCenter];
//
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.textViewnew.attributedText];
    [attributedText replaceCharactersInRange:selectedRange withAttributedString:emojiAttributedString];
    self.textViewnew.attributedText = attributedText;
    self.textViewnew.selectedRange = NSMakeRange(selectedRange.location + emojiAttributedString.length, 0);

    [self refreshTextUI];
//    [self textViewDidChange:self.textViewnew];
 

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

    NSRange selectedRange = self.textViewnew.selectedRange;

//    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc] initWithAttributedString:self.plainText attributes:@{ NSFontAttributeName: self.font, NSForegroundColorAttributeName: HEXCOLOR(0x333333)}];

    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc] initWithAttributedString:self.textViewnew.attributedText];
    // 匹配表情

    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString_yyText:attributedComment font:self.font];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineSpacing = PPStickerTextViewLineSpacing;
    [attributedComment addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:attributedComment.pp_rangeOfAll];
    [attributedComment addAttribute:NSFontAttributeName value:self.font range:attributedComment.pp_rangeOfAll];
    NSUInteger offset = self.textViewnew.attributedText.length - attributedComment.length;
    self.textViewnew.attributedText = attributedComment;
    self.textViewnew.selectedRange = NSMakeRange(selectedRange.location - offset, 0);

    
//    [self textViewDidChange:self.textViewnew];
}

//表情匹配转化文字
- (NSString *)plainText
{
    return [self.textViewnew.attributedText pp_plainTextForRange:NSMakeRange(0, self.textViewnew.attributedText.length)];
}

- (NSAttributedString *)plainTextWithString{
    return [self.textViewnew.attributedText pp_plainAttributedTextForRange:NSMakeRange(0, self.textViewnew.attributedText.length)];
}
@end
