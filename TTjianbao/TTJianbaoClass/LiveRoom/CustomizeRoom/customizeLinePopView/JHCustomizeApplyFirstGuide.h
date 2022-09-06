//
//  JHCustomizeApplyFirstGuide.h
//  TTjianbao
//
//  Created by apple on 2020/11/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeApplyFirstGuide : UIControl
@property (nonatomic, copy) void (^clickSureBlock)(void);
@property (nonatomic, copy) JHActionBlock completeBlock;
@property (nonatomic, copy) NSString *customerId;
@property (nonatomic, copy) NSString *channelId;
- (void)showAlert;
- (void)hiddenAlert;
@end

NS_ASSUME_NONNULL_END
