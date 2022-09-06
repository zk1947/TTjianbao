//
//  JHRecycleOrderDetailAlert.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailAlert : UIView
@property (nonatomic, strong) JHFinishBlock cancelHandle;
@property (nonatomic, strong) JHFinishBlock handle;

@property (nonatomic, strong) JHFinishBlock agreementHandle;

- (void)showAlertWithDesc : (NSString *)desc;
- (void)showAlertWithDesc : (NSString *)desc in : (UIView *)view;
@end

NS_ASSUME_NONNULL_END
