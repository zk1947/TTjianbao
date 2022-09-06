//
//  JHAppealPopWindow.h
//  TTjianbao
//
//  Created by apple on 2020/9/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAppealPopWindow : UIView
@property (nonatomic, copy) void (^btnClickedBlock)(void);
+ (instancetype)signAppealpopVindow;
- (void)show;

@end

NS_ASSUME_NONNULL_END
