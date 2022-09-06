//
//  JHWebView.h
//  TTjianbao
//
//  Created by apple on 2020/3/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseWKWebView.h"
#import "JSCoreObject.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^HidenNavi)(BOOL isHiden);
@class OpenWebModel;

/// WKWebView  基类 (绑定业务) 
/// js 调用 webkit.messageHandlers.方法名.postMessage
@interface JHWebView : JHBaseWKWebView

///是否在控制器内部 关闭
@property (nonatomic, copy) dispatch_block_t closeViewOrVC;
@property (nonatomic, copy) HidenNavi hidenNavi;
/// 显示分享按钮
@property (nonatomic, copy) dispatch_block_t showShareButtonBlock;

/// 显示帮助按钮
@property (nonatomic, copy) void (^ showHelpButtonBlock)(NSString *title, NSString *target);

///VC改变标题
@property (nonatomic, copy) void (^titleChangeBlock)(NSString *title);

//setmodel 后不需要再调用loadWebURL方法
@property (strong, nonatomic) OpenWebModel *model;
/// 来源
@property (nonatomic, copy) NSString *from;

- (void)natActionSubPublicSocketMsg:(NSString *)data;
- (void)setUserAgent;

@property (nonatomic, copy) NSString *(^operateGetRoomInfo)(NSString *callname, NSString *tag, NSString *param);

@property (nonatomic, copy) void (^operateActionScreenCapture)(NSString *actionType, NSString *jsonString);

@property (nonatomic, copy) void (^operateActionAuctionSendOrder)(NSString *actionType, NSString *jsonString);

@property (nonatomic, copy) void (^operateCloseComplet)(void);

@property (nonatomic, copy) void (^resetSizeWebView)(OpenWebModel *model);

@end

NS_ASSUME_NONNULL_END
/*
 
 NSString *string = @"";
    
    if ([action isEqualToString:WebAction_GetRoomInfo]) {
        string = [self actionGetRoomInfoTag:tag callback:callback params:params];
    }else if ([action isEqualToString:WebAction_QueryData]) {
        string = [self actionQueryDataTag:tag callback:callback params:params];
    }
    
    return string;
 
 */
