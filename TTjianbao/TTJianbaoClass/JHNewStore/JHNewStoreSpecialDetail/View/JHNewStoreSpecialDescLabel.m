//
//  JHNewStoreSpecialDescLabel.m
//  TTjianbao
//
//  Created by liuhai on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreSpecialDescLabel.h"

@implementation JHNewStoreSpecialDescLabel

- (void)addSeeMoreButtonInLabel:(NSString *)descStr {
    if (!descStr) {
        return;
    }
    UIFont *font13 = [UIFont systemFontOfSize:13];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:descStr];
    [attrStr addAttribute:NSFontAttributeName value:font13 range:NSMakeRange(0, attrStr.length)];
    [attrStr addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x333333) range:NSMakeRange(0, attrStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:6];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attrStr length])];
    self.attributedText = attrStr;

//    NSString *moreString = @"展开";
//    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"... %@", moreString]];
//    NSRange expandRange = [text.string rangeOfString:moreString];
//
//    [text addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:expandRange];
//    [text addAttribute:NSForegroundColorAttributeName value:[UIColor darkTextColor] range:NSMakeRange(0, expandRange.location)];
    UIImage *image = [UIImage imageNamed:@"newStoreSpecialDescMore"];
    NSMutableAttributedString *text = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeTop attachmentSize:image.size alignToFont:JHFont(13) alignment:YYTextVerticalAlignmentTop];
    //添加点击事件
    YYTextHighlight *hi = [YYTextHighlight new];
    [text setTextHighlight:hi range:text.rangeOfAll];
  
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击展开
        [weakSelf setNewFrame:YES];
    };
    
    text.font = JHFont(13);
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
//    [seeMore sizeToFit];
    seeMore.frame = CGRectMake(0, 0, 40, 18);
//    seeMore.frame.size
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeTop attachmentSize:CGSizeMake(seeMore.frame.size.width-20, seeMore.frame.size.height) alignToFont:text.font alignment:YYTextVerticalAlignmentTop];
    
    self.truncationToken = truncationToken;
}

- (NSAttributedString *)appendAttriStringWithFont:(UIFont *)font {
    if (!font) {
        font = [UIFont systemFontOfSize:13];
    }
    
    NSString *appendText = @" 收起 ";
    NSMutableAttributedString *append = [[NSMutableAttributedString alloc] initWithString:appendText attributes:@{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor blueColor]}];
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [append setTextHighlight:hi range:[append.string rangeOfString:appendText]];
    
    __weak typeof(self) weakSelf = self;
    hi.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        //点击收起
        [weakSelf setNewFrame:NO];
    };
    
    return append;
}

- (void)expandString {
    NSMutableAttributedString *attri = [self.attributedText mutableCopy];
    [attri appendAttributedString:[self appendAttriStringWithFont:attri.font]];
    self.attributedText = attri;
}

- (void)packUpString {
    NSString *appendText = @" 收起 ";
    NSMutableAttributedString *attri = [self.attributedText mutableCopy];
    NSRange range = [attri.string rangeOfString:appendText options:NSBackwardsSearch];

    if (range.location != NSNotFound) {
        [attri deleteCharactersInRange:range];
    }

    self.attributedText = attri;
}


- (void)setNewFrame:(BOOL)isExpand {
    CGFloat maxh = 72;
    if (isExpand) {
//        [self expandString];
        self.numberOfLines = 0;
        maxh = MAXFLOAT;
    } else {
        [self packUpString];
        self.numberOfLines = 3;
        maxh = 72;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(expandOrPackUp:)]) {
        CGFloat textHeight = [self sizeThatFits:CGSizeMake(ScreenW-24, maxh)].height + 8;
        [self.delegate expandOrPackUp:textHeight];
        
    }
}

@end
