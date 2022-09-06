//
//  JHAudienceApplyCustomizeView.h
//  TTjianbao
//申请定制
//  Created by jiangchao on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAudienceApplyCustomizeView : UIControl
- (void)showAlert;
- (void)hiddenAlert;
@property (nonatomic, strong) JHActionBlock completeBlock;
@property (nonatomic, strong) JHFinishBlock cameraBlock;
@property (nonatomic, strong) NSString *channelId;
@end

NS_ASSUME_NONNULL_END
