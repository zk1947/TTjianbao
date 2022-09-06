//
//  PPStickerDataManager.m
//  PPStickerKeyboard
//
//  Created by Vernon on 2018/1/17.
//  Copyright © 2018年 Vernon. All rights reserved.
//

#import "PPStickerDataManager.h"
#import "PPSticker.h"
#import "PPUtil.h"
#import <YYKit.h>


@implementation PPStickerMatchingResult
@end

@interface PPStickerDataManager ()
@property (nonatomic, strong, readwrite) NSArray<PPSticker *> *allStickers;
@end

@implementation PPStickerDataManager

+ (instancetype)sharedInstance
{
    static PPStickerDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PPStickerDataManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self initStickers];
    }
    return self;
}

- (void)initStickers
{
    NSString *path = [NSBundle.mainBundle pathForResource:@"InnerStickersInfo" ofType:@"plist"];
    if (!path) {
        return;
    }

    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    NSMutableArray<PPSticker *> *stickers = [[NSMutableArray alloc] init];
    for (NSDictionary *stickerDict in array) {
        PPSticker *sticker = [[PPSticker alloc] init];
        sticker.coverImageName = stickerDict[@"cover_pic"];
        NSArray *emojiArr = stickerDict[@"emoticons"];
        NSMutableArray<PPEmoji *> *emojis = [[NSMutableArray alloc] init];
        for (NSDictionary *emojiDict in emojiArr) {
            PPEmoji *emoji = [[PPEmoji alloc] init];
            emoji.imageName = emojiDict[@"image"];
            emoji.emojiDescription = emojiDict[@"desc"];
            [emojis addObject:emoji];
        }
        sticker.emojis = emojis;
        [stickers addObject:sticker];
    }
    self.allStickers = stickers;
}

#pragma mark - public method

- (void)replaceEmojiForAttributedString_yyLabel:(NSMutableAttributedString *)attributedString font:(UIFont *)font{
    if (!attributedString || !attributedString.length || !font) {
        return;
    }

    NSArray<PPStickerMatchingResult *> *matchingResults = [self matchingEmojiForString:attributedString.string];

    if (matchingResults && matchingResults.count) {
        NSUInteger offset = 0;
        for (PPStickerMatchingResult *result in matchingResults) {
            if (result.emojiImage) {
                CGFloat emojiHeight = font.lineHeight;
                
                // UIImage attachment
                UIImage *image = result.emojiImage;
                NSMutableAttributedString *emojiAttributedString = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(emojiHeight, emojiHeight) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
               
                [emojiAttributedString pp_setTextBackedString:[PPTextBackedString stringWithString:result.showingDescription] range:NSMakeRange(0, emojiAttributedString.length)];
               
                if (!emojiAttributedString) {
                    continue;
                }
                NSRange actualRange = NSMakeRange(result.range.location - offset, result.showingDescription.length);
                [attributedString replaceCharactersInRange:actualRange withAttributedString:emojiAttributedString];
                offset += result.showingDescription.length - emojiAttributedString.length;
            }
        }
    }
}

//富文本发布时用
- (void)replaceEmojiForAttributedString_yyTextNOBlank:(NSMutableAttributedString *)attributedString font:(UIFont *)font{
    if (!attributedString || !attributedString.length || !font) {
        return;
    }

    NSArray<PPStickerMatchingResult *> *matchingResults = [self matchingEmojiForString:attributedString.string];
    
    if (matchingResults && matchingResults.count) {
        for (NSInteger i = matchingResults.count-1; i>=0; i--) {
            PPStickerMatchingResult *result = matchingResults[i];
            CGFloat emojiHeight = font.lineHeight;
            UIImage *image = result.emojiImage;
            NSMutableAttributedString *emojiAttributedString = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(emojiHeight, emojiHeight) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
            [emojiAttributedString pp_setTextBackedString:[PPTextBackedString stringWithString:result.showingDescription] range:NSMakeRange(0, emojiAttributedString.length)];
            @try {
                [emojiAttributedString appendAttributedString:[attributedString attributedSubstringFromRange:NSMakeRange(result.range.location+result.range.length, 1)]];
                [emojiAttributedString setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:emojiAttributedString.rangeOfAll];
                
                [attributedString replaceCharactersInRange:NSMakeRange(result.range.location, result.range.length+1) withAttributedString:emojiAttributedString];
            } @catch (NSException *exception) {
        
            } @finally {
               
            }
            
        }
    }
}
//富文本发布时用
- (void)replaceEmojiForAttributedString_yyText:(NSMutableAttributedString *)attributedString font:(UIFont *)font{
    if (!attributedString || !attributedString.length || !font) {
        return;
    }

    NSArray<PPStickerMatchingResult *> *matchingResults = [self matchingEmojiForString:attributedString.string];

    if (matchingResults && matchingResults.count) {
        NSUInteger offset = 0;
        for (PPStickerMatchingResult *result in matchingResults) {
            if (result.emojiImage) {
                CGFloat emojiHeight = font.lineHeight;
                
                // UIImage attachment
                UIImage *image = result.emojiImage;
                NSMutableAttributedString *emojiAttributedString = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(emojiHeight, emojiHeight) alignToFont:font alignment:YYTextVerticalAlignmentCenter];
               
                
                [emojiAttributedString pp_setTextBackedString:[PPTextBackedString stringWithString:result.showingDescription] range:NSMakeRange(0, emojiAttributedString.length)];
               
                NSMutableAttributedString *nullString = [[NSMutableAttributedString alloc] initWithString:@" "];
                [nullString removeAttribute:PPTextBackedStringAttributeName range:nullString.pp_rangeOfAll];
                [emojiAttributedString appendAttributedString:nullString];
                
                [emojiAttributedString setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:emojiAttributedString.rangeOfAll];
                if (!emojiAttributedString) {
                    continue;
                }
                NSRange actualRange = NSMakeRange(result.range.location - offset, result.showingDescription.length);
                [attributedString replaceCharactersInRange:actualRange withAttributedString:emojiAttributedString];
                offset += result.showingDescription.length - emojiAttributedString.length;
            }
        }
    }
}
//富文本发布时用
- (void)replaceEmojiForAttributedStringYYText:(NSMutableAttributedString *)attributedString font:(UIFont *)font{
    if (!attributedString || !attributedString.length || !font) {
        return;
    }

    NSArray<PPStickerMatchingResult *> *matchingResults = [self matchingEmojiForString:attributedString.string];

    if (matchingResults && matchingResults.count) {
        NSUInteger offset = 0;
        for (PPStickerMatchingResult *result in matchingResults) {
            if (result.emojiImage) {
        
                CGFloat emojiHeight = font.lineHeight;
                
                UIImage *image = result.emojiImage;
                NSMutableAttributedString *emojiAttributedString = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeScaleAspectFit attachmentSize:CGSizeMake(emojiHeight, emojiHeight) alignToFont:font alignment:YYTextVerticalAlignmentCenter];

                [emojiAttributedString setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:emojiAttributedString.rangeOfAll];
                if (!emojiAttributedString) {
                    continue;
                }
                NSRange actualRange = NSMakeRange(result.range.location - offset, result.showingDescription.length);
                [attributedString replaceCharactersInRange:actualRange withAttributedString:emojiAttributedString];
                offset += result.showingDescription.length - emojiAttributedString.length;
            }
        }
    }
}
- (void)replaceEmojiForAttributedString:(NSMutableAttributedString *)attributedString font:(UIFont *)font
{
    if (!attributedString || !attributedString.length || !font) {
        return;
    }

    NSArray<PPStickerMatchingResult *> *matchingResults = [self matchingEmojiForString:attributedString.string];

    if (matchingResults && matchingResults.count) {
        NSUInteger offset = 0;
        for (PPStickerMatchingResult *result in matchingResults) {
            if (result.emojiImage) {
                CGFloat emojiHeight = font.lineHeight;
                NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
                attachment.image = result.emojiImage;
                attachment.bounds = CGRectMake(0, font.descender, emojiHeight, emojiHeight);
                NSMutableAttributedString *emojiAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[NSAttributedString attributedStringWithAttachment:attachment]];
                [emojiAttributedString pp_setTextBackedString:[PPTextBackedString stringWithString:result.showingDescription] range:NSMakeRange(0, emojiAttributedString.length)];
                if (!emojiAttributedString) {
                    continue;
                }
                NSRange actualRange = NSMakeRange(result.range.location - offset, result.showingDescription.length);
                [attributedString replaceCharactersInRange:actualRange withAttributedString:emojiAttributedString];
                offset += result.showingDescription.length - emojiAttributedString.length;
            }
        }
    }
}

#pragma mark - private method

- (NSArray<PPStickerMatchingResult *> *)matchingEmojiForString:(NSString *)string
{
    if (!string.length) {
        return nil;
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[.+?\\]" options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *results = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if (results && results.count) {
        NSMutableArray *emojiMatchingResults = [[NSMutableArray alloc] init];
        for (NSTextCheckingResult *result in results) {
            NSString *showingDescription = [string substringWithRange:result.range];
            NSString *emojiSubString = [showingDescription substringFromIndex:1];       // 去掉[
            emojiSubString = [emojiSubString substringWithRange:NSMakeRange(0, emojiSubString.length - 1)];    // 去掉]
            PPEmoji *emoji = [self emojiWithEmojiDescription:emojiSubString];
            if (emoji) {
                PPStickerMatchingResult *emojiMatchingResult = [[PPStickerMatchingResult alloc] init];
                emojiMatchingResult.range = result.range;
                emojiMatchingResult.showingDescription = showingDescription;
                emojiMatchingResult.emojiImage = [UIImage imageNamed:[@"Sticker.bundle" stringByAppendingPathComponent:emoji.imageName]];
                [emojiMatchingResults addObject:emojiMatchingResult];
            }
        }
        return emojiMatchingResults;
    }
    return nil;
}

- (PPEmoji *)emojiWithEmojiDescription:(NSString *)emojiDescription
{
    for (PPSticker *sticker in self.allStickers) {
        for (PPEmoji *emoji in sticker.emojis) {
            if ([emoji.emojiDescription isEqualToString:emojiDescription]) {
                return emoji;
            }
        }
    }
    return nil;
}

@end
