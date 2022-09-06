//
//  Created by zhougf on 17/6/3.
//  Copyright © 2017年 printer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^ReadPrinterBlock)(NSString *state,NSError *error);
typedef void (^CheckIDBlock)(BOOL success);
typedef void (^ReadIdcardBlock)(NSData *data,NSError *error);
///字号
typedef enum _fontSizeDot{
    fontSizeDot16 = 1,              ///16点阵
    fontSizeDot24,                  ///24点阵
    fontSizeDot32,                  ///32点阵
    fontSizeDotBold24,              ///24点阵放大一倍
    fontSizeDotBold32,              ///32点阵放大一倍
    fontSizeDotDouble24,            ///24点阵放大两倍
    fontSizeDotDouble32,            ///32点阵放大两倍
    fontSizeDotBold20,              ///20点阵
    fontSizeDotBold28               ///28点阵放大一倍
}fontSizeDot;
///旋转角度
typedef enum _rotationPrint {
    rotationAngle0 = 0,             ///不旋转
    rotationAngle90,                ///90度
    rotationAngle180,               ///180度
    rotationAngle270                ///270度
}rotationPrint;
//打印状态
/*typedef enum _printResult {
    printResultSuccessful,
    printResultCoverOpen,
    printResultNoPaper,
    printResultOverHeat,
    printResultPrinting,
    printResultBatteryLow,
    printResultFailed,
    printResultInvalidDevice,
    printResultUnknow
}printResult;*/

typedef enum _printResult {
    printResultSuccessful,//打印成功
    printResultFailed,//打印失败
    printResultInvalidDevice,
    printResultUnknow
}printResult;
//打印状态
typedef enum _printStatus{
    printResultCoverOpen,//纸舱盖打开
    printResultNoPaper,//缺纸
    printResultOverHeat,//打印头过热
    printResultPrinting,//打印中
    printResultBatteryLow,//低电压
    printResultOk,//正常
}printStatus;


typedef enum _printerState {
    printerStateUnknown = 0,
    printerStateResetting,//复位
    printerStateUnsupported,
    printerStateUnauthorized,
    printerStatePoweredOff,//蓝牙关闭
    printerStatePoweredOn//蓝牙打开
}printerState;


@interface printerMessage : NSObject

@property (nonatomic)NSString  *name;
@property (nonatomic)NSString  *identifier;

@end

@protocol QRPrinterInterfaceDelegate <NSObject>

@optional
- (void)bleDidDiscoverPrints:(NSArray<printerMessage *> *)devices;
- (void)bleDidConnectFail:(NSError *)error;
- (void)bleDidConnect;
- (void)bleDidDisconnect;
- (void)bleDidUpdateRSSI:(NSNumber *)rssi;
- (void)bleDidUpdateState:(printerState)state;
- (void)bleDidFinishPrint:(printResult)state;
- (void)blePrinterStatus:(printStatus)status;
- (void)printerisready;
@end

@interface QRPrinterInterface : NSObject
{
   // __unsafe_unretained id<QRPrinterInterfaceDelegate> _delegate;
}

@property (nonatomic,assign)id<QRPrinterInterfaceDelegate> delegate;

//返回打印机单例对象
+ (QRPrinterInterface *)sharedInstance;
//创建打印服务，成功返回YES，失败返回NO
+ (BOOL)registerPrinter;

//注销打印服务
+ (void)unregisterPrinter;

///1.打开与蓝牙打印机的连接
- (void)connect:(printerMessage *)printer;
///2.关闭与蓝牙打印机的连接。
- (void)disconnect;
///3.判断是否连接
//返回值：true（已连接） | false （未连接）
- (BOOL)isConnected;
//返回打印机的状态
- (void)checkPrinterStatus;

///4.页模式下打印
//参数：
//horizontal:
//        0:正常打印，不旋转；
//        1：整个页面顺时针旋转180°后，再打印
//skip：
//        0：打印结束后不定位，直接停止；
//        >0：打印结束后定位到标签分割线，如果无缝隙，最大进纸skip个dot后停止(1mm==8dot)
- (void)print:(int)horizontal skip:(NSUInteger)skip;

///5.设置打印纸张大小（打印区域）的大小
//参数：
//pageWidth 打印区域宽度
//pageHeight 打印区域高度
- (void)pageSetup:(int)pageWidth  pageHeight:(int)pageHeight;
///6.打印的边框
//参数：
//lineWidth 边框线条宽度
//top_left_x 矩形框左上角x坐标
//top_left_y 矩形框左上角y坐标
//bottom_right_x 矩形框右下角x坐标
//bottom_right_y 矩形框右下角y坐标
- (void)drawBox:(int)lineWidth  top_left_x:(int)top_left_x
    top_left_y:(int)top_left_y bottom_right_x:(int)bottom_right_x bottom_right_y:(int)bottom_right_y;
///7.打印线条
//参数：
//lineWidth 线条宽度
//start_x 线条起始点x坐标
//start_y 线条起始点y坐标
//end_x 线条结束点x坐标
//end_y 线条结束点y坐标
//fullline  true:实线  false: 虚线
- (void) drawLine:(int)lineWidth start_x:(int)start_x start_y:(int)start_y end_x:(int)end_x end_y:(int)end_y fullline:(BOOL)fulline;

///8.页模式下打印文本框
//参数：
//text_x 起始横坐标
//text_y 起始纵坐标
//text  打印的文本内容
//fontSize 字体大小 :
//        1：16点阵；
//        2：24点阵；
//        3：32点阵；
//        4：24点阵放大一倍；
//        5：32点阵放大一倍
//        6：24点阵放大两倍；
//        7：32点阵放大两倍；
//其他：24点阵
//rotate 旋转角度:
//        0：不旋转；	1：90度；	2：180°；	3:270°
//bold 是否粗体
//      0：否； 1：是
//reverse 是否反白
//      false：不反白；true：反白
//underline  是有有下划线
//      false:没有；true：有
- (void)drawText:(int)text_x
         text_y:(int)text_y
        strText:(NSString *)strText
       fontSize:(fontSizeDot)fontSize
         rotate:(rotationPrint)rotate
           bold:(BOOL)bold
        reverse:(BOOL)reverse
      underLine:(BOOL)underLine;

///9.打印文字
//参数：
//text_x 起始横坐标
//text_y 起始纵坐标
//width	 文本框宽度
//height	 文本框高度
//text	 文本内容
//fontSize	字体大小：
//        1：16点阵；
//        2：24点阵；
//        3：32点阵；
//        4：24点阵放大一倍；
//        5：32点阵放大一倍
//        6：24点阵放大两倍；
//        7：32点阵放大两倍；
//        其他：24点阵
//rotate 旋转角度:
//        0：不旋转；	1：90度；	2：180°；	3:270°
//bold 是否粗体
//        0：否； 1：是
//reverse 是否反白
//        false：不反白；true：反白
//underline  是有有下划线
//        false:没有 true：有
- (void)drawText:(int)text_x
         text_y:(int)text_y
          width:(int)width
         height:(int)height
        strText:(NSString*)strText
       fontSize:(fontSizeDot)fontSize
         rotate:(rotationPrint)rotate
           bold:(BOOL)bold
      underline:(BOOL)underline
        reverse:(BOOL)reverse;


///10.一维条码
//参数：
//start_x 一维码起始横坐标
//start_y 一维码起始纵坐标
//text    内容
//type 条码类型：
//        0：CODE39；	1：CODE128；
//        2：CODE93；	3：CODEBAR；
//        4：EAN8；  	5：EAN13；
//        6：UPCA;   	7:UPC-E;
//        8:ITF
//Linewidth 条码线宽度
//Height 条码高度
- (void)drawBarCode:(int)start_x start_y:(int)start_y textStr:(NSString*)text type:(int)type rotate:(int)rotate lineWidth:(int)linewidth height:(int) height;

///11.二维码
//参数：
//start_x 二维码起始横坐标
//start_y 二维码起始纵坐标
//text    二维码内容
//rotate 旋转角度：
//        0：不旋转；	1：90度；	2：180°；	3:270°
//ver  QrCode宽度(2-6)
//lel  QrCode纠错等级(0-20)
- (void)drawQrCode:(int)start_x start_y:(int)start_y strText:(NSString*)text rotate:(int)rotate  ver:(int)ver level:(int)level;

///12.图片
//参数：
//start_x 图片起始点x坐标
//start_y 图片起始点y坐标
//bmp_size_x 图片的宽度
//bmp_size_y 图片的高度
//bmp 图片
- (void)drawGraphic:(int)start_x start_y:(int)start_y bmp_size_x:(int) bmp_size_x bmp_size_y:(int)bmp_size_y img:(UIImage *)img;

///13.打印机的状态信息
- (void)printerStatus:(ReadPrinterBlock)block;

///14.定位到标签
- (void)feed;

///15.获取SDK版本号
- (NSString *)getSDKVersion;

///16.搜索设备
- (void)searchPrinter;

//停止搜索设备
- (void)stopsearchPrinter;

///17.关机
- (void)powerOff;

///18.校验ID，圆通专用接口，block的BOOL参数（YES-成功,NO-失败）
- (void)checkID:(NSString *)key completeBlock:(CheckIDBlock)block;
///19.取消ID
- (void)disableID:(CheckIDBlock)block;
//20.身份证识别
- (void)readIdcard:(ReadIdcardBlock)block;
@end
