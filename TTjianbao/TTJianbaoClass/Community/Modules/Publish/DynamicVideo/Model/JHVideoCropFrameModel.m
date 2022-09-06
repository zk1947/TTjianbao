//
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import "JHVideoCropFrameModel.h"

@implementation JHVideoCropFrameModel

- (void)setStartTime:(CMTime)startTime {
    
    _startTime = startTime;
    
    // 解决某些视频不是从kCMTimeZero开始有帧图像的情况
    if (CMTimeCompare(startTime, kCMTimeZero) == 0) {
        _startTime = CMTimeMakeWithSeconds(1, 50);
    }
}

@end
