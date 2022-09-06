//
//  JHNormalControlView.h
//  TTJB
//
//  Created by 王记伟 on 2021/1/15.
//

#import "JHPlayControlView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNormalControlView : JHPlayControlView
/** 中间的播放按钮图片*/
@property (nonatomic, strong) UIImage *playImage;

/** 竖屏是否也用这个UI*/
@property (nonatomic, assign) BOOL isNeedVertical;

/** 取消下滑变全屏*/
@property (nonatomic, assign) BOOL canScanToFullScreen;
@end

NS_ASSUME_NONNULL_END
