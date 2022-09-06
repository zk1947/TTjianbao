//
//  ViewHelp.m
//  TaoDangPuMall
//
//  Created by jiangchao on 2016/12/22.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

#import "CommHelp.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#import "UserInfoRequestManager.h"
#import "NSObject+Cast.h"

#import "JHSkinManager.h"
#import "JHSkinSceneManager.h"
#import "JHConst.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
//#define IOS_VPN       @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
#import <AdSupport/ASIdentifierManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

#import<CommonCrypto/CommonDigest.h>
#import <SSKeychain.h>
#define KeyIsInstalled @"isInstalled"
#define KeyClientIdentifier @""
#define KeyAcountUUID @"KeyAcountUUID"

#define KeyAppInfoUUIDIdentifier @""
#define KeyAppInfoUUIDAcount @"KeyAppInfoUUIDAcount"
@implementation CommHelp

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(void)setTabBarItem:(UITabBarItem *)tabbarItem
               title:(NSString *)title
       withTitleSize:(CGFloat)size
         andFoneName:(NSString *)foneName
       selectedImage:(NSString *)selectedImage
      withTitleColor:(UIColor *)selectColor
     unselectedImage:(NSString *)unselectedImage
      withTitleColor:(UIColor *)unselectColor{
    
    
//    JHSkinModel *model = [JHSkinManager getSkinInfoWithType:JHSkinTypeBarIndex0];
//    if (!model.isChange)
//    {
//        tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//            [tabbarItem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
//            tabbarItem.imageInsets=UIEdgeInsetsMake(-2, 0,2, 0);
//        
//        //未选中字体颜色
//        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateNormal];
//
//        //选中字体颜色
//        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont systemFontOfSize:size]} forState:UIControlStateSelected];
//
//    }
}

+(UIColor*)toUIColorByStr:(NSString*)colorStr{
    
    NSString *cString = [[colorStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
+(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    
    UIGraphicsBeginImageContext(image.size);

    CGContextRef context =UIGraphicsGetCurrentContext();

    //圆的边框宽度为2，颜色为红色

    CGContextSetLineWidth(context,1);

    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);

    CGRect rect = CGRectMake(inset, inset, image.size.width - inset *2.0f, image.size.height - inset *2.0f);

    CGContextAddEllipseInRect(context, rect);

    CGContextClip(context);

    //在圆区域内画出image原图

    [image drawInRect:rect];

    CGContextAddEllipseInRect(context, rect);

    CGContextStrokePath(context);

    //生成新的image

    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newimg;
    

}
+(NSArray *)sort:(NSArray *)array forParameter:(NSString*)parameter{
    
    NSArray *sorteArray1 = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        
        NSDictionary* dic1=(NSDictionary*)obj1;
        NSDictionary* dic2=(NSDictionary*)obj2;
        NSString * string1=[dic1 objectForKey:parameter];
        NSString * string2=[dic2 objectForKey:parameter];
        
        if ([string1 integerValue] > [string2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if ([string1 integerValue] < [string2 integerValue]){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
        //
    }];
    return sorteArray1;
}
+(NSArray *)sortString:(NSArray *)array forParameter:(NSString*)parameter{
    
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    
    NSComparator sort = ^(id obj1,id obj2){
        
        NSDictionary* dic1=(NSDictionary*)obj1;
        NSDictionary* dic2=(NSDictionary*)obj2;
        NSString * string1=[dic1 objectForKey:parameter];
        NSString * string2=[dic2 objectForKey:parameter];
        return [string1 compare:string2 options:comparisonOptions ];
        
    };
    
    NSArray *resultArray = [array sortedArrayUsingComparator:sort];
    return resultArray;
}

#pragma mark 保存图片到document
+(void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName
{
    float kCompressionQuality =0.4;
    NSData *imageData = UIImageJPEGRepresentation(tempImage, kCompressionQuality);
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    [imageData writeToFile:fullPathToFile atomically:NO];
}
#pragma mark 从文档目录下获取Documents路径
+ (NSString *)documentFolderPath
{
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
}
+ (NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"mmssSSS"];
    return [dateformat stringFromDate:[NSDate date]];
}
+(NSString*)getPastHafHourTime:(NSString*)creatTime{
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSString *date = [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
    
    long during=1800-([date integerValue ]-[creatTime integerValue]/1000);
    
    return [NSString stringWithFormat:@"%ld",during];
    //return  [self getMMSSFromSS:[NSString stringWithFormat:@"%ld",during]];
}


+(BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                // surrogate pair
                                if (0xd800 <= hs && hs <= 0xdbff)
                                {
                                    if (substring.length > 1)
                                    {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f918)
                                        {
                                            returnValue = YES;
                                        }
                                    }
                                }
                                else if (substring.length > 1)
                                {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3 || ls == 0xFE0F || ls == 0xd83c)
                                    {
                                        returnValue = YES;
                                    }
                                }
                                else
                                {
                                    // non surrogate
                                    if (0x2100 <= hs && hs <= 0x27ff)
                                    {
                                        if (0x278b <= hs && 0x2792 >= hs)
                                        {
                                            returnValue = NO;
                                        }
                                        else
                                        {
                                            returnValue = YES;
                                        }
                                    }
                                    else if (0x2B05 <= hs && hs <= 0x2b07)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x2934 <= hs && hs <= 0x2935)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (0x3297 <= hs && hs <= 0x3299)
                                    {
                                        returnValue = YES;
                                    }
                                    else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0xd83e)
                                    {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}
+(void)writeFile:(NSDictionary*)fileDic withName:(NSString*)fileName{
    
    NSString *documentsPath =[self documentFolderPath];
    NSString *Directory = [documentsPath stringByAppendingPathComponent:fileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:Directory]) {
        [[NSFileManager defaultManager] createFileAtPath:Directory contents:nil attributes:nil];  //如果文件不存在就创建一个
    }
    
    BOOL res= [fileDic writeToFile:Directory atomically:YES];
    if (res) {
        NSLog(@"文件写入成功");
    }else
        NSLog(@"文件写入失败");
}
//读文件
+(NSDictionary*)readFile:(NSString*)fileName{
    
    NSString *documentsPath =[self documentFolderPath];
    NSString *Directory = [documentsPath stringByAppendingPathComponent:fileName];
    NSDictionary* dic= [NSDictionary dictionaryWithContentsOfFile:Directory];
    
    return dic;
}

+ (UIColor*)colorWithHexString:(NSString*)stringToConvert{
    if([stringToConvert hasPrefix:@"#"])
    {
        stringToConvert = [stringToConvert substringFromIndex:1];
    }
    NSScanner*scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if(![scanner scanHexInt:&hexNum])
    {
        return nil;
    }
    return [self colorWithRGBHex:hexNum];
}

+ (UIColor*)colorWithRGBHex:(UInt32)hex{
    int r = (hex >>16) &0xFF;
    int g = (hex >>8) &0xFF;
    int b = (hex) &0xFF;
    return[UIColor colorWithRed:r /255.0f
                          green:g /255.0f
                           blue:b /255.0f
                          alpha:1.0f];
}
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString{
    
    if (identityString.length != 18) return NO;
    
    return YES;//测试提出去除本地余数验证，因为算法可能有问题
    
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    //  NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

+ (BOOL) IsBankCard:(NSString *)cardNumber
{
    if(cardNumber.length==0)
    {
        return NO;
    }
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < cardNumber.length; i++)
    {
        c = [cardNumber characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    int sum = 0;
    int digit = 0;
    int addend = 0;
    BOOL timesTwo = false;
    for (NSInteger i = digitsOnly.length - 1; i >= 0; i--)
    {
        digit = [digitsOnly characterAtIndex:i] - '0';
        if (timesTwo)
        {
            addend = digit * 2;
            if (addend > 9) {
                addend -= 9;
            }
        }
        else {
            addend = digit;
        }
        sum += addend;
        timesTwo = !timesTwo;
    }
    int modulus = sum % 10;
    return modulus == 0;
}


+(NSString *)objectToJsonStr:(id)object{
    
    
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:object])
        
    {
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"json data:%@",jsonString);
        
        if(error) {
            
            NSLog(@"Error:%@", error);
            
        }
        
    }
    
    return jsonString;
    
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if(jsonString == nil) {
        
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

//获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}
//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                    
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

+(NSString *)formatPhoneNum:(NSString *)phone
{
    
    NSString *formatStr;
    if ([phone hasPrefix:@"86"]) {
        formatStr = [phone substringWithRange:NSMakeRange(2, [phone length]-2)];
        
    }
    else if ([phone hasPrefix:@"+86"])
    {
        if ([phone hasPrefix:@"+86·"]) {
            formatStr = [phone substringWithRange:NSMakeRange(4, [phone length]-4)];
            
        }
        else
        {
            formatStr = [phone substringWithRange:NSMakeRange(3, [phone length]-3)];
            
        }
    }
    else{
        
        formatStr =phone;;
    }
    
    //删除字符串中的空格
    formatStr = [formatStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    formatStr = [formatStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"str:%@",formatStr);
    
    return formatStr;
}
+ (NSString *) md5:(NSString *) input {
//    const char *cStr = [input UTF8String];
//    unsigned char digest[CC_MD5_DIGEST_LENGTH];
//    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
//
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x", digest[i]];
//
//    return  output;
    // 判断传入的字符串是否为空
       if (! input) return nil;
       // 转成utf-8字符串
       const char *cStr = input.UTF8String;
       // 设置一个接收数组
       unsigned char result[CC_MD5_DIGEST_LENGTH];
       // 对密码进行加密
       CC_MD5(cStr, (CC_LONG) strlen(cStr), result);
       NSMutableString *md5Str = [NSMutableString string];
       // 转成32字节的16进制
       for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
           [md5Str appendFormat:@"%02x", result[i]];
       }
       return md5Str;
}



//时间转时间戳
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"]; //(@"yyyy-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    return timeSp;
    
}
//时间转时间戳 日
+(NSInteger)timeSwitchDatestamp:(NSString *)formatTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd"]; //(@"yyyy-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    return timeSp;
    
}
//时间戳转时间  日
+(NSString *)timestampSwitchTime:(NSInteger)timestamp {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"yyyy-MM-dd"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSLog(@"confromTimesp = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;

}

/// 转化成x 月 x 号
+ (NSString *)timestampSwitchTimeMonthDayAndhour:(NSInteger)timestamp {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日 HH:mm:ss"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    return confromTimespStr;
}



//时间戳转时间 秒
+(NSString*)timeChange:(NSString*)time{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time integerValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

+ (NSString*)stringWithTimeInterval:(NSString*)time formatter:(NSString *)formatterString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatterString];

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time integerValue]/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}
//获取当前时间戳  单位为毫秒
+(NSString *)getNowTimeTimestamp {
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}

+ (NSString *)timeForJHShowTime:(NSString*)timeStr
{
    //此处矫正时间,但是传回来的是与未来时间做对比,因此需要正负取反
    NSTimeInterval time = [CommHelp dateRemaining:timeStr];
    return [self timeFromTimeInterval:time];
}

+ (NSString *)showTimeFromTimeInterval:(NSTimeInterval)time
{
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    return [self timeFromTimeInterval:(time - nowTime)];
}

+ (NSString *)timeFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSTimeInterval time = timeInterval;
    //此处矫正时间,但是传回来的是与未来时间做对比,因此需要正负取反
    if(time < 0)
        time = fabs(time);
    else
        time = 0; //正数认为时间还没到
    NSInteger sec = time/60;
    if (sec < 60)
    {
        if(sec <= 0)
            return @"1分钟内";
        return [NSString stringWithFormat:@"%ld分钟前",sec];
    }
    
    // 秒转小时
    NSInteger hours = sec/60;
    if (hours < 24)
        return [NSString stringWithFormat:@"%ld小时前",hours];
    
    //秒转天数
    NSInteger days = hours/24;
    if (days < 30)
        return [NSString stringWithFormat:@"%ld天前",days];
    
    //秒转月
    NSInteger months = days/30;
    if (months < 12)
        return [NSString stringWithFormat:@"%ld月前",months];

    //秒转年
    NSInteger years = months/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}

//计算和当前时间的时间差
+(NSTimeInterval )dateRemaining:(NSString *)endDate{
    
    //日期格式设置,可以根据想要的数据进行修改 添加小时和分甚至秒
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //得到时区，根据手机系统时区设置（systemTimeZone）
    NSTimeZone* zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    //获取当前日期
    NSDate *nowDate=[NSDate date];
    
    /*GMT：格林威治标准时间*/
    //格林威治标准时间与系统时区之间的偏移量（秒）
    NSInteger nowInterval=[zone secondsFromGMTForDate:nowDate];
    //将偏移量加到当前日期
    NSDate *nowTime=[nowDate dateByAddingTimeInterval:nowInterval];
    //同步服务器时间差
    nowTime=[nowTime dateByAddingTimeInterval:-[UserInfoRequestManager sharedInstance].timeDifference];
    //传入日期设置日期格式
    
    NSDate *yourDate = [dateFormatter dateFromString:endDate];
    //格林威治标准时间与传入日期之间的偏移量
    NSInteger yourInterval = [zone secondsFromGMTForDate:yourDate];
    //将偏移量加到传入日期
    NSDate *yourTime = [yourDate dateByAddingTimeInterval:yourInterval];
    
    //time为两个日期的相差秒数
    NSTimeInterval time=[yourTime timeIntervalSinceDate:nowTime];
    
    return time;
    
}
// 获取同步后的 准确时间 date
+(NSDate* )getCurrentTrueDate{
    
    //日期格式设置,可以根据想要的数据进行修改 添加小时和分甚至秒
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //得到时区，根据手机系统时区设置（systemTimeZone）
     NSTimeZone* zone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    //获取当前日期
    NSDate *nowDate=[NSDate date];
    
    /*GMT：格林威治标准时间*/
    //格林威治标准时间与系统时区之间的偏移量（秒）
    NSInteger nowInterval=[zone secondsFromGMTForDate:nowDate];
    //将偏移量加到当前日期
    NSDate *nowTime=[nowDate dateByAddingTimeInterval:nowInterval];
    //同步服务器时间差
    nowTime=[nowTime dateByAddingTimeInterval:-[UserInfoRequestManager sharedInstance].timeDifference];
    //传入日期设置日期格式
    
    return nowTime;
}
+(BOOL) validate:(NSString *)PredicateUrl andCurrentUrl:(NSString *)currentUrl
{
    if ([PredicateUrl length]==0) {
        return NO;
    }
    NSString *Regex = PredicateUrl;
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",Regex];
    BOOL B = [userNamePredicate evaluateWithObject:currentUrl];
    return B;
}

//十六进制转换为普通字符串的。
+ (NSString *)ConvertHexStringToString:(NSString *)hexString {
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    //    NSLog(@"===字符串===%@",unicodeString);
    return unicodeString;
}

//普通字符串转换为十六进制
+ (NSString *)ConvertStringToHexString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


//int转data
+(NSData *)ConvertIntToData:(int)i
{
    
    NSData *data = [NSData dataWithBytes: &i length: sizeof(i)];
    return data;
}

//data转int
+(int)ConvertDataToInt:(NSData *)data{
    int i;
    [data getBytes:&i length:sizeof(i)];
    return i;
}

//十六进制转换为普通字符串的。
+ (NSData *)ConvertHexStringToData:(NSString *)hexString {
    
    NSData *data = [[CommHelp ConvertHexStringToString:hexString] dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

//
////根据UUIDString查找CBCharacteristic
//+(CBCharacteristic *)findCharacteristicFormServices:(NSMutableArray *)services
//                                         UUIDString:(NSString *)UUIDString{
//    for (CBService *s in services) {
//        for (CBCharacteristic *c in s.characteristics) {
//            if ([c.UUID.UUIDString isEqualToString:UUIDString]) {
//                return c;
//            }
//        }
//    }
//    return nil;
//}


+ (NSString *)getHMSWithSecond:(NSInteger)second {
    NSInteger hh = second/60/60;
    NSInteger mm = second/60%60;
    NSInteger ss = second%60;
    
    return hh>0 ?[NSString stringWithFormat:@"%02zd:%02zd:%02zd",hh,mm,ss]:[NSString stringWithFormat:@"%02zd:%02zd",mm,ss];
}

+ (NSString *)getHMSWithSecondWord:(NSInteger)second {
    NSInteger hh = second/60/60;
    NSInteger mm = second/60%60;
    NSInteger ss = second%60;
    
    if(hh>0){
        return [NSString stringWithFormat:@"%02zd时%02zd分%02zd秒",hh,mm,ss];
    }else if(mm>0){
        return [NSString stringWithFormat:@"%02zd分%02zd秒",mm,ss];
    }else{
        return [NSString stringWithFormat:@"%02zd秒",ss];
    }
    
}

+ (NSString *)saveImage:(UIImage*)image{
    
    NSString* filename=[NSString stringWithFormat:@"%@.jpg",[CommHelp getCurrentTimeString]];
    [CommHelp saveImage:image WithName:filename];
    NSString* photoPath=[[CommHelp documentFolderPath]stringByAppendingPathComponent:filename];
    return photoPath;
}

//获取当前时间戳  （以毫秒为单位）

+ (NSString *)getNowTimeTimestampMS{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a = [dat timeIntervalSince1970];
    
    NSString *timeString = [NSString stringWithFormat:@"%0.f", a*1000];//转为字符型
    
    return timeString;


}
//获取当前时间戳(同步服务器时间后)  （以毫秒为单位）

+ (NSString *)getNowTimetampBySyncServeTime{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    //同步服务器时间差
    datenow=[datenow dateByAddingTimeInterval:-[UserInfoRequestManager sharedInstance].timeDifference];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}
//获取6位随机数
+(NSString *)getRandomNumber
{
    int number = arc4random() % 1000000;
    return [NSString stringWithFormat:@"%06d", number];
}
//+(NSString*) sha1:(NSString*)string
//{
//    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
//
//    NSData *data = [NSData dataWithBytes:cstr length:string.length];
//    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
//    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
//    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
//    CC_SHA1(data.bytes, data.length, digest);
//
//    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//
//    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x", digest[i]];
//
//    return output;
//}
+ (NSString *)sha1:(NSString *)inputString{
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(unsigned int)data.length,digest);
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x",digest[i]];
    }
    return [outputString lowercaseString];
}
+ (NSInteger)isInstalledApp{
    
    NSInteger isInstalled = [[NSUserDefaults standardUserDefaults] integerForKey:KeyIsInstalled];
    if (isInstalled == 0) {
        isInstalled = [[SSKeychain passwordForService:@"com.yiding.jianhuo" account:KeyIsInstalled] integerValue];
        if (isInstalled) {
            [[NSUserDefaults standardUserDefaults] setInteger:isInstalled forKey:KeyIsInstalled];
            [[NSUserDefaults standardUserDefaults] synchronize];

        }else {
            [SSKeychain setPassword:@"1" forService:@"com.yiding.jianhuo" account:KeyIsInstalled];
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:KeyIsInstalled];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
    }
    return isInstalled;
}

+ (BOOL)isFirstForName:(NSString*)name{
    
    BOOL isfirst=[[NSUserDefaults standardUserDefaults] boolForKey:name];
    if (!isfirst) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:name];
        [[NSUserDefaults standardUserDefaults]synchronize];
        };
    
      return !isfirst;
}

+ (BOOL)isFirstTodayForName:(NSString*)name {
    
    NSString *key = name;
    if ([JHRootController isLogin]) {
        key = [key stringByAppendingString:[UserInfoRequestManager sharedInstance].user.customerId ? : @""];
    }
    NSString *date = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *today = [CommHelp getCurrentDate];
    if (!date) {
        [[NSUserDefaults standardUserDefaults] setObject:today forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else {
        if ([date isEqualToString:today]) {
            return NO;
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:today forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return YES;
        }
    }
    
}
+ (BOOL)isOverSevenTodayForName:(NSString*)name {

    NSString *key = name;
    if ([JHRootController isLogin]) {
        key = [NSString stringWithFormat:@"%@%@",key ,[UserInfoRequestManager sharedInstance].user.customerId];
    }
    NSString *date = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSString *today = [CommHelp getCurrentDate];
    if (!date) {
        [[NSUserDefaults standardUserDefaults] setObject:today forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else {

        if ([self numberOfDaysWithFromDate:date toDate:today]<7) {
            return NO;
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:today forKey:key];
            [[NSUserDefaults standardUserDefaults] synchronize];
            return YES;
        }
    }

}
+ (NSInteger)numberOfDaysWithFromDate:(NSString *)from toDate:(NSString *)to{
    
    //创建两个日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *startDate = [dateFormatter dateFromString:from];
    NSDate *endDate = [dateFormatter dateFromString:to];
    
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    //打印
    NSLog(@"cxcxc==%ld",delta.day);
    //获取其中的"天"
     return delta.day;
}

// uuid  appinfo
+ (NSString *)getAppinUUIDFoKeyChain {
    
//    NSString *uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    
    
    NSError *error= nil;
    NSString *accountID = nil;
    
    accountID = [[NSUserDefaults standardUserDefaults] objectForKey:KeyAppInfoUUIDAcount];

    if ([accountID isEqualToString:@""] || accountID == nil ){
        accountID = [SSKeychain passwordForService:KeyAppInfoUUIDIdentifier account:KeyAppInfoUUIDAcount error:&error];
        if (error) {
            NSLog(@"getKeyChain error:%@", error.localizedDescription);
        }
        if (accountID) {
            [[NSUserDefaults standardUserDefaults] setObject:accountID forKey:KeyAppInfoUUIDAcount];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    }
    
    if ([accountID isEqualToString:@""] || accountID == nil) {
        // 随机生成一个UUID，只需要生成一次
        
        accountID = [[UIDevice currentDevice].identifierForVendor UUIDString];
        accountID = [accountID stringByReplacingOccurrencesOfString:@"-" withString:@"w"];
        accountID = [accountID md5String];
        [SSKeychain setPassword:accountID forService:KeyAppInfoUUIDIdentifier account:KeyAppInfoUUIDAcount error:&error];
        
        if (accountID) {
            [[NSUserDefaults standardUserDefaults] setObject:accountID forKey:KeyAppInfoUUIDAcount];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    }
    if([accountID length] > 0)
        return accountID;
    else
        return @"1234567890123456789012345678fail";
    
}
//最早使用idfa 后来改成 自己生成 2.3.6 添加成idfa 3.0.3 改成自己生成
+ (NSString *)getKeyChainUUID
{
    NSError *error= nil;
    NSString *accountID = nil;
    
    accountID = [[NSUserDefaults standardUserDefaults] objectForKey:KeyAcountUUID];

    if ([accountID isEqualToString:@""] || accountID == nil ){
        accountID = [SSKeychain passwordForService:KeyClientIdentifier account:KeyAcountUUID error:&error];
        if (error) {
            NSLog(@"getKeyChain error:%@", error.localizedDescription);
        }
        if (accountID) {
            [[NSUserDefaults standardUserDefaults] setObject:accountID forKey:KeyAcountUUID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    }
    
    if ([accountID isEqualToString:@""] || accountID == nil) {
        // 随机生成一个UUID，只需要生成一次
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        accountID = (__bridge NSString *)stringRef;
        accountID = [accountID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [SSKeychain setPassword:accountID forService:KeyClientIdentifier account:KeyAcountUUID error:&error];
        CFRelease(stringRef);
        CFRelease(uuidRef);
        
        if (accountID) {
            [[NSUserDefaults standardUserDefaults] setObject:accountID forKey:KeyAcountUUID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

    }
    if([accountID length] > 0)
        return accountID;
    else
        return kReadUUIDFail;
}

/*
+ (NSString *)getKeyChainUUID
{
    NSError *error= nil;
    NSString *accountID = nil;
    // 1,首先从user defaults读取
    accountID = [[NSUserDefaults standardUserDefaults] objectForKey:KeyAcountUUID];
    // 2,如果没取到,则从key chain读取
    if ([accountID isEqualToString:@""] || accountID == nil)
    {
        accountID = [SSKeychain passwordForService:KeyClientIdentifier account:KeyAcountUUID error:&error];
        if (error) {
            NSLog(@"getKeyChain error:%@", error.localizedDescription);
        }
    }
    // 3,如果没取到,则直接读取设备IDFA(如果读取到,则存userdefault&keychain)
    if ([accountID isEqualToString:@""] || accountID == nil)
    {
        accountID = [CommHelp deviceIDFA];
        if ([accountID length] > 0)
        {
            BOOL success = [SSKeychain setPassword:accountID forService:KeyClientIdentifier account:KeyAcountUUID error:&error];
            if(!success)
            {
                NSLog(@"get IDFA fail!");
            }
        }
    }
    // 4,如果还没有取到,则随机生成一个UUID
    if ([accountID isEqualToString:@""] || accountID == nil)
    {
        // 随机生成一个UUID，只需要生成一次
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef stringRef = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        accountID = (__bridge NSString *)stringRef;
        accountID = [accountID stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        [SSKeychain setPassword:accountID forService:KeyClientIdentifier account:KeyAcountUUID error:&error];
        CFRelease(stringRef);
        CFRelease(uuidRef);
    }
    //5,同时保存到userdefault
    if ([accountID length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:accountID forKey:KeyAcountUUID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return accountID;
}
 */

/*  IDFA（identifierForIdentifier）广告标示符，适用于对外：例如广告推广，换量等跨应用的用户追踪等
 *     在同一个设备上的所有App都会取到相同的值，是苹果专门给各广告提供商用来追踪用户而设的，用户可
 *     以在 设置|隐私|广告追踪里重置此id的值，或限制此id的使用，故此id有可能会取不到值，但好在Apple
 *     默认是允许追踪的，而且一般用户都不知道有这么个设置，所以基本上用来监测推广效果，是戳戳有余了。
 *     注意：由于idfa会出现取不到的情况，故绝不可以作为业务分析的主id，来识别用户
 *    @return NSString
 */
+ (NSString*)deviceIDFA {
    if (@available(iOS 14.5, *)) {
        // iOS14及以上版本需要先请求权限
        ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
        if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
            NSLog(@"用户允许");
            NSString *idfa = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
            if ([idfa length] > 0) {
                return idfa;
            } else {
                return kReadIDFAFail;
            }
        } else {
            NSLog(@"用户拒绝 或 用户未做选择或未弹窗");
            return kUserCloseAdvertisingSystemSettings;
        }
    } else {
        // Fallback on earlier versions
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSUUID *IDFA = [[ASIdentifierManager sharedManager] advertisingIdentifier];
            NSString* idfaStr = [IDFA UUIDString];
            if([idfaStr length] > 0)
                return idfaStr;
            else
                return kReadIDFAFail;
        } else {
            NSLog(@"用户开启了限制广告追踪");
            return kUserCloseAdvertisingSystemSettings;
       }
    }
     //如果用户关闭系统广告,传此值
    return kUserCloseAdvertisingSystemSettings;

    
//    if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled])
//    {
//        NSUUID *IDFA = [[ASIdentifierManager sharedManager] advertisingIdentifier];
//        NSString* idfaStr = [IDFA UUIDString];
//        if([idfaStr length] > 0)
//            return idfaStr;
//        else
//            return kReadIDFAFail;
//    }
//     //如果用户关闭系统广告,传此值
//    return kUserCloseAdvertisingSystemSettings;
}


+ (BOOL)isFirstInLiveRoom {
    NSString *key = @"isFirstInLiveRoom";
    NSInteger isInstalled = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    if (isInstalled == 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return !isInstalled;

}
+ (void)SaveEnterRoomCount{
    NSString *key = @"EnterRoomCount";
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    count++;
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)isShowAppraisalAlert{
    NSString *key = @"EnterRoomCount";
    NSInteger limitcount = 10;
    NSInteger count = [[NSUserDefaults standardUserDefaults] integerForKey:key];
    if (count == limitcount) {
        return YES;
    }
    return NO;
}
//获取当前日期

+(NSString*)getCurrentDate{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
   
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}
 
+(NSString*)getDateStringFromDate:(NSDate*)date{
    
       NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
       [formatter setDateFormat:@"yyyy-MM-dd"];
       NSString *currentTimeString = [formatter stringFromDate:date];
       NSLog(@"currentTimeString =  %@",currentTimeString);
       return currentTimeString;
    
}
//获取周几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {

    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];

    [calendar setTimeZone: timeZone];

    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;

    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];

    return [weekdays objectAtIndex:theComponents.weekday];

}


+ (BOOL)checkTheDate:(NSString *)string{
    if (isEmpty(string)) {
        return NO;
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd"];
    [format setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *date = [format dateFromString:string];
    BOOL isToday = [[NSCalendar currentCalendar] isDateInToday:date];
   
    return isToday;
}
+ (BOOL)isNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}
+ (NSString *)changeAsset:(NSString *)amountStr{
    if(amountStr&&![amountStr isEqualToString:@""])
        
    {   NSInteger num = [amountStr integerValue];
        if (num>=10000) {
            NSInteger wan = num/10000;
            NSInteger qian = num%10000/1000;
            return qian > 1 ? [NSString stringWithFormat:@"%ld.%ld万", (long)wan, (long)qian]
                            : [NSString stringWithFormat:@"%ld万", (long)wan];
        }
    }
    return amountStr;
}

///数字大于1万，转换成1w+、10w+...不保留小数
//+ (NSString *)convertIntegerToTensUnit:(NSInteger)integer {
//    NSString *integerStr = @(integer).stringValue;
//    if ([integerStr mj_isPureInt]) {
//        if (integer >= 10000) {
//            integerStr = [NSString stringWithFormat:@"%ldw+", (long)(integer/10000)];
//        }
//    }
//    return integerStr;
//}

+ (NSString *)convertNumToWUnitString:(NSInteger)integer existDecimal:(BOOL)existDecimal {
    NSString *integerStr = @(integer).stringValue;
    if ([integerStr mj_isPureInt]) {
        if (integer >= 10000) {
            double num = integer/10000.f;
            if (existDecimal) {
                integerStr=  [NSString stringWithFormat:@"%.1fw", num];//保留1位小数
            } else {
                integerStr = [NSString stringWithFormat:@"%ldw+", (long)num]; //不保留小数
            }
        }
    }
    //过滤.0：例如1.0w去掉.0
    integerStr = [integerStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    return integerStr;
}

+ (NSString *)convertNumToWUnitString:(NSInteger)integer {
    NSString *integerStr = @(integer).stringValue;
    if (integer >= 10000 && integer < 100000) {
        integerStr = [NSString stringWithFormat:@"%.1fw", (float)integer / 10000];
    }
    else if (integer >= 100000) {
        integerStr = [NSString stringWithFormat:@"%ldw", (long)integer / 10000];
    }
    else {
        integerStr = @(integer).stringValue;
    }
    return integerStr;
}

+ (BOOL)isAvailablePrice:(NSString *)price {
    if (!price) {
        return NO;
    }
    if ([price isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([price isKindOfClass:[NSString class]] && [price floatValue] > 0.0) {
        return YES;
    }else{
        return NO;
    }

}

+ (BOOL)isUserNotificationEnable { // 判断用户是否允许接收通知
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) { // iOS版本 >=8.0 处理逻辑
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    } else { // iOS版本 <8.0 处理逻辑
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        isEnable = (UIRemoteNotificationTypeNone == type) ? NO : YES;
    }
    return isEnable;
}

// 如果用户关闭了接收通知功能，该方法可以跳转到APP设置页面进行修改  iOS版本 >=8.0 处理逻辑
+ (void)goToAppSystemSetting {
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([application canOpenURL:url]) {
        if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
            [application openURL:url options:@{} completionHandler:nil];
        } else {
            [application openURL:url];
        }
    }
}
//时间转时间戳
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"yyyy-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}
//时间戳转时间
+(NSString*)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
      NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSLog(@"confromTimesp = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}

+ (NSString*)getCurrentTime:(NSString *)dateFormatter {
    NSDate *datenow = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = dateFormatter;
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}

+ (BOOL) deptNumInputShouldNumber:(NSString *)str {
   if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:str];

}
+ (NSString *)ConvertDataToString:(NSData *)data{
    NSMutableString *string = [NSMutableString string];
    const char *bytes = data.bytes;
    NSUInteger iCount = data.length;
    for (int i = 0; i < iCount; i++) {
        [string appendFormat:@"%02x", bytes[i]&0x000000FF];
    }
    return [NSString stringWithString:string] ;
}

///判断是否是同一年
+ (BOOL)isSameYear:(NSString *)compareYear {
    NSString *currentYear = [CommHelp getCurrentTime:@"yyyy"];
    NSLog(@"currentYear:--- %@", currentYear);
    BOOL isSame = [compareYear integerValue] == [currentYear integerValue];
    return isSame;
}


- (BOOL)isSameDay:(NSDate *)date1 date2:(NSDate *)date2 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *comp1 = [calendar components:unitFlag fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unitFlag fromDate:date2];
    return (([comp1 day] == [comp2 day]) && ([comp1 month] == [comp2 month]) && ([comp1 year] == [comp2 year]));
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString *)mobile {
    NSString *phoneRegex1=@"1[3456789]([0-9]){9}";
    NSPredicate *phoneTest1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex1];
    return [phoneTest1 evaluateWithObject:mobile];
}

//NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//[numberFormatter setPositiveFormat:@"###0.##"];
//NSString *formattedNumberString = [numberFormatter stringFromNumber:@122344.4563];

/**
 NSNumberFormatterNoStyle = kCFNumberFormatterNoStyle,四舍五入
 NSNumberFormatterDecimalStyle = kCFNumberFormatterDecimalStyle,金额 100,200,300.123
 NSNumberFormatterCurrencyStyle = kCFNumberFormatterCurrencyStyle,货币 $100,200,300.12
 NSNumberFormatterPercentStyle = kCFNumberFormatterPercentStyle,百分比 12%
 NSNumberFormatterScientificStyle = kCFNumberFormatterScientificStyle,科学计数法 1.234E8
 */

+ (NSString *)jh_numberSplitWithComma:(NSInteger)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:@(number)];
    return formattedNumberString;
}

+ (BOOL)checkUrlWithString:(NSString *)url {
    if(url.length < 1)
        return NO;
   
    NSURL *result;
    NSString *trimmedStr;
    NSRange schemeMarkerRange;
    NSString *scheme;

    assert(url != nil);
    result = nil;

    trimmedStr = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if ((trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        if (schemeMarkerRange.location == NSNotFound) {
            return NO;
        }
        else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            if (([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame) ||
                ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                return YES;
            } else {
                return NO;
            }
        }
    }
       
    return NO;

}

+ (NSString*)getPriceWithInterFen:(NSInteger)fen{
//    BOOL lastZero = fen%10 == 0;
//    BOOL nofloat = fen%100 == 0;
//
//    NSString *str = [NSString stringWithFormat:@"%.2f", fen/100.f];
//    if (nofloat) {
//        str = [NSString stringWithFormat:@"%ld", fen/100];
//    }else if(lastZero){
//        str = [NSString stringWithFormat:@"%.1f", fen/100.f];
//    }
//    return str;
    NSString *str = @(fen).stringValue;
    NSString *resultStr = @"0";
    if (str.length && fen != 0) {
        NSString *yuanStr = @"0";
        NSString *jiaoStr = @"0";
        if (str.length > 2) {
            yuanStr = [str substringToIndex:str.length - 2];
        }
        if (str.length > 1) {
            jiaoStr = [str substringWithRange:NSMakeRange(str.length - 2, 1)];
        }
        NSString *fenStr = [str substringFromIndex:str.length - 1];
        
        if (fenStr.integerValue == 0 && jiaoStr.integerValue == 0) {
            resultStr = yuanStr;
        }else if(fenStr.integerValue == 0){
            resultStr = [NSString stringWithFormat:@"%@.%@",yuanStr,jiaoStr];
        }else{
            resultStr = [NSString stringWithFormat:@"%@.%@%@",yuanStr,jiaoStr, fenStr];
        }
    }
    return resultStr;
}


@end

