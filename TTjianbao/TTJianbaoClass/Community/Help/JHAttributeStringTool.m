//
//  JHAttributeStringTool.m
//  test
//
//  Created by 王记伟 on 2020/11/18.
//

#import "JHAttributeStringTool.h"
#import <MJExtension.h>
#import <YYKit.h>
#import "JHLinkClickAction.h"

@implementation LinkStringModel

- (void)setSub_text:(NSString *)sub_text{
    if ([sub_text isNotBlank]) {
        _sub_text = sub_text;
    }else{
        _sub_text = @"";
    }
}
- (void)setSub_type:(NSString *)sub_type{
    if ([sub_type isNotBlank]) {
        _sub_type = sub_type;
    }else{
        _sub_type = @"0";
    }
}
@end

@implementation LinkResourceModel

@end

@interface JHAttributeStringTool()

@end

@implementation JHAttributeStringTool

+ (NSMutableAttributedString *)getOneParagraphAttributeStringWithArray:(NSArray *)array normalColor:(UIColor *)normalColor font:(UIFont *)font logoSize:(CGSize )logoSize{
    NSArray *linkModelArray = [LinkStringModel mj_objectArrayWithKeyValuesArray:array];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    for (LinkStringModel *model in linkModelArray) {
        if(!model.sub_text) {
            model.sub_text = @" ";
        }
        if ([model.sub_text isEqualToString:@"网页链接"]) {
            model.sub_text = @"查看详情";
        }
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.sub_text];
        [attri addAttributes:@{NSFontAttributeName:font,
                               NSForegroundColorAttributeName:normalColor
        } range:NSMakeRange(0, [[attri string] length])];
        if (model.sub_type.integerValue) {
            YYAnimatedImageView *linkLogo= [[YYAnimatedImageView alloc] initWithImage:[UIImage imageNamed:@"sq_icon_link_logo"]];
            linkLogo.frame = CGRectMake(0, 0, logoSize.width, logoSize.height);
            // attchmentSize 修改，可以处理内边距
            NSMutableAttributedString *attachText= [NSMutableAttributedString attachmentStringWithContent:linkLogo contentMode:UIViewContentModeScaleAspectFit attachmentSize:linkLogo.frame.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
            //插入到开头
            [attri insertAttributedString:attachText atIndex:0];
            [attri setTextHighlightRange:[[attri string] rangeOfString:model.sub_text] color:RGB(64, 143, 254) backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [JHLinkClickAction linkClickActionWithType:model.sub_type.integerValue andUrl:model.data_value];
            }];
        }
        [attributedString appendAttributedString:[JHAttributeStringTool markAtBlue:attri]];
    }
    return attributedString;
}

+ (NSMutableAttributedString *)getOneParagraphAttrForPostDetail:(NSArray *)array normalColor:(UIColor *)normalColor font:(UIFont *)font logoSize:(CGSize )logoSize {
    NSArray *linkModelArray = [LinkStringModel mj_objectArrayWithKeyValuesArray:array];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    for (LinkStringModel *model in linkModelArray) {
        if(!model.sub_text) {
            model.sub_text = @" ";
        }
        if ([model.sub_text isEqualToString:@"网页链接"]) {
            model.sub_text = @"查看详情";
        }
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:model.sub_text];
        [attri addAttributes:@{NSFontAttributeName:font,
                               NSForegroundColorAttributeName:normalColor
        } range:NSMakeRange(0, [[attri string] length])];
        if (model.sub_type.integerValue) {
            NSTextAttachment *attach = [[NSTextAttachment alloc] init];
            attach.image = [UIImage imageNamed:@"sq_icon_link_logo"];
            attach.bounds = CGRectMake(0, 0, logoSize.width, logoSize.height);
            NSAttributedString *attachText = [NSAttributedString attributedStringWithAttachment:attach];

            //插入到开头
            [attri insertAttributedString:attachText atIndex:0];
            [attri addAttributes:@{NSForegroundColorAttributeName:RGB(64, 143, 254),
                                              NSLinkAttributeName:[NSString stringWithFormat:@"%@,%@",model.data_value, model.sub_type],
                                              NSFontAttributeName:font
            } range:[[attri string] rangeOfString:model.sub_text]];
        }
        [attributedString appendAttributedString:attri];
    }
    return attributedString;
}

+ (NSMutableAttributedString *)getMoreParagraphAttributeStringWithArray:(NSArray *)array normalColor:(UIColor *)normalColor font:(UIFont *)font logoSize:(CGSize )logoSize {
    NSMutableAttributedString * attributedString = [self getMoreParagraphAttributeStringWithArray:array normalColor:normalColor font:font logoSize:logoSize pageFrom:JHAttributePageFromList];
    return attributedString;
}

+ (NSMutableAttributedString *)getMoreParagraphAttributeStringWithArray:(NSArray *)array normalColor:(UIColor *)normalColor font:(UIFont *)font logoSize:(CGSize )logoSize pageFrom:(JHAttributePageFrom)pageFrom {
    NSArray *modelArray = [LinkResourceModel mj_objectArrayWithKeyValuesArray:array];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    for (LinkResourceModel *model in modelArray) {
        if (model.type == 1) {
            NSString *arrayString = model.data[@"attrs"];
            NSArray *arrayArray = [NSArray array];
            if (IS_STRING(arrayString) && [arrayString isNotBlank]) {
                NSData *jsonData = [model.data[@"attrs"] dataUsingEncoding:NSUTF8StringEncoding];
                NSError *err;
                arrayArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&err];
            }
            NSMutableAttributedString *attr = nil;
            if (arrayArray.count > 0) {
                if (pageFrom == JHAttributePageFromPostDetail) {
                    attr = [self getOneParagraphAttrForPostDetail:arrayArray normalColor:normalColor font:font logoSize:logoSize];
                }
                else {
                    attr = [self getOneParagraphAttributeStringWithArray:arrayArray normalColor:normalColor font:font logoSize:logoSize];
                }
            }else{
                NSString *str = [NSString stringWithFormat:@"%@", model.data[@"text"]];
                if (![str isNotBlank] || [str containsString:@"null"]) {
                    str = @"";
                }
                attr = [[NSMutableAttributedString alloc] initWithString:str];
                [attr addAttributes:@{NSFontAttributeName:font,
                                      NSForegroundColorAttributeName:normalColor
                } range:NSMakeRange(0, [[attr string] length])];
                attr = [JHAttributeStringTool markAtBlue:attr];
            }
            if (attributedString.length > 0) {
                [attributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
            }
            
            [attributedString appendAttributedString:attr];
        }
    }
    
    return attributedString;
}

/** 判断文字里面带@的字符,并给予高亮*/
+ (NSMutableAttributedString *)markAtBlue:(NSMutableAttributedString *)attributedString {
    NSString *text = [attributedString string];
    if (text.length == 0 || ![text containsString:@"@"]) {
        return attributedString;
    }
    
    [attributedString addAttributes:@{NSFontAttributeName:attributedString.font,
                                     NSForegroundColorAttributeName:kColor333
    } range:NSMakeRange(0, attributedString.string.length)];

    NSError *error = nil;
    NSRegularExpression *atPersionRE = [NSRegularExpression regularExpressionWithPattern:kCallStringRegex options:NSRegularExpressionCaseInsensitive error:&error];
    [atPersionRE enumerateMatchesInString:text options:NSMatchingReportProgress range:NSMakeRange(0, text.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.range.location != NSNotFound) {
            NSString *string = [[attributedString string] substringWithRange:result.range];
            if ([string isNotBlank] && string.length <= kMax_CallTextCount) {
                [attributedString setTextHighlightRange:result.range color:kHighLightColor backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                    [JHLinkClickAction linkClickActionWithUserName:string];
                }];
            }
        }
    }];
    return attributedString;
}

/** 判断文字里面带@的字符,并给予高亮*/
+ (NSMutableAttributedString *)markAtBlueForPostDetail:(NSMutableAttributedString *)attributedString {
    NSString *text = [attributedString string];
    if (![text isNotBlank] || ![text containsString:@"@"]) {
        return attributedString;
    }
    [attributedString addAttributes:@{NSFontAttributeName:attributedString.font,
                                     NSForegroundColorAttributeName:kColor333
    } range:NSMakeRange(0, attributedString.string.length)];
    NSError *error = nil;
    ///@[^\\S]+\\S?
    NSRegularExpression *atPersionRE = [NSRegularExpression regularExpressionWithPattern:kCallStringRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [atPersionRE matchesInString:attributedString.string options:NSMatchingReportProgress range:attributedString.string.rangeOfAll];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        if (matchRange.length > 0 && matchRange.length <= kMax_CallTextCount) {
            NSString *string = [[attributedString string] substringWithRange:matchRange];
            string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [attributedString addAttributes:@{NSForegroundColorAttributeName:kHighLightColor,
                                              NSLinkAttributeName:[NSString stringWithFormat:@"%@,%@", string, kToUserInfoPage]
            } range:matchRange];
        }
    }

    return attributedString;
}

+ (void)matchHighLightText:(NSMutableAttributedString *)text {
    [text addAttributes:@{NSFontAttributeName:[UIFont fontWithName:kFontNormal size:16],
                                     NSForegroundColorAttributeName:kColor333
    } range:NSMakeRange(0, text.length)];
    NSError *error = nil;
    ///@[^\\S]+\\S?
    NSRegularExpression *atPersionRE = [NSRegularExpression regularExpressionWithPattern:kCallStringRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [atPersionRE matchesInString:text.string options:NSMatchingReportProgress range:text.string.rangeOfAll];
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        if (matchRange.length > 0 && matchRange.length <= kMax_CallTextCount) {
            NSString *string = [[text string] substringWithRange:matchRange];
            string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            [text addAttributes:@{NSForegroundColorAttributeName:kHighLightColor,
                                              NSLinkAttributeName:[NSString stringWithFormat:@"%@,%@", string, kToUserInfoPage]
            } range:matchRange];
        }
    }
}


+ (BOOL)hasCallUser:(NSString *)callString {
    NSError *error = nil;
    NSRegularExpression *atPersionRE = [NSRegularExpression regularExpressionWithPattern:kCallStringRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [atPersionRE matchesInString:callString options:NSMatchingReportProgress range:callString.rangeOfAll];
    return (matches.count>0);
}

@end
