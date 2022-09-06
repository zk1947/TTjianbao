
//
//  JHWebViewController.h
//  TTjianbao
//
//  Created by apple on 2019/12/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHWebView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHWebViewController : JHBaseViewController

@property (nonatomic, weak) JHWebView *webView;

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, copy) NSString *htmlString;

@property (nonatomic, assign) BOOL isHiddenNav;

@property (nonatomic, assign) BOOL isLiveRoom;

@property (nonatomic, assign) BOOL isNeedPoptoRoot;
@property (nonatomic, assign) BOOL isNeedPop;
@property (nonatomic, copy) NSString *familyData;

@property (nonatomic, copy) NSString *(^operateGetRoomInfo)(NSString *callname, NSString *tag, NSString *param);

@end

NS_ASSUME_NONNULL_END

