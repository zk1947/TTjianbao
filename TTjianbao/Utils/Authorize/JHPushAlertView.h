//
//  JHPushAlertView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/8/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CompleteHandler) (void);
NS_ASSUME_NONNULL_BEGIN

@interface JHPushAlertView : UIView
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *subTitleText;
@property (nonatomic, copy) NSString *descText;
@property (nonatomic, copy) CompleteHandler completeHandler;
+ (void)showWithTitle : (NSString *)title subTitle : (NSString *)subTitle desc : (NSString *)desc handler : (CompleteHandler)handler;
@end

NS_ASSUME_NONNULL_END
