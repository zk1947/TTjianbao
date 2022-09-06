//
//  PPStickerDataManager.h
//  PPStickerKeyboard
//
//  Created by Vernon on 2018/1/17.
//  Copyright © 2018年 Vernon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPSticker;
@class PPStickerMatchingResult;

@interface PPStickerMatchingResult : NSObject
@property (nonatomic, assign) NSRange range;                    // 匹配到的表情包文本的range
@property (nonatomic, strong) UIImage *emojiImage;              // 如果能在本地找到emoji的图片，则此值不为空
@property (nonatomic, strong) NSString *showingDescription;     // 表情的实际文本(形如：[哈哈])，不为空
@end

@interface PPStickerDataManager : NSObject

+ (instancetype)sharedInstance;

/// 所有的表情包
@property (nonatomic, strong, readonly) NSArray<PPSticker *> *allStickers;

/* 匹配给定attributedString中的所有emoji，如果匹配到的emoji有本地图片的话会直接换成本地的图片
 *
 * @param attributedString 可能包含表情包的attributedString
 * @param font 表情图片的对齐字体大小
 */

- (void)replaceEmojiForAttributedString_yyLabel:(NSMutableAttributedString *)attributedString font:(UIFont *)font;

//富文本发布时用
- (void)replaceEmojiForAttributedString_yyTextNOBlank:(NSMutableAttributedString *)attributedString font:(UIFont *)font;
- (void)replaceEmojiForAttributedString_yyText:(NSMutableAttributedString *)attributedString font:(UIFont *)font;
- (void)replaceEmojiForAttributedString:(NSMutableAttributedString *)attributedString font:(UIFont *)font;
- (NSArray<PPStickerMatchingResult *> *)matchingEmojiForString:(NSString *)string;
- (void)replaceEmojiForAttributedStringYYText:(NSMutableAttributedString *)attributedString font:(UIFont *)font;
@end
