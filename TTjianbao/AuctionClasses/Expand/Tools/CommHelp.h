//
//  ViewHelp.h
//  TaoDangPuMall
//
//  Created by jiangchao on 2016/12/22.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

#import <Foundation/Foundation.h>

/** UUID即IMEI 、IDFA读取失败和被关闭时,特殊处理
 * 1<如果读取失败,则给特定值
 * 2<IDFA被关闭,则给特殊值
 **/
#define kReadUUIDFail @"ReadUUIDFail"
#define kReadIDFAFail @"ReadIDFAFail"
#define kUserCloseAdvertisingSystemSettings @"UserCloseAdvertisingSystemSettings"

@interface CommHelp : NSObject
+(void)setTabBarItem:(UITabBarItem *)tabbarItem
               title:(NSString *)title
       withTitleSize:(CGFloat)size
         andFoneName:(NSString *)foneName
       selectedImage:(NSString *)selectedImage
      withTitleColor:(UIColor *)selectColor
     unselectedImage:(NSString *)unselectedImage
      withTitleColor:(UIColor *)unselectColor;


//颜色转换
+(UIColor*)toUIColorByStr:(NSString*)colorStr;

//随机颜色
+ (UIColor *)randomColor;

//画圆角
+(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset;

//排序
+(NSArray *)sort:(NSArray *)array forParameter:(NSString*)parameter;


+(NSArray *)sortString:(NSArray *)array forParameter:(NSString*)parameter;


+(NSString*)timeChange:(NSString*)time;

+(void)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName;
+ (NSString *)documentFolderPath;
+ (NSString*)getCurrentTimeString;
+(NSString*)getPastHafHourTime:(NSString*)creatTime;
+(BOOL)isIncludeSpecialCharact: (NSString *)str;
+ (BOOL)stringContainsEmoji:(NSString *)string;

//根据颜色创建image
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;


+(void)writeFile:(NSDictionary*)fileDic withName:(NSString*)fileName;
+(NSDictionary*)readFile:(NSString*)fileName;

+ (UIColor*)colorWithHexString:(NSString*)stringToConvert;
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString;
+ (BOOL) IsBankCard:(NSString *)cardNumber;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+(NSString *)objectToJsonStr:(id)object;
//获取ip地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+(NSString *)formatPhoneNum:(NSString *)phone;

//判断数字
//+ (BOOL)isPureInt:(NSString *)string;
//+ (NSData *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

//md5加密
+ (NSString *) md5:(NSString *) input;

//获取当前时间戳有两种方法(以秒为单位)
+(NSString *)getNowTimeTimestamp;


+ (NSString *)sha1:(NSString *)inputString;

//十六进制转换为普通字符串的。
+ (NSString *)ConvertHexStringToString:(NSString *)hexString;
//普通字符串转换为十六进制
+ (NSString *)ConvertStringToHexString:(NSString *)string;
//int转data
+(NSData *)ConvertIntToData:(int)i;
//data转int
+(int)ConvertDataToInt:(NSData *)data;
//十六进制转换为普通字符串的。
+ (NSData *)ConvertHexStringToData:(NSString *)hexString;

+ (NSString *)ConvertDataToString:(NSData *)data;
////根据UUIDString查找CBCharacteristic
//+(CBCharacteristic *)findCharacteristicFormServices:(NSMutableArray *)services
//                                         UUIDString:(NSString *)UUIDString;

+ (NSString *)getHMSWithSecond:(NSInteger)second;
+ (NSString *)getHMSWithSecondWord:(NSInteger)second;

+ (NSString *)saveImage:(UIImage*)image;

+ (NSString *)deviceIDFA;

//显示N分钟以前格式
+ (NSString *)timeForJHShowTime:(NSString*)timeStr;
//与上面的参数不同
+ (NSString *)showTimeFromTimeInterval:(NSTimeInterval)time;
//计算日期差和当前时间比
+(NSTimeInterval)dateRemaining:(NSString *)endDate;

+ (NSString *)getNowTimeTimestampMS;
+ (NSString *)getNowTimetampBySyncServeTime;
+(NSString *)getRandomNumber;
+ (NSInteger)isInstalledApp;
+ (NSString *)getKeyChainUUID;
// uuid  appinfo
+ (NSString *)getAppinUUIDFoKeyChain;

+(NSDate* )getCurrentTrueDate;
+(NSString*)getDateStringFromDate:(NSDate*)date;

+ (BOOL)isFirstInLiveRoom;
//获得当前日期
+(NSString*)getCurrentDate;
//检查是否为今天
+ (BOOL)checkTheDate:(NSString *)string;

+ (BOOL)isNum:(NSString *)checkedNumString;

+ (NSString *)changeAsset:(NSString *)amountStr;

///数字大于1万，转换成1w+、10w+... <existDecimal 是否保留小数>
+ (NSString *)convertNumToWUnitString:(NSInteger)integer existDecimal:(BOOL)existDecimal;
+ (NSString *)convertNumToWUnitString:(NSInteger)integer;

+ (BOOL)isFirstForName:(NSString*)name;

//是否今天第一次
+(BOOL)isFirstTodayForName:(NSString*)name;

+ (BOOL)isOverSevenTodayForName:(NSString*)name;

+ (BOOL)isAvailablePrice:(NSString *)price;

+ (BOOL)isUserNotificationEnable;

+ (void)goToAppSystemSetting;

+(NSString *)timestampSwitchTime:(NSInteger)timestamp;
+(NSInteger)timeSwitchDatestamp:(NSString *)formatTime;
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime;
+ (NSInteger)numberOfDaysWithFromDate:(NSString *)from toDate:(NSString *)to;

+ (void)SaveEnterRoomCount;
+ (BOOL)isShowAppraisalAlert;

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;

+(NSString*)timestampSwitchTime:(NSInteger)timestamp andFormatter:(NSString *)format;

//获取周几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;

///获取当前时间
+ (NSString*)getCurrentTime:(NSString *)dateFormatter;


/// 根据格式把时间戳转换成日期
/// @param time 时间戳
/// @param formatterString @"yyyy-MM-dd HH:mm:ss"
+ (NSString*)stringWithTimeInterval:(NSString*)time formatter:(NSString *)formatterString;

///判断是否全是数字
+ (BOOL) deptNumInputShouldNumber:(NSString *)str;

///判断是否是同一年
+ (BOOL)isSameYear:(NSString *)compareYear;

/*手机号码验证 MODIFIED BY HELENSONG*/
+ (BOOL)isValidateMobile:(NSString *)mobile;

/*将数字用逗号分隔 隔3个一个逗号*/
+ (NSString *)jh_numberSplitWithComma:(NSInteger)number;

/*判断字符串是否是url*/
+ (BOOL)checkUrlWithString:(NSString *)url;

+ (NSString *)timestampSwitchTimeMonthDayAndhour:(NSInteger)timestamp;


/// 返回字符串 "143"   "14.1"  "14.22"
/// @param fen  分为单位
+ (NSString*)getPriceWithInterFen:(NSInteger)fen;
@end
