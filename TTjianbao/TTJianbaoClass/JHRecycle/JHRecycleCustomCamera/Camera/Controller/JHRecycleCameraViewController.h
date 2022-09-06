//
//  JHRecycleOrderCameraViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleNomalCameraViewController.h"
#import "JHRecycleTemplateImageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleCameraViewController : JHRecycleNomalCameraViewController
/// 可选图片最大值
@property (nonatomic, assign) NSUInteger maximum;
/// 资源回调
@property (nonatomic, strong) RACSubject<NSArray<JHRecycleTemplateImageModel *> *> *assetHandle;

@property (nonatomic, copy) NSString *showTitle;

@end

NS_ASSUME_NONNULL_END
