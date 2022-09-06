//
//  JHTopicDetailHeaderView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/8/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHTopicDetailHeaderView : UIView

@property (nonatomic, assign) BOOL isRequestLoading;

- (void)setImage:(NSString *)imageUrl title:(NSString *)title comment_num:(NSString *)comment_num content_num:(NSString *)content_num scan_num:(NSString *)scan_num;

///滚动下拉放大
- (void)updateImageHeight:(float)height;

- (void)showLoading;

- (void)dismissLoading;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
