//
//  JHCustomizeApplyPopView.h
//  TTjianbao
//
//  Created by apple on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeApplyPopView : UIControl
- (void)showAlert;
- (void)hiddenAlert;
@property (nonatomic, copy) JHActionBlock completeBlock;
@property (nonatomic, copy) JHFinishBlock cameraBlock;
@property (nonatomic, strong) NSString *customerId;
@property (nonatomic, copy) NSString *channelId;
@end

NS_ASSUME_NONNULL_END
