//
//  JHChatTextView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/21.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatTextView.h"
#import "JHAttributeStringTool.h"
#import "NSAttributedString+PPAddition.h"
#import "PPStickerDataManager.h"
#import "JHIMHeader.h"
@implementation JHChatTextView

- (void)paste:(id)sender {
    UIPasteboard *defaultPasteboard = [UIPasteboard generalPasteboard];
    if(defaultPasteboard.string.length>0){
        NSRange range = self.selectedRange;
        if(range.location == NSNotFound){
            range.location = self.text.length;
        }
        
        if([self.delegate textView:self shouldChangeTextInRange:range replacementText:defaultPasteboard.string]){
            NSString *newStr = [self.text stringByAppendingString:defaultPasteboard.string];
            [self resetEmotionAttributedString : newStr];
        }
        return;
    }
    [super paste:sender];
}

- (void)resetEmotionAttributedString : (NSString *)string {
   
    UIFont *font = [UIFont fontWithName:kFontNormal size:IMTextMessagefontSize];
    
    NSRange selectedRange = self.selectedRange;
    NSMutableAttributedString *attributedComment = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName: font, NSForegroundColorAttributeName: HEXCOLOR(0x333333)}];

    // 匹配表情
    [PPStickerDataManager.sharedInstance replaceEmojiForAttributedString:attributedComment font:font];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedComment addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:attributedComment.pp_rangeOfAll];
    [attributedComment addAttribute:NSFontAttributeName value:font range:attributedComment.pp_rangeOfAll];
    NSUInteger offset = self.attributedText.length - attributedComment.length;
    attributedComment = [JHAttributeStringTool markAtBlue:attributedComment];
    self.attributedText = attributedComment;
    
    self.selectedRange = NSMakeRange(selectedRange.location - offset, 0);
}
@end
