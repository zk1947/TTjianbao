//
//  JHApplyMicSuccessAlertView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/4/2.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHConnectMicPopAlertView.h"
#import "JHMicWaitMode.h"

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHApplyMicSuccessAlertView : UIControl
-(void)withSureClick:(sureBlock)block;
-(void)withCancleClick:(cancleBlock)block;
-(void)HideMicPopView;
- (void)showAlert;
@property(strong,nonatomic)JHMicWaitMode * mode;

@end

NS_ASSUME_NONNULL_END
