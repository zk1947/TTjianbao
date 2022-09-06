//
//  JHRefundDetailPhotosView.h
//  TTjianbao
//
//  Created by hao on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRefundDetailPhotosView : UIView
- (instancetype)initPhotosViewFrame:(CGRect)frame withImageHeight:(CGFloat)imageHeight clickPhotoBlock:(void(^)(NSArray *sourceViews, NSInteger index))clickPhotoBlock;

@property (nonatomic, copy) NSArray *images;

@end

NS_ASSUME_NONNULL_END
