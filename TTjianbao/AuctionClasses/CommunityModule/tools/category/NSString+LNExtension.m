//
//  NSString+Extension.m
//  iTrends
//
//  Created by wujin on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+LNExtension.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#include <sys/stat.h>
#include <dirent.h>

NSString * const kStringsNotNullAndEmptyEnd = @"kStringsNotNullAndEmptyEnd";
@implementation NSString (LNExtension)
+(BOOL)empty:(NSString *)str{
    
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0){
            return true;
        } else {
            return false;
        }
    }
}

// 二维码图片
- (UIImage *)createQRCode
{
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    
    return [UIImage imageWithCIImage:outputImage];
}


+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

+ (CGSize)sizeWithStringWithParagraphStyle:(NSString *)string font:(UIFont *)font paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle WithSize:(CGSize)size
{
    CGRect rect = [string boundingRectWithSize:size
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{
                                                 NSFontAttributeName:font,
                                                 NSParagraphStyleAttributeName:paragraphStyle
                                                 }
                                       context:nil];
    return rect.size;
}


+(NSString*)tokenString:(NSData *)devToken
{
    NSString *token=devToken.description;//[[deviceToken description] stringByReplacingOccurrencesOfString:@"" withString:@""];
    
    token=[token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return token;
}

+ (void)wordChange:(UILabel *)label withStr:(NSString *)str withLocation:(int)location withLength:(int)length withNormalColor:(UIColor *)normalColor withHeightColor:(UIColor *)heightColor{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName value:heightColor range:NSMakeRange(0, length)];
    label.attributedText = attrStr;
}
/**
 *  @return 根据字符串的的长度来计算UITextView的高度
 */
+ (float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    float height = [[NSString stringWithFormat:@"%@\n",value] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil].size.height;
    
    return height;
}

+ (NSInteger)calculateLineNumberWithString:(NSString *)value Width:(CGFloat)width Font:(CGFloat)font
{
    CGFloat oneLineHeight = [self heightForString:@"一行" fontSize:font andWidth:width];
    NSLog(@"oneLineHeight = %.2f", oneLineHeight);
//    [@"一行" calculateHeightWithWidth:width Font:font];
    CGFloat allLineHeight = [self heightForString:value fontSize:font andWidth:width];
    //[self calculateHeightWithWidth:width Font:font];
    return (allLineHeight / oneLineHeight) ;
}

//获取某固定文本的显示高度
+(CGRect)heightForString:(NSString*)str Size:(CGSize)size Font:(UIFont*)font
{
    return [NSString heightForString:str Size:size Font:font Lines:0];
}

+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font WithSize:(CGSize)size{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(size.width,size.height)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName: font}
                                       context:nil];
    
    return rect.size;
}

+(CGRect)heightForString:(NSString*)str Size:(CGSize)size Font:(UIFont*)font Lines:(NSInteger)lines
{
    if (StringIsNullOrEmpty(str)) {
        return CGRectMake(0, 0, 0, 0);
    }
    static UILabel *lbtext;
    if (lbtext==nil) {
        lbtext    = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    }else{
        lbtext.frame=CGRectMake(0, 0, size.width, size.height);
    }
    lbtext.font=font;
    lbtext.text=str;
    lbtext.numberOfLines=lines;
    CGRect rect= [lbtext textRectForBounds:lbtext.frame limitedToNumberOfLines:lines];
    if(rect.size.height<0)
        rect.size.height=0;
    if (rect.size.width<0) {
        rect.size.width=0;
    }
    return rect;
}

// 消除所有空格
- (NSString *)removeSpaces
{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}
//返回字符串经过md5加密后的字符
+(NSString*)stringDecodingByMD5:(NSString*)str
{
    const char * cStr = [str UTF8String];
    unsigned char result[32];
    extern unsigned char *CC_M5(const void *data, CC_LONG len, unsigned char *md);
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    return [[NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ] lowercaseString];
}

-(NSString*)md5DecodingString
{
    return [NSString stringDecodingByMD5:self];
}

-(NSString*)md5StringFor16
{
    NSString *md5Str = [NSString stringDecodingByMD5:self];
    if (md5Str) {
        return [md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    return nil;
}
+ (NSString*) base64Decode:(NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[4];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil) {
        return nil;
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true) {
        if (ixtext >= lentext){
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z')) {
            ch = ch - 'A';
        } else if ((ch >= 'a') && (ch <= 'z')) {
            ch = ch - 'a' + 26;
        } else if ((ch >= '0') && (ch <= '9')) {
            ch = ch - '0' + 52;
        } else if (ch == '+') {
            ch = 62;
        } else if (ch == '=') {
            flendtext = true;
        } else if (ch == '/') {
            ch = 63;
        } else {
            flignore = true;
        }
        
        if (!flignore) {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext) {
                if (ixinbuf == 0) {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2)) {
                    ctcharsinbuf = 1;
                } else {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4) {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++) {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak) {
                break;
            }
        }
    }
    
    return [[NSString alloc] initWithData:theData encoding:NSUTF8StringEncoding];// theData;
}

-(NSString*)base64Decode
{
    return [NSString base64Decode:self];
}

+ (NSString*) base64Encode:(NSData *)data
{
    static char base64EncodingTable[64] = {
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
        'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
        'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
        'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
    };
    int length = (int)[data length];
    unsigned long ixtext, lentext;
    long ctremaining;
    unsigned char input[3], output[4];
    short i, charsonline = 0, ctcopy;
    const unsigned char *raw;
    NSMutableString *result;
    
    lentext = [data length];
    if (lentext < 1)
        return @"";
    result = [NSMutableString stringWithCapacity: lentext];
    raw = [data bytes];
    ixtext = 0;
    
    while (true) {
        ctremaining = lentext - ixtext;
        if (ctremaining <= 0)
            break;
        for (i = 0; i < 3; i++) {
            unsigned long ix = ixtext + i;
            if (ix < lentext)
                input[i] = raw[ix];
            else
                input[i] = 0;
        }
        output[0] = (input[0] & 0xFC) >> 2;
        output[1] = ((input[0] & 0x03) << 4) | ((input[1] & 0xF0) >> 4);
        output[2] = ((input[1] & 0x0F) << 2) | ((input[2] & 0xC0) >> 6);
        output[3] = input[2] & 0x3F;
        ctcopy = 4;
        switch (ctremaining) {
            case 1:
                ctcopy = 2;
                break;
            case 2:
                ctcopy = 3;
                break;
        }
        
        for (i = 0; i < ctcopy; i++)
            [result appendString: [NSString stringWithFormat: @"%c", base64EncodingTable[output[i]]]];
        
        for (i = ctcopy; i < 4; i++)
            [result appendString: @"="];
        
        ixtext += 3;
        charsonline += 4;
        
        if ((length > 0) && (charsonline >= length))
            charsonline = 0;
    }
    return result;
}
-(NSString*)base64Encode
{
    return [NSString base64Encode:[self dataUsingEncoding:NSUTF8StringEncoding]];
}

// 方法1：使用NSFileManager来实现获取文件大小
+ (long long) fileSizeAtPath1:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

// 方法1：使用unix c函数来实现获取文件大小
+ (long long) fileSizeAtPath2:(NSString*) filePath{
    struct stat st;
    if(lstat([filePath cStringUsingEncoding:NSUTF8StringEncoding], &st) == 0){
        return st.st_size;
    }
    return 0;
}


#pragma mark 获取目录大小


// 方法1：循环调用fileSizeAtPath1
+ (long long) folderSizeAtPath1:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        if ([self fileSizeAtPath1:fileAbsolutePath] != [self fileSizeAtPath2:fileAbsolutePath]){
            NSLog(@"%@, %lld, %lld", fileAbsolutePath,
                  [self fileSizeAtPath1:fileAbsolutePath],
                  [self fileSizeAtPath2:fileAbsolutePath]);
        }
        folderSize += [self fileSizeAtPath1:fileAbsolutePath];
    }
    return folderSize;
}


// 方法2：循环调用fileSizeAtPath2
+ (long long) folderSizeAtPath2:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath2:fileAbsolutePath];
    }
    return folderSize;
}


// 方法3：完全使用unix c函数
+ (long long) folderSizeAtPath3:(NSString*) folderPath{
    return [self _folderSizeAtPath:[folderPath cStringUsingEncoding:NSUTF8StringEncoding]];
}
+ (long long) _folderSizeAtPath: (const char*)folderPath{
    long long folderSize = 0;
    DIR* dir = opendir(folderPath);
    if (dir == NULL) return 0;
    struct dirent* child;
    while ((child = readdir(dir))!=NULL) {
        if (child->d_type == DT_DIR && (
                                        (child->d_name[0] == '.' && child->d_name[1] == 0) || // 忽略目录 .
                                        (child->d_name[0] == '.' && child->d_name[1] == '.' && child->d_name[2] == 0) // 忽略目录 ..
                                        )) continue;
        
        int folderPathLength = (int)strlen(folderPath);
        char childPath[1024]; // 子文件的路径地址
        stpcpy(childPath, folderPath);
        if (folderPath[folderPathLength-1] != '/'){
            childPath[folderPathLength] = '/';
            folderPathLength++;
        }
        stpcpy(childPath+folderPathLength, child->d_name);
        childPath[folderPathLength + child->d_namlen] = 0;
        if (child->d_type == DT_DIR){ // directory
            folderSize += [self _folderSizeAtPath:childPath]; // 递归调用子目录
            // 把目录本身所占的空间也加上
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }else if (child->d_type == DT_REG || child->d_type == DT_LNK){ // file or link
            struct stat st;
            if(lstat(childPath, &st) == 0) folderSize += st.st_size;
        }
    }
    return folderSize;
}

- (NSString *)trimString
{
    NSString *newString = nil;
    
    if (StringNotNullAndEmpty(self)) {
        newString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//        newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }
    
    if (StringIsNullOrEmpty(newString)) {
        newString = nil;
    }
    
    return newString;
}

- (int)byteCount
{
    int count = 0;
    NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    const char* cString = [self cStringUsingEncoding:gbkEncoding];
    
    if (cString) {
        count = (int)strlen(cString);
    }
    
    return count;
}

- (NSString *)substringWithMaxByteCount:(NSInteger)maxByteCount
{
    NSString *substring = nil;
    
    if ([self byteCount] > maxByteCount) {
        int currentByteCount = 0;
        NSRange subRange;
        NSString *nextWord = nil;
        
        substring = [NSString string];
        while (currentByteCount < maxByteCount) {
            subRange.location = substring.length;
            subRange.length = ((maxByteCount - substring.length) / 2);
            if ((subRange.location + subRange.length) > self.length) {
                subRange.length = (self.length - subRange.location);
            }
            substring = [substring stringByAppendingString:[self substringWithRange:subRange]];
            if ([substring byteCount] > maxByteCount) {
                substring = [substring substringToIndex:(substring.length - 1)];
                subRange.length -= 1;
            }
            currentByteCount = [substring byteCount];
            nextWord = [self substringWithRange:NSMakeRange((subRange.location + subRange.length), 1)];
            if ((currentByteCount + [nextWord byteCount]) > maxByteCount) {
                break;
            }
        }
        
        if (StringIsNullOrEmpty(substring)) {
            substring = nil;
        }
    } else {
        substring = [NSString stringWithString:self];
    }
    
    return substring;
}

//============================for core text=====================//

#pragma mark - Regular expression
- (NSMutableArray *)itemsForPattern:(NSString *)pattern
{
    return [self itemsForPattern:pattern captureGroupIndex:0];
}

- (NSMutableArray *)itemsForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index
{
    if ( !pattern )
        return nil;
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                     options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
        NSLog(@"Error for create regular expression:\nString: %@\nPattern %@\nError: %@\n",self, pattern, error);
    }
    else
    {
        NSMutableArray *results = [[NSMutableArray alloc] init];
        NSRange searchRange = NSMakeRange(0, [self length]);
        [regx enumerateMatchesInString:self options:0 range:searchRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
            
            NSRange groupRange =  [result rangeAtIndex:index];
            NSString *match = [self substringWithRange:groupRange];
            [results addObject:match];
        }];
        return results;
    }
    
    return nil;
}

- (NSString *)itemForPatter:(NSString *)pattern
{
    return [self itemForPattern:pattern captureGroupIndex:0];
}

- (NSString *)itemForPattern:(NSString *)pattern captureGroupIndex:(NSUInteger)index
{
    if ( !pattern )
        return nil;
    
    NSError *error = nil;
    NSRegularExpression *regx = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                     options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
        NSLog(@"Error for create regular expression:\nString: %@\nPattern %@\nError: %@\n",self, pattern, error);
    }
    else
    {
        NSRange searchRange = NSMakeRange(0, [self length]);
        NSTextCheckingResult *result = [regx firstMatchInString:self options:0 range:searchRange];
        NSRange groupRange = [result rangeAtIndex:index];
        NSString *match = [self substringWithRange:groupRange];
        return match;
    }
    
    return nil;
}

#pragma mark - Time Interval
- (NSTimeInterval)timeIntervalFromString:(NSString *)timeString withDateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [[formatter dateFromString:timeString] timeIntervalSince1970];
}

- (NSTimeInterval)localTimeIntervalFromString:(NSString *)timeString withDateFormat:(NSString *)format
{
    NSTimeInterval timeInterval = [self timeIntervalFromString:timeString withDateFormat:format];
    NSUInteger secondsOffset = [[NSTimeZone localTimeZone] secondsFromGMT];
    return (timeInterval + secondsOffset);
}

#pragma mark - Contains
- (BOOL)contains:(NSString *)piece
{
    return ( [self rangeOfString:piece].location != NSNotFound );
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
//============================for core text=====================//


- (id)objectFromJSONString
{
    
    @try {
         return [NSJSONSerialization JSONObjectWithData:[self dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }
    @catch (NSException *exception) {
        return nil;
    }

}

//json格式字符串转字典：
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
}

@end

@implementation NSMutableString (Extension)

-(void)appendLine:(NSString *)string
{
	[self appendFormat:@"%@\n",string];
}

@end

NSString * const NSStringRegexIsEmail = @"(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w+)+)$";
NSString * const NSStringRegexIsPhoneNumber = @"^1\\d{10}$";
