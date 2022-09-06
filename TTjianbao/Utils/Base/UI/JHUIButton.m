//
//  JHUIButton.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/12.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHUIButton.h"
#import "JHWebImage.h"
#import "UIButton+JHWebImage.h"

@implementation JHUIButton

- (void)asynSetBackgroundImage:(NSString*)imgUrl
{
    static int asynDownloadReqcount = 0;
    if(asynDownloadReqcount > 60)
    {
        [JHWebImage cancelAllRequest];
        asynDownloadReqcount = 0;
    }
    JH_WEAK(self)
    [self jhSetImageWithURL:[NSURL URLWithString:imgUrl] forState:UIControlStateNormal placeholder:kDefaultCoverImage options:(SDWebImageOptions)SDWebImageLowPriority completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        JH_STRONG(self)
        [self setBackgroundImage:image forState:UIControlStateNormal];//网络图片
    }];
    asynDownloadReqcount++;
}

@end
