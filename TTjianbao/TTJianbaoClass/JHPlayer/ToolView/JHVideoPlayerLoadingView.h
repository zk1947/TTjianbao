//
//  JHVideoPlayerLoadingView.h
//  TTJB
//
//  Created by 王记伟 on 2021/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickRetryCall)(void);

@interface JHVideoPlayerLoadingView : UIView

@property (nonatomic, copy) ClickRetryCall retryCall;

- (void)startLoading;
- (void)stopLoading;
- (void)showRetry;

@end

NS_ASSUME_NONNULL_END
