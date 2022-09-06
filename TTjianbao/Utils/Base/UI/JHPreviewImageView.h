//
//  JHPreviewImageView.h
//  TTjianbao
//
//  Created by lihui on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPreviewImageView : UIView

///预览图片
+ (JHPreviewImageView *)preImageView:(UIImage *)preImage;

- (void)show;
- (void)dismiss;

@property (nonatomic, copy) void(^completionBlock)(void);


@end

NS_ASSUME_NONNULL_END
