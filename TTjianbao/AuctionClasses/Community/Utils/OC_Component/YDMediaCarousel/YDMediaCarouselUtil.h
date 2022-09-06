//
//  YDMediaCarouselUtil.h
//  TTjianbao
//
//  Created by wuyd on 2020/7/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTjianbaoHeader.h"
#import "YDMediaData.h"
#import "UITapImageView.h"
#import "JHEasyPollLabel.h"
#import <GKPhotoBrowser/GKPhotoBrowser.h>

#define YDMediaCarouselHeight ([YDMediaCarouselUtil mediaHeight])

NS_ASSUME_NONNULL_BEGIN

@interface YDMediaCarouselUtil : NSObject

+ (CGFloat)mediaHeight;

///scrollView
+ (UIScrollView *)mediaScrollWithDelegate:(id)delegate;

///标记当前图片index的Label
+ (UILabel *)imageIndexLabel;

///播放按钮
+ (UIButton *)playButton;

///媒体图片显示视图
+ (UITapImageView *)mediaImageView;

///过滤媒体数据，将视频资源放到首位
+ (void)filterMediaList:(NSMutableArray<YDMediaData *> *)mediaList;


@end

NS_ASSUME_NONNULL_END
