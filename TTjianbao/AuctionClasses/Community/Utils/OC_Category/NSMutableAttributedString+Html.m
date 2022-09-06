//
//  NSMutableAttributedString+Html.m
//  TTjianbao
//
//  Created by wuyd on 2019/9/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NSMutableAttributedString+Html.h"

@implementation NSMutableAttributedString (Html)

+ (NSMutableAttributedString *)yd_loadHtmlString:(NSString *)htmlString {
    
    NSLog(@"htmlString = %@", htmlString);
    NSMutableString *htmlStr = [NSMutableString stringWithString:htmlString];
    
    if (![htmlString hasPrefix:@"<font"]) {
        htmlStr = [NSMutableString stringWithFormat:@"%@%@%@", @"<font color = \"#FFFFFF\">", htmlString, @"</font>"];
    }
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                              NSCharacterEncodingDocumentAttribute : @(NSUTF8StringEncoding)};
    NSData *data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    return attStr;
}

@end
