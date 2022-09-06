//
//  JHQuickLoginView.h
//  TTjianbao
//  Description:快速登录(极光-一键登录)
//  Created by Jesse on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHJVerfication.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHQuickLoginViewDelegate <NSObject>

- (void)closeAll;
- (void)toAppeal:(NSString *)paraStr;
- (void)otherLogin:(UIButton*)button;
- (void)quickLoginResult:(BOOL)result;
@end

@interface JHQuickLoginView : UIView
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, weak) id <JHQuickLoginViewDelegate>delegate;

- (void)dismissQuickLoginControllerAnimated:(BOOL)animated;

- (void)quickLoginStartVerfication:(JHSuccess)response;

@end

NS_ASSUME_NONNULL_END
