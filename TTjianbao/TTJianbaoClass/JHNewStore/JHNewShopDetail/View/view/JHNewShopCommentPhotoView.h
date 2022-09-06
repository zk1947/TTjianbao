//
//  JHNewShopCommentPhotoView.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  图片浏览

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewShopCommentPhotoView : UIView
@property (nonatomic, copy) void(^clickPhotoBlock)(NSArray *sourceViews, NSInteger index);

@property (nonatomic, copy) NSArray *images;

@end

NS_ASSUME_NONNULL_END
