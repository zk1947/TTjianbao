//
//  JHAlertView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/8/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CompleteHandler) (void);
typedef void(^CloseHandler) (void);
NS_ASSUME_NONNULL_BEGIN

@interface JHAlertView : UIView
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *descText;
@property (nonatomic, copy) CompleteHandler completeHandler;
@property (nonatomic, copy) CloseHandler closeHandler;

+ (void)showWithTitle : (NSString *)title desc : (NSString *)desc handler : (CompleteHandler)handler;
+ (void)showWithTitle : (NSString *)title desc : (NSString *)desc handler : (CompleteHandler)handler closeHandler : (CloseHandler)closeHandler;
@end

NS_ASSUME_NONNULL_END
