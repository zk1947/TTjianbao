//
//  JHRecyclePhotoExampleView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/4/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRecycleUploadExampleModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 相册示例——view
@interface JHRecyclePhotoExampleView : UIView


/// 初始化
/// @param title
/// @param arr 图片数组
- (instancetype)initWithTitle:(NSString*)title andImageArray:(NSArray<JHRecycleUploadExampleModel*> *)arr;

@end

NS_ASSUME_NONNULL_END
