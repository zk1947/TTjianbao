//
//  JHAlbumSelectView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/8/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZAssetCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAlbumSelectView : UIView

@property (nonatomic, assign) BOOL allowPickingVideo;
@property (nonatomic, assign) BOOL allowPickingImage;

/// type  0-全部    1-图片      2-视频
+ (void)showAlbumSelectViewWithView:(UIView *)view
                  allowPickingImage:(BOOL)allowPickingImage
                  allowPickingVideo:(BOOL)allowPickingVideo
                              title:(NSString *)title
                          dataBlock:(void (^)(TZAlbumModel *model))dataBlock;

@end

NS_ASSUME_NONNULL_END
