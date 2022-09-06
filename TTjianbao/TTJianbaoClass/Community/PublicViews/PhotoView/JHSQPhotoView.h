//
//  JHSQPhotoView.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  列表中显示图片控件（1~3张）
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSQPhotoView : UIView

@property (nonatomic, copy) void(^clickPhotoBlock)(NSArray *sourceViews, NSInteger index);

@property (nonatomic, strong) NSArray *images;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
