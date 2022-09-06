//
//  JHConnectMicPopAlertView.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/13.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^sureBlock)(void);
typedef void(^cancleBlock)(void);

@class JHConnectMicPopAlertView;

@protocol JHConnectMicPopAlertView <NSObject>

- (void)ConnectViewButtonCancle:(JHConnectMicPopAlertView*)connectView;
- (void)ConnectViewButtonComplete:(JHConnectMicPopAlertView*)connectView;

@end

#import "BaseView.h"

@interface JHConnectMicPopAlertView : BaseView

@property (nonatomic,assign) NSInteger timeCount;

@property (nonatomic, weak) id<JHConnectMicPopAlertView> delegate;

- (instancetype)initWithTitle:(NSString *)title cancleBtnTitle:(NSString *)cancleTitle  sureBtnTitle:(NSString *)completeTitle;
-(void)withSureClick:(sureBlock)block;
-(void)withCancleClick:(cancleBlock)block;
-(void)HideMicPopView;

@end

